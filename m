Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:33458 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750978AbdKEMIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 07:08:37 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] build: add fwnode_property_get_reference_args if not defined
Date: Sun,  5 Nov 2017 13:08:41 +0100
Message-Id: <20171105120841.652-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add function dummy that returns -ENODATA.
Copied struct fwnode_reference_args from include/linux/fwnode.h.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 v4l/compat.h                      | 19 +++++++++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 20 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index f788e79..eec2974 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2212,4 +2212,23 @@ static inline void timer_setup(struct timer_list *timer,
 
 #endif
 
+#ifdef NEED_FWNODE_PROP_GET_REF_ARGS
+#define NR_FWNODE_REFERENCE_ARGS	8
+
+struct fwnode_reference_args {
+    struct fwnode_handle *fwnode;
+    /* unsigned int nargs; */
+    unsigned int args[NR_FWNODE_REFERENCE_ARGS];
+};
+
+static inline int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
+                                      const char *prop, const char *nargs_prop,
+                                      unsigned int nargs, unsigned int index,
+                                      struct fwnode_reference_args *args)
+{
+    return -ENODATA;
+}
+
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 62eb6b9..9752ddf 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -707,6 +707,7 @@ sub check_other_dependencies()
 	check_files_for_func("U32_MAX", "NEED_U32_MAX", "include/linux/kernel.h");
 	check_files_for_func("bsearch", "NEED_BSEARCH", "include/linux/bsearch.h");
 	check_files_for_func("timer_setup", "NEED_TIMER_SETUP", "include/linux/timer.h");
+	check_files_for_func("fwnode_property_get_reference_args", "NEED_FWNODE_PROP_GET_REF_ARGS", "include/linux/property.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.15.0
