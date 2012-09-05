Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:13686 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2IEN0O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 09:26:14 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] s5p-fimc: fimc-lite: Propagate frame format on the subdev
Date: Wed, 05 Sep 2012 15:25:08 +0200
Message-id: <1346851508-16705-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1346851508-16705-1-git-send-email-s.nawrocki@samsung.com>
References: <1346851508-16705-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When setting image format on subdev's sink pad there was no
propagation to the source pad. This resulted in wrong reported
format on the source pad and wrong device configuration when
used from subdev interace level only. Correct this by propagating
format from the sink to the source pad.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-lite.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-lite.c b/drivers/media/video/s5p-fimc/fimc-lite.c
index 9289008..cd4cf12 100644
--- a/drivers/media/video/s5p-fimc/fimc-lite.c
+++ b/drivers/media/video/s5p-fimc/fimc-lite.c
@@ -1064,6 +1064,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
 	struct flite_frame *sink = &fimc->inp_frame;
+	struct flite_frame *source = &fimc->out_frame;
 	const struct fimc_fmt *ffmt;
 
 	v4l2_dbg(1, debug, sd, "pad%d: code: 0x%x, %dx%d",
@@ -1097,8 +1098,10 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		sink->rect.height = mf->height;
 		sink->rect.left = 0;
 		sink->rect.top = 0;
-		/* Reset source crop rectangle */
-		fimc->out_frame.rect = sink->rect;
+		/* Reset source format and crop rectangle */
+		source->rect = sink->rect;
+		source->f_width = mf->width;
+		source->f_height = mf->height;
 	} else {
 		/* Allow changing format only on sink pad */
 		mf->code = fimc->fmt->mbus_code;
-- 
1.7.11.3

