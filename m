Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2194 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HSOor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 13/20] adv7604/ad9389b/ths8200: decrease min_pixelclock to 25MHz
Date: Mon, 19 Aug 2013 16:44:22 +0200
Message-Id: <1376923469-30694-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The CEA-861 standard allows for the 640x480 format at 25.175 MHz.
Ensure that that's allowed according to the struct v4l2_bt_timings_cap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 2 +-
 drivers/media/i2c/adv7604.c | 2 +-
 drivers/media/i2c/ths8200.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 1c6d352..bb74fb6 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -631,7 +631,7 @@ static const struct v4l2_dv_timings_cap ad9389b_timings_cap = {
 	.bt = {
 		.max_width = 1920,
 		.max_height = 1200,
-		.min_pixelclock = 27000000,
+		.min_pixelclock = 25000000,
 		.max_pixelclock = 170000000,
 		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
 			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index a1a9d1e..5b54ba1 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1162,7 +1162,7 @@ static int adv7604_dv_timings_cap(struct v4l2_subdev *sd,
 	cap->type = V4L2_DV_BT_656_1120;
 	cap->bt.max_width = 1920;
 	cap->bt.max_height = 1200;
-	cap->bt.min_pixelclock = 27000000;
+	cap->bt.min_pixelclock = 25000000;
 	if (DIGITAL_INPUT)
 		cap->bt.max_pixelclock = 225000000;
 	else
diff --git a/drivers/media/i2c/ths8200.c b/drivers/media/i2c/ths8200.c
index 49041e5..580bd1b 100644
--- a/drivers/media/i2c/ths8200.c
+++ b/drivers/media/i2c/ths8200.c
@@ -49,7 +49,7 @@ static const struct v4l2_dv_timings_cap ths8200_timings_cap = {
 	.bt = {
 		.max_width = 1920,
 		.max_height = 1080,
-		.min_pixelclock = 27000000,
+		.min_pixelclock = 25000000,
 		.max_pixelclock = 148500000,
 		.standards = V4L2_DV_BT_STD_CEA861,
 		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE,
-- 
1.8.3.2

