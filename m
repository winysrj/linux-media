Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43656 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751732AbdKDQFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Nov 2017 12:05:05 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] build: Add support for timer_setup
Date: Sat,  4 Nov 2017 17:05:06 +0100
Message-Id: <20171104160506.8319-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Literally copied the implementation from kernel
commit 686fef928bba6be13 (timer: Prepare to change timer callback argument type)

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 v4l/compat.h                      | 17 +++++++++++++++++
 v4l/scripts/make_config_compat.pl |  1 +
 2 files changed, 18 insertions(+)

diff --git a/v4l/compat.h b/v4l/compat.h
index 3504288..f788e79 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -2195,4 +2195,21 @@ static inline void *bsearch(const void *key, const void *base, size_t num, size_
 }
 #endif
 
+#ifdef NEED_TIMER_SETUP
+#define TIMER_DATA_TYPE                unsigned long
+#define TIMER_FUNC_TYPE                void (*)(TIMER_DATA_TYPE)
+
+static inline void timer_setup(struct timer_list *timer,
+                              void (*callback)(struct timer_list *),
+                              unsigned int flags)
+{
+       __setup_timer(timer, (TIMER_FUNC_TYPE)callback,
+                     (TIMER_DATA_TYPE)timer, flags);
+}
+
+#define from_timer(var, callback_timer, timer_fieldname) \
+       container_of(callback_timer, typeof(*var), timer_fieldname)
+
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 8ebeea3..62eb6b9 100644
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -706,6 +706,7 @@ sub check_other_dependencies()
 	check_files_for_func("annotate_reachable", "NEED_ANNOTATE_REACHABLE", "include/linux/compiler.h");
 	check_files_for_func("U32_MAX", "NEED_U32_MAX", "include/linux/kernel.h");
 	check_files_for_func("bsearch", "NEED_BSEARCH", "include/linux/bsearch.h");
+	check_files_for_func("timer_setup", "NEED_TIMER_SETUP", "include/linux/timer.h");
 
 	# For tests for uapi-dependent logic
 	check_files_for_func_uapi("usb_endpoint_maxp", "NEED_USB_ENDPOINT_MAXP", "usb/ch9.h");
-- 
2.15.0
