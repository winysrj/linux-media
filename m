Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54196 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756538AbdLUGu5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 01:50:57 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Disabled MEDIA_TUNER_TDA18250 for Kernels older than 4.3
Date: Thu, 21 Dec 2017 07:50:41 +0000
Message-Id: <1513842641-18987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

The previouse patch did enable the TDA18250 driver for Kernel 4.2.
Corrected this now.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 6885a05..ed1e056 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -32,11 +32,13 @@ VIDEO_OV13858
 # needs gpiochip_get_data
 VIDEO_SOLO6X10
 
+[4.3.0]
+# needs regmap_write_bits
+MEDIA_TUNER_TDA18250
+
 [4.2.0]
 # needs led_trigger_remove
 V4L2_FLASH_LED_CLASS
-# needs regmap_write_bits
-MEDIA_TUNER_TDA18250
 
 [4.0.0]
 # needs of_property_read_u64_array
-- 
2.7.4
