Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:53348 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750998AbdLHVBU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 16:01:20 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Added missing timer_setup_on_stack
Date: Fri,  8 Dec 2017 22:00:59 +0100
Message-Id: <1512766859-7667-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/compat.h                      | 5 +++++
 v4l/scripts/make_config_compat.pl | 1 +
 2 files changed, 6 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 4af407e..89deae1 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2270,4 +2270,9 @@ static inline bool fwnode_device_is_available(struct fwnode_handle *fwnode)
 }
 #endif
 
+#ifdef NEED_TIMER_SETUP_ON_STACK
+#define timer_setup_on_stack(timer, callback, flags)        \
+        setup_timer_on_stack((timer), (callback), (flags))
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 01382dd..3b073ac 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -711,6 +711,7 @@ sub check_other_dependencies()
 	check_files_for_func("fwnode_reference_args", "NEED_FWNODE_REF_ARGS", "include/linux/fwnode.h");
 	check_files_for_func("fwnode_for_each_child_node", "NEED_FWNODE_FOR_EACH_CHILD_NODE", "include/linux/property.h");
 	check_files_for_func("fwnode_graph_get_port_parent", "NEED_FWNODE_GRAPH_GET_PORT_PARENT", "include/linux/property.h");
+	check_files_for_func("timer_setup_on_stack", "NEED_TIMER_SETUP_ON_STACK", "include/linux/timer.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.7.4
