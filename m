Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38410 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbbDIIZ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2015 04:25:59 -0400
Received: by wiun10 with SMTP id n10so88422144wiu.1
        for <linux-media@vger.kernel.org>; Thu, 09 Apr 2015 01:25:57 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@osg.samsung.com,
	linux-kernel@vger.kernel.org,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: adv7604: Fix masks used for querying timings in ADV7611
Date: Thu,  9 Apr 2015 10:25:46 +0200
Message-Id: <1428567946-10193-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All masks for timings are different between ADV7604 and ADV7611.
Most of the values have 1 precision bit more in the latter.
Fix this by adding new fields to the chip_info structure.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 69 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 60ffcf0..c1be0f7 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -124,6 +124,20 @@ struct adv76xx_chip_info {
 	unsigned int num_recommended_settings[2];
 
 	unsigned long page_mask;
+
+	/* Masks for timings */
+	unsigned int linewidth_mask;
+	unsigned int field0_height_mask;
+	unsigned int field1_height_mask;
+	unsigned int hfrontporch_mask;
+	unsigned int hsync_mask;
+	unsigned int hbackporch_mask;
+	unsigned int field0_vfrontporch_mask;
+	unsigned int field1_vfrontporch_mask;
+	unsigned int field0_vsync_mask;
+	unsigned int field1_vsync_mask;
+	unsigned int field0_vbackporch_mask;
+	unsigned int field1_vbackporch_mask;
 };
 
 /*
@@ -1504,23 +1518,28 @@ static int adv76xx_query_dv_timings(struct v4l2_subdev *sd,
 	if (is_digital_input(sd)) {
 		timings->type = V4L2_DV_BT_656_1120;
 
-		/* FIXME: All masks are incorrect for ADV7611 */
-		bt->width = hdmi_read16(sd, 0x07, 0xfff);
-		bt->height = hdmi_read16(sd, 0x09, 0xfff);
+		bt->width = hdmi_read16(sd, 0x07, info->linewidth_mask);
+		bt->height = hdmi_read16(sd, 0x09, info->field0_height_mask);
 		bt->pixelclock = info->read_hdmi_pixelclock(sd);
-		bt->hfrontporch = hdmi_read16(sd, 0x20, 0x3ff);
-		bt->hsync = hdmi_read16(sd, 0x22, 0x3ff);
-		bt->hbackporch = hdmi_read16(sd, 0x24, 0x3ff);
-		bt->vfrontporch = hdmi_read16(sd, 0x2a, 0x1fff) / 2;
-		bt->vsync = hdmi_read16(sd, 0x2e, 0x1fff) / 2;
-		bt->vbackporch = hdmi_read16(sd, 0x32, 0x1fff) / 2;
+		bt->hfrontporch = hdmi_read16(sd, 0x20, info->hfrontporch_mask);
+		bt->hsync = hdmi_read16(sd, 0x22, info->hsync_mask);
+		bt->hbackporch = hdmi_read16(sd, 0x24, info->hbackporch_mask);
+		bt->vfrontporch = hdmi_read16(sd, 0x2a,
+			info->field0_vfrontporch_mask) / 2;
+		bt->vsync = hdmi_read16(sd, 0x2e, info->field0_vsync_mask) / 2;
+		bt->vbackporch = hdmi_read16(sd, 0x32,
+			info->field0_vbackporch_mask) / 2;
 		bt->polarities = ((hdmi_read(sd, 0x05) & 0x10) ? V4L2_DV_VSYNC_POS_POL : 0) |
 			((hdmi_read(sd, 0x05) & 0x20) ? V4L2_DV_HSYNC_POS_POL : 0);
 		if (bt->interlaced == V4L2_DV_INTERLACED) {
-			bt->height += hdmi_read16(sd, 0x0b, 0xfff);
-			bt->il_vfrontporch = hdmi_read16(sd, 0x2c, 0x1fff) / 2;
-			bt->il_vsync = hdmi_read16(sd, 0x30, 0x1fff) / 2;
-			bt->il_vbackporch = hdmi_read16(sd, 0x34, 0x1fff) / 2;
+			bt->height += hdmi_read16(sd, 0x0b,
+				info->field1_height_mask);
+			bt->il_vfrontporch = hdmi_read16(sd, 0x2c,
+				info->field1_vfrontporch_mask) / 2;
+			bt->il_vsync = hdmi_read16(sd, 0x30,
+				info->field1_vsync_mask) / 2;
+			bt->il_vbackporch = hdmi_read16(sd, 0x34,
+				info->field1_vbackporch_mask) / 2;
 		}
 		adv76xx_fill_optional_dv_timings_fields(sd, timings);
 	} else {
@@ -2567,6 +2586,18 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 			BIT(ADV76XX_PAGE_EDID) | BIT(ADV76XX_PAGE_HDMI) |
 			BIT(ADV76XX_PAGE_TEST) | BIT(ADV76XX_PAGE_CP) |
 			BIT(ADV7604_PAGE_VDP),
+		.linewidth_mask = 0xfff,
+		.field0_height_mask = 0xfff,
+		.field1_height_mask = 0xfff,
+		.hfrontporch_mask = 0x3ff,
+		.hsync_mask = 0x3ff,
+		.hbackporch_mask = 0x3ff,
+		.field0_vfrontporch_mask = 0x1fff,
+		.field0_vsync_mask = 0x1fff,
+		.field0_vbackporch_mask = 0x1fff,
+		.field1_vfrontporch_mask = 0x1fff,
+		.field1_vsync_mask = 0x1fff,
+		.field1_vbackporch_mask = 0x1fff,
 	},
 	[ADV7611] = {
 		.type = ADV7611,
@@ -2596,6 +2627,18 @@ static const struct adv76xx_chip_info adv76xx_chip_info[] = {
 			BIT(ADV76XX_PAGE_INFOFRAME) | BIT(ADV76XX_PAGE_AFE) |
 			BIT(ADV76XX_PAGE_REP) |  BIT(ADV76XX_PAGE_EDID) |
 			BIT(ADV76XX_PAGE_HDMI) | BIT(ADV76XX_PAGE_CP),
+		.linewidth_mask = 0x1fff,
+		.field0_height_mask = 0x1fff,
+		.field1_height_mask = 0x1fff,
+		.hfrontporch_mask = 0x1fff,
+		.hsync_mask = 0x1fff,
+		.hbackporch_mask = 0x1fff,
+		.field0_vfrontporch_mask = 0x3fff,
+		.field0_vsync_mask = 0x3fff,
+		.field0_vbackporch_mask = 0x3fff,
+		.field1_vfrontporch_mask = 0x3fff,
+		.field1_vsync_mask = 0x3fff,
+		.field1_vbackporch_mask = 0x3fff,
 	},
 };
 
-- 
2.3.1

