Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53626 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbaI2ORj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 10:17:39 -0400
Received: by mail-pa0-f44.google.com with SMTP id et14so2763798pad.17
        for <linux-media@vger.kernel.org>; Mon, 29 Sep 2014 07:17:39 -0700 (PDT)
Date: Mon, 29 Sep 2014 22:17:36 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Add IR support for DVBSky T9580 Dual DVB-S2/T2/C PCIe card
Message-ID: <201409292217331712046@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T9580 uses Integrated CX23885 IR controller to decode IR signal.
The IR type of DVBSky remote control is RC5.

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 3 +++
 drivers/media/pci/cx23885/cx23885-input.c | 8 ++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 88c257d..d07f025 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1621,6 +1621,7 @@ int cx23885_ir_init(struct cx23885_dev *dev)
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
+	case CX23885_BOARD_DVBSKY_T9580:
 		if (!enable_885_ir)
 			break;
 		dev->sd_ir = cx23885_find_hw(dev, CX23885_HW_AV_CORE);
@@ -1667,6 +1668,7 @@ void cx23885_ir_fini(struct cx23885_dev *dev)
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
+	case CX23885_BOARD_DVBSKY_T9580:
 		cx23885_irq_remove(dev, PCI_MSK_AV_CORE);
 		/* sd_ir is a duplicate pointer to the AV Core, just clear it */
 		dev->sd_ir = NULL;
@@ -1714,6 +1716,7 @@ void cx23885_ir_pci_int_enable(struct cx23885_dev *dev)
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
+	case CX23885_BOARD_DVBSKY_T9580:
 		if (dev->sd_ir)
 			cx23885_irq_add_enable(dev, PCI_MSK_AV_CORE);
 		break;
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 9d37fe6..f81c2f9 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -87,6 +87,7 @@ void cx23885_input_rx_work_handler(struct cx23885_dev *dev, u32 events)
 	case CX23885_BOARD_MYGICA_X8507:
 	case CX23885_BOARD_TBS_6980:
 	case CX23885_BOARD_TBS_6981:
+	case CX23885_BOARD_DVBSKY_T9580:
 		/*
 		 * The only boards we handle right now.  However other boards
 		 * using the CX2388x integrated IR controller should be similar
@@ -139,6 +140,7 @@ static int cx23885_input_ir_start(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_MYGICA_X8507:
+	case CX23885_BOARD_DVBSKY_T9580:
 		/*
 		 * The IR controller on this board only returns pulse widths.
 		 * Any other mode setting will fail to set up the device.
@@ -305,6 +307,12 @@ int cx23885_input_init(struct cx23885_dev *dev)
 		/* A guess at the remote */
 		rc_map = RC_MAP_TBS_NEC;
 		break;
+	case CX23885_BOARD_DVBSKY_T9580:
+		/* Integrated CX23885 IR controller */
+		driver_type = RC_DRIVER_IR_RAW;
+		allowed_protos = RC_BIT_ALL;
+		rc_map = RC_MAP_DVBSKY;
+		break;
 	default:
 		return -ENODEV;
 	}
-- 
1.9.1

