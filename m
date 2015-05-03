Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47334 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbbECJy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:54:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/9] ov5642: avoid calling ov5642_find_datafmt() twice
Date: Sun,  3 May 2015 11:54:32 +0200
Message-Id: <1430646876-19594-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify ov5642_set_fmt().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/ov5642.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov5642.c b/drivers/media/i2c/soc_camera/ov5642.c
index bab9ac0..061fca3 100644
--- a/drivers/media/i2c/soc_camera/ov5642.c
+++ b/drivers/media/i2c/soc_camera/ov5642.c
@@ -804,14 +804,15 @@ static int ov5642_set_fmt(struct v4l2_subdev *sd,
 	if (!fmt) {
 		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 			return -EINVAL;
-		mf->code	= ov5642_colour_fmts[0].code;
-		mf->colorspace	= ov5642_colour_fmts[0].colorspace;
+		fmt = ov5642_colour_fmts;
+		mf->code = fmt->code;
+		mf->colorspace = fmt->colorspace;
 	}
 
 	mf->field	= V4L2_FIELD_NONE;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		priv->fmt = ov5642_find_datafmt(mf->code);
+		priv->fmt = fmt;
 	else
 		cfg->try_fmt = *mf;
 	return 0;
-- 
2.1.4

