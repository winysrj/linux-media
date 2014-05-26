Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49556 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaEZTFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 15:05:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/6] v4l: noon010p30: Return V4L2_FIELD_NONE from pad-level set format
Date: Mon, 26 May 2014 21:06:00 +0200
Message-Id: <1401131165-3542-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1401131165-3542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sensor is progressive, always return the field order set to
V4L2_FIELD_NONE.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/noon010pc30.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 271d0b7..7eae487 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -554,6 +554,7 @@ static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	nf = noon010_try_fmt(sd, &fmt->format);
 	noon010_try_frame_size(&fmt->format, &size);
 	fmt->format.colorspace = V4L2_COLORSPACE_JPEG;
+	fmt->format.field = V4L2_FIELD_NONE;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		if (fh) {
-- 
1.8.5.5

