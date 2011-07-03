Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:51503 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750842Ab1GCRCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 13:02:49 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 11/16] ngene: Fix name of Digital Devices PCIe/miniPCIe
Date: Sun, 3 Jul 2011 18:58:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107031858.23566@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix name of Digital Devices PCIe/miniPCIe.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/media/dvb/ngene/ngene-cards.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 0d879cb..e6d5176 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -426,9 +426,9 @@ static struct ngene_info ngene_info_cineS2v5 = {
 };
 
 
-static struct ngene_info ngene_info_duoFlexS2 = {
+static struct ngene_info ngene_info_duoFlex = {
 	.type           = NGENE_SIDEWINDER,
-	.name           = "Digital Devices DuoFlex S2 miniPCIe",
+	.name           = "Digital Devices DuoFlex PCIe or miniPCIe",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN, NGENE_IO_TSIN,
 			   NGENE_IO_TSOUT},
 	.demod_attach   = {cineS2_probe, cineS2_probe, cineS2_probe, cineS2_probe},
@@ -480,8 +480,8 @@ static const struct pci_device_id ngene_id_tbl[] __devinitdata = {
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
 	NGENE_ID(0x18c3, 0xdb02, ngene_info_satixS2v2),
 	NGENE_ID(0x18c3, 0xdd00, ngene_info_cineS2v5),
-	NGENE_ID(0x18c3, 0xdd10, ngene_info_duoFlexS2),
-	NGENE_ID(0x18c3, 0xdd20, ngene_info_duoFlexS2),
+	NGENE_ID(0x18c3, 0xdd10, ngene_info_duoFlex),
+	NGENE_ID(0x18c3, 0xdd20, ngene_info_duoFlex),
 	NGENE_ID(0x1461, 0x062e, ngene_info_m780),
 	{0}
 };
-- 
1.7.4.1

