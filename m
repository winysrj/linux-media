Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:38978 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbdGWMMU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 08:12:20 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 1/3] build: Add compat code for pm_runtime_get_if_in_use
Date: Sun, 23 Jul 2017 14:12:02 +0200
Message-Id: <1500811924-4559-2-git-send-email-jasmin@anw.at>
In-Reply-To: <1500811924-4559-1-git-send-email-jasmin@anw.at>
References: <1500811924-4559-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 15 +++++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 16 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index e565292..b5b0846 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2084,4 +2084,19 @@ static inline void *skb_put_data(struct sk_buff *skb, const void *data,
 }
 #endif
 
+#ifdef NEED_PM_RUNTIME_GET
+static inline int pm_runtime_get_if_in_use(struct device *dev)
+{
+	unsigned long flags;
+	int retval;
+
+	spin_lock_irqsave(&dev->power.lock, flags);
+	retval = dev->power.disable_depth > 0 ? -EINVAL :
+		dev->power.runtime_status == RPM_ACTIVE
+			&& atomic_inc_not_zero(&dev->power.usage_count);
+	spin_unlock_irqrestore(&dev->power.lock, flags);
+	return retval;
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 5ac59ab..be278aa 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -700,6 +700,7 @@ sub check_other_dependencies()
 	check_files_for_func("to_of_node", "NEED_TO_OF_NODE", "include/linux/of.h");
 	check_files_for_func("is_of_node", "NEED_IS_OF_NODE", "include/linux/of.h");
 	check_files_for_func("skb_put_data", "NEED_SKB_PUT_DATA", "include/linux/skbuff.h");
+	check_files_for_func("pm_runtime_get_if_in_use", "NEED_PM_RUNTIME_GET", "include/linux/pm_runtime.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
