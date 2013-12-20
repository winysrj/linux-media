Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4118 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3LTJcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 04:32:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 44/50] adv7842: composite sd-ram test, clear timings before setting.
Date: Fri, 20 Dec 2013 10:31:37 +0100
Message-Id: <1387531903-20496-45-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
References: <1387531903-20496-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Martin Bugge <marbugge@cisco.com>

Must clear timings before setting after test to recover.

Signed-off-by: Martin Bugge <marbugge@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7842.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index e6932f4..ecbe3f2 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2696,6 +2696,7 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct adv7842_state *state = to_state(sd);
 	struct adv7842_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_dv_timings timings;
 	int ret = 0;
 
 	if (!pdata)
@@ -2726,12 +2727,16 @@ static int adv7842_command_ram_test(struct v4l2_subdev *sd)
 
 	enable_input(sd);
 
-	adv7842_s_dv_timings(sd, &state->timings);
-
 	edid_write_vga_segment(sd);
 	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_A);
 	edid_write_hdmi_segment(sd, ADV7842_EDID_PORT_B);
 
+	timings = state->timings;
+
+	memset(&state->timings, 0, sizeof(struct v4l2_dv_timings));
+
+	adv7842_s_dv_timings(sd, &timings);
+
 	return ret;
 }
 
-- 
1.8.4.4

