Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:49968 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbdHZBxF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 21:53:05 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 1/2] build: Add compat code for PCI_DEVICE_SUB
Date: Sat, 26 Aug 2017 03:52:56 +0200
Message-Id: <1503712377-31405-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1503712377-31405-1-git-send-email-jasmin@anw.at>
References: <1503712377-31405-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 6 ++++++
 v4l/scripts/make_config_compat.pl | 1 +
 2 files changed, 7 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 9c5d87d..1ab5c0f 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2107,4 +2107,10 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
 #define __GFP_RETRY_MAYFAIL __GFP_REPEAT
 #endif
 
+#ifdef NEED_PCI_DEVICE_SUB
+#define PCI_DEVICE_SUB(vend, dev, subvend, subdev) \
+	.vendor = (vend), .device = (dev), \
+	.subvendor = (subvend), .subdevice = (subdev)
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index d0dea7a..2508540 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -702,6 +702,7 @@ sub check_other_dependencies()
 	check_files_for_func("skb_put_data", "NEED_SKB_PUT_DATA", "include/linux/skbuff.h");
 	check_files_for_func("pm_runtime_get_if_in_use", "NEED_PM_RUNTIME_GET", "include/linux/pm_runtime.h");
 	check_files_for_func("KEY_APPSELECT", "NEED_KEY_APPSELECT", "include/uapi/linux/input-event-codes.h");
+	check_files_for_func("PCI_DEVICE_SUB", "NEED_PCI_DEVICE_SUB", "include/linux/pci.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
