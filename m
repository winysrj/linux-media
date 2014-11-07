Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39801 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285AbaKGMfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 07:35:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jean-michel.hautbois@vodalys.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/3] adv7842: fix G/S_EDID behavior
Date: Fri,  7 Nov 2014 13:34:55 +0100
Message-Id: <1415363697-32583-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
References: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make this pass the v4l2-compliance test.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 48b628b..bed0586 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2028,16 +2028,7 @@ static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	struct adv7842_state *state = to_state(sd);
 	u8 *data = NULL;
 
-	if (edid->pad > ADV7842_EDID_PORT_VGA)
-		return -EINVAL;
-	if (edid->blocks == 0)
-		return -EINVAL;
-	if (edid->blocks > 2)
-		return -EINVAL;
-	if (edid->start_block > 1)
-		return -EINVAL;
-	if (edid->start_block == 1)
-		edid->blocks = 1;
+	memset(edid->reserved, 0, sizeof(edid->reserved));
 
 	switch (edid->pad) {
 	case ADV7842_EDID_PORT_A:
@@ -2052,12 +2043,23 @@ static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	default:
 		return -EINVAL;
 	}
+
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = data ? 2 : 0;
+		return 0;
+	}
+
 	if (!data)
 		return -ENODATA;
 
-	memcpy(edid->edid,
-	       data + edid->start_block * 128,
-	       edid->blocks * 128);
+	if (edid->start_block >= 2)
+		return -EINVAL;
+
+	if (edid->start_block + edid->blocks > 2)
+		edid->blocks = 2 - edid->start_block;
+
+	memcpy(edid->edid, data + edid->start_block * 128, edid->blocks * 128);
+
 	return 0;
 }
 
@@ -2066,12 +2068,16 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
 	struct adv7842_state *state = to_state(sd);
 	int err = 0;
 
+	memset(e->reserved, 0, sizeof(e->reserved));
+
 	if (e->pad > ADV7842_EDID_PORT_VGA)
 		return -EINVAL;
 	if (e->start_block != 0)
 		return -EINVAL;
-	if (e->blocks > 2)
+	if (e->blocks > 2) {
+		e->blocks = 2;
 		return -E2BIG;
+	}
 
 	/* todo, per edid */
 	state->aspect_ratio = v4l2_calc_aspect_ratio(e->edid[0x15],
-- 
2.1.1

