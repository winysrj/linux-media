Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:55505 "EHLO
	xk120" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752720AbbA2QTw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 11:19:52 -0500
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 4/8] WmT: m-5mols_core style pad handling for adv7604
Date: Thu, 29 Jan 2015 16:19:44 +0000
Message-Id: <1422548388-28861-5-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
References: <1422548388-28861-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/i2c/adv7604.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 30bbd9d..6ed9303 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1976,7 +1976,11 @@ static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = (fh == NULL) ? NULL
+			: v4l2_subdev_get_try_format(fh, format->pad);
+		if (fmt == NULL)
+			return EINVAL;
+
 		format->format.code = fmt->code;
 	} else {
 		format->format.code = state->format->code;
@@ -2008,7 +2012,11 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = (fh == NULL) ? NULL
+			: v4l2_subdev_get_try_format(fh, format->pad);
+		if (fmt == NULL)
+			return -EINVAL;
+
 		fmt->code = format->format.code;
 	} else {
 		state->format = info;
-- 
1.7.10.4

