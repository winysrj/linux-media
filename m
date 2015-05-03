Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:47334 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbbECJyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:54:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/9] imx074: don't call imx074_find_datafmt() twice
Date: Sun,  3 May 2015 11:54:28 +0200
Message-Id: <1430646876-19594-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify imx074_set_fmt().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f68c235..4226f06 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -171,8 +171,9 @@ static int imx074_set_fmt(struct v4l2_subdev *sd,
 		/* MIPI CSI could have changed the format, double-check */
 		if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 			return -EINVAL;
-		mf->code	= imx074_colour_fmts[0].code;
-		mf->colorspace	= imx074_colour_fmts[0].colorspace;
+		fmt = imx074_colour_fmts;
+		mf->code = fmt->code;
+		mf->colorspace = fmt->colorspace;
 	}
 
 	mf->width	= IMX074_WIDTH;
@@ -180,7 +181,7 @@ static int imx074_set_fmt(struct v4l2_subdev *sd,
 	mf->field	= V4L2_FIELD_NONE;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		priv->fmt = imx074_find_datafmt(mf->code);
+		priv->fmt = fmt;
 	else
 		cfg->try_fmt = *mf;
 
-- 
2.1.4

