Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51225 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965996AbcAZOdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 09:33:14 -0500
Date: Tue, 26 Jan 2016 12:33:08 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] em28xx: add MEDIA_TUNER dependency
Message-ID: <20160126123308.6d59d373@recife.lan>
In-Reply-To: <1453817424-3080054-6-git-send-email-arnd@arndb.de>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
	<1453817424-3080054-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 15:10:00 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> em28xx selects VIDEO_TUNER, which has a dependency on MEDIA_TUNER,
> so we get a Kconfig warning if that is disabled:
> 
> warning: (VIDEO_PVRUSB2 && VIDEO_USBVISION && VIDEO_GO7007 && VIDEO_AU0828_V4L2 && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)

This warning is bogus, as it is OK to select VIDEO_TUNER even if MEDIA_TUNER
is not defined.

See how MEDIA_TUNER is defined:


config MEDIA_TUNER
	tristate
	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT) && I2C
	default y
	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT

MEDIA_TUNER is just one of the media Kconfig workarounds to its limitation of
not allowing to select a device that has dependencies. It is true if the user
selected either TV or radio media devices. It works together with 
MEDIA_SUBDRV_AUTOSELECT. When both are enabled, it selects all
media tuners. That makes easier for end users to not need to worry about
manually selecting the needed tuners.

Advanced users may, instead, manually select the media tuner that his
hardware needs. In such case, it doesn't matter if MEDIA_TUNER
is enabled or not.

As this is due to a Kconfig limitation, I've no idea how to fix or get
hid of it, but making em28xx dependent of MEDIA_TUNER is wrong.

Also, as this is a Kconfig hidden option, making em28xx dependent of
MEDIA_TUNER would actually disable it, if no other media driver is
compiled.

The problem here is that the em28xx driver is used by several different
types of devices:

- pure webcam devices. Those devices don't have a tuner;
- stream capture devices. Those devices don't have a tuner;
- analog TV devices. For analog TV to work, MEDIA_TUNER is needed. Still,
  most of those devices have Composite and S-VIDEO ports. It is possible
  to use the driver for stream capture on those ports even if MEDIA_TUNER
  is not compiled;
- digital TV devices. Those require either a tuner or a DVB frontend.
- any combination of the above.

Regards,
Mauro

> 
> This adds a dependency on MEDIA_TUNER to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/usb/em28xx/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
> index 75323f5efd0f..cacc757e2254 100644
> --- a/drivers/media/usb/em28xx/Kconfig
> +++ b/drivers/media/usb/em28xx/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_EM28XX
>  	tristate "Empia EM28xx USB devices support"
> -	depends on VIDEO_DEV && I2C
> +	depends on VIDEO_DEV && I2C && MEDIA_TUNER
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  
