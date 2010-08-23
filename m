Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0HWNaJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 09:30:09 -0400
Received: by bwz11 with SMTP id 11so3861905bwz.19
        for <linux-media@vger.kernel.org>; Mon, 23 Aug 2010 06:30:08 -0700 (PDT)
Date: Mon, 23 Aug 2010 09:30:14 -0400
From: Dmitri Belimov <d.belimov@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] Fix regression for BeholdTV Columbus.
Message-ID: <20100823093014.682ee959@glory.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/u_Su=/m2bIVmX_=G.HbtWaQ"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

--MP_/u_Su=/m2bIVmX_=G.HbtWaQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi 

Some time a go our customers wrote me about problem with our TV card
BeholdTV Columbus. It's PCMCIA TV card for notebook.
As I understand v4l has some regression with autodetect address of tuners.
I can set incorrect I2C address and had report about detect tuner. No any TV of course.
When I set correct tuner type and I2C address of the tuners all works well.

diff -r eff98a88caf3 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jun 24 05:14:22 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 21 10:38:28 2010 -0400
@@ -4362,13 +4362,13 @@
 	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
-		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV Columbus TVFM",
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV Columbus TV/FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
-		.radio_type     = UNSET,
-		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+		.radio_type     = TUNER_TEA5767,
+		.tuner_addr     = 0xc2 >> 1,
+		.radio_addr     = 0xc0 >> 1,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x000A8004,
 		.inputs         = {{

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>


With my best regards, Dmitry.
--MP_/u_Su=/m2bIVmX_=G.HbtWaQ
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_columbus_fix.patch

diff -r eff98a88caf3 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jun 24 05:14:22 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sat Aug 21 10:38:28 2010 -0400
@@ -4362,13 +4362,13 @@
 	},
 	[SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM] = {
 		/*       Beholder Intl. Ltd. 2008      */
-		/*Dmitry Belimov <d.belimov@gmail.com> */
-		.name           = "Beholder BeholdTV Columbus TVFM",
+		/* Dmitry Belimov <d.belimov@gmail.com> */
+		.name           = "Beholder BeholdTV Columbus TV/FM",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_ALPS_TSBE5_PAL,
-		.radio_type     = UNSET,
-		.tuner_addr     = ADDR_UNSET,
-		.radio_addr     = ADDR_UNSET,
+		.radio_type     = TUNER_TEA5767,
+		.tuner_addr     = 0xc2 >> 1,
+		.radio_addr     = 0xc0 >> 1,
 		.tda9887_conf   = TDA9887_PRESENT,
 		.gpiomask       = 0x000A8004,
 		.inputs         = {{

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/u_Su=/m2bIVmX_=G.HbtWaQ--
