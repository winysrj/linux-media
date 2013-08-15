Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4484 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3HOLha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:37:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 07/12] ad9389b: trigger edid re-read by power-cycle chip
Date: Thu, 15 Aug 2013 13:36:29 +0200
Message-Id: <192e28b0f2ffbbc72d15872a31bec06d414437a6.1376566340.git.hans.verkuil@cisco.com>
In-Reply-To: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
References: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
References: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 52384e8..545aabb 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -855,8 +855,10 @@ static void ad9389b_edid_handler(struct work_struct *work)
 		 * (DVI connectors are particularly prone to this problem). */
 		if (state->edid.read_retries) {
 			state->edid.read_retries--;
-			/* EDID read failed, trigger a retry */
-			ad9389b_wr(sd, 0xc9, 0xf);
+			v4l2_dbg(1, debug, sd, "%s: edid read failed\n", __func__);
+			state->have_monitor = false;
+			ad9389b_s_power(sd, false);
+			ad9389b_s_power(sd, true);
 			queue_delayed_work(state->work_queue,
 					&state->edid_handler, EDID_DELAY);
 			return;
@@ -1019,7 +1021,6 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	segment = ad9389b_rd(sd, 0xc4);
 	if (segment >= EDID_MAX_SEGM) {
 		v4l2_err(sd, "edid segment number too big\n");
-		state->have_monitor = false;
 		return false;
 	}
 	v4l2_dbg(1, debug, sd, "%s: got segment %d\n", __func__, segment);
-- 
1.8.3.2

