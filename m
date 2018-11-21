Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:49249 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbeKUXoa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Nov 2018 18:44:30 -0500
Subject: Re: [PATCH v9 3/3] media: add Rockchip VPU JPEG encoder driver
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Miouyouyou <myy@miouyouyou.fr>
References: <20181120212059.29244-1-ezequiel@collabora.com>
 <20181120212059.29244-4-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <df04e23d-35f8-0fdf-9e14-892e716b1434@xs4all.nl>
Date: Wed, 21 Nov 2018 14:10:07 +0100
MIME-Version: 1.0
In-Reply-To: <20181120212059.29244-4-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/20/2018 10:20 PM, Ezequiel Garcia wrote:
> Add a mem2mem driver for the VPU available on Rockchip SoCs.
> Currently only JPEG encoding is supported, for RK3399 and RK3288
> platforms.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  MAINTAINERS                                   |   7 +
>  drivers/staging/media/Kconfig                 |   2 +
>  drivers/staging/media/Makefile                |   1 +
>  drivers/staging/media/rockchip/vpu/Kconfig    |  14 +
>  drivers/staging/media/rockchip/vpu/Makefile   |  10 +
>  drivers/staging/media/rockchip/vpu/TODO       |   6 +
>  .../media/rockchip/vpu/rk3288_vpu_hw.c        | 118 +++
>  .../rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c     | 133 ++++
>  .../media/rockchip/vpu/rk3288_vpu_regs.h      | 442 +++++++++++
>  .../media/rockchip/vpu/rk3399_vpu_hw.c        | 118 +++
>  .../rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c     | 160 ++++
>  .../media/rockchip/vpu/rk3399_vpu_regs.h      | 600 +++++++++++++++
>  .../staging/media/rockchip/vpu/rockchip_vpu.h | 237 ++++++
>  .../media/rockchip/vpu/rockchip_vpu_common.h  |  29 +
>  .../media/rockchip/vpu/rockchip_vpu_drv.c     | 535 +++++++++++++
>  .../media/rockchip/vpu/rockchip_vpu_enc.c     | 702 ++++++++++++++++++
>  .../media/rockchip/vpu/rockchip_vpu_hw.h      |  58 ++
>  .../media/rockchip/vpu/rockchip_vpu_jpeg.c    | 289 +++++++
>  .../media/rockchip/vpu/rockchip_vpu_jpeg.h    |  12 +
>  19 files changed, 3473 insertions(+)
>  create mode 100644 drivers/staging/media/rockchip/vpu/Kconfig
>  create mode 100644 drivers/staging/media/rockchip/vpu/Makefile
>  create mode 100644 drivers/staging/media/rockchip/vpu/TODO
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_hw_jpeg_enc.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_hw_jpeg_enc.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rk3399_vpu_regs.h
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu.h
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_common.h
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_drv.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_enc.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_hw.h
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
>  create mode 100644 drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> 

<snip>

> diff --git a/drivers/staging/media/rockchip/vpu/Kconfig b/drivers/staging/media/rockchip/vpu/Kconfig
> new file mode 100644
> index 000000000000..fa65c03d65bf
> --- /dev/null
> +++ b/drivers/staging/media/rockchip/vpu/Kconfig
> @@ -0,0 +1,14 @@
> +config VIDEO_ROCKCHIP_VPU
> +	tristate "Rockchip VPU driver"
> +	depends on ARCH_ROCKCHIP || COMPILE_TEST
> +	depends on VIDEO_DEV && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	select VIDEOBUF2_DMA_CONTIG
> +	select VIDEOBUF2_VMALLOC
> +	select V4L2_MEM2MEM_DEV
> +	default n
> +	help
> +	  Support for the Video Processing Unit present on Rockchip SoC,
> +	  which accelerates video and image encoding and decoding.
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called rockchip-vpu.
> +

checkpatch warns about empty line at the end of the Kconfig

<snip>

> diff --git a/drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h b/drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
> new file mode 100644
> index 000000000000..d6cf9c682e7d
> --- /dev/null
> +++ b/drivers/staging/media/rockchip/vpu/rk3288_vpu_regs.h
> @@ -0,0 +1,442 @@
> +// SPDX-License-Identifier: GPL-2.0

Headers must use /* */ for the SPDX license. Sorry, I didn't make up these rules.

In any case, checkpatch.pl --strict complains about it.

<snip>

> diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> new file mode 100644
> index 000000000000..678d53f3c2c2
> --- /dev/null
> +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.c
> @@ -0,0 +1,289 @@

Missing SPDX license!

> +/*
> + * Copyright (C) Collabora, Ltd.
> + *
> + * Based on GSPCA and CODA drivers:
> + * Copyright (C) Jean-Francois Moine (http://moinejf.free.fr)
> + * Copyright (C) 2014 Philipp Zabel, Pengutronix
> + */

<snip>

> diff --git a/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> new file mode 100644
> index 000000000000..a616d85359e8
> --- /dev/null
> +++ b/drivers/staging/media/rockchip/vpu/rockchip_vpu_jpeg.h
> @@ -0,0 +1,12 @@

Missing SPDX license!

> +#define JPEG_HEADER_SIZE	601
> +
> +struct rockchip_vpu_jpeg_ctx {
> +	int width;
> +	int height;
> +	int quality;
> +	unsigned char *buffer;
> +};
> +
> +unsigned char *
> +rockchip_vpu_jpeg_get_qtable(struct rockchip_vpu_jpeg_ctx *ctx, int index);
> +void rockchip_vpu_jpeg_render(struct rockchip_vpu_jpeg_ctx *ctx);
> 

So close...

Regards,

	Hans
