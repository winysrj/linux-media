Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35956 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZHZIso (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 04:48:44 -0400
Received: by ewy2 with SMTP id 2so1181077ewy.17
        for <linux-media@vger.kernel.org>; Wed, 26 Aug 2009 01:48:44 -0700 (PDT)
Subject: Re: Prolems with RoverMedia Tv Link Pro(LifeView FlyVIDEO3000) and recent kernels
To: linux-media@vger.kernel.org
From: Eugene Yudin <eugene.yudin@gmail.com>
Date: Wed, 26 Aug 2009 12:52:14 +0400
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_+ePlKkKoMw85biM"
Message-Id: <200908261252.14713.Eugene.Yudin@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_+ePlKkKoMw85biM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hello Again! I solved the problem. 
First, I added it in "/etc/modprobe.d/modprobe.conf": 
alias char-major-81 videodev 
alias char-major-81-0 saa7134 

Secondly, because the tuner option is ignored, then I wrote a small patch to 
support the tuner. 
I added it to the letter. 

Thirdly, I added "/etc/modprobe.d/modprobe.conf": 
options saa7134 card=170 secam=dk 

After rebooting all earned perfect. 

It would be great if you added this patch to a new version of your wonderful 
driver.

If something is wrong, forgive me. This is my first patch in linux.

Best Regards, Eugene.

PS: If you just write card=2 tuner=63 at third step, the driver is not paying 
attention to the parameter tuner.

--Boundary-00=_+ePlKkKoMw85biM
Content-Type: text/x-patch;
  charset="UTF-8";
  name="rovermedia.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rovermedia.patch"

diff -r /home/eugene/.build/or/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c /home/eugene/.build/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
5184a5185,5235
> 	
> 	[SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM] = {
> 		/* Eugene Yudin <Eugene.Yudin@gmail.com> */
> 		.name		= "RoverMedia TV Link Pro FM",
> 		.audio_clock	= 0x00200000,
> 		.tuner_type	= TUNER_PHILIPS_FQ1216ME,
> 		.radio_type     = UNSET,
> 		.tuner_addr	= ADDR_UNSET,
> 		.radio_addr	= ADDR_UNSET,
> 		.tda9887_conf   = TDA9887_PRESENT,
> 
> 		.gpiomask       = 0xe000,
> 		.inputs         = {{
> 			.name = name_tv,
> 			.vmux = 1,
> 			.amux = TV,
> 			.gpio = 0x8000,
> 			.tv   = 1,
> 		},{
> 			.name = name_tv_mono,
> 			.vmux = 1,
> 			.amux = LINE2,
> 			.gpio = 0x0000,
> 			.tv   = 1,
> 		},{
> 			.name = name_comp1,
> 			.vmux = 0,
> 			.amux = LINE2,
> 			.gpio = 0x4000,
> 		},{
> 			.name = name_comp2,
> 			.vmux = 3,
> 			.amux = LINE2,
> 			.gpio = 0x4000,
> 		},{
> 			.name = name_svideo,
> 			.vmux = 8,
> 			.amux = LINE2,
> 			.gpio = 0x4000,
> 		}},
> 		.radio = {
> 			.name = name_radio,
> 			.amux = LINE2,
> 			.gpio = 0x2000,
> 		},
> 		.mute = {
> 			.name = name_mute,
> 			.amux = TV,
> 			.gpio = 0x8000,
> 		},
> 	},
6336a6388,6393
> 		.vendor       = PCI_VENDOR_ID_PHILIPS,
> 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7134,
> 		.subvendor    = 0x19d1,
> 		.subdevice    = 0x0138,
> 		.driver_data  = SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM,
> 	},{
6815a6873,6875
> 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
> 		dev->has_remote = SAA7134_REMOTE_GPIO;
> 		break;
diff -r /home/eugene/.build/or/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c /home/eugene/.build/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c
458a459
> 	case SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM:
diff -r /home/eugene/.build/or/v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h /home/eugene/.build/v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h
296a297
> #define SAA7134_BOARD_ROVERMEDIA_LINK_PRO_FM 170

--Boundary-00=_+ePlKkKoMw85biM--
