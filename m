Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3965 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966090Ab3E2OTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/14] vpx3220: fix querystd
Date: Wed, 29 May 2013 16:19:01 +0200
Message-Id: <1369837147-8747-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/vpx3220.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/vpx3220.c b/drivers/media/i2c/vpx3220.c
index f02e74b..02c1e39 100644
--- a/drivers/media/i2c/vpx3220.c
+++ b/drivers/media/i2c/vpx3220.c
@@ -297,7 +297,7 @@ static int vpx3220_init(struct v4l2_subdev *sd, u32 val)
 static int vpx3220_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pstd)
 {
 	int res = V4L2_IN_ST_NO_SIGNAL, status;
-	v4l2_std_id std = 0;
+	v4l2_std_id std = pstd ? *pstd : V4L2_STD_ALL;
 
 	status = vpx3220_fp_read(sd, 0x0f3);
 
@@ -314,19 +314,21 @@ static int vpx3220_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pst
 		case 0x10:
 		case 0x14:
 		case 0x18:
-			std = V4L2_STD_PAL;
+			std &= V4L2_STD_PAL;
 			break;
 
 		case 0x08:
-			std = V4L2_STD_SECAM;
+			std &= V4L2_STD_SECAM;
 			break;
 
 		case 0x04:
 		case 0x0c:
 		case 0x1c:
-			std = V4L2_STD_NTSC;
+			std &= V4L2_STD_NTSC;
 			break;
 		}
+	} else {
+		std = V4L2_STD_UNKNOWN;
 	}
 	if (pstd)
 		*pstd = std;
-- 
1.7.10.4

