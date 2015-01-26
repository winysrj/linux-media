Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42651 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbAZNwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2015 08:52:50 -0500
Received: by mail-we0-f174.google.com with SMTP id w55so3729983wes.5
        for <linux-media@vger.kernel.org>; Mon, 26 Jan 2015 05:52:49 -0800 (PST)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hans.verkuil@cisco.com,
	m.chehab@samsung.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: adv7604: CP CSC uses a different register on adv7604 and adv7611
Date: Mon, 26 Jan 2015 14:52:40 +0100
Message-Id: <1422280360-20461-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bits are the same, but register is 0xf4 on ADV7611 instead of 0xfc.
When reading back the value in log_status, differentiate both.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..32e53e0 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2310,8 +2310,12 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 			(reg_io_0x02 & 0x04) ? "(16-235)" : "(0-255)",
 			((reg_io_0x02 & 0x04) ^ (reg_io_0x02 & 0x01)) ?
 				"enabled" : "disabled");
-	v4l2_info(sd, "Color space conversion: %s\n",
+	if (state->info->type == ADV7604)
+		v4l2_info(sd, "Color space conversion: %s\n",
 			csc_coeff_sel_rb[cp_read(sd, 0xfc) >> 4]);
+	else
+		v4l2_info(sd, "Color space conversion: %s\n",
+			csc_coeff_sel_rb[cp_read(sd, 0xf4) >> 4]);
 
 	if (!is_digital_input(sd))
 		return 0;
-- 
2.2.2

