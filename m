Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:60224 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaATTkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 14:40:06 -0500
Received: by mail-la0-f43.google.com with SMTP id er20so5881934lab.16
        for <linux-media@vger.kernel.org>; Mon, 20 Jan 2014 11:40:04 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH 1/4] rc-core: Add defintions needed for sysfs callback
Date: Mon, 20 Jan 2014 21:39:44 +0200
Message-Id: <1390246787-15616-2-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce a list for wake scancode values and add callback for sysfs
reads/writes.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 include/media/rc-core.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2f6f1f7..6ee68ac 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -20,6 +20,7 @@
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#include <linux/list.h>
 #include <media/rc-map.h>
 
 extern int rc_core_debug;
@@ -35,6 +36,16 @@ enum rc_driver_type {
 };
 
 /**
+ * struct rc_wakeup_scancode - represents a single IR code sample
+ * @value: scan code value
+ * @list: linked list pointer
+ */
+struct rc_wakeup_scancode {
+	u8			value;
+	struct list_head	list_item;
+};
+
+/**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
  * @input_name: name of the input child device
@@ -84,6 +95,7 @@ enum rc_driver_type {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
+ * @s_wakeup_scancodes: set/get IR scancode to wake hardware from sleep states
  */
 struct rc_dev {
 	struct device			dev;
@@ -127,6 +139,7 @@ struct rc_dev {
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
+	int				(*s_wakeup_scancodes) (struct rc_dev *dev, struct list_head *scancode_list, int write);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
-- 
1.8.3.2

