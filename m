Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2659 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1HZMAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 08:00:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 8/8] saa7115: use the new auto cluster support.
Date: Fri, 26 Aug 2011 14:00:13 +0200
Message-Id: <2cae016b0233c4ed961644396e519554f74cd2e1.1314359706.git.hans.verkuil@cisco.com>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
References: <c30383666acc85a530fba5b1a14189670dfb8bb3.1314359706.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/saa7115.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index e443d0d..cee98ea 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -793,7 +793,6 @@ static int saa711x_s_ctrl(struct v4l2_ctrl *ctrl)
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val);
 		else
 			saa711x_write(sd, R_0F_CHROMA_GAIN_CNTL, state->gain->val | 0x80);
-		v4l2_ctrl_activate(state->gain, !state->agc->val);
 		break;
 
 	default:
@@ -1601,7 +1600,6 @@ static int saa711x_probe(struct i2c_client *client,
 			V4L2_CID_CHROMA_AGC, 0, 1, 1, 1);
 	state->gain = v4l2_ctrl_new_std(hdl, &saa711x_ctrl_ops,
 			V4L2_CID_CHROMA_GAIN, 0, 127, 1, 40);
-	state->gain->flags |= V4L2_CTRL_FLAG_VOLATILE;
 	sd->ctrl_handler = hdl;
 	if (hdl->error) {
 		int err = hdl->error;
@@ -1610,8 +1608,7 @@ static int saa711x_probe(struct i2c_client *client,
 		kfree(state);
 		return err;
 	}
-	state->agc->flags |= V4L2_CTRL_FLAG_UPDATE;
-	v4l2_ctrl_cluster(2, &state->agc);
+	v4l2_ctrl_auto_cluster(2, &state->agc, 0, true);
 
 	state->input = -1;
 	state->output = SAA7115_IPORT_ON;
-- 
1.7.5.4

