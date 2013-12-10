Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1577 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3LJNZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/15] adv7604: adv7604_s_register clean up.
Date: Tue, 10 Dec 2013 14:23:09 +0100
Message-Id: <12ba6c8909259a6055aea5e48b0b0ca09c8c9ed1.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 417468c..37f3994 100644
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
1.8.4.rc3

