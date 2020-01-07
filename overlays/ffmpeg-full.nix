# requires my fork of nixpkgs for now
final: prev: {
  ffmpeg-full = prev.ffmpeg-full.override {
    svt-av1 = prev.svt-av1;
    dav1d = prev.dav1d;
    libaom = null;
    opencore-amr = null;
    libopus = prev.libopus;
  };
}
