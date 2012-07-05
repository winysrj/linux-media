Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65304 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab2GEPS1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 11:18:27 -0400
Received: by werb14 with SMTP id b14so5373398wer.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 08:18:26 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add backport patch for request_firmware_nowait() to kernels <= 2.6.32
Date: Thu,  5 Jul 2012 17:18:15 +0200
Message-Id: <1341501495-22729-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In kernel 2.6.33 request_firmware_nowait() gained a new parameter to set
the memory allocation flags.
We have to remove this parameter to make the drxk driver (the only user of
request_firmware_nowait() so far) compilable again with kernels older
than 2.6.33.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/backports.txt                         |    1 +
 backports/v2.6.32_request_firmware_nowait.patch |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 backports/v2.6.32_request_firmware_nowait.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index cc768d2..5554d9e 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -62,6 +62,7 @@ add v2.6.33_pvrusb2_sysfs.patch
 
 [2.6.32]
 add v2.6.32_kfifo.patch
+add v2.6.32_request_firmware_nowait.patch
 
 [2.6.31]
 add v2.6.31_nodename.patch
diff --git a/backports/v2.6.32_request_firmware_nowait.patch b/backports/v2.6.32_request_firmware_nowait.patch
new file mode 100644
index 0000000..8483189
--- /dev/null
+++ b/backports/v2.6.32_request_firmware_nowait.patch
@@ -0,0 +1,15 @@
+---
+ drivers/media/dvb/frontends/drxk_hard.c |    1 -
+ 1 files changed, 0 insertions(+), 1 deletions(-)
+
+--- a/drivers/media/dvb/frontends/drxk_hard.c
++++ b/drivers/media/dvb/frontends/drxk_hard.c
+@@ -6548,7 +6548,6 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
+ 		status = request_firmware_nowait(THIS_MODULE, 1,
+ 					      state->microcode_name,
+ 					      state->i2c->dev.parent,
+-					      GFP_KERNEL,
+ 					      state, load_firmware_cb);
+ 		if (status < 0) {
+ 			printk(KERN_ERR
+
-- 
1.7.0.4

