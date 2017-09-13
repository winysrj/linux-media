Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45153 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbdIMWke (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 18:40:34 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, jian.xu.zheng@intel.com,
        tian.shu.qiu@intel.com, andy.yeh@intel.com,
        rajmohan.mani@intel.com, hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Fix 4224x3136 video flickering at some vblanks
Date: Wed, 13 Sep 2017 15:38:45 -0700
Message-Id: <1505342325-9180-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, the sensor was outputting blank every other frame at 4224x3136
video when vblank was in the range [79, 86]. This resulted in video
flickering.

Omni Vision recommends us to use their settings for crop start/end for
4224x3136.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index af7af0d..f7c5771 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -238,11 +238,11 @@ struct ov13858_mode {
 	{0x3800, 0x00},
 	{0x3801, 0x00},
 	{0x3802, 0x00},
-	{0x3803, 0x00},
+	{0x3803, 0x08},
 	{0x3804, 0x10},
 	{0x3805, 0x9f},
 	{0x3806, 0x0c},
-	{0x3807, 0x5f},
+	{0x3807, 0x57},
 	{0x3808, 0x10},
 	{0x3809, 0x80},
 	{0x380a, 0x0c},
-- 
1.9.1
