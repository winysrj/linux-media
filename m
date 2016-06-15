Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35070 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbcFOWbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 18:31:07 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee.jones@linaro.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 3/3] media: i2c/soc_camera: fix ov6650 sensor getting wrong clock
Date: Thu, 16 Jun 2016 00:29:50 +0200
Message-Id: <1466029790-31094-4-git-send-email-jmkrzyszt@gmail.com>
In-Reply-To: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
References: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After changes to v4l2_clk API introduced in v4.1 by commits a37462b919
'[media] V4L: remove clock name from v4l2_clk API' and 4f528afcfb
'[media] V4L: add CCF support to the v4l2_clk API', ov6650 sensor
stopped responding because v4l2_clk_get(), still called with
depreciated V4L2 clock name "mclk", started to return respective CCF
clock instead of the V4l2 one registered by soc_camera. Fix it by
calling v4l2_clk_get() with NULL clock name.

Created and tested on Amstrad Delta against Linux-4.7-rc3 with
omap1_camera fixes.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
---
 drivers/media/i2c/soc_camera/ov6650.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 1f8af1e..1e4783b 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -1033,7 +1033,7 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
-	priv->clk = v4l2_clk_get(&client->dev, "mclk");
+	priv->clk = v4l2_clk_get(&client->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		ret = PTR_ERR(priv->clk);
 		goto eclkget;
-- 
2.7.3

