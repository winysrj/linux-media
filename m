Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:46691 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753338AbdCHNVo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 08:21:44 -0500
Message-ID: <1488975727.2467.22.camel@pengutronix.de>
Subject: Re: [PATCH] coda: enable with COMPILE_TEST
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Wed, 08 Mar 2017 13:22:07 +0100
In-Reply-To: <cc407203-ce28-3678-915f-eaab8e52d4a2@xs4all.nl>
References: <cc407203-ce28-3678-915f-eaab8e52d4a2@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-03-08 at 12:52 +0100, Hans Verkuil wrote:
> Allow building of coda with COMPILE_TEST.
> 
> Fixed one v4l2_err format string that caused a compiler warning when compiling on a 64-bit
> platform.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 53f6f12bff0d..9b9bee4b2323 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -151,7 +151,8 @@ if V4L_MEM2MEM_DRIVERS
> 
>   config VIDEO_CODA
>   	tristate "Chips&Media Coda multi-standard codec IP"
> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	depends on ARCH_MXC || COMPILE_TEST

Yes, that could be helpful.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

>   	depends on HAS_DMA
>   	select SRAM
>   	select VIDEOBUF2_DMA_CONTIG
> diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> index bd9e5ca8a640..5ec27626539e 100644
> --- a/drivers/media/platform/coda/coda-common.c
> +++ b/drivers/media/platform/coda/coda-common.c
> @@ -1407,7 +1407,7 @@ int coda_alloc_aux_buf(struct coda_dev *dev, struct coda_aux_buf *buf,
>   					GFP_KERNEL);
>   	if (!buf->vaddr) {
>   		v4l2_err(&dev->v4l2_dev,
> -			 "Failed to allocate %s buffer of size %u\n",
> +			 "Failed to allocate %s buffer of size %zu\n",
>   			 name, size);
>   		return -ENOMEM;
>   	}
> 

regards
Philipp
