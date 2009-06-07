Return-path: <linux-media-owner@vger.kernel.org>
Received: from nschwqsrv03p.mx.bigpond.com ([61.9.189.237]:63957 "EHLO
	nschwqsrv03p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbZFGP1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2009 11:27:39 -0400
From: Barry Kitson <b.kitson@gmail.com>
To: linux-media@vger.kernel.org
Cc: Barry Kitson <b.kitson@gmail.com>
Subject: [PATCH] saa7134: add support for AVerMedia M103 (f736)
Date: Sun,  7 Jun 2009 23:41:03 +1000
Message-Id: <1244382063-9640-1-git-send-email-b.kitson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add 1461:f736 to the list of identifiers corresponding to the
SAA7134_BOARD_AVERMEDIA_M103 board.  This patch adds support for
a variant of the AVerMedia M103 MiniPCI DVB-T Hybrid card.

Signed-off-by: Barry Kitson <b.kitson@gmail.com>
---
 Documentation/video4linux/CARDLIST.saa7134  |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c |    6 ++++++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/Documentation/video4linux/CARDLIST.saa7134 b/Documentation/video4linux/CARDLIST.saa7134
index b8d4705..fa16e6c 100644
--- a/Documentation/video4linux/CARDLIST.saa7134
+++ b/Documentation/video4linux/CARDLIST.saa7134
@@ -143,7 +143,7 @@
 142 -> Beholder BeholdTV H6                     [5ace:6290]
 143 -> Beholder BeholdTV M63                    [5ace:6191]
 144 -> Beholder BeholdTV M6 Extra               [5ace:6193]
-145 -> AVerMedia MiniPCI DVB-T Hybrid M103      [1461:f636]
+145 -> AVerMedia MiniPCI DVB-T Hybrid M103      [1461:f636,1461:f736]
 146 -> ASUSTeK P7131 Analog
 147 -> Asus Tiger 3in1                          [1043:4878]
 148 -> Encore ENLTV-FM v5.3                     [1a7f:2008]
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index e2febcd..0863c3e 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -5723,6 +5723,12 @@ struct pci_device_id saa7134_pci_tbl[] = {
 	}, {
 		.vendor       = PCI_VENDOR_ID_PHILIPS,
 		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
+		.subvendor    = 0x1461, /* Avermedia Technologies Inc */
+		.subdevice    = 0xf736,
+		.driver_data  = SAA7134_BOARD_AVERMEDIA_M103,
+	}, {
+		.vendor       = PCI_VENDOR_ID_PHILIPS,
+		.device       = PCI_DEVICE_ID_PHILIPS_SAA7133,
 		.subvendor    = 0x1043,
 		.subdevice    = 0x4878, /* REV:1.02G */
 		.driver_data  = SAA7134_BOARD_ASUSTeK_TIGER_3IN1,
-- 
1.6.3.1

