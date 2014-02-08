Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56069 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaBHPIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Feb 2014 10:08:34 -0500
Received: by mail-wi0-f182.google.com with SMTP id f8so1645622wiw.15
        for <linux-media@vger.kernel.org>; Sat, 08 Feb 2014 07:08:33 -0800 (PST)
Message-ID: <1391872102.3386.10.camel@canaries32-MCP7A>
Subject: Re: video from USB DVB-T get  damaged after some time
From: Malcolm Priestley <tvboxspy@gmail.com>
To: kapetr@mizera.cz
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Date: Sat, 08 Feb 2014 15:08:22 +0000
In-Reply-To: <52F6429E.6070704@mizera.cz>
References: <52F50E0B.1060507@mizera.cz> <52F56971.8060104@iki.fi>
	 <52F6429E.6070704@mizera.cz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2014-02-08 at 15:43 +0100, kapetr@mizera.cz wrote:
> Hello,
> 
> unfortunately I do not understand development, patching, compiling things.
> I have try it but I need more help.
> 
> I have done:
> 
> git clone --depth=1 git://linuxtv.org/media_build.git
> cd media_build
> ./build
> 
> it downloads and builds all. At begin of compiling I had stop it.
> Then I did manual change of
> ./media_build/linux/drivers/media/usb/dvb-usb-v2/af9035.c
> 
> ------------------- old part:
>          { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
>                  &af9035_props, "TerraTec Cinergy T Stick (rev. 2)", 
> NULL) },
>          /* IT9135 devices */
> #if 0
>          { DVB_USB_DEVICE(0x048d, 0x9135,
>                  &af9035_props, "IT9135 reference design", NULL) },
>          { DVB_USB_DEVICE(0x048d, 0x9006,
>                  &af9035_props, "IT9135 reference design", NULL) },
> #endif
>          /* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
>          { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
>                  &af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 
> 2)", NULL) },
> ----------------------------- new:
> 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
> 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
> 	/* IT9135 devices */
> 
> 	{ DVB_USB_DEVICE(0x048d, 0x9135,
> 		&af9035_props, "IT9135 reference design", NULL) },
> 
> 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
> 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
> 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)", NULL) },
> --------------------------------------------
> 
> 
> But now I do not know how to "restart" build process.

Just 

make

from media_build directory.

> 
> I have try:
> 
> cd /tmp/media_build/linux
> make
> 
> It had compiled *. and *.ko files.
> 
you need to run
/sbin/depmod -a

and reboot

it best to just run with su/sudo 

make install

I have just tested all the single ids.

I am about to send a patch to add all the single tuner ids
to af9035 from it913x.

I haven't found any problems.


Regards


Malcolm

