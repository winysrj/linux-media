Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49561 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaEZTFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH 3/6] v4l: s5k5baf: Return V4L2_FIELD_NONE from pad-level set format
Date: Mon, 26 May 2014 21:06:02 +0200
Message-Id: <1401131165-3542-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor is progressive, always return the field order set to
V4L2_FIELD_NONE.

Cc: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/s5k5baf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 2d768ef..564f05f 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1313,6 +1313,8 @@ static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	const struct s5k5baf_pixfmt *pixfmt;
 	int ret = 0;
 
+	mf->field = V4L2_FIELD_NONE;
+
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_get_try_format(fh, fmt->pad) = *mf;
 		return 0;
-- 
1.8.5.5

