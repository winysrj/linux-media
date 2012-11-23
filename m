Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64596 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2KWPXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 10:23:00 -0500
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDY00HL75EQWY70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:23:14 +0000 (GMT)
Received: from AMDC1061.digital.local ([106.116.147.88])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDY003BI5DXCUB0@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Nov 2012 15:22:58 +0000 (GMT)
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>
Subject: [PATCH RFC 2/3] s5p-fimc: add support for sensors with multiple pads
Date: Fri, 23 Nov 2012 16:22:29 +0100
Message-id: <1353684150-24581-3-git-send-email-a.hajda@samsung.com>
In-reply-to: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
References: <1353684150-24581-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some sensors can have more than one pad (case of S5C73M3).
In such cases FIMC assumes the last pad of the sensor is the source pad.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-capture.c |    6 ++++--
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-capture.c b/drivers/media/platform/s5p-fimc/fimc-capture.c
index 3d39d97..3acbea3 100644
--- a/drivers/media/platform/s5p-fimc/fimc-capture.c
+++ b/drivers/media/platform/s5p-fimc/fimc-capture.c
@@ -885,14 +885,16 @@ static int fimc_get_sensor_frame_desc(struct v4l2_subdev *sensor,
 {
 	struct v4l2_mbus_frame_desc fd;
 	int i, ret;
+	int pad;
 
 	for (i = 0; i < num_planes; i++)
 		fd.entry[i].length = plane_fmt[i].sizeimage;
 
+	pad = sensor->entity.num_pads - 1;
 	if (try)
-		ret = v4l2_subdev_call(sensor, pad, set_frame_desc, 0, &fd);
+		ret = v4l2_subdev_call(sensor, pad, set_frame_desc, pad, &fd);
 	else
-		ret = v4l2_subdev_call(sensor, pad, get_frame_desc, 0, &fd);
+		ret = v4l2_subdev_call(sensor, pad, get_frame_desc, pad, &fd);
 
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index a69f053..0a6d23c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -660,7 +660,8 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 				 "but s5p-csis module is not loaded!\n"))
 				return -EINVAL;
 
-			ret = media_entity_create_link(&sensor->entity, 0,
+			pad = sensor->entity.num_pads - 1;
+			ret = media_entity_create_link(&sensor->entity, pad,
 					      &csis->entity, CSIS_PAD_SINK,
 					      MEDIA_LNK_FL_IMMUTABLE |
 					      MEDIA_LNK_FL_ENABLED);
-- 
1.7.10.4

