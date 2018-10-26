Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:48882 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbeJ0ALz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Oct 2018 20:11:55 -0400
From: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
To: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com
Cc: tfiga@chromium.org, tian.shu.qiu@intel.com,
        rajmohan.mani@intel.com, bingbu.cao@intel.com,
        hyungwoo.yang@intel.com,
        Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
Subject: [PATCH v1] media: ov13858: Check for possible null pointer
Date: Fri, 26 Oct 2018 08:34:30 -0700
Message-Id: <1540568070-26405-1-git-send-email-chiranjeevi.rapolu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Check for possible null pointer to avoid crash.

Signed-off-by: Chiranjeevi Rapolu <chiranjeevi.rapolu@intel.com>
---
 drivers/media/i2c/ov13858.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov13858.c b/drivers/media/i2c/ov13858.c
index c8bbc1f..45bb872 100644
--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1612,7 +1612,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 				OV13858_NUM_OF_LINK_FREQS - 1,
 				0,
 				link_freq_menu_items);
-	ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ov13858->link_freq)
+		ov13858->link_freq->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	pixel_rate_max = link_freq_to_pixel_rate(link_freq_menu_items[0]);
 	pixel_rate_min = link_freq_to_pixel_rate(link_freq_menu_items[1]);
@@ -1635,7 +1636,8 @@ static int ov13858_init_controls(struct ov13858 *ov13858)
 	ov13858->hblank = v4l2_ctrl_new_std(
 				ctrl_hdlr, &ov13858_ctrl_ops, V4L2_CID_HBLANK,
 				hblank, hblank, 1, hblank);
-	ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+	if (ov13858->hblank)
+		ov13858->hblank->flags |= V4L2_CTRL_FLAG_READ_ONLY;
 
 	exposure_max = mode->vts_def - 8;
 	ov13858->exposure = v4l2_ctrl_new_std(
-- 
2.7.4
