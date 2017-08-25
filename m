Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18120 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdHYEWf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 00:22:35 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov5670: Use recommended black level and output bias
Date: Thu, 24 Aug 2017 21:20:55 -0700
Message-Id: <1503634855-5740-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, images were relatively darker due to non-optimal
settings for black target level and bias.

Now, use recommended settings for black target level and output bias
as default values. The same default settings apply to all the resolutions.
Given these recommeneded settings do not change dynamically, add these to
existing mode register settings.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov5670.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov5670.c b/drivers/media/i2c/ov5670.c
index 6f7a1d6..759ca62 100644
--- a/drivers/media/i2c/ov5670.c
+++ b/drivers/media/i2c/ov5670.c
@@ -390,7 +390,10 @@ struct ov5670_mode {
 	{0x5792, 0x00},
 	{0x5793, 0x52},
 	{0x5794, 0xa3},
-	{0x3503, 0x00}
+	{0x3503, 0x00},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const struct ov5670_reg mode_1296x972_regs[] = {
@@ -653,7 +656,10 @@ struct ov5670_mode {
 	{0x5792, 0x00},
 	{0x5793, 0x52},
 	{0x5794, 0xa3},
-	{0x3503, 0x00}
+	{0x3503, 0x00},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const struct ov5670_reg mode_648x486_regs[] = {
@@ -916,7 +922,10 @@ struct ov5670_mode {
 	{0x5792, 0x00},
 	{0x5793, 0x52},
 	{0x5794, 0xa3},
-	{0x3503, 0x00}
+	{0x3503, 0x00},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const struct ov5670_reg mode_2560x1440_regs[] = {
@@ -1178,7 +1187,10 @@ struct ov5670_mode {
 	{0x5791, 0x06},
 	{0x5792, 0x00},
 	{0x5793, 0x52},
-	{0x5794, 0xa3}
+	{0x5794, 0xa3},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const struct ov5670_reg mode_1280x720_regs[] = {
@@ -1441,7 +1453,10 @@ struct ov5670_mode {
 	{0x5792, 0x00},
 	{0x5793, 0x52},
 	{0x5794, 0xa3},
-	{0x3503, 0x00}
+	{0x3503, 0x00},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const struct ov5670_reg mode_640x360_regs[] = {
@@ -1704,7 +1719,10 @@ struct ov5670_mode {
 	{0x5792, 0x00},
 	{0x5793, 0x52},
 	{0x5794, 0xa3},
-	{0x3503, 0x00}
+	{0x3503, 0x00},
+	{0x5045, 0x05},
+	{0x4003, 0x40},
+	{0x5048, 0x40}
 };
 
 static const char * const ov5670_test_pattern_menu[] = {
-- 
1.9.1
