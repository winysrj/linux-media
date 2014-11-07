Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:39754 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbaKGMfG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Nov 2014 07:35:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: jean-michel.hautbois@vodalys.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/3] adv7511: fix G/S_EDID behavior
Date: Fri,  7 Nov 2014 13:34:56 +0100
Message-Id: <1415363697-32583-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
References: <1415363697-32583-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fixes the v4l2-compliance failures.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index f98acf4..8acc8c5 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -779,21 +779,28 @@ static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
 	if (edid->pad != 0)
 		return -EINVAL;
-	if ((edid->blocks == 0) || (edid->blocks > 256))
-		return -EINVAL;
-	if (!state->edid.segments) {
-		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
-		return -ENODATA;
+
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = state->edid.segments * 2;
+		return 0;
 	}
+
+	if (state->edid.segments == 0)
+		return -ENODATA;
+
 	if (edid->start_block >= state->edid.segments * 2)
-		return -E2BIG;
-	if ((edid->blocks + edid->start_block) >= state->edid.segments * 2)
+		return -EINVAL;
+
+	if (edid->start_block + edid->blocks > state->edid.segments * 2)
 		edid->blocks = state->edid.segments * 2 - edid->start_block;
 
 	memcpy(edid->edid, &state->edid.data[edid->start_block * 128],
 			128 * edid->blocks);
+
 	return 0;
 }
 
-- 
2.1.1

