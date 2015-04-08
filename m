Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52177 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbbDHPbn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 11:31:43 -0400
Date: Wed, 8 Apr 2015 12:31:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] CONFIG_VIDEO_DEV needs to be enabled by
 MEDIA_DIGITAL_TV_SUPPORT also
Message-ID: <20150408123137.45872734@recife.lan>
In-Reply-To: <20150215221313.4844.16785.stgit@warthog.procyon.org.uk>
References: <20150215221313.4844.16785.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 15 Feb 2015 22:13:13 +0000
David Howells <dhowells@redhat.com> escreveu:

> CONFIG_VIDEO_DEV needs to be enabled by MEDIA_DIGITAL_TV_SUPPORT so that DVB
> TV receiver drivers can be enabled.

Actually, no. VIDEO_DEV enables the V4L2 core, with is not needed by pure
DVB devices.

Ok, some drivers are hybrid, and there's no way to enable just the DVB part
of the driver. So, for those specific drivers, both analog and digital
support should be enabled. 

This is actually a driver issue, as the driver was written originally for
analog, and then extended to support digital, without making the analog
part optional. I fixed this on a few drivers (like em28xx). It is not that
hard to split the driver, but it requires some care and careful tests to
avoiding breaking the driver, as sometimes the register init for the
device mixes analog and digital init at the same part of the driver.

Regards,
Mauro

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/media/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 49cd308..52d4a20 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -102,7 +102,7 @@ config MEDIA_CONTROLLER
>  config VIDEO_DEV
>  	tristate
>  	depends on MEDIA_SUPPORT
> -	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
> +	depends on MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
>  	default y
>  
>  config VIDEO_V4L2_SUBDEV_API
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
