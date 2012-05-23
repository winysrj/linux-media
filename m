Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44289 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2EWJy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:56 -0400
Subject: [PATCH 16/43] rc-core: add an ioctl for getting IR RX settings
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:24 +0200
Message-ID: <20120523094324.14474.87233.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

LIRC currently supports quite a number of ioctl's for getting/setting
various TX and RX parameters. One problem with the one-ioctl-per-parameter
approach is that it might be quite elaborate to reprogram the hardware
(an operation which will have to be done once for every parameter change).

LIRC has approached this problem by providing something similar to
database transactions (ioctl commands LIRC_SETUP_START and LIRC_SETUP_END)
which is one (complicated) way of doing it.

The proposed approach for rc-core instead uses a struct with all known
parameters defined in one go. Drivers are expected to fill in the struct
with all the parameters that apply to them while leaving the rest intact.

I've looked at parameters defined in: LIRC, current rc-core, and in Microsoft
CIRClass drivers. The current struct rc_ir_rx should be a superset of all
three and also has room for further additions. Hopefully this should be fairly
complete and future-proof, please check carefully that you favourite
parameter is supported to satisfy your OCD.

Also, it would be interesting to know if carrier reporting is actually an
expensive operation (which should be explicitly enabled by setting the
appropriate flag as now) or not (in which case it should always be on).

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   28 +++++++++++++++++++
 include/media/rc-core.h    |   65 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d9ed1a8..2d3f421 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1677,6 +1677,7 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	unsigned int __user *ip = (unsigned int __user *)p;
+	struct rc_ir_rx rx;
 
 	switch (cmd) {
 
@@ -1685,6 +1686,33 @@ static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
 
 	case RCIOCGTYPE:
 		return put_user(dev->driver_type, ip);
+
+	case RCIOCGIRPSIZE:
+		return put_user(ARRAY_SIZE(rx.protocols_supported), ip);
+
+	case RCIOCGIRRX:
+		memset(&rx, 0, sizeof(rx));
+		rx.rx_supported = 0x1;
+		rx.rx_enabled = 0x1;
+		rx.rx_connected = 0x1;
+		rx.protocols_enabled[0] = dev->enabled_protocols;
+		if (dev->driver_type == RC_DRIVER_SCANCODE)
+			rx.protocols_supported[0] = dev->allowed_protos;
+		else
+			rx.protocols_supported[0] = ir_raw_get_allowed_protocols();
+		rx.timeout = dev->timeout;
+		rx.timeout_min = dev->min_timeout;
+		rx.timeout_max = dev->max_timeout;
+		rx.resolution = dev->rx_resolution;
+
+		/* See if the driver wishes to override anything */
+		if (dev->get_ir_rx)
+			dev->get_ir_rx(dev, &rx);
+
+		if (copy_to_user(p, &rx, sizeof(rx)))
+			return -EFAULT;
+
+		return 0;
 	}
 
 	return -EINVAL;
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e3d445b..5669b64 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -47,6 +47,69 @@ do {								\
 /* get driver/hardware type */
 #define RCIOCGTYPE	_IOR(RC_IOC_MAGIC, 0x02, unsigned int)
 
+/* get size of protocols array (i.e. multiples of u64) for struct rc_ir_rx */
+#define RCIOCGIRPSIZE	_IOR(RC_IOC_MAGIC, 0x03, unsigned int)
+
+/* get ir rx parameters */
+#define RCIOCGIRRX	_IOC(_IOC_READ, RC_IOC_MAGIC, 0x04, sizeof(struct rc_ir_rx))
+
+/**
+ * struct rc_ir_rx - used to get all IR RX parameters in one go
+ * @flags: device specific flags (only %RC_IR_RX_MEASURE_CARRIER is
+ *	currently defined)
+ * @rx_supported: bitmask of supported (i.e. possible) receivers
+ * @rx_enabled: bitmask of enabled receivers
+ * @rx_connected: bitmask of connected receivers
+ * @rx_learning: bitmask of learning receivers
+ * @protocols_supported: bitmask of supported protocols
+ * @protocols_enabled: bitmask of enabled protocols
+ * @freq_min: min carrier frequency
+ * @freq_max: max carrier frequency
+ * @duty_min: min duty cycle
+ * @duty_max: max duty cycle
+ * @timeout: current timeout (i.e. silence-before-idle)
+ * @timeout_min: min timeout
+ * @timeout_max: max timeout
+ * @filter_space: shorter spaces may be filtered
+ * @filter_space_min: min space filter value
+ * @filter_space_max: max space filter value
+ * @filter_pulse: shorter pulses may be filtered
+ * @filter_pulse_min: min pulse filter value
+ * @filter_pulse_max: max pulse filter value
+ * @resolution: current pulse/space resolution
+ * @resolution_min: min resolution
+ * @resolution_max: max resolution
+ * @reserved: for future use, set to zero
+ */
+struct rc_ir_rx {
+	__u32 flags;
+#define RC_IR_RX_MEASURE_CARRIER	0x01
+	__u32 rx_supported;
+	__u32 rx_enabled;
+	__u32 rx_connected;
+	__u32 rx_learning;
+	__u64 protocols_supported[1];
+	__u64 protocols_enabled[1];
+	__u32 freq_min;
+	__u32 freq_max;
+	__u32 duty_min;
+	__u32 duty_max;
+	__u32 timeout;
+	__u32 timeout_min;
+	__u32 timeout_max;
+	__u32 filter_space;
+	__u32 filter_space_min;
+	__u32 filter_space_max;
+	__u32 filter_pulse;
+	__u32 filter_pulse_min;
+	__u32 filter_pulse_max;
+	__u32 resolution;
+	__u32 resolution_min;
+	__u32 resolution_max;
+	__u32 reserved[9];
+} __packed;
+
+
 
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
@@ -145,6 +208,7 @@ struct ir_raw_event {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
+ * @get_ir_rx: allow driver to provide rx settings
  */
 struct rc_dev {
 	struct device			dev;
@@ -195,6 +259,7 @@ struct rc_dev {
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
+	void				(*get_ir_rx)(struct rc_dev *dev, struct rc_ir_rx *rx);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)

