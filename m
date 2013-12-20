Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2812 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3LTJcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 39/50] adv7842: clear edid, if no edid just disable Edid-DDC access
Date: Fri, 20 Dec 2013 10:31:32 +0100
Message-Id: <1387531903-20496-40-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
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
index bbd80ac..eab9a1b 100644
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
 
@@ -2638,8 +2641,8 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 	adv7842_s_dv_timings(sd, &state->timings);
 
 	edid_write_vga_segment(sd);
-	edid_write_hdmi_segment(sd, 0);
-	edid_write_hdmi_segment(sd, 1);
+	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_A);
+	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_B);
 
 	return ret;
 }
-- 
1.8.4.4

