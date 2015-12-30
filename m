Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57800 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbbL3PWj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 10:22:39 -0500
Received: from [192.168.1.40] ([146.60.55.33]) by smtp.web.de (mrweb003) with
 ESMTPSA (Nemesis) id 0MNcHy-1aKKzH0iMM-007F6M for
 <linux-media@vger.kernel.org>; Wed, 30 Dec 2015 16:22:37 +0100
Subject: Re: Probably a new board ID for em28xx: [1b80:e349]
To: linux-media@vger.kernel.org
References: <567FC93D.7060602@web.de>
From: Peter Schlaf <peter.schlaf@web.de>
Message-ID: <5683F6BC.2070005@web.de>
Date: Wed, 30 Dec 2015 16:22:36 +0100
MIME-Version: 1.0
In-Reply-To: <567FC93D.7060602@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To whom it may concern...

Added this device to em28xx-cards.c and used 
"EM2860_BOARD_HT_VIDBOX_NW03" as ID
because it's the only device listed there that has the same chips as my 
hardware.
Recompiled the module and it works!

--- /usr/src/linux/drivers/media/usb/em28xx/em28xx-cards.c 2015-11-26 
17:35:17.000000000 +0100
+++ em28xx-cards.c      2015-12-30 14:54:19.000000000 +0100
@@ -2475,6 +2475,8 @@ struct usb_device_id em28xx_id_table[] =
                         .driver_info = EM2861_BOARD_LEADTEK_VC100 },
         { USB_DEVICE(0xeb1a, 0x8179),
                         .driver_info = 
EM28178_BOARD_TERRATEC_T2_STICK_HD },
+       { USB_DEVICE(0x1b80, 0xe349),
+                       .driver_info = EM2860_BOARD_HT_VIDBOX_NW03 },
         { },
  };
  MODULE_DEVICE_TABLE(usb, em28xx_id_table);

