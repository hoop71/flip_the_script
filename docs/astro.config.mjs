// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  site: 'https://hoop71.github.io',
  base: '/flip_the_script',
  outDir: '../dist',
  build: {
    assets: 'assets'
  }
});
