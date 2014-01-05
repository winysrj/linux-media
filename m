Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62616 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaAEKMD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 05:12:03 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so7363895eek.17
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 02:12:02 -0800 (PST)
Message-ID: <52C93036.1040102@googlemail.com>
Date: Sun, 05 Jan 2014 11:13:10 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 02/22] [media] em28xx: some cosmetic changes
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-3-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> In order to make easier for the next patches, do some
> cosmetic changes.
>
> No functional changes.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-cards.c |  2 +-
>  drivers/media/usb/em28xx/em28xx-video.c |  2 --
>  drivers/media/usb/em28xx/em28xx.h       | 11 ++++++-----
>  3 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 19827e79cf53..551cbc294190 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -2106,7 +2106,7 @@ struct em28xx_board em28xx_boards[] = {
>  	},
>  	/* 1b80:e1cc Delock 61959
>  	 * Empia EM2874B + Micronas DRX 3913KA2 + NXP TDA18271HDC2
> -         * mostly the same as MaxMedia UB-425-TC but different remote */
> +	 * mostly the same as MaxMedia UB-425-TC but different remote */
>  	[EM2874_BOARD_DELOCK_61959] = {
>  		.name          = "Delock 61959",
>  		.tuner_type    = TUNER_ABSENT,
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index 70ffe259df5b..8b8a4eb96875 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -51,8 +51,6 @@
>  
>  #define DRIVER_DESC         "Empia em28xx based USB video device driver"
>  
> -#define EM28XX_VERSION "0.2.0"
> -
>  static unsigned int isoc_debug;
>  module_param(isoc_debug, int, 0644);
>  MODULE_PARM_DESC(isoc_debug, "enable debug messages [isoc transfers]");
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 0259270dda46..7ae05ebc13c1 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -26,6 +26,8 @@
>  #ifndef _EM28XX_H
>  #define _EM28XX_H
>  
> +#define EM28XX_VERSION "0.2.0"
> +
>  #include <linux/workqueue.h>
>  #include <linux/i2c.h>
>  #include <linux/mutex.h>
> @@ -522,9 +524,12 @@ struct em28xx {
>  	int model;		/* index in the device_data struct */
>  	int devno;		/* marks the number of this device */
>  	enum em28xx_chip_id chip_id;
> -	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
>  
> +	unsigned int is_em25xx:1;	/* em25xx/em276x/7x/8x family bridge */
>  	unsigned char disconnected:1;	/* device has been diconnected */
> +	unsigned int has_audio_class:1;
> +	unsigned int has_alsa_audio:1;
> +	unsigned int is_audio_only:1;
>  
>  	int audio_ifnum;
>  
> @@ -544,10 +549,6 @@ struct em28xx {
>  	/* Vinmode/Vinctl used at the driver */
>  	int vinmode, vinctl;
>  
> -	unsigned int has_audio_class:1;
> -	unsigned int has_alsa_audio:1;
> -	unsigned int is_audio_only:1;
> -
>  	/* Controls audio streaming */
>  	struct work_struct wq_trigger;	/* Trigger to start/stop audio for alsa module */
>  	atomic_t       stream_started;	/* stream should be running if true */

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

