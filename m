Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2476 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3HSOor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/20] adv7604: corrected edid crc-calculation
Date: Mon, 19 Aug 2013 16:44:17 +0200
Message-Id: <1376923469-30694-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Reviewed-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 545aabb..d78fd3d 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -983,12 +983,12 @@ static void ad9389b_check_monitor_present_status(struct v4l2_subdev *sd)
 
 static bool edid_block_verify_crc(u8 *edid_block)
 {
-	int i;
 	u8 sum = 0;
+	int i;
 
-	for (i = 0; i < 127; i++)
-		sum += *(edid_block + i);
-	return ((255 - sum + 1) == edid_block[127]);
+	for (i = 0; i < 128; i++)
+		sum += edid_block[i];
+	return sum == 0;
 }
 
 static bool edid_segment_verify_crc(struct v4l2_subdev *sd, u32 segment)
-- 
1.8.3.2

