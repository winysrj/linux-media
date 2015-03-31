Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33446 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbbCaRtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2015 13:49:07 -0400
Received: by lbbzk7 with SMTP id zk7so1973758lbb.0
        for <linux-media@vger.kernel.org>; Tue, 31 Mar 2015 10:49:06 -0700 (PDT)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
	James Hogan <james@albanarts.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>
Subject: [PATCH v3 6/7] rc: rc-loopback: Add loopback of filter scancodes
Date: Tue, 31 Mar 2015 20:48:11 +0300
Message-Id: <1427824092-23163-7-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
References: <1427824092-23163-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: James Hogan <james@albanarts.com>

Add the s_wakeup_filter callback to the rc-loopback driver, which instead of
setting the filter just feeds the scancode back through the input device
so that it can be verified.

Signed-off-by: James Hogan <james@albanarts.com>
Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
Cc: David Härdeman <david@hardeman.nu>
---

Notes:
    Changes in v3:
     - Ported to apply against latest media-tree
     - Checkpatch.pl fixes
    
    Changes in v2:
     - Move img-ir-raw test code to rc-loopback.
     - Handle new encode API, specifically -ENOBUFS when the buffer isn't
       long enough.
     - Set encode_wakeup so that the set of allowed wakeup protocols matches
       the set of raw IR encoders.

 drivers/media/rc/rc-loopback.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 63dace8..d8bdf63 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
@@ -176,6 +177,39 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
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
+	ret = ir_raw_encode_scancode(dev->enabled_wakeup_protocols, sc_filter,
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
@@ -195,6 +229,7 @@ static int __init loop_init(void)
 	rc->map_name		= RC_MAP_EMPTY;
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
+	rc->encode_wakeup	= true;
 	rc->allowed_protocols	= RC_BIT_ALL;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
@@ -209,6 +244,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->s_wakeup_filter	= loop_set_wakeup_filter;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;
-- 
2.0.5

