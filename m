Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42851 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727182AbeJSUVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 00/22] i.MX media mem2mem scaler
Date: Fri, 19 Oct 2018 14:15:17 +0200
Message-Id: <20181019121539.12778-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is the fourth version of the i.MX mem2mem scaler series.

An alignment issue with 24-bit RGB formats has been corrected in the
seam position selection patch and a few new fixes by Steve have been
added. If there are no more issues, I'll pick up the ipu-v3 patches
via imx-drm/next. The first patch could be merged via the media tree
independently.

Changes since v3:
 - Fix tile_left_align for 24-bit RGB formats and reduce alignment
   restrictions for U/V packed planar YUV formats
 - Catch unaligned tile offsets in image-convert
 - Add chroma plane offset overrides to ipu_cpmem_set_image() to
   prevent a false positive warning in some cases
 - Fix a race between run and unprepare and make abort reentrant.


Changes since v2:
 - Rely on ipu_image_convert_adjust() in mem2mem_try_fmt() for format
   adjustments. This makes the mem2mem driver mostly a V4L2 mem2mem API
   wrapper around the IPU image converter, and independent of the
   internal image converter implementation.
 - Remove the source and destination buffers on error in device_run().
   Otherwise the conversion is re-attempted apparently over and over
   again (with WARN() backtraces).
 - Allow subscribing to control changes.
 - Fix seam position selection for more corner cases:
    - Switch width/height properly and align tile top left positions to 8x8
      IRT block size when rotating.
    - Align input width to input burst length in case the scaling step
      flips horizontally.
    - Fix bottom edge calculation.

Changes since v1:
 - Fix inverted allow_overshoot logic
 - Correctly switch horizontal / vertical tile alignment when
   determining seam positions with the 90° rotator active.
 - Fix SPDX-License-Identifier and remove superfluous license
   text.
 - Fix uninitialized walign in try_fmt

Previous cover letter:

we have image conversion code for scaling and colorspace conversion in
the IPUv3 base driver for a while. Since the IC hardware can only write
up to 1024x1024 pixel buffers, it scales to larger output buffers by
splitting the input and output frame into similarly sized tiles.

This causes the issue that the bilinear interpolation resets at the tile
boundary: instead of smoothly interpolating across the seam, there is a
jump in the input sample position that is very apparent for high
upscaling factors. This can be avoided by slightly changing the scaling
coefficients to let the left/top tiles overshoot their input sampling
into the first pixel / line of their right / bottom neighbors. The error
can be further reduced by letting tiles be differently sized and by
selecting seam positions that minimize the input sampling position error
at tile boundaries.
This is complicated by different DMA start address, burst size, and
rotator block size alignment requirements, depending on the input and
output pixel formats, and the fact that flipping happens in different
places depending on the rotation.

This series implements optimal seam position selection and seam hiding
with per-tile resizing coefficients and adds a scaling mem2mem device
to the imx-media driver.

regards
Philipp

Philipp Zabel (15):
  media: imx: add mem2mem device
  gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients
  gpu: ipu-v3: image-convert: prepare for per-tile configuration
  gpu: ipu-v3: image-convert: calculate per-tile resize coefficients
  gpu: ipu-v3: image-convert: reconfigure IC per tile
  gpu: ipu-v3: image-convert: store tile top/left position
  gpu: ipu-v3: image-convert: calculate tile dimensions and offsets
    outside fill_image
  gpu: ipu-v3: image-convert: move tile alignment helpers
  gpu: ipu-v3: image-convert: select optimal seam positions
  gpu: ipu-v3: image-convert: fix debug output for varying tile sizes
  gpu: ipu-v3: image-convert: relax alignment restrictions
  gpu: ipu-v3: image-convert: fix bytesperline adjustment
  gpu: ipu-v3: image-convert: add some ASCII art to the exposition
  gpu: ipu-v3: image-convert: disable double buffering if necessary
  gpu: ipu-v3: image-convert: allow three rows or columns

Steve Longerbeam (7):
  gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma buffers
  gpu: ipu-v3: Add chroma plane offset overrides to
    ipu_cpmem_set_image()
  gpu: ipu-v3: image-convert: Prevent race between run and unprepare
  gpu: ipu-v3: image-convert: Only wait for abort completion if active
    run
  gpu: ipu-v3: image-convert: Allow reentrancy into abort
  gpu: ipu-v3: image-convert: Remove need_abort flag
  gpu: ipu-v3: image-convert: Catch unaligned tile offsets

 drivers/gpu/ipu-v3/ipu-cpmem.c                |   52 +-
 drivers/gpu/ipu-v3/ipu-ic.c                   |   52 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c        | 1019 ++++++++++++++---
 drivers/staging/media/imx/Kconfig             |    1 +
 drivers/staging/media/imx/Makefile            |    1 +
 drivers/staging/media/imx/imx-media-dev.c     |   11 +
 drivers/staging/media/imx/imx-media-mem2mem.c |  873 ++++++++++++++
 drivers/staging/media/imx/imx-media.h         |   10 +
 include/video/imx-ipu-v3.h                    |    9 +
 9 files changed, 1821 insertions(+), 207 deletions(-)
 create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c

-- 
2.19.0
