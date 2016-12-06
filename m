Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:35817 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751779AbcLFKTa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Dec 2016 05:19:30 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: James Hogan <james@albanarts.com>,
        =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v4 12/13] [media] rc: rc-loopback: Add loopback of filter scancodes
Date: Tue,  6 Dec 2016 10:19:20 +0000
Message-Id: <1486dfe13e8060734ca96655d53f405e85c81675.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
In-Reply-To: <cover.1481019109.git.sean@mess.org>
References: <cover.1481019109.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add the s_wakeup_filter callback to the rc-loopback driver, which instead
of setting the filter just feeds the scancode back through the input
device so that it can be verified.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Cc: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-loopback.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 4bc3f01..487214e 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
@@ -176,6 +177,41 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
+static int loop_set_wakeup_filter(struct rc_dev *dev,
+				  struct rc_scancode_filter *sc_filter)
+{
+	static const unsigned int max = 512;
+	struct ir_raw_event *raw;
+	int ret;
+	int i;
+
+	/* fine to disable filter */
+	if (!sc_filter->mask)
+		return 0;
+
+	/* encode the specified filter and loop it back */
+	raw = kmalloc_array(max, sizeof(*raw), GFP_KERNEL);
+	if (!raw)
+		return -ENOMEM;
+
+	ret = ir_raw_encode_scancode(dev->wakeup_protocol, sc_filter, raw, max);
+	/* still loop back the partial raw IR even if it's incomplete */
+	if (ret == -ENOBUFS)
+		ret = max;
+	if (ret >= 0) {
+		/* do the loopback */
+		for (i = 0; i < ret; ++i)
+			ir_raw_event_store(dev, &raw[i]);
+		ir_raw_event_handle(dev);
+
+		ret = 0;
+	}
+
+	kfree(raw);
+
+	return ret;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -195,6 +231,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
+	rc->encode_wakeup	= true;
 	rc->allowed_protocols	= RC_BIT_ALL_IR_DECODER;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
@@ -209,6 +246,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->s_wakeup_filter	= loop_set_wakeup_filter;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;
-- 
2.9.3

