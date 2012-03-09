Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60468 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2CIUrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 15:47:09 -0500
Received: by wejx9 with SMTP id x9so1395206wej.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 12:47:07 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: add module_driver and module_i2c_driver macros to compat.h
Date: Fri,  9 Mar 2012 21:45:50 +0100
Message-Id: <1331325950-2879-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch eliminates a lot of warnings like this on old kernels:

media_build/v4l/au8522_decoder.c:842: warning: data definition has no type or storage class
media_build/v4l/au8522_decoder.c:842: warning: type defaults to 'int' in declaration of 'module_i2c_driver'
media_build/v4l/au8522_decoder.c:842: warning: parameter names (without types) in function declaration
media_build/v4l/au8522_decoder.c:832: warning: 'au8522_driver' defined but not used

Tested with 2.6.32 and 3.3-rc6 without problems.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/compat.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/v4l/compat.h b/v4l/compat.h
index 62710c9..acc105c 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -898,4 +898,24 @@ module_exit(plat_mod_exit);
 #define DMA_MEM_TO_DEV DMA_TO_DEVICE
 #endif
 
+#ifndef module_driver
+#define module_driver(__driver, __register, __unregister) \
+static int __init __driver##_init(void) \
+{ \
+	return __register(&(__driver)); \
+} \
+module_init(__driver##_init); \
+static void __exit __driver##_exit(void) \
+{ \
+	__unregister(&(__driver)); \
+} \
+module_exit(__driver##_exit);
+#endif
+
+#ifndef module_i2c_driver
+#define module_i2c_driver(__i2c_driver) \
+       module_driver(__i2c_driver, i2c_add_driver, \
+                       i2c_del_driver)
+#endif
+
 #endif /*  _COMPAT_H */
-- 
1.7.0.4

