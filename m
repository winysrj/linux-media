Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41937 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbaCNXHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Mar 2014 19:07:06 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi5so165909wib.11
        for <linux-media@vger.kernel.org>; Fri, 14 Mar 2014 16:07:05 -0700 (PDT)
From: James Hogan <james@albanarts.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Cc: linux-media@vger.kernel.org, James Hogan <james@albanarts.com>
Subject: [PATCH v2 8/9] rc: rc-loopback: Add loopback of filter scancodes
Date: Fri, 14 Mar 2014 23:04:18 +0000
Message-Id: <1394838259-14260-9-git-send-email-james@albanarts.com>
In-Reply-To: <1394838259-14260-1-git-send-email-james@albanarts.com>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the s_filter callback to the rc-loopback driver, which instead of
setting the filter just feeds the scancode back through the input device
so that it can be verified.

Signed-off-by: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Seppälä <a.seppala@gmail.com>
---
Changes in v2:
 - Move img-ir-raw test code to rc-loopback.
 - Handle new encode API, specifically -ENOBUFS when the buffer isn't
   long enough.
 - Set encode_wakeup so that the set of allowed wakeup protocols matches
   the set of raw IR encoders.
---
 drivers/media/rc/rc-loopback.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 0a88e0c..aefd335 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
@@ -176,6 +177,42 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
+static int loop_set_filter(struct rc_dev *dev, enum rc_filter_type type,
+			   struct rc_scancode_filter *sc_filter)
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
+	raw = kmalloc(max * sizeof(*raw), GFP_KERNEL);
+	ret = ir_raw_encode_scancode(dev->enabled_protocols[type], sc_filter,
+				     raw, max);
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
+	} else if (type == RC_FILTER_NORMAL) {
+		/* accept any normal filter */
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
@@ -195,6 +232,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
+	rc->encode_wakeup	= true;
 	rc_set_allowed_protocols(rc, RC_BIT_ALL);
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
@@ -209,6 +247,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->s_filter		= loop_set_filter;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;
-- 
1.8.3.2

