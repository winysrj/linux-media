Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2091 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3LJPGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 10:06:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 15/22] adv7842: clear edid, if no edid just disable Edid-DDC access
Date: Tue, 10 Dec 2013 16:04:01 +0100
Message-Id: <4fe2b952f8c407e5dc316493864e1d4c980975ae.1386687810.git.hans.verkuil@cisco.com>
In-Reply-To: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
References: <0b624eb4cc9c2b7c88323771dca10c503785fcb7.1386687810.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index 943e578..bff8314 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -700,6 +700,9 @@ static int edid_write_hdmi_segment(struct v4l2_subdev *sd, u8 port)
 	/* Disable I2C access to internal EDID ram from HDMI DDC ports */
 	rep_write_and_or(sd, 0x77, 0xf3, 0x00);
 
+	if (!state->hdmi_edid.present)
+		return 0;
+
 	/* edid segment pointer '0' for HDMI ports */
 	rep_write_and_or(sd, 0x77, 0xef, 0x00);
 
@@ -2636,8 +2639,8 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 	adv7842_s_dv_timings(sd, &state->timings);
 
 	edid_write_vga_segment(sd);
-	edid_write_hdmi_segment(sd, 0);
-	edid_write_hdmi_segment(sd, 1);
+	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_A);
+	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_B);
 
 	return ret;
 }
-- 
1.8.4.rc3

