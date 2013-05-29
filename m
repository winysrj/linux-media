Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1824 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965648Ab3E2OTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/14] saa7191: fix querystd
Date: Wed, 29 May 2013 16:18:59 +0200
Message-Id: <1369837147-8747-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7191.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/saa7191.c b/drivers/media/i2c/saa7191.c
index 84f7899..9d8ea2a 100644
--- a/drivers/media/i2c/saa7191.c
+++ b/drivers/media/i2c/saa7191.c
@@ -272,7 +272,7 @@ static int saa7191_querystd(struct v4l2_subdev *sd, v4l2_std_id *norm)
 
 	dprintk("SAA7191 extended signal auto-detection...\n");
 
-	*norm = V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
+	*norm &= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM;
 	stdc &= ~SAA7191_STDC_SECS;
 	ctl3 &= ~(SAA7191_CTL3_FSEL);
 
@@ -303,7 +303,7 @@ static int saa7191_querystd(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	if (status & SAA7191_STATUS_FIDT) {
 		/* 60Hz signal -> NTSC */
 		dprintk("60Hz signal: NTSC\n");
-		*norm = V4L2_STD_NTSC;
+		*norm &= V4L2_STD_NTSC;
 		return 0;
 	}
 
@@ -325,12 +325,13 @@ static int saa7191_querystd(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	if (status & SAA7191_STATUS_FIDT) {
 		dprintk("No 50Hz signal\n");
 		saa7191_s_std(sd, old_norm);
-		return -EAGAIN;
+		*norm = V4L2_STD_UNKNOWN;
+		return 0;
 	}
 
 	if (status & SAA7191_STATUS_CODE) {
 		dprintk("PAL\n");
-		*norm = V4L2_STD_PAL;
+		*norm &= V4L2_STD_PAL;
 		return saa7191_s_std(sd, old_norm);
 	}
 
@@ -350,18 +351,19 @@ static int saa7191_querystd(struct v4l2_subdev *sd, v4l2_std_id *norm)
 	/* not 50Hz ? */
 	if (status & SAA7191_STATUS_FIDT) {
 		dprintk("No 50Hz signal\n");
-		err = -EAGAIN;
+		*norm = V4L2_STD_UNKNOWN;
 		goto out;
 	}
 
 	if (status & SAA7191_STATUS_CODE) {
 		/* Color detected -> SECAM */
 		dprintk("SECAM\n");
-		*norm = V4L2_STD_SECAM;
+		*norm &= V4L2_STD_SECAM;
 		return saa7191_s_std(sd, old_norm);
 	}
 
 	dprintk("No color detected with SECAM - Going back to PAL.\n");
+	*norm = V4L2_STD_UNKNOWN;
 
 out:
 	return saa7191_s_std(sd, old_norm);
-- 
1.7.10.4

