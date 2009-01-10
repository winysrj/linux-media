Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35163 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759152AbZAJA6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Jan 2009 19:58:35 -0500
Subject: Re: [patch 1/9] radio-si470x: add USB ID for dealextreme usb radio
From: Alexey Klimov <klimov.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, linux-usb@vger.kernel.org, lkml@rtr.ca,
	mlord@pobox.com, tobias.lorenz@gmx.net,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <200901092029.n09KTBTb025445@imap1.linux-foundation.org>
References: <200901092029.n09KTBTb025445@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 10 Jan 2009 03:58:54 +0300
Message-Id: <1231549134.4474.222.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added linux-media mailing list)

On Fri, 2009-01-09 at 12:29 -0800, akpm@linux-foundation.org wrote:
> From: Mark Lord <lkml@rtr.ca>
> 
> Add USB ID for the Sil4701 radio from DealExtreme.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> Cc: Tobias Lorenz <tobias.lorenz@gmx.net>
> Cc: Greg KH <greg@kroah.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/media/radio/radio-si470x.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff -puN drivers/media/radio/radio-si470x.c~radio-si470x-add-usb-id-for-dealextreme-usb-radio drivers/media/radio/radio-si470x.c
> --- a/drivers/media/radio/radio-si470x.c~radio-si470x-add-usb-id-for-dealextreme-usb-radio
> +++ a/drivers/media/radio/radio-si470x.c
> @@ -136,6 +136,8 @@
>  static struct usb_device_id si470x_usb_driver_id_table[] = {
>  	/* Silicon Labs USB FM Radio Reference Design */
>  	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c4, 0x818a, USB_CLASS_HID, 0, 0) },
> +	/* DealExtreme USB Radio */
> +	{ USB_DEVICE_AND_INTERFACE_INFO(0x10c5, 0x819a,	USB_CLASS_HID, 0, 0) },
>  	/* ADS/Tech FM Radio Receiver (formerly Instant FM Music) */
>  	{ USB_DEVICE_AND_INTERFACE_INFO(0x06e1, 0xa155, USB_CLASS_HID, 0, 0) },
>  	/* KWorld USB FM Radio SnapMusic Mobile 700 (FM700) */
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This patch already in Linus tree (in 2.6.28-git) and in v4l-dvb tree.
It is called "V4L/DVB (10157): Add USB ID for the Sil4701 radio from
DealExtreme"

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e6de7d9a1a373414a41a7441100f90b71c6119f

So, there is no need in this patch here.

-- 
Best regards, Klimov Alexey

