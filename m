Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38380 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaLGXiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 18:38:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	prabhakar.csengg@gmail.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/8] media/i2c/Kconfig: drop superfluous MEDIA_CONTROLLER
Date: Mon, 08 Dec 2014 01:38:55 +0200
Message-ID: <14053074.Xr1qj9KfnY@avalon>
In-Reply-To: <1417686899-30149-6-git-send-email-hverkuil@xs4all.nl>
References: <1417686899-30149-1-git-send-email-hverkuil@xs4all.nl> <1417686899-30149-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Thursday 04 December 2014 10:54:56 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These drivers depend on VIDEO_V4L2_SUBDEV_API, which in turn
> depends on MEDIA_CONTROLLER. So it is sufficient to just depend
> on VIDEO_V4L2_SUBDEV_API.

Shouldn't the VIDEO_V4L2_SUBDEV_API dependency be dropped from those (and 
other) subdev drivers ? They don't require the userspace API, just the kernel 
part.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/i2c/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index f40b4cf..29276fd 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -196,7 +196,7 @@ config VIDEO_ADV7183
> 
>  config VIDEO_ADV7604
>  	tristate "Analog Devices ADV7604 decoder"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	---help---
>  	  Support for the Analog Devices ADV7604 video decoder.
> 
> @@ -208,7 +208,7 @@ config VIDEO_ADV7604
> 
>  config VIDEO_ADV7842
>  	tristate "Analog Devices ADV7842 decoder"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	---help---
>  	  Support for the Analog Devices ADV7842 video decoder.
> 
> @@ -431,7 +431,7 @@ config VIDEO_ADV7393
> 
>  config VIDEO_ADV7511
>  	tristate "Analog Devices ADV7511 encoder"
> -	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	---help---
>  	  Support for the Analog Devices ADV7511 video encoder.

-- 
Regards,

Laurent Pinchart

