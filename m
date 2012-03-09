Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59113 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2CIMTi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:19:38 -0500
Received: by eaaq12 with SMTP id q12so428033eaa.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 04:19:37 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] disable IR_GPIO_CIR module for kernels older than 2.6.35
Date: Fri,  9 Mar 2012 13:19:29 +0100
Message-Id: <1331295569-25158-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new module introduced with this patch:
http://patchwork.linuxtv.org/patch/10083/
requires request_any_context_irq() first introduced in 2.6.35

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 v4l/versions.txt |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index ff103bf..08b903a 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -30,6 +30,10 @@ VIDEO_VIA_CAMERA
 
 [2.6.36]
 
+[2.6.35]
+# Requires request_any_context_irq() introduced in 2.6.35
+IR_GPIO_CIR
+
 [2.6.34]
 MACH_DAVINCI_DM6467_EVM
 MFD_TIMBERDALE
-- 
1.7.0.4

