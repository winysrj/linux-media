Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37332 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdLSSot (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 13:44:49 -0500
Received: by mail-pl0-f66.google.com with SMTP id s3so7493764plp.4
        for <linux-media@vger.kernel.org>; Tue, 19 Dec 2017 10:44:48 -0800 (PST)
Subject: Re: [PATCH] media: imx: allow to build with COMPILE_TEST
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, kernel@pengutronix.de
References: <20171219114232.11604-1-p.zabel@pengutronix.de>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <00f0eff8-955f-334f-6129-0ec5d19c3fa1@gmail.com>
Date: Tue, 19 Dec 2017 10:44:46 -0800
MIME-Version: 1.0
In-Reply-To: <20171219114232.11604-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 12/19/2017 03:42 AM, Philipp Zabel wrote:
> Allow building this driver for other platforms under COMPILE_TEST.
>
> Suggested-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>

> ---
>   drivers/staging/media/imx/Kconfig | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 2be921cd0d55a..59b380cc6d223 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -1,6 +1,7 @@
>   config VIDEO_IMX_MEDIA
>   	tristate "i.MX5/6 V4L2 media core driver"
> -	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
> +	depends on ARCH_MXC || COMPILE_TEST
> +	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && IMX_IPUV3_CORE
>   	depends on VIDEO_V4L2_SUBDEV_API
>   	select VIDEOBUF2_DMA_CONTIG
>   	select V4L2_FWNODE
