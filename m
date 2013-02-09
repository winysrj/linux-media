Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:33430 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3BIOEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 09:04:50 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so2453231eek.20
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2013 06:04:49 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add PTR_RET to compat.h
Date: Sat,  9 Feb 2013 15:04:40 +0100
Message-Id: <1360418680-9682-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PTR_RET is used by the solo6x10 staging driver,
and was introduced in kernel 2.6.39.
Add it to compat.h for compatibility with older kernels.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/compat.h                      | 10 ++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 11 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 1a82bb7..b27b178 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1137,4 +1137,14 @@ static inline int usb_translate_errors(int error_code)
 }
 #endif
 
+#ifdef NEED_PTR_RET
+static inline int __must_check PTR_RET(const void *ptr)
+{
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+	else
+		return 0;
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 583ef9d..51a1f5d 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -588,6 +588,7 @@ sub check_other_dependencies()
 	check_files_for_func("config_enabled", "NEED_IS_ENABLED", "include/linux/kconfig.h");
 	check_files_for_func("DEFINE_PCI_DEVICE_TABLE", "NEED_DEFINE_PCI_DEVICE_TABLE", "include/linux/pci.h");
 	check_files_for_func("usb_translate_errors", "NEED_USB_TRANSLATE_ERRORS", "include/linux/usb.h");
+	check_files_for_func("PTR_RET", "NEED_PTR_RET", "include/linux/err.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
1.8.1.1

