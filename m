Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:46985 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab2HMM7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Aug 2012 08:59:53 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Stefan Macher <st_maker-lirc@yahoo.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 02/13] [media] iguanair: ignore unsupported firmware versions
Date: Mon, 13 Aug 2012 13:59:40 +0100
Message-Id: <1344862791-30352-2-git-send-email-sean@mess.org>
In-Reply-To: <1344862791-30352-1-git-send-email-sean@mess.org>
References: <1344862791-30352-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Firmware versions lower than 0x0205 use a different interface which is not
supported. Also report the firmware version in the standard format.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/Kconfig    |  8 ++++++--
 drivers/media/rc/iguanair.c | 21 +++++++++++----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 5180390..2e91e66 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -264,8 +264,12 @@ config IR_IGUANA
 	depends on RC_CORE
 	select USB
 	---help---
-	   Say Y here if you want to use the IgaunaWorks USB IR Transceiver.
-	   Both infrared receive and send are supported.
+	   Say Y here if you want to use the IguanaWorks USB IR Transceiver.
+	   Both infrared receive and send are supported. If you want to
+	   change the ID or the pin config, use the user space driver from
+	   IguanaWorks.
+
+	   Only firmware 0x0205 and later is supported.
 
 	   To compile this driver as a module, choose M here: the module will
 	   be called iguanair.
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index bdd526d..5885400 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -36,8 +36,8 @@ struct iguanair {
 	struct usb_device *udev;
 
 	int pipe_out;
+	uint16_t version;
 	uint8_t bufsize;
-	uint8_t version[2];
 
 	struct mutex lock;
 
@@ -97,8 +97,8 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 		switch (ir->buf_in[3]) {
 		case CMD_GET_VERSION:
 			if (len == 6) {
-				ir->version[0] = ir->buf_in[4];
-				ir->version[1] = ir->buf_in[5];
+				ir->version = (ir->buf_in[5] << 8) |
+							ir->buf_in[4];
 				complete(&ir->completion);
 			}
 			break;
@@ -110,8 +110,7 @@ static void process_ir_data(struct iguanair *ir, unsigned len)
 			break;
 		case CMD_GET_FEATURES:
 			if (len > 5) {
-				if (ir->version[0] >= 4)
-					ir->cycle_overhead = ir->buf_in[5];
+				ir->cycle_overhead = ir->buf_in[5];
 				complete(&ir->completion);
 			}
 			break;
@@ -219,6 +218,12 @@ static int iguanair_get_features(struct iguanair *ir)
 		goto out;
 	}
 
+	if (ir->version < 0x205) {
+		dev_err(ir->dev, "firmware 0x%04x is too old\n", ir->version);
+		rc = -ENODEV;
+		goto out;
+	}
+
 	ir->bufsize = 150;
 	ir->cycle_overhead = 65;
 
@@ -230,9 +235,6 @@ static int iguanair_get_features(struct iguanair *ir)
 		goto out;
 	}
 
-	if (ir->version[0] == 0 || ir->version[1] == 0)
-		goto out;
-
 	packet.cmd = CMD_GET_FEATURES;
 
 	rc = iguanair_send(ir, &packet, sizeof(packet));
@@ -485,8 +487,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 		goto out2;
 
 	snprintf(ir->name, sizeof(ir->name),
-		"IguanaWorks USB IR Transceiver version %d.%d",
-		ir->version[0], ir->version[1]);
+		"IguanaWorks USB IR Transceiver version 0x%04x", ir->version);
 
 	usb_make_path(ir->udev, ir->phys, sizeof(ir->phys));
 
-- 
1.7.11.2

