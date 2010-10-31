Return-path: <mchehab@gaivota>
Received: from vbox10718.hkn.net ([213.9.107.18]:46201 "EHLO
	mail.pab-software.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab0JaNHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 09:07:44 -0400
Received: from [192.168.2.101] (dslb-088-071-137-037.pools.arcor-ip.net [88.71.137.37])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.pab-software.de (Postfix) with ESMTPSA id DB51652EEB88
	for <linux-media@vger.kernel.org>; Sun, 31 Oct 2010 13:59:31 +0100 (CET)
Subject: Terratec Cinergy Hybrid T USB XS
From: Philippe Bourdin <richel@AngieBecker.ch>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-q0DZPVPDnftlwiTUg1EY"
Date: Sun, 31 Oct 2010 13:57:58 +0100
Message-ID: <1288529878.1858.16.camel@andromeda>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


--=-q0DZPVPDnftlwiTUg1EY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit


	Hello,

I found that the problems people have reported with the USB-TV-stick
"Terratec Cinergy Hybrid T USB XS" (USB-ID: 0ccd:0042)
are coming from a wrong header file in the v4l-sources.

Attached is a diff, which fixes the problem (tested successfully here).
Obviously the USB-ID has been associated with a wrong chip: EM2880
instead of EM2882, which would be correct.

Thanks and best regards,

	Philippe Bourdin.


--=-q0DZPVPDnftlwiTUg1EY
Content-Disposition: attachment; filename="em28xx-cards.c.diff"
Content-Type: text/x-patch; name="em28xx-cards.c.diff"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-07-11 16:27:35.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2010-07-10 17:18:42.000000000 +0200
@@ -1494,7 +1494,7 @@
 		} },
 	},
 	[EM2882_BOARD_TERRATEC_HYBRID_XS] = {
-		.name         = "Terratec Hybrid XS (em2882)",
+		.name         = "Terratec Cinnergy Hybrid T USB XS (em2882)",
 		.tuner_type   = TUNER_XC2028,
 		.tuner_gpio   = default_tuner_gpio,
 		.mts_firmware = 1,
@@ -1794,7 +1794,7 @@
 	{ USB_DEVICE(0x0ccd, 0x005e),
 			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0042),
-			.driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
+			.driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
 	{ USB_DEVICE(0x0ccd, 0x0043),
 			.driver_info = EM2870_BOARD_TERRATEC_XS },
 	{ USB_DEVICE(0x0ccd, 0x0047),


--=-q0DZPVPDnftlwiTUg1EY--

