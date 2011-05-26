Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:39554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081Ab1EZAK5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 20:10:57 -0400
Message-ID: <4DDD9A8A.3020109@redhat.com>
Date: Wed, 25 May 2011 21:10:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] The USB_SPEED... keywords are already defined by the
 USB stack. Rename currently unused macros to avoid possible future warnings
 and errors.
References: <201105231319.11284.hselasky@c2i.net>
In-Reply-To: <201105231319.11284.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 08:19, Hans Petter Selasky escreveu:
> --HPS
> 
> 
> dvb-usb-0001.patch
> 
> 
> From f7a0f7254da47ff88f69314f14043b01ba0764eb Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 12:43:50 +0200
> Subject: [PATCH] The USB_SPEED_XXX keywords are already defined by the USB stack. Rename currently unused macros to avoid possible future warnings and errors.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/dvb/dvb-usb/gp8psk.h |    6 +++---
>  drivers/media/dvb/dvb-usb/vp7045.h |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/dvb/dvb-usb/gp8psk.h
> index 831749a..c271b68 100644
> --- a/drivers/media/dvb/dvb-usb/gp8psk.h
> +++ b/drivers/media/dvb/dvb-usb/gp8psk.h
> @@ -78,9 +78,9 @@ extern int dvb_usb_gp8psk_debug;
>  #define ADV_MOD_DVB_BPSK 9     /* DVB-S BPSK */
>  
>  #define GET_USB_SPEED                     0x07
> - #define USB_SPEED_LOW                    0
> - #define USB_SPEED_FULL                   1
> - #define USB_SPEED_HIGH                   2
> + #define TH_USB_SPEED_LOW                 0
> + #define TH_USB_SPEED_FULL                1
> + #define TH_USB_SPEED_HIGH                2
>  
>  #define RESET_FX2                         0x13
>  
> diff --git a/drivers/media/dvb/dvb-usb/vp7045.h b/drivers/media/dvb/dvb-usb/vp7045.h
> index 969688f..7ce6c00 100644
> --- a/drivers/media/dvb/dvb-usb/vp7045.h
> +++ b/drivers/media/dvb/dvb-usb/vp7045.h
> @@ -36,9 +36,9 @@
>   #define Tuner_Power_OFF                  0
>  
>  #define GET_USB_SPEED                     0x07
> - #define USB_SPEED_LOW                    0
> - #define USB_SPEED_FULL                   1
> - #define USB_SPEED_HIGH                   2
> + #define TH_USB_SPEED_LOW                 0
> + #define TH_USB_SPEED_FULL                1
> + #define TH_USB_SPEED_HIGH                2
>  
>  #define LOCK_TUNER_COMMAND                0x09


Nah. Those vars are unused on those drivers. Just remove them.

Thanks!
Mauro.
