Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:25077 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758087Ab0GTBQK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:16:10 -0400
Subject: [PATCH 05/17] cx23885: Add correct detection of the HVR-1250 model
 79501
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:12:21 -0400
Message-ID: <1279588341.28153.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The offset in the eeprom data for the 79501 version of the HVR-1250 is at 0xc0
vs. the standard 0x80.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-cards.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index d639186..093de84 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -586,6 +586,9 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 79101:
 		/* WinTV-HVR1250 (PCIe, Retail, IR, half height,
 			ATSC and Basic analog */
+	case 79501:
+		/* WinTV-HVR1250 (PCIe, No IR, half height,
+			ATSC [at least] and Basic analog) */
 	case 79561:
 		/* WinTV-HVR1250 (PCIe, OEM, No IR, half height,
 			ATSC and Basic analog */
@@ -988,6 +991,13 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 
 	switch (dev->board) {
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
+		if (dev->i2c_bus[0].i2c_rc == 0) {
+			if (eeprom[0x80] != 0x84)
+				hauppauge_eeprom(dev, eeprom+0xc0);
+			else
+				hauppauge_eeprom(dev, eeprom+0x80);
+		}
+		break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1500:
 	case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
-- 
1.7.1.1


