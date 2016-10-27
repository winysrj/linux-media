Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:44135 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935657AbcJ0Of4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 10:35:56 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH] [media] lirc: introduce LIRC_SET_TRANSMITTER_WAIT ioctl
Date: Thu, 27 Oct 2016 15:35:53 +0100
Message-Id: <1477578953-5309-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc transmit waits for the IR to complete, since existing versions
of lircd (prior to 0.9.4) rely on this. Allows this to be configurable
if this is not desirable.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-func.rst          |  1 +
 .../media/uapi/rc/lirc-set-transmitter-wait.rst    | 46 ++++++++++++++++++++++
 Documentation/media/uapi/rc/lirc-write.rst         |  6 ++-
 drivers/media/rc/ir-lirc-codec.c                   | 29 +++++++++-----
 drivers/media/rc/rc-core-priv.h                    |  2 +-
 include/uapi/linux/lirc.h                          |  5 +++
 6 files changed, 76 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-transmitter-wait.rst

diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index 9b5a772..be02ca2 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -26,3 +26,4 @@ LIRC Function Reference
     lirc-set-rec-timeout-reports
     lirc-set-measure-carrier-mode
     lirc-set-wideband-receiver
+    lirc-set-transmitter-wait
diff --git a/Documentation/media/uapi/rc/lirc-set-transmitter-wait.rst b/Documentation/media/uapi/rc/lirc-set-transmitter-wait.rst
new file mode 100644
index 0000000..37835ad
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-transmitter-wait.rst
@@ -0,0 +1,46 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_transmitter_mask:
+
+*******************************
+ioctl LIRC_SET_TRANSMITTER_WAIT
+*******************************
+
+Name
+====
+
+LIRC_SET_TRANSMITTER_WAIT - Wait for IR to transmit
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, LIRC_SET_TRANSMITTER_WAIT, __u32 *enable )
+    :name: LIRC_SET_TRANSMITTER_WAIT
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``enable``
+    enable = 1 means wait for IR to transmit before write() returns,
+    enable = 0 means return as soon as the driver has sent the commmand
+    to the hardware.
+
+
+Description
+===========
+
+Early lirc drivers would only return from write() when the IR had been
+transmitted and the lirc daemon relies on this for calculating when to
+send the next IR signal. Some drivers (e.g. usb drivers) can return
+earlier than that.
+
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/Documentation/media/uapi/rc/lirc-write.rst b/Documentation/media/uapi/rc/lirc-write.rst
index 3b035c6..32c2152 100644
--- a/Documentation/media/uapi/rc/lirc-write.rst
+++ b/Documentation/media/uapi/rc/lirc-write.rst
@@ -46,8 +46,10 @@ The data written to the chardev is a pulse/space sequence of integer
 values. Pulses and spaces are only marked implicitly by their position.
 The data must start and end with a pulse, therefore, the data must
 always include an uneven number of samples. The write function must
-block until the data has been transmitted by the hardware. If more data
-is provided than the hardware can send, the driver returns ``EINVAL``.
+block until the data has been transmitted by the hardware, unless
+:ref:`LIRC_SET_TRANSMITTER_WAIT <LIRC_SET_TRANSMITTER_WAIT>` has been
+disabled. If more data is provided than the hardware can send, the driver
+returns ``EINVAL``.
 
 
 Return Value
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index c327730..110e501 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -161,17 +161,19 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 
 	ret *= sizeof(unsigned int);
 
-	/*
-	 * The lircd gap calculation expects the write function to
-	 * wait for the actual IR signal to be transmitted before
-	 * returning.
-	 */
-	towait = ktime_us_delta(ktime_add_us(start, duration), ktime_get());
-	if (towait > 0) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(usecs_to_jiffies(towait));
+	if (!lirc->tx_no_wait) {
+		/*
+		 * The lircd gap calculation expects the write function to
+		 * wait for the actual IR signal to be transmitted before
+		 * returning.
+		 */
+		towait = ktime_us_delta(ktime_add_us(start, duration),
+								ktime_get());
+		if (towait > 0) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(usecs_to_jiffies(towait));
+		}
 	}
-
 out:
 	kfree(txbuf);
 	return ret;
@@ -234,6 +236,13 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 
 		return dev->s_tx_duty_cycle(dev, val);
 
+	case LIRC_SET_TRANSMITTER_WAIT:
+		if (!dev->tx_ir)
+			return -ENOTTY;
+
+		lirc->tx_no_wait = !val;
+		break;
+
 	/* RX settings */
 	case LIRC_SET_REC_CARRIER:
 		if (!dev->s_rx_carrier_range)
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 585d5e5..0c0d2f2 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -112,7 +112,7 @@ struct ir_raw_event_ctrl {
 		u64 gap_duration;
 		bool gap;
 		bool send_timeout_reports;
-
+		bool tx_no_wait;
 	} lirc;
 	struct xmp_dec {
 		int state;
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index 991ab45..3874f21 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -130,4 +130,9 @@
 
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
+/*
+ * Should the lirc driver wait until the IR has been transmitted.
+ */
+#define LIRC_SET_TRANSMITTER_WAIT      _IOW('i', 0x00000024, __u32)
+
 #endif
-- 
2.7.4

