Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:41883 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbcGQJIe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 05:08:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/5] adv7604: add vic detect
Date: Sun, 17 Jul 2016 11:08:17 +0200
Message-Id: <1468746497-46692-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
References: <1468746497-46692-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Obtain the correct timings based on the VIC code from the AVI InfoFrame.

It does a sanity check to see if at least the measured width and height
are in line with what the VIC code reports. If not, then use the timings
instead of the VIC code (as per the CEA-861 spec).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 4003831..1ab7572 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1566,10 +1566,24 @@ static int adv76xx_query_dv_timings(struct v4l2_subdev *sd,
 		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
 
 	if (is_digital_input(sd)) {
+		bool hdmi_signal = hdmi_read(sd, 0x05) & 0x80;
+		u8 vic = 0;
+		u32 w, h;
+
+		w = hdmi_read16(sd, 0x07, info->linewidth_mask);
+		h = hdmi_read16(sd, 0x09, info->field0_height_mask);
+
+		if (hdmi_signal && (io_read(sd, 0x60) & 1))
+			vic = infoframe_read(sd, 0x04);
+
+		if (vic && v4l2_find_dv_timings_cea861_vic(timings, vic) &&
+		    bt->width == w && bt->height == h)
+			goto found;
+
 		timings->type = V4L2_DV_BT_656_1120;
 
-		bt->width = hdmi_read16(sd, 0x07, info->linewidth_mask);
-		bt->height = hdmi_read16(sd, 0x09, info->field0_height_mask);
+		bt->width = w;
+		bt->height = h;
 		bt->pixelclock = info->read_hdmi_pixelclock(sd);
 		bt->hfrontporch = hdmi_read16(sd, 0x20, info->hfrontporch_mask);
 		bt->hsync = hdmi_read16(sd, 0x22, info->hsync_mask);
-- 
2.8.1

