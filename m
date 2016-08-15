Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:46968 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbcHOKFC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 06:05:02 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 14/14] media: platform: pxa_camera: move pxa_camera out of soc_camera
References: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
	<1470684652-16295-15-git-send-email-robert.jarzmik@free.fr>
Date: Mon, 15 Aug 2016 12:04:57 +0200
In-Reply-To: <1470684652-16295-15-git-send-email-robert.jarzmik@free.fr>
	(Robert Jarzmik's message of "Mon, 8 Aug 2016 21:30:52 +0200")
Message-ID: <87r39qqree.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> As the conversion to a v4l2 standalone device is finished, move
> pxa_camera one directory up and finish severing any dependency to
> soc_camera.

> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 0bf33ccf9a1e..10f49214b521 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -25,8 +25,8 @@ config VIDEO_PXA27x
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
>  
> -config VIDEO_RCAR_VIN_OLD
> -	tristate "R-Car Video Input (VIN) support (DEPRECATED)"
> +config VIDEO_RCAR_VIN
> +	tristate "R-Car Video Input (VIN) support"
>  	depends on VIDEO_DEV && SOC_CAMERA
>  	depends on ARCH_RENESAS || COMPILE_TEST
>  	depends on HAS_DMA
This is wrong, looks like a rebase error, where instead of removing the
VIDEO_PXA27x config parameter I modify an RCAR_VIN one.

I will fix that for next iteration.

Cheers.

--
Robert
