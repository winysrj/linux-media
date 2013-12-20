Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2900 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3LTJb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/50] adv7604: adv7604_s_register clean up.
Date: Fri, 20 Dec 2013 10:31:04 +0100
Message-Id: <1387531903-20496-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 9f80d2e..ff8130f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -718,45 +718,47 @@ static int adv7604_g_register(struct v4l2_subdev *sd,
 static int adv7604_s_register(struct v4l2_subdev *sd,
 					const struct v4l2_dbg_register *reg)
 {
+	u8 val = reg->val & 0xff;
+
 	switch (reg->reg >> 8) {
 	case 0:
-		io_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		io_write(sd, reg->reg & 0xff, val);
 		break;
 	case 1:
-		avlink_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		avlink_write(sd, reg->reg & 0xff, val);
 		break;
 	case 2:
-		cec_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		cec_write(sd, reg->reg & 0xff, val);
 		break;
 	case 3:
-		infoframe_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		infoframe_write(sd, reg->reg & 0xff, val);
 		break;
 	case 4:
-		esdp_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		esdp_write(sd, reg->reg & 0xff, val);
 		break;
 	case 5:
-		dpp_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		dpp_write(sd, reg->reg & 0xff, val);
 		break;
 	case 6:
-		afe_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		afe_write(sd, reg->reg & 0xff, val);
 		break;
 	case 7:
-		rep_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		rep_write(sd, reg->reg & 0xff, val);
 		break;
 	case 8:
-		edid_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		edid_write(sd, reg->reg & 0xff, val);
 		break;
 	case 9:
-		hdmi_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		hdmi_write(sd, reg->reg & 0xff, val);
 		break;
 	case 0xa:
-		test_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		test_write(sd, reg->reg & 0xff, val);
 		break;
 	case 0xb:
-		cp_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		cp_write(sd, reg->reg & 0xff, val);
 		break;
 	case 0xc:
-		vdp_write(sd, reg->reg & 0xff, reg->val & 0xff);
+		vdp_write(sd, reg->reg & 0xff, val);
 		break;
 	default:
 		v4l2_info(sd, "Register %03llx not supported\n", reg->reg);
-- 
1.8.4.4

