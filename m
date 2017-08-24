Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:45713 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdHXAPW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 20:15:22 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Add compat code for KEY_APPSELECT
Date: Thu, 24 Aug 2017 02:15:16 +0200
Message-Id: <1503533716-31931-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 4 ++++
 v4l/scripts/make_config_compat.pl | 1 +
 2 files changed, 5 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index a28ce76..9c5d87d 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2099,6 +2099,10 @@ static inline int pm_runtime_get_if_in_use(struct device *dev)
 }
 #endif
 
+#ifdef NEED_KEY_APPSELECT
+#define KEY_APPSELECT         0x244   /* AL Select Task/Application */
+#endif
+
 #ifndef __GFP_RETRY_MAYFAIL
 #define __GFP_RETRY_MAYFAIL __GFP_REPEAT
 #endif
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index be278aa..d0dea7a 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -701,6 +701,7 @@ sub check_other_dependencies()
 	check_files_for_func("is_of_node", "NEED_IS_OF_NODE", "include/linux/of.h");
 	check_files_for_func("skb_put_data", "NEED_SKB_PUT_DATA", "include/linux/skbuff.h");
 	check_files_for_func("pm_runtime_get_if_in_use", "NEED_PM_RUNTIME_GET", "include/linux/pm_runtime.h");
+	check_files_for_func("KEY_APPSELECT", "NEED_KEY_APPSELECT", "include/uapi/linux/input-event-codes.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
