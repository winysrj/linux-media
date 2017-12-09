Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57925 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752050AbdLIATT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 19:19:19 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Added missing READ_ONCE
Date: Sat,  9 Dec 2017 01:19:09 +0100
Message-Id: <1512778749-12452-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 5 +++++
 v4l/scripts/make_config_compat.pl | 1 +
 2 files changed, 6 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 89deae1..fba7a99 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2275,4 +2275,9 @@ static inline bool fwnode_device_is_available(struct fwnode_handle *fwnode)
         setup_timer_on_stack((timer), (callback), (flags))
 #endif
 
+#ifdef NEED_READ_ONCE
+#define READ_ONCE(x)  ACCESS_ONCE(x)
+#endif
+
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 3b073ac..4a178dd 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -712,6 +712,7 @@ sub check_other_dependencies()
 	check_files_for_func("fwnode_for_each_child_node", "NEED_FWNODE_FOR_EACH_CHILD_NODE", "include/linux/property.h");
 	check_files_for_func("fwnode_graph_get_port_parent", "NEED_FWNODE_GRAPH_GET_PORT_PARENT", "include/linux/property.h");
 	check_files_for_func("timer_setup_on_stack", "NEED_TIMER_SETUP_ON_STACK", "include/linux/timer.h");
+	check_files_for_func("READ_ONCE", "NEED_READ_ONCE", "include/linux/compiler.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
