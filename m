Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:42202 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427401AbeBORhK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Feb 2018 12:37:10 -0500
Received: by mail-pg0-f67.google.com with SMTP id y8so295494pgr.9
        for <linux-media@vger.kernel.org>; Thu, 15 Feb 2018 09:37:10 -0800 (PST)
Subject: Re: [PATCH] imx/Kconfig: add depends on HAS_DMA
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <ec6cb539-4571-f006-513d-9ac5e955e236@xs4all.nl>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <f3cee891-ee06-6362-50a2-ec1f1f9d1fc8@gmail.com>
Date: Thu, 15 Feb 2018 09:37:05 -0800
MIME-Version: 1.0
In-Reply-To: <ec6cb539-4571-f006-513d-9ac5e955e236@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Steve Longerbeam <steve_longerbeam@mentor.com>


On 02/15/2018 07:54 AM, Hans Verkuil wrote:
> Add missing dependency.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
> index 59b380cc6d22..bfc17de56b17 100644
> --- a/drivers/staging/media/imx/Kconfig
> +++ b/drivers/staging/media/imx/Kconfig
> @@ -3,6 +3,7 @@ config VIDEO_IMX_MEDIA
>   	depends on ARCH_MXC || COMPILE_TEST
>   	depends on MEDIA_CONTROLLER && VIDEO_V4L2 && IMX_IPUV3_CORE
>   	depends on VIDEO_V4L2_SUBDEV_API
> +	depends on HAS_DMA
>   	select VIDEOBUF2_DMA_CONTIG
>   	select V4L2_FWNODE
>   	---help---
