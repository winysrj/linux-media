Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65321 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CTOK1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 10:10:27 -0400
Received: by eaaq12 with SMTP id q12so30151eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 07:10:26 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: fix module_*_driver redefined warnings
Date: Tue, 20 Mar 2012 15:10:17 +0100
Message-Id: <1332252617-3171-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The conditions "#ifndef module_usb_driver" and "#ifndef module_platform_driver"
are always true, as the header files where this macros are defined are not
included in compat.h (linux/usb.h and linux/platform_devices.h).

This produces a lot of warnings like "module_usb_driver redefined" or
"module_platform_driver redefined" with kernels 3.2 and 3.3.

But including the header files in compat.h produces other "redefined" warnings,
so let's check the kernel version instead.

module_usb_driver was first introduced in kernel 3.3,
while module_platform_driver was introduced in kernel 3.2.

Tested with kernel 3.3, 3.2 and 3.0.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/compat.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/v4l/compat.h b/v4l/compat.h
index 62710c9..ab0f2e7 100644
--- a/v4l/compat.h
+++ b/v4l/compat.h
@@ -864,7 +864,7 @@ static inline int snd_ctl_enum_info(struct snd_ctl_elem_info *info, unsigned int
 #endif
 #endif /*pr_debug_ratelimited */
 
-#ifndef module_usb_driver
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 3, 0)
 #define module_usb_driver(drv)			\
 static int __init usb_mod_init(void)		\
 {						\
@@ -878,7 +878,7 @@ module_init(usb_mod_init);			\
 module_exit(usb_mod_exit);
 #endif /* module_usb_driver */
 
-#ifndef module_platform_driver
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3, 2, 0)
 #define module_platform_driver(drv)		\
 static int __init plat_mod_init(void)		\
 {						\
-- 
1.7.5.4

