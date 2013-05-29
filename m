Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2742 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966014Ab3E2OTf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/14] saa7115: fix querystd
Date: Wed, 29 May 2013 16:18:58 +0200
Message-Id: <1369837147-8747-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7115.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 18cf0bf..e247fdd 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1420,6 +1420,7 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 			*std &= V4L2_STD_SECAM;
 			break;
 		default:
+			*std = V4L2_STD_UNKNOWN;
 			/* Can't detect anything */
 			break;
 		}
@@ -1428,8 +1429,10 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	v4l2_dbg(1, debug, sd, "Status byte 2 (0x1f)=0x%02x\n", reg1f);
 
 	/* horizontal/vertical not locked */
-	if (reg1f & 0x40)
+	if (reg1f & 0x40) {
+		*std = V4L2_STD_UNKNOWN;
 		goto ret;
+	}
 
 	if (reg1f & 0x20)
 		*std &= V4L2_STD_525_60;
-- 
1.7.10.4

