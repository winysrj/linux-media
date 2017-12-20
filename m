Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:54637 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754723AbdLTItr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 03:49:47 -0500
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Disabled MEDIA_TUNER_TDA18250 for Kernels older than 4.3
Date: Wed, 20 Dec 2017 09:49:30 +0000
Message-Id: <1513763370-24556-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Due to recent changes the TDA18250 driver requires now regmap_write_bits,
which is available since Kernel 4.3 only.

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 v4l/versions.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/v4l/versions.txt b/v4l/versions.txt
index 072e7d6..6885a05 100644
--- a/v4l/versions.txt
+++ b/v4l/versions.txt
@@ -35,6 +35,8 @@ VIDEO_SOLO6X10
 [4.2.0]
 # needs led_trigger_remove
 V4L2_FLASH_LED_CLASS
+# needs regmap_write_bits
+MEDIA_TUNER_TDA18250
 
 [4.0.0]
 # needs of_property_read_u64_array
@@ -86,8 +88,6 @@ VIDEO_COBALT
 [3.13.0]
 # needs gpio/consumer.h
 RADIO_SI4713
-# needs regmap_reg_range
-MEDIA_TUNER_TDA18250
 
 [3.12.0]
 # BIN_ATTR_RW was changed
-- 
2.7.4
