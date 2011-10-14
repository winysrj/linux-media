Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe01.c2i.net ([212.247.154.2]:49110 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751326Ab1JNHad (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 03:30:33 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Piotr Chmura <chmooreck@poczta.onet.pl>
Subject: Re: [PATCH] dvb/as102 nBox DVB-T dongle
Date: Fri, 14 Oct 2011 09:27:23 +0200
Cc: linux-media@vger.kernel.org
References: <4E273AB5.7090405@poczta.onet.pl>
In-Reply-To: <4E273AB5.7090405@poczta.onet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110140927.23067.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Could someone pull the AS102 driver into the media tree?

http://git.linuxtv.org/media_tree.git/tree/HEAD:/drivers/media/dvb

--HPS


On Wednesday 20 July 2011 22:29:41 Piotr Chmura wrote:
> I just bought DVB-T USB dongle for one of polish digital platform. It
> works fine with as102 driver.
> Here is patch adding vendor and product ID to as102 driver taken from
> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102.
> I tested it with kernel-3.0-rc7-git7 (had to change usb_buffer_alloc()
> to usb_alloc_coherent and usb_buffer_free to usb_free_coherent() ).
> 
> patch:
> 
> diff -Nur linux/drivers/media/dvb/as102/as102_usb_drv.c
> linux-mine/drivers/media/dvb/as102/as102_usb_drv.c
> --- as102/as102_usb_drv.c    2011-07-20 21:37:33.924143297 +0200
> +++ /usr/src/linux/drivers/media/dvb/as102/as102_usb_drv.c    2011-07-20
> 20:40:21.000000000 +0200
> @@ -39,6 +39,7 @@
>   static struct usb_device_id as102_usb_id_table[] = {
>       { USB_DEVICE(AS102_USB_DEVICE_VENDOR_ID, AS102_USB_DEVICE_PID_0001)
> }, { USB_DEVICE(PCTV_74E_USB_VID, PCTV_74E_USB_PID) },
> +    { USB_DEVICE(NBOX_USB_VID, NBOX_USB_PID) },
>       { USB_DEVICE(ELGATO_EYETV_DTT_USB_VID, ELGATO_EYETV_DTT_USB_PID) },
>       { } /* Terminating entry */
>   };
> @@ -48,6 +49,7 @@
>   static const char *as102_device_names[] = {
>       AS102_REFERENCE_DESIGN,
>       AS102_PCTV_74E,
> +    AS102_NBOX,
>       AS102_ELGATO_EYETV_DTT_NAME,
>       NULL /* Terminating entry */
>   };
> diff -Nur linux/drivers/media/dvb/as102/as102_usb_drv.h
> linux-mine/drivers/media/dvb/as102/as102_usb_drv.h
> --- as102/as102_usb_drv.h    2011-07-20 21:37:33.925143297 +0200
> +++ /usr/src/linux/drivers/media/dvb/as102/as102_usb_drv.h    2011-07-20
> 20:39:46.000000000 +0200
> @@ -36,6 +36,11 @@
>   #define PCTV_74E_USB_VID        0x2013
>   #define PCTV_74E_USB_PID        0x0246
> 
> +/* nBox DVB-T Stick */
> +#define AS102_NBOX            "nBox DVB-T Stick"
> +#define NBOX_USB_VID            0x0b89
> +#define NBOX_USB_PID            0x0007
> +
>   /* Elgato: EyeTV DTT Deluxe */
>   #define AS102_ELGATO_EYETV_DTT_NAME    "Elgato EyeTV DTT Deluxe"
>   #define ELGATO_EYETV_DTT_USB_VID    0x0fd9
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
