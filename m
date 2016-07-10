Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56155 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933464AbcGJQek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 12:34:40 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Chris Dodge <chris@redrat.co.uk>, linux-media@vger.kernel.org
Subject: [PATCH 4/5] [media] redrat3: make hardware timeout configurable
Date: Sun, 10 Jul 2016 17:34:38 +0100
Message-Id: <1468168479-27543-2-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c |  5 ++++-
 drivers/media/rc/redrat3.c       | 34 ++++++++++++++++++++++++++++++++++
 include/media/rc-core.h          |  3 +++
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 5effc65..c327730 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -292,7 +292,10 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		    tmp > dev->max_timeout)
 				return -EINVAL;
 
-		dev->timeout = tmp;
+		if (dev->s_timeout)
+			ret = dev->s_timeout(dev, tmp);
+		if (!ret)
+			dev->timeout = tmp;
 		break;
 
 	case LIRC_SET_REC_TIMEOUT_REPORTS:
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 1e65f7a..399f44d 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -475,6 +475,37 @@ static u32 redrat3_get_timeout(struct redrat3_dev *rr3)
 	return timeout;
 }
 
+static int redrat3_set_timeout(struct rc_dev *rc_dev, unsigned int timeoutns)
+{
+	struct redrat3_dev *rr3 = rc_dev->priv;
+	struct usb_device *udev = rr3->udev;
+	struct device *dev = rr3->dev;
+	u32 *timeout;
+	int ret;
+
+	timeout = kmalloc(sizeof(*timeout), GFP_KERNEL);
+	if (!timeout)
+		return -ENOMEM;
+
+	*timeout = cpu_to_be32(redrat3_us_to_len(timeoutns / 1000));
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
+		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+		     RR3_IR_IO_SIG_TIMEOUT, 0, timeout, sizeof(*timeout),
+		     HZ * 25);
+	dev_dbg(dev, "set ir parm timeout %d ret 0x%02x\n",
+						be32_to_cpu(*timeout), ret);
+
+	if (ret == sizeof(*timeout)) {
+		rr3->hw_timeout = timeoutns / 1000;
+		ret = 0;
+	} else if (ret >= 0)
+		ret = -EIO;
+
+	kfree(timeout);
+
+	return ret;
+}
+
 static void redrat3_reset(struct redrat3_dev *rr3)
 {
 	struct usb_device *udev = rr3->udev;
@@ -856,7 +887,10 @@ static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
 	rc->priv = rr3;
 	rc->driver_type = RC_DRIVER_IR_RAW;
 	rc->allowed_protocols = RC_BIT_ALL;
+	rc->min_timeout = MS_TO_NS(RR3_RX_MIN_TIMEOUT);
+	rc->max_timeout = MS_TO_NS(RR3_RX_MAX_TIMEOUT);
 	rc->timeout = US_TO_NS(rr3->hw_timeout);
+	rc->s_timeout = redrat3_set_timeout;
 	rc->tx_ir = redrat3_transmit_ir;
 	rc->s_tx_carrier = redrat3_set_tx_carrier;
 	rc->driver_name = DRIVER_NAME;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0f77b3d..b69d946 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -119,6 +119,7 @@ enum rc_filter_type {
  * @s_carrier_report: enable carrier reports
  * @s_filter: set the scancode filter
  * @s_wakeup_filter: set the wakeup scancode filter
+ * @s_timeout: set hardware timeout in ns
  */
 struct rc_dev {
 	struct device			dev;
@@ -174,6 +175,8 @@ struct rc_dev {
 						    struct rc_scancode_filter *filter);
 	int				(*s_wakeup_filter)(struct rc_dev *dev,
 							   struct rc_scancode_filter *filter);
+	int				(*s_timeout)(struct rc_dev *dev,
+						     unsigned int timeout);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
-- 
2.7.4

