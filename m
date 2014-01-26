Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60654 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:51:07 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so3905800lbv.19
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:51:06 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 3/5] rc-loopback: Add support for reading/writing wakeup scancodes via sysfs
Date: Sun, 26 Jan 2014 23:50:24 +0200
Message-Id: <1390773026-567-4-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds sample support for reading/writing the wakeup scancodes
to rc-loopback device driver.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-loopback.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 53d0282..46e76ad 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,6 +26,7 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
@@ -45,6 +46,7 @@ struct loopback_dev {
 	bool carrierreport;
 	u32 rxcarriermin;
 	u32 rxcarriermax;
+	u32 wakeup_scancode;
 };
 
 static struct loopback_dev loopdev;
@@ -176,6 +178,41 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
+static int loop_wakeup_codes(struct rc_dev *dev,
+				 struct list_head *wakeup_code_list, int write)
+{
+	u32 value = 0;
+	struct rc_wakeup_code *code;
+	struct loopback_dev *lodev = dev->priv;
+
+	dprintk("%sing wakeup codes\n", write ? "writ" : "read");
+
+	if (write) {
+		code = list_first_entry_or_null(wakeup_code_list,
+						struct rc_wakeup_code,
+						list_item);
+		if (code)
+			value = code->value;
+
+		if (dev->enabled_wake_protos & RC_BIT_RC5) {
+			if (value > 0xFFF)
+				return -EINVAL;
+		} else if (dev->enabled_wake_protos & RC_BIT_RC6_0) {
+			if (value > 0xFFFF)
+				return -EINVAL;
+		}
+
+		lodev->wakeup_scancode = value;
+	} else {
+		code = kmalloc(sizeof(struct rc_wakeup_code), GFP_KERNEL);
+		if (!code)
+			return -ENOMEM;
+		code->value = lodev->wakeup_scancode;
+		list_add_tail(&code->list_item, wakeup_code_list);
+	}
+	return 0;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -196,6 +233,8 @@ static int __init loop_init(void)
 	rc->priv		= &loopdev;
 	rc->driver_type		= RC_DRIVER_IR_RAW;
 	rc->allowed_protos	= RC_BIT_ALL;
+	rc->allowed_wake_protos	= RC_BIT_RC6_0 | RC_BIT_RC5;
+	rc->enabled_wake_protos	= RC_BIT_RC6_0;
 	rc->timeout		= 100 * 1000 * 1000; /* 100 ms */
 	rc->min_timeout		= 1;
 	rc->max_timeout		= UINT_MAX;
@@ -209,6 +248,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->s_wakeup_codes	= loop_wakeup_codes;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;
-- 
1.8.3.2

