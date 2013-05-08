Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4.epfl.ch ([128.178.224.219]:45881 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754169Ab3EHMGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 May 2013 08:06:25 -0400
From: =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 1/1] mt9t031: Fix panic on probe
Date: Wed,  8 May 2013 13:58:54 +0200
Message-Id: <1368014334-23680-1-git-send-email-philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The video device is not yet valid when probe() is called.
Call directly soc_camera_power_on/off() instead of calling mt9t031_s_power().

Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
---
 drivers/media/i2c/soc_camera/mt9t031.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
index d80d044..71c0b16 100644
--- a/drivers/media/i2c/soc_camera/mt9t031.c
+++ b/drivers/media/i2c/soc_camera/mt9t031.c
@@ -632,10 +632,11 @@ static int mt9t031_s_power(struct v4l2_subdev *sd, int on)
 static int mt9t031_video_probe(struct i2c_client *client)
 {
 	struct mt9t031 *mt9t031 = to_mt9t031(client);
+	struct soc_camera_subdev_desc *ssdd = soc_camera_i2c_to_desc(client);
 	s32 data;
 	int ret;
 
-	ret = mt9t031_s_power(&mt9t031->subdev, 1);
+	ret = soc_camera_power_on(&client->dev, ssdd);
 	if (ret < 0)
 		return ret;
 
@@ -664,7 +665,7 @@ static int mt9t031_video_probe(struct i2c_client *client)
 	ret = v4l2_ctrl_handler_setup(&mt9t031->hdl);
 
 done:
-	mt9t031_s_power(&mt9t031->subdev, 0);
+	soc_camera_power_off(&client->dev, ssdd);
 
 	return ret;
 }
-- 
1.7.9.5

