Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4595 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965572Ab3E2OT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/14] ks0127: fix querystd
Date: Wed, 29 May 2013 16:18:56 +0200
Message-Id: <1369837147-8747-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ks0127.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ks0127.c b/drivers/media/i2c/ks0127.c
index c722776..f7250e5 100644
--- a/drivers/media/i2c/ks0127.c
+++ b/drivers/media/i2c/ks0127.c
@@ -616,17 +616,24 @@ static int ks0127_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pstd
 {
 	int stat = V4L2_IN_ST_NO_SIGNAL;
 	u8 status;
-	v4l2_std_id std = V4L2_STD_ALL;
+	v4l2_std_id std = pstd ? *pstd : V4L2_STD_ALL;
 
 	status = ks0127_read(sd, KS_STAT);
 	if (!(status & 0x20))		 /* NOVID not set */
 		stat = 0;
-	if (!(status & 0x01))		      /* CLOCK set */
+	if (!(status & 0x01)) {		      /* CLOCK set */
 		stat |= V4L2_IN_ST_NO_COLOR;
-	if ((status & 0x08))		   /* PALDET set */
-		std = V4L2_STD_PAL;
+		std = V4L2_STD_UNKNOWN;
+	} else {
+		if ((status & 0x08))		   /* PALDET set */
+			std &= V4L2_STD_PAL;
+		else
+			std &= V4L2_STD_NTSC;
+	}
+	if ((status & 0x10))		   /* PALDET set */
+		std &= V4L2_STD_525_60;
 	else
-		std = V4L2_STD_NTSC;
+		std &= V4L2_STD_625_50;
 	if (pstd)
 		*pstd = std;
 	if (pstatus)
-- 
1.7.10.4

