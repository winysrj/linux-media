Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2259 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab3LJMLP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 07:11:15 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/6] adv7511: add VIC and audio CTS/N values to log_status
Date: Tue, 10 Dec 2013 13:08:54 +0100
Message-Id: <9e6b2a84d52136da9f7f8ec66186e659de5a0230.1386677238.git.hans.verkuil@cisco.com>
In-Reply-To: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
References: <1386677334-20953-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
References: <5857a9bc34d88ef46d61c9d25d11117ac874afc4.1386677238.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Improve status logging.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7511.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 89ea266..f20450c 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -452,6 +452,29 @@ static int adv7511_log_status(struct v4l2_subdev *sd)
 			  errors[adv7511_rd(sd, 0xc8) >> 4], state->edid_detect_counter,
 			  adv7511_rd(sd, 0x94), adv7511_rd(sd, 0x96));
 	v4l2_info(sd, "RGB quantization: %s range\n", adv7511_rd(sd, 0x18) & 0x80 ? "limited" : "full");
+	if (adv7511_rd(sd, 0xaf) & 0x02) {
+		/* HDMI only */
+		u8 manual_cts = adv7511_rd(sd, 0x0a) & 0x80;
+		u32 N = (adv7511_rd(sd, 0x01) & 0xf) << 16 |
+			adv7511_rd(sd, 0x02) << 8 |
+			adv7511_rd(sd, 0x03);
+		u8 vic_detect = adv7511_rd(sd, 0x3e) >> 2;
+		u8 vic_sent = adv7511_rd(sd, 0x3d) & 0x3f;
+		u32 CTS;
+
+		if (manual_cts)
+			CTS = (adv7511_rd(sd, 0x07) & 0xf) << 16 |
+			      adv7511_rd(sd, 0x08) << 8 |
+			      adv7511_rd(sd, 0x09);
+		else
+			CTS = (adv7511_rd(sd, 0x04) & 0xf) << 16 |
+			      adv7511_rd(sd, 0x05) << 8 |
+			      adv7511_rd(sd, 0x06);
+		v4l2_info(sd, "CTS %s mode: N %d, CTS %d\n",
+			  manual_cts ? "manual" : "automatic", N, CTS);
+		v4l2_info(sd, "VIC: detected %d, sent %d\n",
+			  vic_detect, vic_sent);
+	}
 	if (state->dv_timings.type == V4L2_DV_BT_656_1120)
 		v4l2_print_dv_timings(sd->name, "timings: ",
 				&state->dv_timings, false);
-- 
1.8.4.rc3

