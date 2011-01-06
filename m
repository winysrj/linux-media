Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:64199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab1AFUAN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jan 2011 15:00:13 -0500
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 5/6] rc: fix up and genericize some time unit conversions
Date: Thu,  6 Jan 2011 14:59:36 -0500
Message-Id: <1294343977-31929-6-git-send-email-jarod@redhat.com>
In-Reply-To: <1294343839-31784-1-git-send-email-jarod@redhat.com>
References: <1294343839-31784-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

The ene_ir driver was using a private define of MS_TO_NS, which is meant
to be microseconds to nanoseconds. The mceusb driver copied it,
intending to use is a milliseconds to microseconds. Lets move the
defines to a common location, expand and standardize them a touch, so
that we now have:

  MS_TO_NS - milliseconds to nanoseconds
  MS_TO_US - milliseconds to microseconds
  US_TO_NS - microseconds to nanoseconds

Reported-by: David Härdeman <david@hardeman.nu>
CC: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ene_ir.c |   16 ++++++++--------
 drivers/media/rc/ene_ir.h |    2 --
 drivers/media/rc/mceusb.c |    7 +++----
 include/media/rc-core.h   |    3 +++
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 885abdd..1ac4913 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -446,27 +446,27 @@ static void ene_rx_setup(struct ene_device *dev)
 
 select_timeout:
 	if (dev->rx_fan_input_inuse) {
-		dev->rdev->rx_resolution = MS_TO_NS(ENE_FW_SAMPLE_PERIOD_FAN);
+		dev->rdev->rx_resolution = US_TO_NS(ENE_FW_SAMPLE_PERIOD_FAN);
 
 		/* Fan input doesn't support timeouts, it just ends the
 			input with a maximum sample */
 		dev->rdev->min_timeout = dev->rdev->max_timeout =
-			MS_TO_NS(ENE_FW_SMPL_BUF_FAN_MSK *
+			US_TO_NS(ENE_FW_SMPL_BUF_FAN_MSK *
 				ENE_FW_SAMPLE_PERIOD_FAN);
 	} else {
-		dev->rdev->rx_resolution = MS_TO_NS(sample_period);
+		dev->rdev->rx_resolution = US_TO_NS(sample_period);
 
 		/* Theoreticly timeout is unlimited, but we cap it
 		 * because it was seen that on one device, it
 		 * would stop sending spaces after around 250 msec.
 		 * Besides, this is close to 2^32 anyway and timeout is u32.
 		 */
-		dev->rdev->min_timeout = MS_TO_NS(127 * sample_period);
-		dev->rdev->max_timeout = MS_TO_NS(200000);
+		dev->rdev->min_timeout = US_TO_NS(127 * sample_period);
+		dev->rdev->max_timeout = US_TO_NS(200000);
 	}
 
 	if (dev->hw_learning_and_tx_capable)
-		dev->rdev->tx_resolution = MS_TO_NS(sample_period);
+		dev->rdev->tx_resolution = US_TO_NS(sample_period);
 
 	if (dev->rdev->timeout > dev->rdev->max_timeout)
 		dev->rdev->timeout = dev->rdev->max_timeout;
@@ -801,7 +801,7 @@ static irqreturn_t ene_isr(int irq, void *data)
 
 		dbg("RX: %d (%s)", hw_sample, pulse ? "pulse" : "space");
 
-		ev.duration = MS_TO_NS(hw_sample);
+		ev.duration = US_TO_NS(hw_sample);
 		ev.pulse = pulse;
 		ir_raw_event_store_with_filter(dev->rdev, &ev);
 	}
@@ -821,7 +821,7 @@ static void ene_setup_default_settings(struct ene_device *dev)
 	dev->learning_mode_enabled = learning_mode_force;
 
 	/* Set reasonable default timeout */
-	dev->rdev->timeout = MS_TO_NS(150000);
+	dev->rdev->timeout = US_TO_NS(150000);
 }
 
 /* Upload all hardware settings at once. Used at load and resume time */
diff --git a/drivers/media/rc/ene_ir.h b/drivers/media/rc/ene_ir.h
index c179baf..337a41d 100644
--- a/drivers/media/rc/ene_ir.h
+++ b/drivers/media/rc/ene_ir.h
@@ -201,8 +201,6 @@
 #define dbg_verbose(format, ...)	__dbg(2, format, ## __VA_ARGS__)
 #define dbg_regs(format, ...)		__dbg(3, format, ## __VA_ARGS__)
 
-#define MS_TO_NS(msec) ((msec) * 1000)
-
 struct ene_device {
 	struct pnp_dev *pnp_dev;
 	struct rc_dev *rdev;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 0fef6ef..2d91134 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -48,7 +48,6 @@
 #define USB_BUFLEN		32 /* USB reception buffer length */
 #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
 #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
-#define MS_TO_NS(msec)		((msec) * 1000)
 
 /* MCE constants */
 #define MCE_CMDBUF_SIZE		384  /* MCE Command buffer length */
@@ -817,7 +816,7 @@ static void mceusb_handle_command(struct mceusb_dev *ir, int index)
 	switch (ir->buf_in[index]) {
 	/* 2-byte return value commands */
 	case MCE_CMD_S_TIMEOUT:
-		ir->rc->timeout = MS_TO_NS((hi << 8 | lo) / 2);
+		ir->rc->timeout = MS_TO_US((hi << 8 | lo) / 2);
 		break;
 
 	/* 1-byte return value commands */
@@ -858,7 +857,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
 			ir->rem--;
 			rawir.pulse = ((ir->buf_in[i] & MCE_PULSE_BIT) != 0);
 			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
-					 * MS_TO_NS(MCE_TIME_UNIT);
+					 * MS_TO_US(MCE_TIME_UNIT);
 
 			dev_dbg(ir->dev, "Storing %s with duration %d\n",
 				rawir.pulse ? "pulse" : "space",
@@ -1061,7 +1060,7 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 	rc->priv = ir;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protos = RC_TYPE_ALL;
-	rc->timeout = MS_TO_NS(1000);
+	rc->timeout = MS_TO_US(1000);
 	if (!ir->flags.no_tx) {
 		rc->s_tx_mask = mceusb_set_tx_mask;
 		rc->s_tx_carrier = mceusb_set_tx_carrier;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index a23c1fc..2963263 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -183,6 +183,9 @@ static inline void init_ir_raw_event(struct ir_raw_event *ev)
 }
 
 #define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
+#define US_TO_NS(usec)		((usec) * 1000)
+#define MS_TO_US(msec)		((msec) * 1000)
+#define MS_TO_NS(msec)		((msec) * 1000 * 1000)
 
 void ir_raw_event_handle(struct rc_dev *dev);
 int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-- 
1.7.3.4

