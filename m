Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59775 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaFLPp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 11:45:28 -0400
Received: by mail-qa0-f44.google.com with SMTP id hw13so687064qab.31
        for <linux-media@vger.kernel.org>; Thu, 12 Jun 2014 08:45:28 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH] Add patch to allow compilation on versions < 3.5 with CONFIG_OF
Date: Thu, 12 Jun 2014 11:45:04 -0400
Message-Id: <1402587904-9321-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for Open Firmware was introduced in the V4L2 tree, but
it depends on features only found in 3.5+.  Add a patch to disable
the support for earlier kernels.

Tested on Ubuntu 10.04 with kernel 3.2.0-030200-generic (which has
CONFIG_OF enabled by default).

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 backports/backports.txt           |  1 +
 backports/v3.4_openfirmware.patch | 13 +++++++++++++
 2 files changed, 14 insertions(+)
 create mode 100644 backports/v3.4_openfirmware.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 281c263..08908e6 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -43,6 +43,7 @@ add v3.6_i2c_add_mux_adapter.patch
 
 [3.4.255]
 add v3.4_i2c_add_mux_adapter.patch
+add v3.4_openfirmware.patch
 
 [3.2.255]
 add v3.2_devnode_uses_mode_t.patch
diff --git a/backports/v3.4_openfirmware.patch b/backports/v3.4_openfirmware.patch
new file mode 100644
index 0000000..f0a8d36
--- /dev/null
+++ b/backports/v3.4_openfirmware.patch
@@ -0,0 +1,13 @@
+--- a/drivers/media/v4l2-core/v4l2-of.c	2014-06-11 17:05:02.000000000 -0700
++++ b/drivers/media/v4l2-core/v4l2-of.c	2014-06-11 17:05:34.000000000 -0700
+@@ -1,3 +1,5 @@
++/* Depends on symbols not present until kernel 3.5 */
++#if 0
+ /*
+  * V4L2 OF binding parsing library
+  *
+@@ -142,3 +144,4 @@
+ 	return 0;
+ }
+ EXPORT_SYMBOL(v4l2_of_parse_endpoint);
++#endif
-- 
1.9.1

