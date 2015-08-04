Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:34556 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbHDKp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Aug 2015 06:45:56 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Josh Wu <josh.wu@atmel.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] media: soc-camera: increase the length of clk_name on soc_of_bind()
Date: Tue, 4 Aug 2015 18:51:09 +0800
Message-ID: <1438685469-12230-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since in soc_of_bind() it may use the of node's full name as the clk_name,
and this full name may be longer than 32 characters, take at91 i2c sensor
as an example, length is 34 bytes:
   /ahb/apb/i2c@f8028000/camera@0x30

So this patch increase the clk_name[] array size to 64. It seems big
enough so far.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---

 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d708df4..fcf3e97 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1621,7 +1621,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	struct soc_camera_async_client *sasc;
 	struct soc_of_info *info;
 	struct i2c_client *client;
-	char clk_name[V4L2_SUBDEV_NAME_SIZE];
+	char clk_name[V4L2_SUBDEV_NAME_SIZE + 32];
 	int ret;
 
 	/* allocate a new subdev and add match info to it */
-- 
1.9.1

