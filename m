Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:48529 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2EUMhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 May 2012 08:37:18 -0400
Received: by weyu7 with SMTP id u7so3153001wey.19
        for <linux-media@vger.kernel.org>; Mon, 21 May 2012 05:37:17 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: disable VIDEO_SMIAPP_PLL, VIDEO_MT9M032 and VIDEO_MT9P031 on old kernels
Date: Mon, 21 May 2012 14:37:07 +0200
Message-Id: <1337603827-22392-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_SMIAPP_PLL can't build on vanilla kernels older than 2.6.34 as it
requires linux/lcm.h; this is not a problem with the Ubuntu 10.04 2.6.32 kernel
as it includes the new lcm.* lib/header files, so the issue was not detected
before. This fixes the error:

media_build/v4l/smiapp-pll.c:26:23: fatal error: linux/lcm.h: No such file or directory

Also, this patch explicitly disables the MT9M032 and MT9P031 drivers that
depends on APTINA_PLL; this drivers try to autoselect the APTINA_PLL dependency
and so they are not enabled by default on old kernels (where this driver is
already blacklisted) but are still manually selectable by the user through
'make menuconfig' or 'make xconfig', breaking compilation.
So it's better to explicitly blacklist this drivers too.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com
---
 v4l/versions.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index a8170c2..d0626e8 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -43,7 +43,13 @@ VIDEO_TVP7002
 VIDEO_DT3155
 # Needs include/linux/lcm.h
 VIDEO_APTINA_PLL
-# Requires gpio_request_one introduced in 2.6.34
+# Depends on VIDEO_APTINA_PLL
+VIDEO_MT9M032
+# Depends on VIDEO_APTINA_PLL and requires gpio_request_one
+VIDEO_MT9P031
+# Needs include/linux/lcm.h
+VIDEO_SMIAPP_PLL
+# Depends on VIDEO_SMIAPP_PLL and requires gpio_request_one
 VIDEO_SMIAPP
 
 [2.6.33]
-- 
1.7.0.4

