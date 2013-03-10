Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34985 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3CJOMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:05 -0400
Received: by mail-la0-f52.google.com with SMTP id fs12so3019294lab.25
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:04 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 2/7] hverkuil/go7007: staging: media: go7007: Add Frameintervals
Date: Sun, 10 Mar 2013 18:04:41 +0400
Message-Id: <1362924286-23995-2-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |  123 ++++++++++++++++++++++++++++
 1 files changed, 123 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 4ec9b84..96538f6 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -703,6 +703,129 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 {
 	struct go7007 *go = video_drvdata(filp);
 
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		switch (fival->pixel_format) {
+		case V4L2_PIX_FMT_MJPEG:
+		case V4L2_PIX_FMT_MPEG:
+		case V4L2_PIX_FMT_H263:
+			switch (go->standard) {
+			case GO7007_STD_NTSC:
+				switch (fival->index) {
+				case 0:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*1;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 1:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*2;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 2:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*3;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 3:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*4;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 4:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*5;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 5:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*6;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 6:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*7;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 7:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*10;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 8:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*15;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 9:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*30;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				default:
+					return -EINVAL;
+				}
+				break;
+			case GO7007_STD_PAL:
+				switch (fival->index) {
+				case 0:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*1;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 1:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*2;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 2:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*3;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 3:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*4;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 4:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*5;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 5:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*6;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 6:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*8;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 7:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*13;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				case 8:
+					fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+					fival->discrete.numerator = 1001*25;
+					fival->discrete.denominator = go->sensor_framerate;
+					break;
+				default:
+					return -EINVAL;
+				}
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	}
+
 	if (fival->index > 0)
 		return -EINVAL;
 
-- 
1.7.7.6

