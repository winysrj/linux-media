Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2147 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965648Ab3E2OT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/14] bt819: fix querystd
Date: Wed, 29 May 2013 16:18:55 +0200
Message-Id: <1369837147-8747-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/bt819.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/bt819.c b/drivers/media/i2c/bt819.c
index ee9ed67..3c0a5ab 100644
--- a/drivers/media/i2c/bt819.c
+++ b/drivers/media/i2c/bt819.c
@@ -217,15 +217,17 @@ static int bt819_status(struct v4l2_subdev *sd, u32 *pstatus, v4l2_std_id *pstd)
 	struct bt819 *decoder = to_bt819(sd);
 	int status = bt819_read(decoder, 0x00);
 	int res = V4L2_IN_ST_NO_SIGNAL;
-	v4l2_std_id std;
+	v4l2_std_id std = pstd ? *pstd : V4L2_STD_ALL;
 
 	if ((status & 0x80))
 		res = 0;
+	else
+		std = V4L2_STD_UNKNOWN;
 
 	if ((status & 0x10))
-		std = V4L2_STD_PAL;
+		std &= V4L2_STD_PAL;
 	else
-		std = V4L2_STD_NTSC;
+		std &= V4L2_STD_NTSC;
 	if (pstd)
 		*pstd = std;
 	if (pstatus)
-- 
1.7.10.4

