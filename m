Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49755 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3CJOMB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:01 -0400
Received: by mail-lb0-f180.google.com with SMTP id q12so2434777lbc.25
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:00 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 1/7] hverkuil/go7007: staging: media: go7007: Add Framesizes
Date: Sun, 10 Mar 2013 18:04:40 +0400
Message-Id: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   76 ++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 66307ea..4ec9b84 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -612,6 +612,82 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 {
 	struct go7007 *go = video_drvdata(filp);
 
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		switch (go->standard) {
+		case GO7007_STD_NTSC:
+			switch (fsize->pixel_format) {
+			case V4L2_PIX_FMT_MJPEG:
+			case V4L2_PIX_FMT_MPEG:
+			case V4L2_PIX_FMT_H263:
+				switch (fsize->index) {
+				case 0:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 720;
+					fsize->discrete.height = 480;
+					break;
+				case 1:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 640;
+					fsize->discrete.height = 480;
+					break;
+				case 2:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 352;
+					fsize->discrete.height = 240;
+					break;
+				case 3:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 320;
+					fsize->discrete.height = 240;
+					break;
+				case 4:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 176;
+					fsize->discrete.height = 112;
+					break;
+				default:
+					return -EINVAL;
+				}
+				break;
+			default:
+				return -EINVAL;
+			}
+			break;
+		case GO7007_STD_PAL:
+			switch (fsize->pixel_format) {
+			case V4L2_PIX_FMT_MJPEG:
+			case V4L2_PIX_FMT_MPEG:
+			case V4L2_PIX_FMT_H263:
+				switch (fsize->index) {
+				case 0:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 720;
+					fsize->discrete.height = 576;
+					break;
+				case 1:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 352;
+					fsize->discrete.height = 288;
+					break;
+				case 2:
+					fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+					fsize->discrete.width = 176;
+					fsize->discrete.height = 144;
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
 	if (fsize->index > 0)
 		return -EINVAL;
 
-- 
1.7.7.6

