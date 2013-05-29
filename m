Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2393 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701Ab3E2LBM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCHv1 34/38] media/i2c: fill in missing reg->size fields.
Date: Wed, 29 May 2013 13:00:07 +0200
Message-Id: <1369825211-29770-35-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/i2c/ak881x.c             |    1 +
 drivers/media/i2c/soc_camera/mt9t031.c |    1 +
 drivers/media/i2c/soc_camera/tw9910.c  |    1 +
 drivers/media/i2c/tvp7002.c            |    1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ak881x.c b/drivers/media/i2c/ak881x.c
index fcd8a3f..c14e667 100644
--- a/drivers/media/i2c/ak881x.c
+++ b/drivers/media/i2c/ak881x.c
@@ -69,6 +69,7 @@ static int ak881x_g_register(struct v4l2_subdev *sd,
 	if (reg->reg > 0x26)
 		return -EINVAL;
 
+	reg->size = 1;
 	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index 1d2cc27..8f71c9a 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -398,6 +398,7 @@ static int mt9t031_g_register(struct v4l2_subdev *sd,
 	if (reg->reg > 0xff)
 		return -EINVAL;
 
+	reg->size = 1;
 	reg->val = reg_read(client, reg->reg);
 
 	if (reg->val > 0xffff)
diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index 8a2ac24..b5407df 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -527,6 +527,7 @@ static int tw9910_g_register(struct v4l2_subdev *sd,
 	if (reg->reg > 0xff)
 		return -EINVAL;
 
+	reg->size = 1;
 	ret = i2c_smbus_read_byte_data(client, reg->reg);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index c2d0280..36ad565 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -722,6 +722,7 @@ static int tvp7002_g_register(struct v4l2_subdev *sd,
 
 	ret = tvp7002_read(sd, reg->reg & 0xff, &val);
 	reg->val = val;
+	reg->size = 1;
 	return ret;
 }
 
-- 
1.7.10.4

