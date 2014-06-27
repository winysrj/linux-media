Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3642 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaF0OP4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 10:15:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: it@sca-uk.com, =stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] cx23885: add support for Hauppauge ImpactVCB-e
Date: Fri, 27 Jun 2014 16:15:42 +0200
Message-Id: <1403878542-1230-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
References: <1403878542-1230-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-cards.c | 31 ++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885-video.c |  1 +
 drivers/media/pci/cx23885/cx23885.h       |  1 +
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 79f20c8..9723067 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -649,7 +649,26 @@ struct cx23885_board cx23885_boards[] = {
 				  CX25840_NONE1_CH3,
 			.amux   = CX25840_AUDIO6,
 		} },
-	}
+	},
+	[CX23885_BOARD_HAUPPAUGE_IMPACTVCBE] = {
+		.name		= "Hauppauge ImpactVCB-e",
+		.tuner_type	= TUNER_ABSENT,
+		.porta		= CX23885_ANALOG_VIDEO,
+		.input          = {{
+			.type   = CX23885_VMUX_COMPOSITE1,
+			.vmux   = CX25840_VIN7_CH3 |
+				  CX25840_VIN4_CH2 |
+				  CX25840_VIN6_CH1,
+			.amux   = CX25840_AUDIO7,
+		}, {
+			.type   = CX23885_VMUX_SVIDEO,
+			.vmux   = CX25840_VIN7_CH3 |
+				  CX25840_VIN4_CH2 |
+				  CX25840_VIN8_CH1 |
+				  CX25840_SVIDEO_ON,
+			.amux   = CX25840_AUDIO7,
+		} },
+	},
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
 
@@ -897,6 +916,10 @@ struct cx23885_subid cx23885_subids[] = {
 		.subvendor = 0x1461,
 		.subdevice = 0xd939,
 		.card      = CX23885_BOARD_AVERMEDIA_HC81R,
+	}, {
+		.subvendor = 0x0070,
+		.subdevice = 0x7133,
+		.card      = CX23885_BOARD_HAUPPAUGE_IMPACTVCBE,
 	},
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -977,6 +1000,9 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 	case 71009:
 		/* WinTV-HVR1200 (PCIe, Retail, full height)
 		 * DVB-T and basic analog */
+	case 71100:
+		/* WinTV-ImpactVCB-e (PCIe, Retail, half height)
+		 * Basic analog */
 	case 71359:
 		/* WinTV-HVR1200 (PCIe, OEM, half height)
 		 * DVB-T and basic analog */
@@ -1701,6 +1727,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1850:
 	case CX23885_BOARD_HAUPPAUGE_HVR1290:
 	case CX23885_BOARD_HAUPPAUGE_HVR4400:
+	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
 		if (dev->i2c_bus[0].i2c_rc == 0)
 			hauppauge_eeprom(dev, eeprom+0xc0);
 		break;
@@ -1807,6 +1834,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_HAUPPAUGE_HVR1200:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_HAUPPAUGE_HVR1400:
+	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H_XC4000:
@@ -1835,6 +1863,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 			break;
 	case CX23885_BOARD_HAUPPAUGE_HVR1250:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800:
+	case CX23885_BOARD_HAUPPAUGE_IMPACTVCBE:
 	case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
 	case CX23885_BOARD_HAUPPAUGE_HVR1700:
 	case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 2a890e9..91e4cb4 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -507,6 +507,7 @@ static int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 	if ((dev->board == CX23885_BOARD_HAUPPAUGE_HVR1800) ||
 		(dev->board == CX23885_BOARD_MPX885) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1250) ||
+		(dev->board == CX23885_BOARD_HAUPPAUGE_IMPACTVCBE) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1255_22111) ||
 		(dev->board == CX23885_BOARD_HAUPPAUGE_HVR1850) ||
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 0fa4048..6a4b20e 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -96,6 +96,7 @@
 #define CX23885_BOARD_TBS_6981                 40
 #define CX23885_BOARD_TBS_6980                 41
 #define CX23885_BOARD_LEADTEK_WINFAST_PXPVR2200 42
+#define CX23885_BOARD_HAUPPAUGE_IMPACTVCBE     43
 
 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
-- 
2.0.0

