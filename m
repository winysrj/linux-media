Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4376 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3HSOoq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 10:44:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: marbugge@cisco.com, matrandg@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/20] ad9389b: no monitor if EDID is wrong
Date: Mon, 19 Aug 2013 16:44:15 +0200
Message-Id: <1376923469-30694-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
References: <1376923469-30694-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

state->have_monitor is set to false if the EDID that is read from
the monitor has too many segments or wrong CRC.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index 7e68d8f..52384e8 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -1019,6 +1019,7 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	segment = ad9389b_rd(sd, 0xc4);
 	if (segment >= EDID_MAX_SEGM) {
 		v4l2_err(sd, "edid segment number too big\n");
+		state->have_monitor = false;
 		return false;
 	}
 	v4l2_dbg(1, debug, sd, "%s: got segment %d\n", __func__, segment);
@@ -1032,6 +1033,8 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 	}
 	if (!edid_segment_verify_crc(sd, segment)) {
 		/* edid crc error, force reread of edid segment */
+		v4l2_err(sd, "%s: edid crc error\n", __func__);
+		state->have_monitor = false;
 		ad9389b_s_power(sd, false);
 		ad9389b_s_power(sd, true);
 		return false;
-- 
1.8.3.2

