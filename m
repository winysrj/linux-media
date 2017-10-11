Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:58794 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751337AbdJKVzq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 17:55:46 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Add U32_MAX if not defined
Date: Wed, 11 Oct 2017 23:55:34 +0200
Message-Id: <1507758934-11680-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Compiling for Kernel 3.4 failed in "ir-lirc-codec.c" with
  error: 'U32_MAX' undeclared

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 4 ++++
 v4l/scripts/make_config_compat.pl | 1 +
 2 files changed, 5 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index a20264c..15f2cd6 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2166,4 +2166,8 @@ static inline unsigned long nsecs_to_jiffies_static(u64 n)
 
 #endif
 
+#ifdef NEED_U32_MAX
+#define U32_MAX     ((u32)~0U)
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 53ca439..9fdf10d 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -704,6 +704,7 @@ sub check_other_dependencies()
 	check_files_for_func("KEY_APPSELECT", "NEED_KEY_APPSELECT", "include/uapi/linux/input-event-codes.h");
 	check_files_for_func("PCI_DEVICE_SUB", "NEED_PCI_DEVICE_SUB", "include/linux/pci.h");
 	check_files_for_func("annotate_reachable", "NEED_ANNOTATE_REACHABLE", "include/linux/compiler.h");
+	check_files_for_func("U32_MAX", "NEED_U32_MAX", "include/linux/kernel.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
