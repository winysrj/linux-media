Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2688 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965635Ab3E2OT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 04/14] saa7110: fix querystd
Date: Wed, 29 May 2013 16:18:57 +0200
Message-Id: <1369837147-8747-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Return V4L2_STD_UNKNOWN if no signal is detected.
Otherwise AND the standard mask with the detected standards.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7110.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/saa7110.c b/drivers/media/i2c/saa7110.c
index e4026aa..5480a18 100644
--- a/drivers/media/i2c/saa7110.c
+++ b/drivers/media/i2c/saa7110.c
@@ -203,7 +203,7 @@ static v4l2_std_id determine_norm(struct v4l2_subdev *sd)
 	status = saa7110_read(sd);
 	if (status & 0x40) {
 		v4l2_dbg(1, debug, sd, "status=0x%02x (no signal)\n", status);
-		return decoder->norm;	/* no change*/
+		return V4L2_STD_UNKNOWN;
 	}
 	if ((status & 3) == 0) {
 		saa7110_write(sd, 0x06, 0x83);
@@ -265,7 +265,7 @@ static int saa7110_g_input_status(struct v4l2_subdev *sd, u32 *pstatus)
 
 static int saa7110_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
-	*(v4l2_std_id *)std = determine_norm(sd);
+	*std &= determine_norm(sd);
 	return 0;
 }
 
-- 
1.7.10.4

