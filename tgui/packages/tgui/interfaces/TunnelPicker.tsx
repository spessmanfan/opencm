import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui/components';
import { Window } from 'tgui/layouts';

type Tunnel = {
  ref: string;
  desc: string;
  dist: number;
};

type Preview = {
  url: string | null;
  area: string;
};

type Data = {
  tunnels: Tunnel[];
  selected_ref: string | null;
  preview: Preview | null;
};

const MAX_LOAD_ATTEMPTS = 6;
const RETRY_DELAY_MS = 500;

/**
 * Preloads the preview image in the background before ever handing it to
 * an <img> tag, so a slow/first-time asset transfer never flashes the
 * browser's native broken-image icon. Only swaps in (and bounces in) the
 * image once it's confirmed to have loaded.
 */
const TunnelPreview = (props: { src: string | null }) => {
  const { src } = props;
  const [status, setStatus] = useState<'loading' | 'loaded' | 'error'>(
    'loading',
  );

  useEffect(() => {
    if (!src) {
      return;
    }
    let cancelled = false;
    let attempts = 0;
    let retryTimer: ReturnType<typeof setTimeout>;
    setStatus('loading');

    const tryLoad = () => {
      const img = new Image();
      img.onload = () => {
        if (!cancelled) setStatus('loaded');
      };
      img.onerror = () => {
        if (cancelled) return;
        attempts += 1;
        if (attempts < MAX_LOAD_ATTEMPTS) {
          retryTimer = setTimeout(tryLoad, RETRY_DELAY_MS);
        } else {
          setStatus('error');
        }
      };
      img.src = src;
    };
    tryLoad();

    return () => {
      cancelled = true;
      clearTimeout(retryTimer);
    };
  }, [src]);

  if (!src) {
    return (
      <Box className="TunnelPicker__previewEmpty">
        Select a tunnel to preview it.
      </Box>
    );
  }

  if (status === 'error') {
    return (
      <Box className="TunnelPicker__previewEmpty">Preview unavailable.</Box>
    );
  }

  if (status === 'loading') {
    return (
      <Box className="TunnelPicker__previewEmpty">
        Scanning tunnel surroundings...
      </Box>
    );
  }

  return (
    <img
      key={src}
      className="TunnelPicker__previewImage"
      src={src}
      alt="Tunnel surroundings"
    />
  );
};

export const TunnelPicker = (props) => {
  const { act, data } = useBackend<Data>();
  const { tunnels = [], selected_ref, preview } = data;

  return (
    <Window width={700} height={580} theme="hive_status" title="Tunnel">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="14rem">
            <Section title="Destinations" fill scrollable>
              {tunnels.length === 0 && (
                <Box color="label" italic>
                  No other tunnels are open.
                </Box>
              )}
              <Stack vertical>
                {tunnels.map((tunnel) => (
                  <Stack.Item key={tunnel.ref}>
                    <Box
                      className={
                        'TunnelPicker__row' +
                        (tunnel.ref === selected_ref
                          ? ' TunnelPicker__row--selected'
                          : '')
                      }
                      onClick={() => act('select', { ref: tunnel.ref })}
                      onDoubleClick={() =>
                        act('confirm', { ref: tunnel.ref })
                      }
                    >
                      <Box className="TunnelPicker__rowDesc">
                        {tunnel.desc}
                      </Box>
                      <Box className="TunnelPicker__rowDist">
                        {tunnel.dist}m
                      </Box>
                    </Box>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title={preview?.area || 'Preview'} fill>
              <Stack vertical fill>
                <Stack.Item grow>
                  <Box className="TunnelPicker__previewFrame">
                    <TunnelPreview src={preview?.url || null} />
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    color="good"
                    disabled={!selected_ref}
                    icon="person-running"
                    onClick={() => act('confirm', { ref: selected_ref })}
                  >
                    Travel Here
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
