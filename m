Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52619 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbbBDOQL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 09:16:11 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so1910913wgh.13
        for <linux-media@vger.kernel.org>; Wed, 04 Feb 2015 06:16:09 -0800 (PST)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH v2] media: adv7604: CP CSC uses a different register on adv7604 and adv7611
Date: Wed,  4 Feb 2015 15:16:00 +0100
Message-Id: <1423059360-26922-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bits are the same, but register is 0xf4 on ADV7611 instead of 0xfc.
When reading back the value in log_status, differentiate both.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
v2: Use adv7604_chip_info to get register instead of testing the chip ID

 drivers/media/i2c/adv7604.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..0ee1255 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -109,6 +109,7 @@ struct adv7604_chip_info {
 	unsigned int cable_det_mask;
 	unsigned int tdms_lock_mask;
 	unsigned int fmt_change_digital_mask;
+	unsigned int cp_csc;
 
 	const struct adv7604_format_info *formats;
 	unsigned int nformats;
@@ -2311,7 +2312,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 			((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
 				"enabled" : "disabled");
 	v4l2_info(sd, "Color space conversion: %s\n",
-			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
+			csc_coeff_sel_rb[cp_read(sd, info->cp_csc) >> 4]);
 
 	if (!is_digital_input(sd))
 		return 0;
@@ -2615,6 +2616,7 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		.tdms_lock_mask = 0xe0,
 		.cable_det_mask = 0x1e,
 		.fmt_change_digital_mask = 0xc1,
+		.cp_csc = 0xfc,
 		.formats = adv7604_formats,
 		.nformats = ARRAY_SIZE(adv7604_formats),
 		.set_termination = adv7604_set_termination,
@@ -2648,6 +2650,7 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
 		.tdms_lock_mask = 0x43,
 		.cable_det_mask = 0x01,
 		.fmt_change_digital_mask = 0x03,
+		.cp_csc = 0xf4,
 		.formats = adv7611_formats,
 		.nformats = ARRAY_SIZE(adv7611_formats),
 		.set_termination = adv7611_set_termination,
-- 
2.2.2

