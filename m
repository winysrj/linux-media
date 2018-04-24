Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55913 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933202AbeDXNLj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 09:11:39 -0400
Received: by mail-wm0-f66.google.com with SMTP id a8so868804wmg.5
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 06:11:39 -0700 (PDT)
Received: from toshiba (541B3FFD.cm-5-4a.dynamic.ziggo.nl. [84.27.63.253])
        by smtp.gmail.com with ESMTPSA id y29sm9126984edl.6.2018.04.24.06.11.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 24 Apr 2018 06:11:38 -0700 (PDT)
Message-ID: <5adf2d0a.ddf1500a.f24fc.61a0@mx.google.com>
Date: Tue, 24 Apr 2018 15:11:35 +0200
From: mjs <mjstork@gmail.com>
To: "3 linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] remove 2 excess lines in driver module em28xx
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

=46rom 5103cc546075de0eb800f5a76f3212a3e342b833 Mon Sep 17 00:00:00 2001
From: Marcel Stork <mjstork@gmail.com>
Date: Tue, 24 Apr 2018 14:43:01 +0200
Subject: [PATCH] remove 2 excess lines in driver module em28xx

A cosmetic change by combining two sets of boards into one set because havi=
ng the same arguments.
=20
 Changes to be committed:
	modified:   em28xx-cards.c
---
 em28xx-cards.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/em28xx-cards.c b/em28xx-cards.c
index 6e0e67d..7fa9a00 100644
--- a/em28xx-cards.c
+++ b/em28xx-cards.c
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
