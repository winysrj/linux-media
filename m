Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49147 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132Ab1DLQ2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 12:28:48 -0400
Received: by wwa36 with SMTP id 36so8113554wwa.1
        for <linux-media@vger.kernel.org>; Tue, 12 Apr 2011 09:28:47 -0700 (PDT)
References: <BANLkTi=JhkPHFrBx62fP0EfUEBSp9RDBNw@mail.gmail.com> <BANLkTimKck8GwXPNOQdu17PD1QtppfJCVg@mail.gmail.com>
In-Reply-To: <BANLkTimKck8GwXPNOQdu17PD1QtppfJCVg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <E3EB9AF6-50E7-4B6B-99E7-B51B5FCDBC35@wilsonet.com>
Content-Transfer-Encoding: 8BIT
Cc: linux-media@vger.kernel.org
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: cx231xx: add support for Kworld..
Date: Tue, 12 Apr 2011 12:28:56 -0400
To: =?iso-8859-1?Q?M=E1rcio_Alves?= <froooozen@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Apr 11, 2011, at 6:57 PM, Márcio Alves wrote:

> patch to cx231xx: add support for Kworld UB430
> Signed-off-by: Márcio A Alves <froooozen@gmail.com>
> 
> diff -upr ../new_build2/linux//drivers/media/dvb/dvb-usb/dvb-usb-ids.h linux//drivers/media/dvb/dvb-usb/dvb-usb-ids.h
> --- ../new_build2/linux//drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-02-28 01:45:23.000000000 -0300
> +++ linux//drivers/media/dvb/dvb-usb/dvb-usb-ids.h	2011-04-11 14:23:31.836858001 -0300
> @@ -125,6 +125,7 @@
>  #define USB_PID_GRANDTEC_DVBT_USB_COLD			0x0fa0
>  #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
>  #define USB_PID_INTEL_CE9500				0x9500
> +#define USB_PID_KWORLD_UB430				0xe424
>  #define USB_PID_KWORLD_399U				0xe399
>  #define USB_PID_KWORLD_399U_2				0xe400
>  #define USB_PID_KWORLD_395U				0xe396

That addition does nothing, since cx231xx-*.c don't include that
header. Its only for use by drivers under dvb-usb/. Just leave
this out.

...
> diff -upr ../new_build2/linux//drivers/media/video/cx231xx/cx231xx.h linux//drivers/media/video/cx231xx/cx231xx.h
> --- ../new_build2/linux//drivers/media/video/cx231xx/cx231xx.h	2011-03-11 13:25:49.000000000 -0300
> +++ linux//drivers/media/video/cx231xx/cx231xx.h	2011-04-11 14:20:30.616858003 -0300
> @@ -64,7 +64,8 @@
>  #define CX231XX_BOARD_HAUPPAUGE_EXETER  8
>  #define CX231XX_BOARD_HAUPPAUGE_USBLIVE2 9
>  #define CX231XX_BOARD_PV_PLAYTV_USB_HYBRID 10
> -#define CX231XX_BOARD_PV_XCAPTURE_USB 11
> +#define CX231XX_BOARD_KWORLD_UB430_USB_HYBRID 11
> +#define CX231XX_BOARD_PV_XCAPTURE_USB 12
>  
>  /* Limits minimum and default number of buffers */
>  #define CX231XX_MIN_BUF                 4

You should add to the end of the list, as device 12, not move an
already existing device.

Those two minor nits aside, the patch looks sane.

-- 
Jarod Wilson
jarod@wilsonet.com



