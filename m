Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45109 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732156AbeGSQOd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 12:14:33 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v2 00/16]  i.MX media mem2mem scaler
Date: Thu, 19 Jul 2018 17:30:26 +0200
Message-Id: <20180719153042.533-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is the second version of the i.MX mem2mem scaler series.
Patches 8 and 16 have been modified.

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

Philipp Zabel (16):
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
  gpu: ipu-v3: image-convert: relax tile width alignment for NV12 and
    NV16
  gpu: ipu-v3: image-convert: relax input alignment restrictions
  gpu: ipu-v3: image-convert: relax output alignment restrictions
  gpu: ipu-v3: image-convert: fix bytesperline adjustment
  gpu: ipu-v3: image-convert: add some ASCII art to the exposition
  gpu: ipu-v3: image-convert: disable double buffering if necessary
  media: imx: add mem2mem device

 drivers/gpu/ipu-v3/ipu-ic.c                   |  52 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c        | 870 +++++++++++++---
 drivers/staging/media/imx/Kconfig             |   1 +
 drivers/staging/media/imx/Makefile            |   1 +
 drivers/staging/media/imx/imx-media-dev.c     |  11 +
 drivers/staging/media/imx/imx-media-mem2mem.c | 946 ++++++++++++++++++
 drivers/staging/media/imx/imx-media.h         |  10 +
 include/video/imx-ipu-v3.h                    |   6 +
 8 files changed, 1758 insertions(+), 139 deletions(-)
 create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c

-- 
2.18.0
