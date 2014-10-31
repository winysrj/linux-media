Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:40587 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaJaRHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 13:07:31 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so1861321wib.7
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 10:07:30 -0700 (PDT)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hverkuil@xs4all.nl,
	m.chehab@samsung.com,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: adv7604: Correct G/S_EDID behaviour
Date: Fri, 31 Oct 2014 18:06:59 +0100
Message-Id: <1414775219-27127-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to have v4l2-compliance tool pass the G/S_EDID some modifications
where needed in the driver.
In particular, the edid.reserved zone must be blanked.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 47795ff..0848ee7 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1997,16 +1997,23 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	struct adv7604_state *state = to_state(sd);
 	u8 *data = NULL;
 
+	memset(edid->reserved, 0, sizeof(edid->reserved));
 	if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
 		return -EINVAL;
-	if (edid->blocks == 0)
-		return -EINVAL;
-	if (edid->blocks > 2)
-		return -EINVAL;
-	if (edid->start_block > 1)
+
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = state->edid.blocks;
+		return 0;
+	}
+
+	if (state->edid.blocks == 0)
+		return -ENODATA;
+
+	if (edid->start_block >= state->edid.blocks)
 		return -EINVAL;
-	if (edid->start_block == 1)
-		edid->blocks = 1;
+
+	if (edid->start_block + edid->blocks > state->edid.blocks)
+		edid->blocks = state->edid.blocks - edid->start_block;
 
 	if (edid->blocks > state->edid.blocks)
 		edid->blocks = state->edid.blocks;
@@ -2068,6 +2075,8 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 	int err;
 	int i;
 
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
 	if (edid->pad > ADV7604_PAD_HDMI_PORT_D)
 		return -EINVAL;
 	if (edid->start_block != 0)
@@ -2164,7 +2173,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return -EIO;
 	}
 
-
 	/* enable hotplug after 100 ms */
 	queue_delayed_work(state->work_queues,
 			&state->delayed_work_enable_hotplug, HZ / 10);
-- 
2.1.2

