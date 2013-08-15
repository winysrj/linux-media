Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3530 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3HOLh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Aug 2013 07:37:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 06/12] ad9389b: no monitor if EDID is wrong
Date: Thu, 15 Aug 2013 13:36:28 +0200
Message-Id: <ce9901a4cc81c7ff59aac7fcc0c963003c5ad84e.1376566340.git.hans.verkuil@cisco.com>
In-Reply-To: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
References: <1376566594-427-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
References: <b1134caad54251cdfc8191a446a160ecc986f9b9.1376566340.git.hans.verkuil@cisco.com>
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

