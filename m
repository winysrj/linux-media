Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48727 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaCJXOm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 16/48] media: staging: davinci: vpfe: Switch to pad-level DV operations
Date: Tue, 11 Mar 2014 00:15:27 +0100
Message-Id: <1394493359-14115-17-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video-level enum_dv_timings and dv_timings_cap operations are
deprecated in favor of the pad-level versions. All subdev drivers
implement the pad-level versions, switch to them.

Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 1f3b0f9..a1655a8 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -987,8 +987,10 @@ vpfe_enum_dv_timings(struct file *file, void *fh,
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
 	struct v4l2_subdev *subdev = video->current_ext_subdev->subdev;
 
+	timings->pad = 0;
+
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_dv_timings\n");
-	return v4l2_subdev_call(subdev, video, enum_dv_timings, timings);
+	return v4l2_subdev_call(subdev, pad, enum_dv_timings, timings);
 }
 
 /*
-- 
1.8.3.2

