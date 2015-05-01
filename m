Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39049 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbbEAKGk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 May 2015 06:06:40 -0400
Date: Fri, 1 May 2015 07:06:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] media: i2c: ov2659: add VIDEO_V4L2_SUBDEV_API
 dependency
Message-ID: <20150501070633.18cbc3ad@recife.lan>
In-Reply-To: <1428701313-16367-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1428701313-16367-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Apr 2015 22:28:33 +0100
Lad Prabhakar <prabhakar.csengg@gmail.com> escreveu:

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch adds dependency of VIDEO_V4L2_SUBDEV_API
> for VIDEO_OV2659 so that it doesn't complain for random
> config builds.

Actually, this doesn't seem right. Why should this driver depend on
an optional API? It should be possible to use it on some bridge driver
that doesn't expose the subdev API. So, please fix it the other
way, by making subdev API optional on it.

Regards,
Mauro

> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/i2c/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 6f30ea7..8b05681 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -468,7 +468,7 @@ config VIDEO_SMIAPP_PLL
>  
>  config VIDEO_OV2659
>  	tristate "OmniVision OV2659 sensor support"
> -	depends on VIDEO_V4L2 && I2C
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
>  	depends on MEDIA_CAMERA_SUPPORT
>  	---help---
>  	  This is a Video4Linux2 sensor-level driver for the OmniVision
