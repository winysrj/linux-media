Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([93.97.41.153]:41204 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab2HWVSh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 17:18:37 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Cc: =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH] [media] rc: do not sleep when the driver blocks on IR completion
Date: Thu, 23 Aug 2012 22:18:35 +0100
Message-Id: <1345756715-17643-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some drivers wait for the IR device to complete sending before
returning, so sleeping should not be done.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/iguanair.c      | 1 +
 drivers/media/rc/ir-lirc-codec.c | 5 +++++
 drivers/media/rc/winbond-cir.c   | 1 +
 include/media/rc-core.h          | 2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 66ba237..7f1941d 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -519,6 +519,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
 	rc->s_tx_mask = iguanair_set_tx_mask;
 	rc->s_tx_carrier = iguanair_set_tx_carrier;
 	rc->tx_ir = iguanair_tx;
+	rc->tx_ir_drains = 1;
 	rc->driver_name = DRIVER_NAME;
 	rc->map_name = RC_MAP_RC6_MCE;
 	rc->timeout = MS_TO_NS(100);
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 569124b..dd21917 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -144,6 +144,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	if (ret < 0)
 		goto out;
 
+	if (dev->tx_ir_drains) {
+		ret *= sizeof(unsigned int);
+		goto out;
+	}
+
 	for (i = 0; i < ret; i++)
 		duration += txbuf[i];
 
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 54ee348..b1b6d34 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1029,6 +1029,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 	data->dev->s_idle = wbcir_idle_rx;
 	data->dev->s_tx_mask = wbcir_txmask;
 	data->dev->s_tx_carrier = wbcir_txcarrier;
+	data->dev->tx_ir_drains = 1;
 	data->dev->tx_ir = wbcir_tx;
 	data->dev->priv = data;
 	data->dev->dev.parent = &device->dev;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index b0c494a..fc2318c 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -64,6 +64,7 @@ enum rc_driver_type {
  * @last_keycode: keycode of last keypress
  * @last_scancode: scancode of last keypress
  * @last_toggle: toggle value of last command
+ * @tx_ir_drains: tx_ir returns after IR has been sent
  * @timeout: optional time after which device stops sending data
  * @min_timeout: minimum timeout supported by device
  * @max_timeout: maximum timeout supported by device
@@ -108,6 +109,7 @@ struct rc_dev {
 	u32				last_keycode;
 	u32				last_scancode;
 	u8				last_toggle;
+	unsigned			tx_ir_drains:1;
 	u32				timeout;
 	u32				min_timeout;
 	u32				max_timeout;
-- 
1.7.11.4

