Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49561 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaEZTF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/6] v4l: s3c-camif: Return V4L2_FIELD_NONE from pad-level set format
Date: Mon, 26 May 2014 21:06:05 +0200
Message-Id: <1401131165-3542-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The bridge driver doesn't support interlaced formats, always return the
field order set to V4L2_FIELD_NONE.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index deba425..cc89133 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1271,6 +1271,7 @@ static int s3c_camif_subdev_get_fmt(struct v4l2_subdev *sd,
 	}
 
 	mutex_unlock(&camif->lock);
+	mf->field = V4L2_FIELD_NONE;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	return 0;
 }
@@ -1319,6 +1320,7 @@ static int s3c_camif_subdev_set_fmt(struct v4l2_subdev *sd,
 	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %ux%u\n",
 		 fmt->pad, mf->code, mf->width, mf->height);
 
+	mf->field = V4L2_FIELD_NONE;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 	mutex_lock(&camif->lock);
 
-- 
1.8.5.5

