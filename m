Return-path: <linux-media-owner@vger.kernel.org>
Received: from bgl-iport-3.cisco.com ([72.163.197.27]:23013 "EHLO
	bgl-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbbHCIgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 04:36:47 -0400
From: Prashant Laddha <prladdha@cisco.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prashant Laddha <prladdha@cisco.com>
Subject: [PATCH] vivid: support cvt, gtf timings for video out
Date: Mon,  3 Aug 2015 14:06:43 +0530
Message-Id: <1438591003-4733-1-git-send-email-prladdha@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The generation of cvt, gtf timings is already supported by v4l2-ctl.
This patch adds support for setting cvt,gtf timings for video out.
While enabling cvt,gtf in vivid capture, the vivid video out was
missed out. Adding it now.

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Prashant Laddha <prladdha@cisco.com>
---
 drivers/media/platform/vivid/vivid-vid-out.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 0862c1f..c404e27 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1124,15 +1124,26 @@ int vivid_vid_out_s_std(struct file *file, void *priv, v4l2_std_id id)
 	return 0;
 }
 
+static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
+{
+	struct v4l2_bt_timings *bt = &timings->bt;
+
+	if ((bt->standards & (V4L2_DV_BT_STD_CVT | V4L2_DV_BT_STD_GTF)) &&
+	    v4l2_valid_dv_timings(timings, &vivid_dv_timings_cap, NULL, NULL))
+		return true;
+
+	return false;
+}
+
 int vivid_vid_out_s_dv_timings(struct file *file, void *_fh,
 				    struct v4l2_dv_timings *timings)
 {
 	struct vivid_dev *dev = video_drvdata(file);
-
 	if (!vivid_is_hdmi_out(dev))
 		return -ENODATA;
 	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
-				0, NULL, NULL))
+				0, NULL, NULL) &&
+	    !valid_cvt_gtf_timings(timings))
 		return -EINVAL;
 	if (v4l2_match_dv_timings(timings, &dev->dv_timings_out, 0))
 		return 0;
-- 
1.9.1

