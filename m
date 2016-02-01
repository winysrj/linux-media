Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39597 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbcBAN0W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2016 08:26:22 -0500
Date: Mon, 1 Feb 2016 11:26:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org,
	user-mode-linux-devel@lists.sourceforge.net,
	Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 17/22] media: Fix dependencies for !HAS_IOMEM archs
Message-ID: <20160201112610.6dc22cd0@recife.lan>
In-Reply-To: <1453760661-1444-18-git-send-email-richard@nod.at>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
	<1453760661-1444-18-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Jan 2016 23:24:16 +0100
Richard Weinberger <richard@nod.at> escreveu:

> Not every arch has io memory.
> While the driver has correct dependencies the select statement
> will bypass the HAS_IOMEM dependency.

No, if a driver has:
	config foo
	depends on HAS_IOMEM
	select I2C

the select will only be handled if HAS_IOMEM. It won't bypass HAS_IOMEM
(and if it is bypassing, then there's some regression at the building
system, and lots of other things would break).

Also, changing from select to depends on I2C_MUX is not nice for users,
as it is not intuitive that a driver would need such core support for
a media driver to work.

> So, unbreak the build by rendering it into a real dependency.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/media/Kconfig             | 3 +--
>  drivers/media/usb/cx231xx/Kconfig | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index a8518fb..5553cb1 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -187,8 +187,7 @@ config MEDIA_SUBDRV_AUTOSELECT
>  	bool "Autoselect ancillary drivers (tuners, sensors, i2c, frontends)"
>  	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_CAMERA_SUPPORT || MEDIA_SDR_SUPPORT
>  	depends on HAS_IOMEM
> -	select I2C
> -	select I2C_MUX
> +	depends on I2C_MUX && I2C
>  	default y
>  	help
>  	  By default, a media driver auto-selects all possible ancillary

Here, everything is OK. No need to convert it to depends on.

> diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
> index 0cced3e..30ae67d 100644
> --- a/drivers/media/usb/cx231xx/Kconfig
> +++ b/drivers/media/usb/cx231xx/Kconfig
> @@ -1,13 +1,13 @@
>  config VIDEO_CX231XX
>  	tristate "Conexant cx231xx USB video capture support"
>  	depends on VIDEO_DEV && I2C
> +	depends on I2C_MUX
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	depends on RC_CORE
>  	select VIDEOBUF_VMALLOC
>  	select VIDEO_CX25840
>  	select VIDEO_CX2341X
> -	select I2C_MUX

So, just this should be enough to fix the dependencies for HAS_IOMEM/I2C_MUX
at the drivers under drivers/media:

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 0cced3e5b040..67d21b026054 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_CX231XX
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
+	depends on HAS_IOMEM # due to I2C_MUX
 	select I2C_MUX
 
 	---help---


Regards,
Mauro

