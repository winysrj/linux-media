Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51628 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbdJILAH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:00:07 -0400
Subject: Re: [PATCH 07/24] media: get rid of i2c-addr.h
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <3ed54fa388ce0ca9752f62eaddde150429bd7e3d.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9c2621a1-3618-31f5-1f3c-b9cbc7493e28@xs4all.nl>
Date: Mon, 9 Oct 2017 13:00:04 +0200
MIME-Version: 1.0
In-Reply-To: <3ed54fa388ce0ca9752f62eaddde150429bd7e3d.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> In the past, the same I2C address were used on multiple places.
> After I2C rebinding changes, this is no longer needed. So, we
> can just get rid of this header, placing the I2C address where
> they belong, e. g. either at bttv driver or at tvtuner.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Huh, I thought this header was nuked a long time ago...

Regards,

	Hans

> ---
>  drivers/media/i2c/tda7432.c             |  1 -
>  drivers/media/i2c/tvaudio.c             |  2 --
>  drivers/media/pci/bt8xx/bttv-cards.c    |  7 +++++++
>  drivers/media/pci/bt8xx/bttv.h          |  1 -
>  drivers/media/usb/em28xx/em28xx-cards.c |  1 -
>  drivers/media/usb/tm6000/tm6000-cards.c |  1 -
>  include/media/i2c-addr.h                | 35 ---------------------------------
>  include/media/i2c/tvaudio.h             | 17 +++++++++++++++-
>  8 files changed, 23 insertions(+), 42 deletions(-)
>  delete mode 100644 include/media/i2c-addr.h
> 
> diff --git a/drivers/media/i2c/tda7432.c b/drivers/media/i2c/tda7432.c
> index d87168adee45..1c5c61d829d6 100644
> --- a/drivers/media/i2c/tda7432.c
> +++ b/drivers/media/i2c/tda7432.c
> @@ -36,7 +36,6 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-ctrls.h>
> -#include <media/i2c-addr.h>
>  
>  #ifndef VIDEO_AUDIO_BALANCE
>  # define VIDEO_AUDIO_BALANCE 32
> diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
> index ce86534450ac..92718a9ff5ea 100644
> --- a/drivers/media/i2c/tvaudio.c
> +++ b/drivers/media/i2c/tvaudio.c
> @@ -40,8 +40,6 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  
> -#include <media/i2c-addr.h>
> -
>  /* ---------------------------------------------------------------------- */
>  /* insmod args                                                            */
>  
> diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
> index 5cc42b426715..7dcf509e66d9 100644
> --- a/drivers/media/pci/bt8xx/bttv-cards.c
> +++ b/drivers/media/pci/bt8xx/bttv-cards.c
> @@ -141,6 +141,13 @@ MODULE_PARM_DESC(audiodev, "specify audio device:\n"
>  MODULE_PARM_DESC(saa6588, "if 1, then load the saa6588 RDS module, default (0) is to use the card definition.");
>  MODULE_PARM_DESC(no_overlay, "allow override overlay default (0 disables, 1 enables) [some VIA/SIS chipsets are known to have problem with overlay]");
>  
> +
> +/* I2C addresses list */
> +#define I2C_ADDR_TDA7432	0x8a
> +#define I2C_ADDR_MSP3400	0x80
> +#define I2C_ADDR_MSP3400_ALT	0x88
> +
> +
>  /* ----------------------------------------------------------------------- */
>  /* list of card IDs for bt878+ cards                                       */
>  
> diff --git a/drivers/media/pci/bt8xx/bttv.h b/drivers/media/pci/bt8xx/bttv.h
> index 91301c3cad1e..faea9aeff711 100644
> --- a/drivers/media/pci/bt8xx/bttv.h
> +++ b/drivers/media/pci/bt8xx/bttv.h
> @@ -17,7 +17,6 @@
>  #include <linux/videodev2.h>
>  #include <linux/i2c.h>
>  #include <media/v4l2-device.h>
> -#include <media/i2c-addr.h>
>  #include <media/tuner.h>
>  
>  /* ---------------------------------------------------------- */
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 4c57fd7929cb..34e16f6ab4ac 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -36,7 +36,6 @@
>  #include <media/i2c/saa7115.h>
>  #include <dt-bindings/media/tvp5150.h>
>  #include <media/i2c/tvaudio.h>
> -#include <media/i2c-addr.h>
>  #include <media/tveeprom.h>
>  #include <media/v4l2-common.h>
>  #include <sound/ac97_codec.h>
> diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
> index 2537643a1808..b4df9181c54b 100644
> --- a/drivers/media/usb/tm6000/tm6000-cards.c
> +++ b/drivers/media/usb/tm6000/tm6000-cards.c
> @@ -23,7 +23,6 @@
>  #include <media/v4l2-common.h>
>  #include <media/tuner.h>
>  #include <media/i2c/tvaudio.h>
> -#include <media/i2c-addr.h>
>  #include <media/rc-map.h>
>  
>  #include "tm6000.h"
> diff --git a/include/media/i2c-addr.h b/include/media/i2c-addr.h
> deleted file mode 100644
> index fba0457b74c4..000000000000
> --- a/include/media/i2c-addr.h
> +++ /dev/null
> @@ -1,35 +0,0 @@
> -/*
> - *	V4L I2C address list
> - *
> - *
> - *	Copyright (C) 2006 Mauro Carvalho Chehab <mchehab@infradead.org>
> - *	Based on a previous mapping by
> - *	Ralph Metzler (rjkm@thp.uni-koeln.de)
> - *	Gerd Knorr <kraxel@goldbach.in-berlin.de>
> - *
> - */
> -
> -/* bttv address list */
> -#define I2C_ADDR_TDA7432	0x8a
> -#define I2C_ADDR_TDA8425	0x82
> -#define I2C_ADDR_TDA9840	0x84
> -#define I2C_ADDR_TDA9874	0xb0 /* also used by 9875 */
> -#define I2C_ADDR_TDA9875	0xb0
> -#define I2C_ADDR_MSP3400	0x80
> -#define I2C_ADDR_MSP3400_ALT	0x88
> -#define I2C_ADDR_TEA6300	0x80 /* also used by 6320 */
> -
> -/*
> - * i2c bus addresses for the chips supported by tvaudio.c
> - */
> -
> -#define I2C_ADDR_TDA8425	0x82
> -#define I2C_ADDR_TDA9840	0x84 /* also used by TA8874Z */
> -#define I2C_ADDR_TDA985x_L	0xb4 /* also used by 9873 */
> -#define I2C_ADDR_TDA985x_H	0xb6
> -#define I2C_ADDR_TDA9874	0xb0 /* also used by 9875 */
> -
> -#define I2C_ADDR_TEA6300	0x80 /* also used by 6320 */
> -#define I2C_ADDR_TEA6420	0x98
> -
> -#define I2C_ADDR_PIC16C54	0x96 /* PV951 */
> diff --git a/include/media/i2c/tvaudio.h b/include/media/i2c/tvaudio.h
> index 1ac8184693f8..f13e1a386364 100644
> --- a/include/media/i2c/tvaudio.h
> +++ b/include/media/i2c/tvaudio.h
> @@ -21,7 +21,22 @@
>  #ifndef _TVAUDIO_H
>  #define _TVAUDIO_H
>  
> -#include <media/i2c-addr.h>
> +/*
> + * i2c bus addresses for the chips supported by tvaudio.c
> + */
> +
> +#define I2C_ADDR_TDA8425	0x82
> +#define I2C_ADDR_TDA9840	0x84
> +#define I2C_ADDR_TDA9874	0xb0 /* also used by 9875 */
> +#define I2C_ADDR_TDA9875	0xb0
> +#define I2C_ADDR_TDA8425	0x82
> +#define I2C_ADDR_TDA9840	0x84 /* also used by TA8874Z */
> +#define I2C_ADDR_TDA985x_L	0xb4 /* also used by 9873 */
> +#define I2C_ADDR_TDA985x_H	0xb6
> +#define I2C_ADDR_TDA9874	0xb0 /* also used by 9875 */
> +#define I2C_ADDR_TEA6300	0x80 /* also used by 6320 */
> +#define I2C_ADDR_TEA6420	0x98
> +#define I2C_ADDR_PIC16C54	0x96 /* PV951 */
>  
>  /* The tvaudio module accepts the following inputs: */
>  #define TVAUDIO_INPUT_TUNER  0
> 
