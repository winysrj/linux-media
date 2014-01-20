Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:60355 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaATTkM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:40:12 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so5799945lan.24
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 11:40:10 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 3/4] rc-loopback: Add support for reading/writing wakeup scancodes via sysfs
Date: Mon, 20 Jan 2014 21:39:46 +0200
Message-Id: <1390246787-15616-4-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds sample support for reading/writing the wakeup scancodes
to rc-loopback device driver.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/rc/rc-loopback.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 53d0282..12bd1c5 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -26,12 +26,14 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/rc-core.h>
 
 #define DRIVER_NAME	"rc-loopback"
 #define dprintk(x...)	if (debug) printk(KERN_INFO DRIVER_NAME ": " x)
 #define RXMASK_REGULAR	0x1
 #define RXMASK_LEARNING	0x2
+#define WAKE_CODE_LEN	0xF
 
 static bool debug;
 
@@ -45,6 +47,7 @@ struct loopback_dev {
 	bool carrierreport;
 	u32 rxcarriermin;
 	u32 rxcarriermax;
+	u8 wake_codes[WAKE_CODE_LEN];
 };
 
 static struct loopback_dev loopdev;
@@ -176,6 +179,33 @@ static int loop_set_carrier_report(struct rc_dev *dev, int enable)
 	return 0;
 }
 
+static int loop_wakeup_scancodes(struct rc_dev *dev,
+				 struct list_head *scancode_list, int write)
+{
+	int i = 0;
+	struct rc_wakeup_scancode *scancode;
+	struct loopback_dev *lodev = dev->priv;
+
+	dprintk("%sing wakeup scancodes\n", write ? "writ" : "read");
+
+	if (write) {
+		list_for_each_entry_reverse(scancode, scancode_list,
+					    list_item) {
+			lodev->wake_codes[i] = scancode->value;
+			if (++i > WAKE_CODE_LEN)
+				return -EINVAL;
+		}
+	} else {
+		for (i = 0; i < WAKE_CODE_LEN; i++) {
+			scancode = kmalloc(sizeof(struct rc_wakeup_scancode),
+					   GFP_KERNEL);
+			scancode->value = lodev->wake_codes[i];
+			list_add(&scancode->list_item, scancode_list);
+		}
+	}
+	return 0;
+}
+
 static int __init loop_init(void)
 {
 	struct rc_dev *rc;
@@ -209,6 +239,7 @@ static int __init loop_init(void)
 	rc->s_idle		= loop_set_idle;
 	rc->s_learning_mode	= loop_set_learning_mode;
 	rc->s_carrier_report	= loop_set_carrier_report;
+	rc->s_wakeup_scancodes	= loop_wakeup_scancodes;
 
 	loopdev.txmask		= RXMASK_REGULAR;
 	loopdev.txcarrier	= 36000;
-- 
1.8.3.2

