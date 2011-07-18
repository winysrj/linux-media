Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab1GRTy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2011 15:54:57 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6IJsvgi025579
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 18 Jul 2011 15:54:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH v2 7/9] [media] mceusb: flash LED (emu v2+ only) to signal end of init
Date: Mon, 18 Jul 2011 15:54:27 -0400
Message-Id: <1311018869-22794-8-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: rebase for mdelay->msleep changes and tx fix

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 9e71aef..160409e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -451,6 +451,7 @@ static char DEVICE_RESUME[]	= {MCE_CMD_NULL, MCE_CMD_PORT_SYS,
 static char GET_REVISION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_G_REVISION};
 static char GET_EMVER[]		= {MCE_CMD_PORT_SYS, MCE_CMD_GETEMVER};
 static char GET_WAKEVERSION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_GETWAKEVERSION};
+static char FLASH_LED[]		= {MCE_CMD_PORT_SYS, MCE_CMD_FLASHLED};
 static char GET_UNKNOWN2[]	= {MCE_CMD_PORT_IR, MCE_CMD_UNKNOWN2};
 static char GET_CARRIER_FREQ[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRCFS};
 static char GET_RX_TIMEOUT[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRTIMEOUT};
@@ -591,6 +592,9 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
 				dev_info(dev, "TX port %d: blaster is%s connected\n",
 					 data1 + 1, data4 ? " not" : "");
 			break;
+		case MCE_CMD_FLASHLED:
+			dev_info(dev, "Attempting to flash LED\n");
+			break;
 		default:
 			dev_info(dev, "Unknown command 0x%02x 0x%02x\n",
 				 cmd, subcmd);
@@ -1165,6 +1169,14 @@ static void mceusb_get_parameters(struct mceusb_dev *ir)
 	}
 }
 
+static void mceusb_flash_led(struct mceusb_dev *ir)
+{
+	if (ir->emver < 2)
+		return;
+
+	mce_async_out(ir, FLASH_LED, sizeof(FLASH_LED));
+}
+
 static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 {
 	struct device *dev = ir->dev;
@@ -1347,6 +1359,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 
 	mceusb_get_parameters(ir);
 
+	mceusb_flash_led(ir);
+
 	if (!ir->flags.no_tx)
 		mceusb_set_tx_mask(ir->rc, MCE_DEFAULT_TX_MASK);
 
-- 
1.7.1

