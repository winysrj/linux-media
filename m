Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:29150 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3GYMkk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 08:40:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] soc_camera: fix compiler warning
Date: Thu, 25 Jul 2013 14:40:34 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307251440.34496.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


media_build/v4l/soc_camera.c: In function 'soc_camera_host_register':
media_build/v4l/soc_camera.c:1513:10: warning: 'sasd' may be used uninitialized in this function [-Wmaybe-uninitialized]
  snprintf(clk_name, sizeof(clk_name), "%d-%04x",
          ^
media_build/v4l/soc_camera.c:1464:34: note: 'sasd' was declared here
  struct soc_camera_async_subdev *sasd;
                                  ^

By changing the type of 'i' to unsigned and changing a condition we finally
convince the compiler that sasd is really initialized.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 2dd0e52..ed7a99f 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1466,7 +1466,8 @@ static int scan_async_group(struct soc_camera_host *ici,
 	struct soc_camera_device *icd;
 	struct soc_camera_desc sdesc = {.host_desc.bus_id = ici->nr,};
 	char clk_name[V4L2_SUBDEV_NAME_SIZE];
-	int ret, i;
+	unsigned int i;
+	int ret;
 
 	/* First look for a sensor */
 	for (i = 0; i < size; i++) {
@@ -1475,7 +1476,7 @@ static int scan_async_group(struct soc_camera_host *ici,
 			break;
 	}
 
-	if (i == size || asd[i]->bus_type != V4L2_ASYNC_BUS_I2C) {
+	if (i >= size || asd[i]->bus_type != V4L2_ASYNC_BUS_I2C) {
 		/* All useless */
 		dev_err(ici->v4l2_dev.dev, "No I2C data source found!\n");
 		return -ENODEV;
-- 
1.8.3.2

