Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57481 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbbFOLeG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2015 07:34:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, william.towle@codethink.co.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 03/14] tw9910: don't use COLORSPACE_JPEG
Date: Mon, 15 Jun 2015 13:33:30 +0200
Message-Id: <1434368021-7467-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
References: <1434368021-7467-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is an SDTV video receiver, so the colorspace should be SMPTE170M.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/tw9910.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 42bec9b..df66417 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -711,7 +711,7 @@ static int tw9910_get_fmt(struct v4l2_subdev *sd,
 	mf->width	= priv->scale->width;
 	mf->height	= priv->scale->height;
 	mf->code	= MEDIA_BUS_FMT_UYVY8_2X8;
-	mf->colorspace	= V4L2_COLORSPACE_JPEG;
+	mf->colorspace	= V4L2_COLORSPACE_SMPTE170M;
 	mf->field	= V4L2_FIELD_INTERLACED_BT;
 
 	return 0;
@@ -732,7 +732,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 	if (mf->code != MEDIA_BUS_FMT_UYVY8_2X8)
 		return -EINVAL;
 
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	ret = tw9910_set_frame(sd, &width, &height);
 	if (!ret) {
@@ -762,7 +762,7 @@ static int tw9910_set_fmt(struct v4l2_subdev *sd,
 	}
 
 	mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	mf->colorspace = V4L2_COLORSPACE_JPEG;
+	mf->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	/*
 	 * select suitable norm
-- 
2.1.4

