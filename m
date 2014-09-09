Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:32873 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaIIK4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 06:56:39 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id A07A920015
	for <linux-media@vger.kernel.org>; Tue,  9 Sep 2014 12:55:38 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media_build] Add compat clock helpers
Date: Tue,  9 Sep 2014 13:56:34 +0300
Message-Id: <1410260194-20839-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index ee05f3a..77abb55 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -1492,4 +1492,27 @@ static inline u32 prandom_u32_max(u32 ep_ro)
 )
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
index cb362be..88d8cd0 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -617,6 +617,7 @@ sub check_other_dependencies()
 	check_files_for_func("prandom_u32", "NEED_PRANDOM_U32", "include/linux/random.h");
 	check_files_for_func("GENMASK", "NEED_GENMASK", "include/linux/bitops.h");
 	check_files_for_func("mult_frac", "NEED_MULT_FRAC", "include/linux/kernel.h");
+	check_files_for_func("clk_prepare_enable", "NEED_CLOCK_HELPERS", "include/linux/clk.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
1.8.5.5

