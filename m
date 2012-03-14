Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56506 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2CNOoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 10:44:10 -0400
Received: by eekc41 with SMTP id c41so927097eek.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 07:44:08 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add new backport patch v2.6.35_kfifo.patch
Date: Wed, 14 Mar 2012 15:43:58 +0100
Message-Id: <1331736238-28277-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_build tree fails to build with kernels 2.6.33, .34 and .35:

In file included from /home/hans/work/build/media_build/v4l/rc-main.c:22:0:
/home/hans/work/build/media_build/v4l/rc-core-priv.h:38:26: error: field 'kfifo' has incomplete type
make[3]: *** [/home/hans/work/build/media_build/v4l/rc-main.o] Error 1
make[3]: *** Waiting for unfinished jobs....

This is due to patch http://patchwork.linuxtv.org/patch/9914/ .
Patch http://patchwork.linuxtv.org/patch/10274/ fixed the issue with 2.6.32,
but the proper fix is to revert patch 9914 for kernel 2.6.35,
adding a new backport patch.

Tested with kernels 2.6.32 and 2.6.33.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/backports.txt       |    1 +
 backports/v2.6.32_kfifo.patch |    2 +-
 backports/v2.6.35_kfifo.patch |   17 +++++++++++++++++
 3 files changed, 19 insertions(+), 1 deletions(-)
 create mode 100644 backports/v2.6.35_kfifo.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 8219033..54d41fd 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -48,6 +48,7 @@ add v2.6.35_vm_prev.patch
 add v2.6.35_firedtv_handle_fcp.patch
 add v2.6.35_i2c_new_probed_device.patch
 add v2.6.35_work_handler.patch
+add v2.6.35_kfifo.patch
 
 [2.6.34]
 add v2.6.34_dvb_net.patch
diff --git a/backports/v2.6.32_kfifo.patch b/backports/v2.6.32_kfifo.patch
index 88a435a..10075b9 100644
--- a/backports/v2.6.32_kfifo.patch
+++ b/backports/v2.6.32_kfifo.patch
@@ -14,7 +14,7 @@
  	struct list_head		list;		/* to keep track of raw clients */
  	struct task_struct		*thread;
  	spinlock_t			lock;
--	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
+-	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
 +	struct kfifo			*kfifo;		/* fifo for the pulse/space durations */
  	ktime_t				last_event;	/* when last event occurred */
  	enum raw_event_type		last_type;	/* last event type */
diff --git a/backports/v2.6.35_kfifo.patch b/backports/v2.6.35_kfifo.patch
new file mode 100644
index 0000000..6837f27
--- /dev/null
+++ b/backports/v2.6.35_kfifo.patch
@@ -0,0 +1,17 @@
+---
+ drivers/media/rc/rc-core-priv.h |    2 +-
+ 1 files changed, 1 insertions(+), 1 deletions(-)
+
+diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
+index 96f0a8b..b72f858 100644
+--- a/drivers/media/rc/rc-core-priv.h
++++ b/drivers/media/rc/rc-core-priv.h
+@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
+ 	struct list_head		list;		/* to keep track of raw clients */
+ 	struct task_struct		*thread;
+ 	spinlock_t			lock;
+-	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
++	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+ 	ktime_t				last_event;	/* when last event occurred */
+ 	enum raw_event_type		last_type;	/* last event type */
+ 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-- 
1.7.0.4

