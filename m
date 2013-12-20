Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3475 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab3LTJb6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:31:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/50] adv7511: verify EDID header
Date: Fri, 20 Dec 2013 10:31:00 +0100
Message-Id: <1387531903-20496-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Ignore EDID's where the header is wrong.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index f20450c..ee61894 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -965,26 +965,38 @@ static void adv7511_check_monitor_present_status(struct v4l2_subdev *sd)
 
 static bool edid_block_verify_crc(uint8_t *edid_block)
 {
-	int i;
 	uint8_t sum = 0;
+	int i;
 
 	for (i = 0; i < 128; i++)
-		sum += *(edid_block + i);
-	return (sum == 0);
+		sum += edid_block[i];
+	return sum == 0;
 }
 
-static bool edid_segment_verify_crc(struct v4l2_subdev *sd, u32 segment)
+static bool edid_verify_crc(struct v4l2_subdev *sd, u32 segment)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	u32 blocks = state->edid.blocks;
 	uint8_t *data = state->edid.data;
 
-	if (edid_block_verify_crc(&data[segment * 256])) {
-		if ((segment + 1) * 2 <= blocks)
-			return edid_block_verify_crc(&data[segment * 256 + 128]);
+	if (!edid_block_verify_crc(&data[segment * 256]))
+		return false;
+	if ((segment + 1) * 2 <= blocks)
+		return edid_block_verify_crc(&data[segment * 256 + 128]);
+	return true;
+}
+
+static bool edid_verify_header(struct v4l2_subdev *sd, u32 segment)
+{
+	static const u8 hdmi_header[] = {
+		0x00, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00
+	};
+	struct adv7511_state *state = get_adv7511_state(sd);
+	u8 *data = state->edid.data;
+
+	if (segment != 0)
 		return true;
-	}
-	return false;
+	return !memcmp(data, hdmi_header, sizeof(hdmi_header));
 }
 
 static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
@@ -1013,9 +1025,10 @@ static bool adv7511_check_edid_status(struct v4l2_subdev *sd)
 			state->edid.blocks = state->edid.data[0x7e] + 1;
 			v4l2_dbg(1, debug, sd, "%s: %d blocks in total\n", __func__, state->edid.blocks);
 		}
-		if (!edid_segment_verify_crc(sd, segment)) {
+		if (!edid_verify_crc(sd, segment) ||
+		    !edid_verify_header(sd, segment)) {
 			/* edid crc error, force reread of edid segment */
-			v4l2_dbg(1, debug, sd, "%s: edid crc error\n", __func__);
+			v4l2_err(sd, "%s: edid crc or header error\n", __func__);
 			state->have_monitor = false;
 			adv7511_s_power(sd, false);
 			adv7511_s_power(sd, true);
-- 
1.8.4.4

