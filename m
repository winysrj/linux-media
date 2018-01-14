Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44139 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbeANKDy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 05:03:54 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Disabled VIDEO_IPU3_CIO2 for Kernels older than 3.18.17
Date: Sun, 14 Jan 2018 11:03:39 +0000
Message-Id: <1515927819-27521-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The driver requires linux/property.h, which is available since Kernel
3.18.17 only.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 945e1c3..bf19bb1 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -55,6 +55,10 @@ MEDIA_CEC_SUPPORT
 # needs fwnode_property_read_u32
 SDR_MAX2175
 
+[3.18.17]
+# requires linux/property.h
+VIDEO_IPU3_CIO2
+
 [3.18.0]
 # needs LED brightness support
 V4L2_FLASH_LED_CLASS
-- 
2.7.4
