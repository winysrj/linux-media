Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:60853 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753539AbdBUUnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 15:43:46 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 02/19] [media] lirc: return ENOTTY when ioctl is not supported
Date: Tue, 21 Feb 2017 20:43:26 +0000
Message-Id: <cce1af7f154e86973725647b92b24bc8e134c47c.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
In-Reply-To: <cover.1487709384.git.sean@mess.org>
References: <cover.1487709384.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We shouldn't be using ENOSYS when a feature is not available. I've tested
lirc; nothing is broken as far as I can make out.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 20 ++++++++++----------
 drivers/media/rc/lirc_dev.c      |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 8517d51..637b583 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -139,7 +139,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	}
 
 	if (!dev->tx_ir) {
-		ret = -ENOSYS;
+		ret = -EINVAL;
 		goto out;
 	}
 
@@ -221,19 +221,19 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	/* TX settings */
 	case LIRC_SET_TRANSMITTER_MASK:
 		if (!dev->s_tx_mask)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		return dev->s_tx_mask(dev, val);
 
 	case LIRC_SET_SEND_CARRIER:
 		if (!dev->s_tx_carrier)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		return dev->s_tx_carrier(dev, val);
 
 	case LIRC_SET_SEND_DUTY_CYCLE:
 		if (!dev->s_tx_duty_cycle)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		if (val <= 0 || val >= 100)
 			return -EINVAL;
@@ -243,7 +243,7 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
 		if (!dev->s_rx_carrier_range)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		if (val <= 0)
 			return -EINVAL;
@@ -265,32 +265,32 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 	case LIRC_SET_WIDEBAND_RECEIVER:
 		if (!dev->s_learning_mode)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		return dev->s_learning_mode(dev, !!val);
 
 	case LIRC_SET_MEASURE_CARRIER_MODE:
 		if (!dev->s_carrier_report)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		return dev->s_carrier_report(dev, !!val);
 
 	/* Generic timeout support */
 	case LIRC_GET_MIN_TIMEOUT:
 		if (!dev->max_timeout)
-			return -ENOSYS;
+			return -ENOTTY;
 		val = DIV_ROUND_UP(dev->min_timeout, 1000);
 		break;
 
 	case LIRC_GET_MAX_TIMEOUT:
 		if (!dev->max_timeout)
-			return -ENOSYS;
+			return -ENOTTY;
 		val = dev->max_timeout / 1000;
 		break;
 
 	case LIRC_SET_REC_TIMEOUT:
 		if (!dev->max_timeout)
-			return -ENOSYS;
+			return -ENOTTY;
 
 		tmp = val * 1000;
 
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index a54ca53..ccbdce0 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -623,7 +623,7 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		result = put_user(ir->d.max_timeout, (__u32 __user *)arg);
 		break;
 	default:
-		result = -EINVAL;
+		result = -ENOTTY;
 	}
 
 	mutex_unlock(&ir->irctl_lock);
-- 
2.9.3
