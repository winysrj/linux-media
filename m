Return-path: <mchehab@pedra>
Received: from vsmtpvtin1.tin.it ([212.216.176.105]:39588 "EHLO
	vsmtpvtin1.tin.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1F0QDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 12:03:46 -0400
Received: from [192.168.13.198] (80.169.201.166) by vsmtpvtin1.tin.it (8.5.132) (authenticated as demarsi@tin.it)
        id 4D95884601656849 for linux-media@vger.kernel.org; Mon, 27 Jun 2011 17:40:15 +0200
Message-ID: <4E08A463.2050101@gmail.com>
Date: Mon, 27 Jun 2011 17:40:19 +0200
From: Andrea De Marsi <andrea.demarsi@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: EM28xx based device support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear all,

I recently tried to have a wireless microscope working with the em28xx 
driver; the device is the following:

http://www.cosview.com/cp/html/?3.html

it is listed in the usb bus with vendor id 14c3 and product id 2301.
Looking the .inf of the MS windows driver I noticed that it seems to be 
based on a Empia em2860 chipset, therefore I modified the em28xx driver 
of the 2.6.24 linux kernel (specifically 2.6.24-28-generic linux kernel 
in a Ubuntu Hardy distribution) so that this particular vendor id and 
product id are associated to that driver (pls find patch below).

In fact this trick has worked, at least as far as the images are 
concerned (there is also a button to take picture which I will be 
working on later), and I've been able to see the images with the 
following parameters of mplayer:

mplayer -tv driver=v4l2:device=/dev/video0:norm=NTSC -vo x11 tv://

I now need to upgrade the linux kernel to a newer version (2.6.32 or 
newer); I followed the same path that was working with 2.6.24 (which is 
basically have the device recognized as an empia device) and in fact 
some images are visible but they are not stable; it seems as the new 
driver version was not capble of managing the NTSC format (in fact I 
noticed there is no more .norm field in the initialization structure).
Do you have any advice?

Thanks in advance,

Andrea


diff em28xx-modified/em28xx-cards.c em28xx-orig/em28xx-cards.c
266,283d265
<     [EM2861_BOARD_COSVIEW] = {
<         .name         = "Cosview Driver",
<         .is_em2800    = 0,
<         .vchannels    = 2,
<         .norm         = VIDEO_MODE_NTSC,
<         .tda9887_conf = TDA9887_PRESENT,
<         .has_tuner    = 1,
<         .decoder      = EM28XX_SAA7113,
<         .input           = {{
<             .type     = EM28XX_VMUX_COMPOSITE1,
<             .vmux     = SAA7115_COMPOSITE0,
<             .amux     = 1,
<         },{
<             .type     = EM28XX_VMUX_SVIDEO,
<             .vmux     = SAA7115_SVIDEO3,
<             .amux     = 1,
<         }},
<     },
295,296d276
<     { USB_DEVICE(0x2040, 0x6502), .driver_info = 
EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900 },
<     { USB_DEVICE(0x14c3, 0x2301), .driver_info = EM2861_BOARD_COSVIEW },
diff em28xx-modified/em28xx.h em28xx-orig/em28xx.h
49d48
< #define EM2861_BOARD_COSVIEW            14

