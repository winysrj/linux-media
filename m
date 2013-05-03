Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43141 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761851Ab3ECKmv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 May 2013 06:42:51 -0400
Received: by mail-ee0-f52.google.com with SMTP id d41so692452eek.39
        for <linux-media@vger.kernel.org>; Fri, 03 May 2013 03:42:49 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com,
	hans.verkuil@cisco.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] media_build: enable uvcvideo starting from kernel 2.6.32
Date: Fri,  3 May 2013 12:42:14 +0200
Message-Id: <1367577734-13856-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch already provides all the required compat bits:

http://git.linuxtv.org/media_build.git/commit/d84f5306d8bd62ca0d8f49f06557c54573addaf4

Tested with the integrated webcam in my Dell Precision M6500 laptop
on Ubuntu 10.04 with kernel 2.6.32 and the latest media_build drivers.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/versions.txt                           |   4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index c541319..ea203b2 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -58,8 +58,6 @@ VIDEO_VIA_CAMERA
 [2.6.36]
 
 [2.6.35]
-# Requires ss_ep_comp in usb_host_endpoint
-USB_VIDEO_CLASS
 
 [2.6.34]
 MACH_DAVINCI_DM6467_EVM
@@ -98,6 +96,8 @@ IR_ITE_CIR
 IR_FINTEK
 # Relies on i2c_lock_adapter
 DVB_DRXK
+# Requires ss_ep_comp in usb_host_endpoint
+USB_VIDEO_CLASS
 
 [2.6.31]
 # These rely on arch support that wasn't available until 2.6.31
-- 
1.8.2.2

