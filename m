Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:57889 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbZG1VKg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 17:10:36 -0400
Subject: [PATCH] saa7134: fix the radio on Avermedia GO 007 FM
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-media@vger.kernel.org
Cc: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>,
	Laszlo Kustan <lkustan@gmail.com>
Content-Type: multipart/mixed; boundary="=-8yQUkjRW39VDH/xdy1+z"
Date: Tue, 28 Jul 2009 23:07:11 +0200
Message-Id: <1248815231.3430.143.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8yQUkjRW39VDH/xdy1+z
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

We have support for radio on saa7133/35/31e cards with tda8290/8275(a)
and 5.5MHz ceramic filter on the bridge chips since a while.

It was previously not tested, if this card supports it too, but the old
"ghost" radio with wrong filters doesn't work anymore.

Thanks go to Pham Thanh Nam and Laszlo Kustan for reporting it working
on that input.

Signed-off-by: hermann pitton <hermann-pitton@arcor.de>

diff -r fd96af63f79b linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jun 19 19:56:56 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jul 28 22:16:52 2009 +0200
@@ -1633,7 +1633,7 @@
 		}},
 		.radio = {
 			.name = name_radio,
-			.amux = LINE1,
+			.amux = TV,
 			.gpio = 0x00300001,
 		},
 		.mute = {



--=-8yQUkjRW39VDH/xdy1+z
Content-Disposition: inline; filename=saa7134_fix_radio_of_Avermedia-GO-007-FM.patch
Content-Type: text/x-patch; name=saa7134_fix_radio_of_Avermedia-GO-007-FM.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r fd96af63f79b linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Jun 19 19:56:56 2009 +0000
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Jul 28 22:16:52 2009 +0200
@@ -1633,7 +1633,7 @@
 		}},
 		.radio = {
 			.name = name_radio,
-			.amux = LINE1,
+			.amux = TV,
 			.gpio = 0x00300001,
 		},
 		.mute = {

--=-8yQUkjRW39VDH/xdy1+z--

