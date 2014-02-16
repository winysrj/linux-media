Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58276 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaBPX6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Feb 2014 18:58:40 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.198.104])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 334BF35ADE
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 00:57:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add compat clock helpers
Date: Mon, 17 Feb 2014 00:59:43 +0100
Message-Id: <1392595183-14450-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The clk_prepare_enable() and clk_disable_unprepare() clock helpers were
introduced in kernel v3.3. Add them to compat.h for kernels that don't
provide them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 v4l/compat.h                      | 23 +++++++++++++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 24 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 66c5efa..dd4390c 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1435,4 +1435,27 @@ static inline bool ether_addr_equal(const u8 *addr1, const u8 *addr2)
 }
 #endif
 
+#ifdef NEED_CLK_HELPERS
+#include <linux/clk.h>
+static inline int clk_prepare_enable(struct clk *clk)
+{
+	int ret;
+
+	ret = clk_prepare(clk);
+	if (ret)
+		return ret;
+	ret = clk_enable(clk);
+	if (ret)
+		clk_unprepare(clk);
+
+	return ret;
+}
+
+static inline void clk_disable_unprepare(struct clk *clk)
+{
+	clk_disable(clk);
+	clk_unprepare(clk);
+}
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index b1a1709..c50148d 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -606,6 +606,7 @@ sub check_other_dependencies()
 	check_files_for_func("devm_kmalloc", "NEED_DEVM_KMALLOC", "include/linux/device.h");
 	check_files_for_func("usb_speed_string", "NEED_USB_SPEED_STRING", "include/linux/usb/ch9.h");
 	check_files_for_func("ether_addr_equal", "NEED_ETHER_ADDR_EQUAL", "include/linux/etherdevice.h");
+	check_files_for_func("clk_prepare_enable", "NEED_CLOCK_HELPERS", "include/linux/clk.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
1.8.3.2

