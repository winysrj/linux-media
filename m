Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48892 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdGWJb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 05:31:57 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] Add compat code for skb_put_data
Date: Sun, 23 Jul 2017 11:31:51 +0200
Message-Id: <20170723093151.26338-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 v4l/compat.h                      | 12 ++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 13 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 47e2694..e565292 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2072,4 +2072,16 @@ static inline bool is_of_node(struct fwnode_handle *fwnode)
 }
 #endif
 
+#ifdef NEED_SKB_PUT_DATA
+static inline void *skb_put_data(struct sk_buff *skb, const void *data,
+                                 unsigned int len)
+{
+        void *tmp = skb_put(skb, len);
+
+        memcpy(tmp, data, len);
+
+        return tmp;
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index d186cb4..5ac59ab 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -699,6 +699,7 @@ sub check_other_dependencies()
 	check_files_for_func("of_fwnode_handle", "NEED_FWNODE", "include/linux/of.h");
 	check_files_for_func("to_of_node", "NEED_TO_OF_NODE", "include/linux/of.h");
 	check_files_for_func("is_of_node", "NEED_IS_OF_NODE", "include/linux/of.h");
+	check_files_for_func("skb_put_data", "NEED_SKB_PUT_DATA", "include/linux/skbuff.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.13.3
