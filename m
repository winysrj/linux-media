Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:40722 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbbBFOiM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2015 09:38:12 -0500
Received: by mail-we0-f181.google.com with SMTP id k48so14058603wev.12
        for <linux-media@vger.kernel.org>; Fri, 06 Feb 2015 06:38:08 -0800 (PST)
From: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
To: linux-media@vger.kernel.org, hans.verkuil@cisco.com
Cc: m.chehab@samsung.com, linux-kernel@vger.kernel.org,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Subject: [PATCH] media: i2c: ADV7604: In free run mode, signal is locked
Date: Fri,  6 Feb 2015 15:37:58 +0100
Message-Id: <1423233478-20774-1-git-send-email-jean-michel.hautbois@vodalys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CP_NON_STD_VIDEO bit indicates an input not aligned with DV timings.
If there is no input, and chip is in free run mode, consider we are locked.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
---
 drivers/media/i2c/adv7604.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index e43dd2e..24fb342 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1329,13 +1329,21 @@ static inline bool no_lock_cp(struct v4l2_subdev *sd)
 	return io_read(sd, 0x12) & 0x01;
 }
 
+static inline bool in_free_run(struct v4l2_subdev *sd)
+{
+	return cp_read(sd, 0xff) & 0x10;
+}
+
 static int adv7604_g_input_status(struct v4l2_subdev *sd, u32 *status)
 {
 	*status = 0;
 	*status |= no_power(sd) ? V4L2_IN_ST_NO_POWER : 0;
 	*status |= no_signal(sd) ? V4L2_IN_ST_NO_SIGNAL : 0;
-	if (no_lock_cp(sd))
-		*status |= is_digital_input(sd) ? V4L2_IN_ST_NO_SYNC : V4L2_IN_ST_NO_H_LOCK;
+	if (!in_free_run(sd))
+		if (no_lock_cp(sd))
+			*status |= is_digital_input(sd)
+				? V4L2_IN_ST_NO_SYNC
+				: V4L2_IN_ST_NO_H_LOCK;
 
 	v4l2_dbg(1, debug, sd, "%s: status = 0x%x\n", __func__, *status);
 
@@ -2276,7 +2284,7 @@ static int adv7604_log_status(struct v4l2_subdev *sd)
 	v4l2_info(sd, "STDI locked: %s\n", no_lock_stdi(sd) ? "false" : "true");
 	v4l2_info(sd, "CP locked: %s\n", no_lock_cp(sd) ? "false" : "true");
 	v4l2_info(sd, "CP free run: %s\n",
-			(!!(cp_read(sd, 0xff) & 0x10) ? "on" : "off"));
+			(in_free_run(sd)) ? "on" : "off");
 	v4l2_info(sd, "Prim-mode = 0x%x, video std = 0x%x, v_freq = 0x%x\n",
 			io_read(sd, 0x01) & 0x0f, io_read(sd, 0x00) & 0x3f,
 			(io_read(sd, 0x01) & 0x70) >> 4);
-- 
2.2.2

