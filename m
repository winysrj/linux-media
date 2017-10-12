Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:41009 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753576AbdJLXBQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 19:01:16 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Add bsearch if not defined
Date: Fri, 13 Oct 2017 01:01:08 +0200
Message-Id: <1507849268-31034-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Compiling for Kernel 2.6.x failed in "rc-main.c" with
  linux/bsearch.h: No such file or directory
Beside adding the missing function, also the include of "linux/bsearch.h"
has been removed by new patch "v2.6_rc_main_bsearch_h.patch".

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/backports.txt                |  3 +++
 backports/v2.6_rc_main_bsearch_h.patch | 10 ++++++++++
 v4l/compat.h                           | 25 +++++++++++++++++++++++++
 v4l/scripts/make_config_compat.pl      |  1 +
 4 files changed, 39 insertions(+)
 create mode 100644 backports/v2.6_rc_main_bsearch_h.patch

diff --git a/backports/backports.txt b/backports/backports.txt
index 87b9ee8..b245e3b 100644
--- a/backports/backports.txt
+++ b/backports/backports.txt
@@ -127,6 +127,9 @@ add no_atomic_include.patch
 add v4l2-compat-timespec.patch
 add v3.0_ida2bit.patch
 
+[2.6.39]
+add v2.6_rc_main_bsearch_h.patch
+
 [2.6.38]
 add v2.6.38_use_getkeycode_new_setkeycode_new.patch
 add v2.6.38_config_of_for_of_node.patch
diff --git a/backports/v2.6_rc_main_bsearch_h.patch b/backports/v2.6_rc_main_bsearch_h.patch
new file mode 100644
index 0000000..9ed45b4
--- /dev/null
+++ b/backports/v2.6_rc_main_bsearch_h.patch
@@ -0,0 +1,10 @@
+--- a/drivers/media/rc/rc-main.c
++++ b/drivers/media/rc/rc-main.c
+@@ -16,7 +16,6 @@
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include <media/rc-core.h>
+-#include <linux/bsearch.h>
+ #include <linux/spinlock.h>
+ #include <linux/delay.h>
+ #include <linux/input.h>
diff --git a/v4l/compat.h b/v4l/compat.h
index 15f2cd6..3504288 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2170,4 +2170,29 @@ static inline unsigned long nsecs_to_jiffies_static(u64 n)
 #define U32_MAX     ((u32)~0U)
 #endif
 
+#ifdef NEED_BSEARCH
+static inline void *bsearch(const void *key, const void *base, size_t num, size_t size,
+                            int (*cmp)(const void *key, const void *elt))
+{
+    const char *pivot;
+    int result;
+
+    while (num > 0) {
+        pivot = base + (num >> 1) * size;
+        result = cmp(key, pivot);
+
+        if (result == 0)
+            return (void *)pivot;
+
+        if (result > 0) {
+            base = pivot + size;
+            num--;
+        }
+        num >>= 1;
+    }
+
+    return NULL;
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 9fdf10d..8ebeea3 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -705,6 +705,7 @@ sub check_other_dependencies()
 	check_files_for_func("PCI_DEVICE_SUB", "NEED_PCI_DEVICE_SUB", "include/linux/pci.h");
 	check_files_for_func("annotate_reachable", "NEED_ANNOTATE_REACHABLE", "include/linux/compiler.h");
 	check_files_for_func("U32_MAX", "NEED_U32_MAX", "include/linux/kernel.h");
+	check_files_for_func("bsearch", "NEED_BSEARCH", "include/linux/bsearch.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
