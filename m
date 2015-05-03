Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:39772 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858AbbECJzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 May 2015 05:55:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 9/9] mt9t112: initialize left and top
Date: Sun,  3 May 2015 11:54:36 +0200
Message-Id: <1430646876-19594-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
References: <1430646876-19594-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The left and top variables were uninitialized, leading to unexpected
results.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/mt9t112.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index de10a76..02190d6 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -952,7 +952,8 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
-	unsigned int top, left;
+	unsigned int top = priv->frame.top;
+	unsigned int left = priv->frame.left;
 	int i;
 
 	if (format->pad)
-- 
2.1.4

