Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:51824 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751344AbbEDK0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 May 2015 06:26:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/8] imx074: don't call imx074_find_datafmt() twice
Date: Mon,  4 May 2015 12:25:48 +0200
Message-Id: <1430735155-24110-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430735155-24110-1-git-send-email-hverkuil@xs4all.nl>
References: <1430735155-24110-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify imx074_set_fmt().

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/soc_camera/imx074.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/imx074.c b/drivers/media/i2c/soc_camera/imx074.c
index f68c235..dabfa3f 100644
--- a/drivers/media/i2c/soc_camera/imx074.c
+++ b/drivers/media/i2c/soc_camera/imx074.c
@@ -180,7 +180,7 @@ static int imx074_set_fmt(struct v4l2_subdev *sd,
 	mf->field	= V4L2_FIELD_NONE;
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		priv->fmt = imx074_find_datafmt(mf->code);
+		priv->fmt = fmt;
 	else
 		cfg->try_fmt = *mf;
 
-- 
2.1.4

