Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3652 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966094Ab3E2OTj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 07/14] tvp514x: fix querystd
Date: Wed, 29 May 2013 16:19:00 +0200
Message-Id: <1369837147-8747-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/tvp514x.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7438e01..c2b343b 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -543,8 +543,6 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	if (std_id == NULL)
 		return -EINVAL;
 
-	*std_id = V4L2_STD_UNKNOWN;
-
 	/* To query the standard the TVP514x must power on the ADCs. */
 	if (!decoder->streaming) {
 		tvp514x_s_stream(sd, 1);
@@ -553,8 +551,10 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 
 	/* query the current standard */
 	current_std = tvp514x_query_current_std(sd);
-	if (current_std == STD_INVALID)
+	if (current_std == STD_INVALID) {
+		*std_id = V4L2_STD_UNKNOWN;
 		return 0;
+	}
 
 	input_sel = decoder->input;
 
@@ -595,10 +595,12 @@ static int tvp514x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std_id)
 	}
 	/* check whether signal is locked */
 	sync_lock_status = tvp514x_read_reg(sd, REG_STATUS1);
-	if (lock_mask != (sync_lock_status & lock_mask))
+	if (lock_mask != (sync_lock_status & lock_mask)) {
+		*std_id = V4L2_STD_UNKNOWN;
 		return 0;	/* No input detected */
+	}
 
-	*std_id = decoder->std_list[current_std].standard.id;
+	*std_id &= decoder->std_list[current_std].standard.id;
 
 	v4l2_dbg(1, debug, sd, "Current STD: %s\n",
 			decoder->std_list[current_std].standard.name);
-- 
1.7.10.4

