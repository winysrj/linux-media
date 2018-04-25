Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55275 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755145AbeDYS6a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 14:58:30 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6so8908696wmc.4
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 11:58:30 -0700 (PDT)
Received: from toshiba (90-145-46-101.wxdsl.nl. [90.145.46.101])
        by smtp.gmail.com with ESMTPSA id g15sm11702300edb.69.2018.04.25.11.58.28
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Apr 2018 11:58:29 -0700 (PDT)
Message-ID: <5ae0cfd5.0f98500a.620a6.4a7c@mx.google.com>
Date: Wed, 25 Apr 2018 20:58:28 +0200
From: mjs <mjstork@gmail.com>
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] [2] Remove 2 excess lines in driver module em28xx
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=46rom c5007d7596dd755fb5d95664d9eda9733d7df461 Mon Sep 17 00:00:00 2001
From: Marcel Stork <mjstork@gmail.com>
Date: Wed, 25 Apr 2018 19:34:20 +0200
Subject: [PATCH] Remove 2 excess lines in driver module em28xx

A cosmetic change by combining two sets of boards into one set because havi=
ng the same arguments.
=20
Changes to be committed:
	modified: drivers/media/usb/em28xx/em28xx-cards.c

Signed-off-by: Marcel Stork <mjstork@gmail.com>

---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em=
28xx/em28xx-cards.c
index 6e0e67d2..7fa9a00e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3182,8 +3182,6 @@ void em28xx_setup_xc3028(struct em28xx *dev, struct x=
c2028_ctrl *ctl)
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
 	case EM2882_BOARD_TERRATEC_HYBRID_XS:
-		ctl->demod =3D XC3028_FE_ZARLINK456;
-		break;
 	case EM2880_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
 	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
--=20
2.11.0
