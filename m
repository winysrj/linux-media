Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2373 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab3LJMLL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 07:11:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/6] ad9389b: verify EDID header
Date: Tue, 10 Dec 2013 13:08:49 +0100
Message-Id: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
In-Reply-To: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
References: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

Ignore EDIDs where the header is wrong.

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index b06a7e5..e7f7171 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -978,7 +978,7 @@ static bool edid_block_verify_crc(u8 *edid_block)
 	return sum == 0;
 }
 
-static bool edid_segment_verify_crc(struct v4l2_subdev *sd, u32 segment)
+static bool edid_verify_crc(struct v4l2_subdev *sd, u32 segment)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
 	u32 blocks = state->edid.blocks;
@@ -992,6 +992,25 @@ static bool edid_segment_verify_crc(struct v4l2_subdev *sd, u32 segment)
 	return false;
 }
 
+static bool edid_verify_header(struct v4l2_subdev *sd, u32 segment)
+{
+	static const u8 hdmi_header[] = {
+		0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
+	};
+	struct ad9389b_state *state = get_ad9389b_state(sd);
+	u8 *data = state->edid.data;
+	int i;
+
+	if (segment)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(hdmi_header); i++)
+		if (data[i] != hdmi_header[i])
+			return false;
+
+	return true;
+}
+
 static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 {
 	struct ad9389b_state *state = get_ad9389b_state(sd);
@@ -1019,9 +1038,10 @@ static bool ad9389b_check_edid_status(struct v4l2_subdev *sd)
 		v4l2_dbg(1, debug, sd, "%s: %d blocks in total\n",
 				__func__, state->edid.blocks);
 	}
-	if (!edid_segment_verify_crc(sd, segment)) {
+	if (!edid_verify_crc(sd, segment) ||
+			!edid_verify_header(sd, segment)) {
 		/* edid crc error, force reread of edid segment */
-		v4l2_err(sd, "%s: edid crc error\n", __func__);
+		v4l2_err(sd, "%s: edid crc or header error\n", __func__);
 		state->have_monitor = false;
 		ad9389b_s_power(sd, false);
 		ad9389b_s_power(sd, true);
-- 
1.8.4.rc3

