Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab1GNWKC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 18:10:02 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6EMA2N1029103
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 18:10:02 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 5/9] [media] mceusb: query device for firmware emulator version
Date: Thu, 14 Jul 2011 18:09:50 -0400
Message-Id: <1310681394-3530-6-git-send-email-jarod@redhat.com>
In-Reply-To: <1310681394-3530-1-git-send-email-jarod@redhat.com>
References: <1310681394-3530-1-git-send-email-jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Supposedly, there are essentially three different classes of devices
that are compatible with Microsoft's specs. First are the "legacy"
devices, which are built using Microsoft-provided hardware specs and
firmware. Second are "emulator" devices, which are built using custom
hardware and firmware, written to emulate Microsoft's firmware. Third
are "port" devices, which have their own device driver and firmware,
which provides compatible data to higher levels of the stack.

>From what I can tell, things like nuvoton-cir and fintek-cir are
essentially "port" devices -- their raw IR buffer format is very similar
to that of the mceusb devices. Now, within the mceusb driver, we have
three different "generations", which at first, seemed like maybe they
mapped to emulator versions. Unfortuantely, every single device I have
responds "illegal command" to the query to get firmware emulator version
from the hardware, which means they're either all emulator version 1, or
they're legacy devices, and our different "generations" aren't at all
related here. Though in theory, its possible the gen1 devices are
"legacy" devices and the rest are emulator v1. There are some useful
features of the v2 interface I was hoping to play with, but alas...

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/mceusb.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a777623..114fb13 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -439,12 +439,14 @@ struct mceusb_dev {
 	enum mceusb_model_type model;
 
 	bool need_reset;	/* flag to issue a device resume cmd */
+	u8 emver;		/* emulator interface version */
 };
 
 /* MCE Device Command Strings, generally a port and command pair */
 static char DEVICE_RESUME[]	= {MCE_CMD_NULL, MCE_CMD_PORT_SYS,
 				   MCE_CMD_RESUME};
 static char GET_REVISION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_G_REVISION};
+static char GET_EMVER[]		= {MCE_CMD_PORT_SYS, MCE_CMD_GETEMVER};
 static char GET_WAKEVERSION[]	= {MCE_CMD_PORT_SYS, MCE_CMD_GETWAKEVERSION};
 static char GET_UNKNOWN2[]	= {MCE_CMD_PORT_IR, MCE_CMD_UNKNOWN2};
 static char GET_CARRIER_FREQ[]	= {MCE_CMD_PORT_IR, MCE_CMD_GETIRCFS};
@@ -916,6 +918,9 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 		break;
 
 	/* 1-byte return value commands */
+	case MCE_RSP_EQEMVER:
+		ir->emver = hi;
+		break;
 	case MCE_RSP_EQIRTXPORTS:
 		ir->tx_mask = hi;
 		break;
@@ -1038,6 +1043,13 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
 	usb_submit_urb(urb, GFP_ATOMIC);
 }
 
+static void mceusb_get_emulator_version(struct mceusb_dev *ir)
+{
+	/* If we get no reply or an illegal command reply, its ver 1, says MS */
+	ir->emver = 1;
+	mce_async_out(ir, GET_EMVER, sizeof(GET_EMVER));
+}
+
 static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int ret;
@@ -1291,6 +1303,9 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	mce_dbg(&intf->dev, "Flushing receive buffers\n");
 	mce_flush_rx_buffer(ir, maxp);
 
+	/* figure out which firmware/emulator version this hardware has */
+	mceusb_get_emulator_version(ir);
+
 	/* initialize device */
 	if (ir->flags.microsoft_gen1)
 		mceusb_gen1_init(ir);
@@ -1308,8 +1323,8 @@ static int __devinit mceusb_dev_probe(struct usb_interface *intf,
 	device_set_wakeup_capable(ir->dev, true);
 	device_set_wakeup_enable(ir->dev, true);
 
-	dev_info(&intf->dev, "Registered %s on usb%d:%d\n", name,
-		 dev->bus->busnum, dev->devnum);
+	dev_info(&intf->dev, "Registered %s with mce emulator interface "
+		 "version %x\n", name, ir->emver);
 
 	return 0;
 
-- 
1.7.1

