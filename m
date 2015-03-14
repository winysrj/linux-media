Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:37164 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752599AbbCNMff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 08:35:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 18BFE2A0081
	for <linux-media@vger.kernel.org>; Sat, 14 Mar 2015 13:35:24 +0100 (CET)
Message-ID: <55042B0B.1080201@xs4all.nl>
Date: Sat, 14 Mar 2015 13:35:23 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] vivid: allow s_dv_timings if it is the same as the current
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow setting the same timings as the current timings (i.e., do nothing in that
case). The code was actually there, but the vb2_is_busy() call was done before
the timings check instead of afterwards.

Found by v4l2-compliance.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1d9ea2d..c942bf7 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1585,13 +1585,13 @@ int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh,
 
 	if (!vivid_is_hdmi_cap(dev))
 		return -ENODATA;
-	if (vb2_is_busy(&dev->vb_vid_cap_q))
-		return -EBUSY;
 	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
 				0, NULL, NULL))
 		return -EINVAL;
 	if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0))
 		return 0;
+	if (vb2_is_busy(&dev->vb_vid_cap_q))
+		return -EBUSY;
 	dev->dv_timings_cap = *timings;
 	vivid_update_format_cap(dev, false);
 	return 0;
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 917cc69..5782b7d 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1125,13 +1125,13 @@ int vivid_vid_out_s_dv_timings(struct file *file, void *_fh,
 
 	if (!vivid_is_hdmi_out(dev))
 		return -ENODATA;
-	if (vb2_is_busy(&dev->vb_vid_out_q))
-		return -EBUSY;
 	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
 				0, NULL, NULL))
 		return -EINVAL;
 	if (v4l2_match_dv_timings(timings, &dev->dv_timings_out, 0))
 		return 0;
+	if (vb2_is_busy(&dev->vb_vid_out_q))
+		return -EBUSY;
 	dev->dv_timings_out = *timings;
 	vivid_update_format_out(dev);
 	return 0;
