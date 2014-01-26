Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:59958 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaAZVvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jan 2014 16:51:01 -0500
Received: by mail-la0-f47.google.com with SMTP id hr17so3971091lab.34
        for <linux-media@vger.kernel.org>; Sun, 26 Jan 2014 13:51:00 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sean Young <sean@mess.org>,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFCv2 PATCH 1/5] rc-core: Add defintions needed for sysfs callback
Date: Sun, 26 Jan 2014 23:50:22 +0200
Message-Id: <1390773026-567-2-git-send-email-a.seppala@gmail.com>
In-Reply-To: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
References: <1390773026-567-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduce a list for wake code values and add callback for reading
/ writing it via sysfs.

Also introduce bitfields for setting which protocols are allowed and
enabled for wakeup.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 include/media/rc-core.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 2f6f1f7..e0e5699 100644
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
+ * struct rc_wakeup_code - represents a single IR scancode or pulse/space
+ * @value: scan code value or pulse (+) / space (-) length
+ * @list: linked list pointer
+ */
+struct rc_wakeup_code {
+	s32			value;
+	struct list_head	list_item;
+};
+
+/**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
  * @input_name: name of the input child device
@@ -52,6 +63,8 @@ enum rc_driver_type {
  * @idle: used to keep track of RX state
  * @allowed_protos: bitmask with the supported RC_BIT_* protocols
  * @enabled_protocols: bitmask with the enabled RC_BIT_* protocols
+ * @allowed_wake_protos: bitmask with the supported RC_BIT_* protocols for wakeup
+ * @enabled_wake_protos: bitmask with the enabled RC_BIT_* protocols for wakeup
  * @scanmask: some hardware decoders are not capable of providing the full
  *	scancode to the application. As this is a hardware limit, we can't do
  *	anything with it. Yet, as the same keycode table can be used with other
@@ -84,6 +97,7 @@ enum rc_driver_type {
  *	device doesn't interrupt host until it sees IR pulses
  * @s_learning_mode: enable wide band receiver used for learning
  * @s_carrier_report: enable carrier reports
+ * @s_wakeup_codes: set/get IR scancode to wake hardware from sleep states
  */
 struct rc_dev {
 	struct device			dev;
@@ -101,6 +115,8 @@ struct rc_dev {
 	bool				idle;
 	u64				allowed_protos;
 	u64				enabled_protocols;
+	u64				allowed_wake_protos;
+	u64				enabled_wake_protos;
 	u32				users;
 	u32				scanmask;
 	void				*priv;
@@ -127,6 +143,7 @@ struct rc_dev {
 	void				(*s_idle)(struct rc_dev *dev, bool enable);
 	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
 	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
+	int				(*s_wakeup_codes) (struct rc_dev *dev, struct list_head *wakeup_code_list, int write);
 };
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
-- 
1.8.3.2

