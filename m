Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4102 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3LJPGL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 17/22] adv7842: support g_edid ioctl
Date: Tue, 10 Dec 2013 16:04:03 +0100
Message-Id: <115be90a1e319c457b63c9f33c5eda060062c5e6.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 8390b93..c3ac4e9 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -1908,6 +1908,46 @@ static int adv7842_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	return 0;
 }
 
+static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *edid)
+{
+	struct adv7842_state *state = to_state(sd);
+	u8 *data = NULL;
+
+	if (edid->pad > ADV7842_EDID_PORT_VGA)
+		return -EINVAL;
+	if (edid->blocks == 0)
+		return -EINVAL;
+	if (edid->blocks > 2)
+		return -EINVAL;
+	if (edid->start_block > 1)
+		return -EINVAL;
+	if (edid->start_block == 1)
+		edid->blocks = 1;
+	if (!edid->edid)
+		return -EINVAL;
+
+	switch (edid->pad) {
+	case ADV7842_EDID_PORT_A:
+	case ADV7842_EDID_PORT_B:
+		if (state->hdmi_edid.present & (0x04 << edid->pad))
+			data = state->hdmi_edid.edid;
+		break;
+	case ADV7842_EDID_PORT_VGA:
+		if (state->vga_edid.present)
+			data = state->vga_edid.edid;
+		break;
+	default:
+		return -EINVAL;
+	}
+	if (!data)
+		return -ENODATA;
+
+	memcpy(edid->edid,
+	       data + edid->start_block * 128,
+	       edid->blocks * 128);
+	return 0;
+}
+
 static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_subdev_edid *e)
 {
 	struct adv7842_state *state = to_state(sd);
@@ -2720,6 +2760,7 @@ static const struct v4l2_subdev_video_ops adv7842_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops adv7842_pad_ops = {
+	.get_edid = adv7842_get_edid,
 	.set_edid = adv7842_set_edid,
 };
 
-- 
1.8.4.rc3

