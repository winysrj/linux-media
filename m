Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40095 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965771AbdLSLqo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:46:44 -0500
Message-ID: <1513684002.7538.10.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: allow to build with COMPILE_TEST
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel@pengutronix.de
Date: Tue, 19 Dec 2017 12:46:42 +0100
In-Reply-To: <20171219114232.11604-1-p.zabel@pengutronix.de>
References: <20171219114232.11604-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-12-19 at 12:42 +0100, Philipp Zabel wrote:
> Allow building this driver for other platforms under COMPILE_TEST.
>
> Suggested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/staging/media/imx/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 2be921cd0d55a..59b380cc6d223 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_IMX_MEDIA
>  	tristate "i.MX5/6 V4L2 media core driver"
> -	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
> +	depends on ARCH_MXC || COMPILE_TEST
> +	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && IMX_IPUV3_CORE
>  	depends on VIDEO_V4L2_SUBDEV_API
>  	select VIDEOBUF2_DMA_CONTIG
>  	select V4L2_FWNODE

Currently IMX_IPUV3_CORE is not buildable under COMPILE_TEST either,
I'll fix that separately.

regards
Philipp
