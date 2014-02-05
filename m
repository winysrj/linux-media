Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaBEQly (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 17/47] s5p-tv: mixer: Switch to pad-level DV operations
Date: Wed,  5 Feb 2014 17:42:08 +0100
Message-Id: <1391618558-5580-18-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/s5p-tv/mixer_video.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index c5059ba..0d6b928 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -509,9 +509,11 @@ static int mxr_enum_dv_timings(struct file *file, void *fh,
 	struct mxr_device *mdev = layer->mdev;
 	int ret;
 
+	timings->pad = 0;
+
 	/* lock protects from changing sd_out */
 	mutex_lock(&mdev->mutex);
-	ret = v4l2_subdev_call(to_outsd(mdev), video, enum_dv_timings, timings);
+	ret = v4l2_subdev_call(to_outsd(mdev), pad, enum_dv_timings, timings);
 	mutex_unlock(&mdev->mutex);
 
 	return ret ? -EINVAL : 0;
@@ -567,9 +569,11 @@ static int mxr_dv_timings_cap(struct file *file, void *fh,
 	struct mxr_device *mdev = layer->mdev;
 	int ret;
 
+	cap->pad = 0;
+
 	/* lock protects from changing sd_out */
 	mutex_lock(&mdev->mutex);
-	ret = v4l2_subdev_call(to_outsd(mdev), video, dv_timings_cap, cap);
+	ret = v4l2_subdev_call(to_outsd(mdev), pad, dv_timings_cap, cap);
 	mutex_unlock(&mdev->mutex);
 
 	return ret ? -EINVAL : 0;
-- 
1.8.3.2

