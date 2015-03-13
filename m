Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:38866 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbCMQWS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 12:22:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 51C352A002F
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2015 17:22:07 +0100 (CET)
Message-ID: <55030EAF.8060305@xs4all.nl>
Date: Fri, 13 Mar 2015 17:22:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: report only one frameinterval
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vivid driver reports a range of frame intervals for non-webcams, when in fact
the frame interval is fixed for those inputs as it depends on the DV timings or
standard. Just report the single discrete frame interval instead.

Caught by v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1d9ea2d..5ed44f2 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1689,18 +1689,14 @@ int vidioc_enum_frameintervals(struct file *file, void *priv,
 		return -EINVAL;
 
 	if (!vivid_is_webcam(dev)) {
-		static const struct v4l2_fract step = { 1, 1 };
-
 		if (fival->index)
 			return -EINVAL;
 		if (fival->width < MIN_WIDTH || fival->width > MAX_WIDTH * MAX_ZOOM)
 			return -EINVAL;
 		if (fival->height < MIN_HEIGHT || fival->height > MAX_HEIGHT * MAX_ZOOM)
 			return -EINVAL;
-		fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
-		fival->stepwise.min = tpf_min;
-		fival->stepwise.max = tpf_max;
-		fival->stepwise.step = step;
+		fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+		fival->discrete = dev->timeperframe_vid_cap;
 		return 0;
 	}
 
