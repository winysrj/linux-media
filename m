Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1947 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2ITMHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Sep 2012 08:07:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 14/14] tvp514x: s_routing should just change routing, not try to detect a signal.
Date: Thu, 20 Sep 2012 14:06:33 +0200
Message-Id: <9bb567110718a2bef1908cd04396c0e83e1e2e51.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
References: <1348142793-27157-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The s_routing function should not try to detect a signal. It is a really
bad idea to try to detect a valid video signal and return an error if
you can't. Changing input should do just that and nothing more.

Also don't power on the ADCs on s_routing, instead do that on querystd.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tvp514x.c |   77 ++++---------------------------------------
 1 file changed, 6 insertions(+), 71 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 1f3943b..d5e1021 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -519,6 +519,12 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 
 	*std_id = V4L2_STD_UNKNOWN;
 
+	/* To query the standard the TVP514x must power on the ADCs. */
+	if (!decoder->streaming) {
+		tvp514x_s_stream(sd, 1);
+		msleep(LOCK_RETRY_DELAY);
+	}
+
 	/* query the current standard */
 	current_std = tvp514x_query_current_std(sd);
 	if (current_std == STD_INVALID)
@@ -625,25 +631,12 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 	int err;
 	enum tvp514x_input input_sel;
 	enum tvp514x_output output_sel;
-	u8 sync_lock_status, lock_mask;
-	int try_count = LOCK_RETRY_COUNT;
 
 	if ((input >= INPUT_INVALID) ||
 			(output >= OUTPUT_INVALID))
 		/* Index out of bound */
 		return -EINVAL;
 
-	/*
-	 * For the sequence streamon -> streamoff and again s_input
-	 * it fails to lock the signal, since streamoff puts TVP514x
-	 * into power off state which leads to failure in sub-sequent s_input.
-	 *
-	 * So power up the TVP514x device here, since it is important to lock
-	 * the signal at this stage.
-	 */
-	if (!decoder->streaming)
-		tvp514x_s_stream(sd, 1);
-
 	input_sel = input;
 	output_sel = output;
 
@@ -660,64 +653,6 @@ static int tvp514x_s_routing(struct v4l2_subdev *sd,
 
 	decoder->tvp514x_regs[REG_INPUT_SEL].val = input_sel;
 	decoder->tvp514x_regs[REG_OUTPUT_FORMATTER1].val = output_sel;
-
-	/* Clear status */
-	msleep(LOCK_RETRY_DELAY);
-	err =
-	    tvp514x_write_reg(sd, REG_CLEAR_LOST_LOCK, 0x01);
-	if (err)
-		return err;
-
-	switch (input_sel) {
-	case INPUT_CVBS_VI1A:
-	case INPUT_CVBS_VI1B:
-	case INPUT_CVBS_VI1C:
-	case INPUT_CVBS_VI2A:
-	case INPUT_CVBS_VI2B:
-	case INPUT_CVBS_VI2C:
-	case INPUT_CVBS_VI3A:
-	case INPUT_CVBS_VI3B:
-	case INPUT_CVBS_VI3C:
-	case INPUT_CVBS_VI4A:
-		lock_mask = STATUS_CLR_SUBCAR_LOCK_BIT |
-			STATUS_HORZ_SYNC_LOCK_BIT |
-			STATUS_VIRT_SYNC_LOCK_BIT;
-		break;
-
-	case INPUT_SVIDEO_VI2A_VI1A:
-	case INPUT_SVIDEO_VI2B_VI1B:
-	case INPUT_SVIDEO_VI2C_VI1C:
-	case INPUT_SVIDEO_VI2A_VI3A:
-	case INPUT_SVIDEO_VI2B_VI3B:
-	case INPUT_SVIDEO_VI2C_VI3C:
-	case INPUT_SVIDEO_VI4A_VI1A:
-	case INPUT_SVIDEO_VI4A_VI1B:
-	case INPUT_SVIDEO_VI4A_VI1C:
-	case INPUT_SVIDEO_VI4A_VI3A:
-	case INPUT_SVIDEO_VI4A_VI3B:
-	case INPUT_SVIDEO_VI4A_VI3C:
-		lock_mask = STATUS_HORZ_SYNC_LOCK_BIT |
-			STATUS_VIRT_SYNC_LOCK_BIT;
-		break;
-	/* Need to add other interfaces*/
-	default:
-		return -EINVAL;
-	}
-
-	while (try_count-- > 0) {
-		/* Allow decoder to sync up with new input */
-		msleep(LOCK_RETRY_DELAY);
-
-		sync_lock_status = tvp514x_read_reg(sd,
-				REG_STATUS1);
-		if (lock_mask == (sync_lock_status & lock_mask))
-			/* Input detected */
-			break;
-	}
-
-	if (try_count < 0)
-		return -EINVAL;
-
 	decoder->input = input;
 	decoder->output = output;
 
-- 
1.7.10.4

