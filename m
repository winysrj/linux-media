Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:51686 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753409AbeGEVzM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 17:55:12 -0400
Subject: Re: [PATCH 00/16] i.MX media mem2mem scaler
To: Philipp Zabel <p.zabel@pengutronix.de>,
        <linux-media@vger.kernel.org>
CC: <kernel@pengutronix.de>, Steve Longerbeam <slongerbeam@gmail.com>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <828c3de1-0afd-d128-7e1d-f735e7a2f4f9@mentor.com>
Date: Thu, 5 Jul 2018 14:55:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thanks for this great patchset! Finally we have improved seams
with tiled conversions, and relaxed width alignment requirements.

Unfortunately this patchset isn't working correctly yet. It breaks tiled
conversions with rotation.

Trying the following conversion:

input: 720x480, UYVY
output: 1280x768, UYVY, rotation=90 degrees

causes non-8-byte aligned tile buffers at the output:

[  129.578210] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: Input@[0,0]: 
phys 00000000
[  129.585980] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: Input@[1,0]: 
phys 00051360
[  129.593736] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: 
Output@[0,0]: phys 00000000
[  129.601556] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: 
Output@[0,1]: phys 0000052e

resulting in hung conversion and abort timeout:

[  147.689220] imx-ipuv3 2400000.ipu: ipu_image_convert_abort: timeout

Note that when converting to a planar format, the final (rotated) chroma 
tile
buffers are also mis-aligned, in addition to the Y buffers.

I have some additional comments to follow in the patches.

Steve

On 06/22/2018 08:52 AM, Philipp Zabel wrote:
> Hi,
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
> Philipp Zabel (16):
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
>    gpu: ipu-v3: image-convert: relax tile width alignment for NV12 and
>      NV16
>    gpu: ipu-v3: image-convert: relax input alignment restrictions
>    gpu: ipu-v3: image-convert: relax output alignment restrictions
>    gpu: ipu-v3: image-convert: fix bytesperline adjustment
>    gpu: ipu-v3: image-convert: add some ASCII art to the exposition
>    gpu: ipu-v3: image-convert: disable double buffering if necessary
>    media: imx: add mem2mem device
>
>   drivers/gpu/ipu-v3/ipu-ic.c                   |  52 +-
>   drivers/gpu/ipu-v3/ipu-image-convert.c        | 865 +++++++++++++---
>   drivers/staging/media/imx/Kconfig             |   1 +
>   drivers/staging/media/imx/Makefile            |   1 +
>   drivers/staging/media/imx/imx-media-dev.c     |  11 +
>   drivers/staging/media/imx/imx-media-mem2mem.c | 953 ++++++++++++++++++
>   drivers/staging/media/imx/imx-media.h         |  10 +
>   include/video/imx-ipu-v3.h                    |   6 +
>   8 files changed, 1760 insertions(+), 139 deletions(-)
>   create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>
