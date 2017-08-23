Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:45187 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751003AbdHWXqq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 19:46:46 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] [media_build] rc: Fix ktime erros in rc_ir_raw.c
Date: Thu, 24 Aug 2017 01:46:28 +0200
Message-Id: <1503531988-15429-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

In Kernels prior to 4.10 ktime is a union. This fixes the compile errors
due to media_tree commits 86fe1ac0d and 48b2de197.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt              |  1 +
 backports/v4.9_rc_ir_raw_ktime.patch | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)
 create mode 100644 backports/v4.9_rc_ir_raw_ktime.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 87b9ee8..5691a3e 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -38,6 +38,7 @@ add v4.10_refcount.patch
 add v4.9_mm_address.patch
 add v4.9_dvb_net_max_mtu.patch
 add v4.9_ktime_cleanups.patch
+add v4.9_rc_ir_raw_ktime.patch
 
 [4.8.255]
 add v4.8_user_pages_flag.patch
diff --git a/backports/v4.9_rc_ir_raw_ktime.patch b/backports/v4.9_rc_ir_raw_ktime.patch
new file mode 100644
index 0000000..407128d
--- /dev/null
+++ b/backports/v4.9_rc_ir_raw_ktime.patch
@@ -0,0 +1,36 @@
+diff --git a/drivers/media/rc/rc-ir-raw.c b/drivers/media/rc/rc-ir-raw.c
+index f495709..f1259d1 100644
+--- a/drivers/media/rc/rc-ir-raw.c
++++ b/drivers/media/rc/rc-ir-raw.c
+@@ -106,7 +107,7 @@ int ir_raw_event_store_edge(struct rc_dev *dev, bool pulse)
+ 		return -EINVAL;
+ 
+ 	now = ktime_get();
+-	ev.duration = ktime_sub(now, dev->raw->last_event);
++	ev.duration = ktime_to_ns(ktime_sub(now, dev->raw->last_event));
+ 	ev.pulse = !pulse;
+ 
+ 	rc = ir_raw_event_store(dev, &ev);
+@@ -474,18 +479,18 @@ EXPORT_SYMBOL(ir_raw_encode_scancode);
+ static void edge_handle(unsigned long arg)
+ {
+ 	struct rc_dev *dev = (struct rc_dev *)arg;
+-	ktime_t interval = ktime_get() - dev->raw->last_event;
++	ktime_t interval = ktime_sub(ktime_get(), dev->raw->last_event);
+ 
+-	if (interval >= dev->timeout) {
++	if (ktime_to_ns(interval) >= dev->timeout) {
+ 		DEFINE_IR_RAW_EVENT(ev);
+ 
+ 		ev.timeout = true;
+-		ev.duration = interval;
++		ev.duration = ktime_to_ns(interval);
+ 
+ 		ir_raw_event_store(dev, &ev);
+ 	} else {
+ 		mod_timer(&dev->raw->edge_handle,
+-			  jiffies + nsecs_to_jiffies(dev->timeout - interval));
++			  jiffies + nsecs_to_jiffies(dev->timeout - ktime_to_ns(interval)));
+ 	}
+ 
+ 	ir_raw_event_handle(dev);
-- 
2.7.4
