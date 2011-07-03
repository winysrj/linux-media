Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51524 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750869Ab1GCRCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:02:49 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 12/16] ngene: Support DuoFlex CT attached to CineS2 and SaTiX-S2
Date: Sun, 3 Jul 2011 18:59:30 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031859.31661@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Support DuoFlex CT with Digital Devices CineS2 and Mystique SaTiX-S2.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-cards.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index e6d5176..9f72dd8 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -401,7 +401,7 @@ static struct ngene_info ngene_info_satixS2v2 = {
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
 			   NGENE_IO_TSOUT},
 	.demod_attach	= {demod_attach_stv0900, demod_attach_stv0900, cineS2_probe, cineS2_probe},
-	.tuner_attach	= {tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110},
+	.tuner_attach	= {tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_probe, tuner_attach_probe},
 	.fe_config	= {&fe_cineS2, &fe_cineS2, &fe_cineS2_2, &fe_cineS2_2},
 	.tuner_config	= {&tuner_cineS2_0, &tuner_cineS2_1, &tuner_cineS2_0, &tuner_cineS2_1},
 	.lnb		= {0x0a, 0x08, 0x0b, 0x09},
@@ -416,7 +416,7 @@ static struct ngene_info ngene_info_cineS2v5 = {
 	.io_type	= {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
 			   NGENE_IO_TSOUT},
 	.demod_attach	= {demod_attach_stv0900, demod_attach_stv0900, cineS2_probe, cineS2_probe},
-	.tuner_attach	= {tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_stv6110},
+	.tuner_attach	= {tuner_attach_stv6110, tuner_attach_stv6110, tuner_attach_probe, tuner_attach_probe},
 	.fe_config	= {&fe_cineS2, &fe_cineS2, &fe_cineS2_2, &fe_cineS2_2},
 	.tuner_config	= {&tuner_cineS2_0, &tuner_cineS2_1, &tuner_cineS2_0, &tuner_cineS2_1},
 	.lnb		= {0x0a, 0x08, 0x0b, 0x09},
-- 
1.7.4.1

