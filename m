Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39054 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbeJMIEa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 04:04:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id 61-v6so15105991wrb.6
        for <linux-media@vger.kernel.org>; Fri, 12 Oct 2018 17:29:34 -0700 (PDT)
Subject: Re: [PATCH v3 00/16] i.MX media mem2mem scaler
To: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <cc2a7233-2761-902b-843a-0e3f458f230b@gmail.com>
Date: Fri, 12 Oct 2018 17:29:28 -0700
MIME-Version: 1.0
In-Reply-To: <20180918093421.12930-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

I finished some fairly comprehensive testing on this series,
scaling to and from the following common resolutions:

640x480,
720x480,
720x576,
800x480,
800x600,
1024x768,
1152x720,
1280x720,
1280x768,
1280x800,
1280x1024,
1920x1080,
1920x1200,
2560x1440,
2560x1600,
2592x1944

and within each scaling conversion, I tested converting to and from
all the pixel formats supported by the mem2mem device:

422p, nv12, rgb4, yu12, bgr3, nv16,
rgbp, yuyv, bgr4, rgb3, uyvy, yv12

What I found is that most of these conversions are working, producing
no mis-aligned tile buffer addresses, except for one exception: converting
to or from a packed 24-bit pixel format (rgb3 or bgr3). For example,
try 640x480.rgb3 -> 1920x1080.yu12.

I found the cause of that, I added the following patch to my fork
git@github.com:slongerbeam/mediatree.git, branch imx-mem2mem.3:

"gpu: ipu-v3: image-convert: Fix tile_left_align()"

Feel free to squash it with

"gpu: ipu-v3: image-convert: select optimal seam positions"

I've also added a few other patches to my branch:

"gpu: ipu-v3: Add chroma plane offset overrides to ipu_cpmem_set_image()"

which fixes a false warning in ipu_cpmem_set_yuv_planar_full().

Also added:

"gpu: ipu-v3: image-convert: Prevent race between run and unprepare"
"gpu: ipu-v3: image-convert: Only wait for abort completion if active run"
"gpu: ipu-v3: image-convert: Allow reentrancy into abort"
"gpu: ipu-v3: image-convert: Remove need_abort flag"
"gpu: ipu-v3: image-convert: Catch unaligned tile offsets"

With the fix to tile_left_align(), all conversions for the above scaling
resolutions are not producing mis-aligned tile buffers anymore, for all
pixel formats.

But one last thing. Conversions to and from YV12 are producing images
with wrong colors, it looks like the .uv_swapped boolean needs to be checked
additionally somewhere. Any ideas?


Steve


On 09/18/2018 02:34 AM, Philipp Zabel wrote:
> Hi,
>
> this is the third version of the i.MX mem2mem scaler series.
>
> The driver patch has been moved to the beginning, as Steve suggested.
> I've added his warning patch to catch alignment bugs to the series,
> seam position selection has been fixed for more corner cases, the
> alignment restriction relaxation patches have been merged into one
> patch, and support for tiling with three rows or columns has been added
> to avoid unnecessary overhead.
>
> Changes since v2:
>   - Rely on ipu_image_convert_adjust() in mem2mem_try_fmt() for format
>     adjustments. This makes the mem2mem driver mostly a V4L2 mem2mem API
>     wrapper around the IPU image converter, and independent of the
>     internal image converter implementation.
>   - Remove the source and destination buffers on error in device_run().
>     Otherwise the conversion is re-attempted apparently over and over
>     again (with WARN() backtraces).
>   - Allow subscribing to control changes.
>   - Fix seam position selection for more corner cases:
>      - Switch width/height properly and align tile top left positions to 8x8
>        IRT block size when rotating.
>      - Align input width to input burst length in case the scaling step
>        flips horizontally.
>      - Fix bottom edge calculation.
>
> Changes since v1:
>   - Fix inverted allow_overshoot logic
>   - Correctly switch horizontal / vertical tile alignment when
>     determining seam positions with the 90° rotator active.
>   - Fix SPDX-License-Identifier and remove superfluous license
>     text.
>   - Fix uninitialized walign in try_fmt
>
> Previous cover letter:
>
> we have image conversion code for scaling and colorspace conversion in
> the IPUv3 base driver for a while. Since the IC hardware can only write
> up to 1024x1024 pixel buffers, it scales to larger output buffers by
> splitting the input and output frame into similarly sized tiles.
>
> This causes the issue that the bilinear interpolation resets at the tile
> boundary: instead of smoothly interpolating across the seam, there is a
> jump in the input sample position that is very apparent for high
> upscaling factors. This can be avoided by slightly changing the scaling
> coefficients to let the left/top tiles overshoot their input sampling
> into the first pixel / line of their right / bottom neighbors. The error
> can be further reduced by letting tiles be differently sized and by
> selecting seam positions that minimize the input sampling position error
> at tile boundaries.
> This is complicated by different DMA start address, burst size, and
> rotator block size alignment requirements, depending on the input and
> output pixel formats, and the fact that flipping happens in different
> places depending on the rotation.
>
> This series implements optimal seam position selection and seam hiding
> with per-tile resizing coefficients and adds a scaling mem2mem device
> to the imx-media driver.
>
> regards
> Philipp
>
> Philipp Zabel (15):
>    media: imx: add mem2mem device
>    gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients
>    gpu: ipu-v3: image-convert: prepare for per-tile configuration
>    gpu: ipu-v3: image-convert: calculate per-tile resize coefficients
>    gpu: ipu-v3: image-convert: reconfigure IC per tile
>    gpu: ipu-v3: image-convert: store tile top/left position
>    gpu: ipu-v3: image-convert: calculate tile dimensions and offsets
>      outside fill_image
>    gpu: ipu-v3: image-convert: move tile alignment helpers
>    gpu: ipu-v3: image-convert: select optimal seam positions
>    gpu: ipu-v3: image-convert: fix debug output for varying tile sizes
>    gpu: ipu-v3: image-convert: relax alignment restrictions
>    gpu: ipu-v3: image-convert: fix bytesperline adjustment
>    gpu: ipu-v3: image-convert: add some ASCII art to the exposition
>    gpu: ipu-v3: image-convert: disable double buffering if necessary
>    gpu: ipu-v3: image-convert: allow three rows or columns
>
> Steve Longerbeam (1):
>    gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma buffers
>
>   drivers/gpu/ipu-v3/ipu-cpmem.c                |   6 +
>   drivers/gpu/ipu-v3/ipu-ic.c                   |  52 +-
>   drivers/gpu/ipu-v3/ipu-image-convert.c        | 919 +++++++++++++++---
>   drivers/staging/media/imx/Kconfig             |   1 +
>   drivers/staging/media/imx/Makefile            |   1 +
>   drivers/staging/media/imx/imx-media-dev.c     |  11 +
>   drivers/staging/media/imx/imx-media-mem2mem.c | 873 +++++++++++++++++
>   drivers/staging/media/imx/imx-media.h         |  10 +
>   include/video/imx-ipu-v3.h                    |   6 +
>   9 files changed, 1727 insertions(+), 152 deletions(-)
>   create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>
