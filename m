Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab2DJW6K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 18:58:10 -0400
Message-ID: <4F84BAFE.60301@redhat.com>
Date: Tue, 10 Apr 2012 19:58:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Chmielewski <marek.chmielewski@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Add usb device id for tm6000-cards.c
References: <CAG9CFj=UWR4pSW=aYLTQiC5W+LTQHxzdAVnZ-is1vXisMWkBoQ@mail.gmail.com>
In-Reply-To: <CAG9CFj=UWR4pSW=aYLTQiC5W+LTQHxzdAVnZ-is1vXisMWkBoQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-03-2012 16:37, Marek Chmielewski escreveu:
> -- Pozdrawiam Marek Chmielewski
> 
> 
> patch_for_tm6000-cards.patch
> 
> 
> --- tm6000-cards.c.bakup	2012-03-10 14:34:07.471348336 +0100
> +++ tm6000-cards.c	2012-03-10 15:18:09.856380721 +0100

Please, use it ad diff -p1 format (e. g. a/drivers/media/video/tm6000/tm6000-cards.c). 
A tool like quilt or git would do it for you.

> @@ -615,6 +615,7 @@
>  struct usb_device_id tm6000_id_table[] = {
>  	{ USB_DEVICE(0x6000, 0x0001), .driver_info = TM5600_BOARD_GENERIC },
>  	{ USB_DEVICE(0x6000, 0x0002), .driver_info = TM6010_BOARD_GENERIC },
> +	{ USB_DEVICE(0x0572, 0x262a), .driver_info = TM5600_BOARD_GENERIC },

Hmm... different USB vendor??? Are you sure this is a generic board? It seems unlikely that
Trident would be using a different Vendor ID there.

If this is not a "Generic" ID (e.g. a Trident SDK ID), then you should, instead, create an
entry for your board.

>  	{ USB_DEVICE(0x06e1, 0xf332), .driver_info = TM6000_BOARD_ADSTECH_DUAL_TV },
>  	{ USB_DEVICE(0x14aa, 0x0620), .driver_info = TM6000_BOARD_FREECOM_AND_SIMILAR },
>  	{ USB_DEVICE(0x06e1, 0xb339), .driver_info = TM6000_BOARD_ADSTECH_MINI_DUAL_TV },
> 

Regards,
Mauro
