Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44326 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbbD0HaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 03:30:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 2/5] s3c-camif: fix compiler warnings
Date: Mon, 27 Apr 2015 09:29:52 +0200
Message-Id: <1430119795-16527-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
References: <1430119795-16527-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fix these compiler warnings that appeared after switching to gcc-5.1.0:

drivers/media/platform/s3c-camif/camif-capture.c: In function 'sensor_set_power':
drivers/media/platform/s3c-camif/camif-capture.c:118:10: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  if (!on == camif->sensor.power_count)
          ^
drivers/media/platform/s3c-camif/camif-capture.c: In function 'sensor_set_streaming':
drivers/media/platform/s3c-camif/camif-capture.c:134:10: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]
  if (!on == camif->sensor.stream_count)
          ^

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/platform/s3c-camif/camif-capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index f6a61b9..db4d7d2 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -115,7 +115,7 @@ static int sensor_set_power(struct camif_dev *camif, int on)
 	struct cam_sensor *sensor = &camif->sensor;
 	int err = 0;
 
-	if (!on == camif->sensor.power_count)
+	if (camif->sensor.power_count == !on)
 		err = v4l2_subdev_call(sensor->sd, core, s_power, on);
 	if (!err)
 		sensor->power_count += on ? 1 : -1;
@@ -131,7 +131,7 @@ static int sensor_set_streaming(struct camif_dev *camif, int on)
 	struct cam_sensor *sensor = &camif->sensor;
 	int err = 0;
 
-	if (!on == camif->sensor.stream_count)
+	if (camif->sensor.stream_count == !on)
 		err = v4l2_subdev_call(sensor->sd, video, s_stream, on);
 	if (!err)
 		sensor->stream_count += on ? 1 : -1;
-- 
2.1.4

