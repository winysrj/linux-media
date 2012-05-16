Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45994 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966987Ab2EPKoi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 May 2012 06:44:38 -0400
Received: by mail-we0-f174.google.com with SMTP id u7so341289wey.19
        for <linux-media@vger.kernel.org>; Wed, 16 May 2012 03:44:37 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: hans.verkuil@cisco.com, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 1/2] media_build: add SET_SYSTEM_SLEEP_PM_OPS definition to compat.h
Date: Wed, 16 May 2012 12:44:09 +0200
Message-Id: <1337165050-31638-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
References: <1337165050-31638-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Old kernels are missing the definition of SET_SYSTEM_SLEEP_PM_OPS in linux/pm.h:

media_build/v4l/msp3400-driver.c:871:2: error: implicit declaration of function 'SET_SYSTEM_SLEEP_PM_OPS' [-Werror=implicit-function-declaration]
media_build/v4l/msp3400-driver.c:872:1: error: initializer element is not constant
media_build/v4l/msp3400-driver.c:872:1: error: (near initialization for 'msp3400_pm_ops.prepare')

Add it to compat.h to fix the compilation breakage.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com
---
 v4l/compat.h                      |   14 ++++++++++++++
 v4l/scripts/make_config_compat.pl |    1 +
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/v4l/compat.h b/v4l/compat.h
index 1556986..179ec26 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -963,4 +963,18 @@ static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_sg(
 }
 #endif
 
+#ifdef NEED_SET_SYSTEM_SLEEP_PM_OPS
+#ifdef CONFIG_PM_SLEEP
+#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
+        .suspend = suspend_fn, \
+        .resume = resume_fn, \
+        .freeze = suspend_fn, \
+        .thaw = resume_fn, \
+        .poweroff = suspend_fn, \
+        .restore = resume_fn,
+#else
+#define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
+#endif
+#endif
+
 #endif /*  _COMPAT_H */
diff --git a/v4l/scripts/make_config_compat.pl b/v4l/scripts/make_config_compat.pl
index 7810cfb..15220e6 100755
--- a/v4l/scripts/make_config_compat.pl
+++ b/v4l/scripts/make_config_compat.pl
@@ -520,6 +520,7 @@ sub check_other_dependencies()
 	check_file_for_func("include/linux/platform_device.h", "module_platform_driver", "NEED_MODULE_PLATFORM_DRIVER");
 	check_file_for_func("include/linux/slab.h", "kmalloc_array", "NEED_KMALLOC_ARRAY");
 	check_file_for_func("include/linux/dmaengine.h", "dmaengine_prep_slave_sg", "NEED_DMAENGINE_PREP_SLAVE_SG");
+	check_file_for_func("include/linux/pm.h", "SET_SYSTEM_SLEEP_PM_OPS", "NEED_SET_SYSTEM_SLEEP_PM_OPS");
 }
 
 # Do the basic rules
-- 
1.7.0.4

