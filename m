Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:64621 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751311AbdK0NYz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 08:24:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] [media] staging: atomisp: convert timestamps to ktime_t
Date: Mon, 27 Nov 2017 14:19:59 +0100
Message-Id: <20171127132027.1734806-7-arnd@arndb.de>
In-Reply-To: <20171127132027.1734806-1-arnd@arndb.de>
References: <20171127132027.1734806-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

timespec overflows in 2038 on 32-bit architectures, and the
getnstimeofday() suffers from possible time jumps, so the
timestamps here are better done using ktime_get(), which has
neither of those problems.

In case of ov2680, we don't seem to use the timestamp at
all, so I just remove it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/media/atomisp/i2c/ov2680.h                |  1 -
 drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c | 15 ++++++---------
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h         |  2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index bf4897347df7..03f75dd80f87 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -174,7 +174,6 @@ struct ov2680_format {
 		struct mutex input_lock;
 	struct v4l2_ctrl_handler ctrl_handler;
 		struct camera_sensor_platform_data *platform_data;
-		struct timespec timestamp_t_focus_abs;
 		int vt_pix_clk_freq_mhz;
 		int fmt_idx;
 		int run_mode;
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
index 3e7c3851280f..a715ea0e4230 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/atomisp-ov5693.c
@@ -973,7 +973,7 @@ static int ov5693_t_focus_abs(struct v4l2_subdev *sd, s32 value)
 	if (ret == 0) {
 		dev->number_of_steps = value - dev->focus;
 		dev->focus = value;
-		getnstimeofday(&(dev->timestamp_t_focus_abs));
+		dev->timestamp_t_focus_abs = ktime_get();
 	} else
 		dev_err(&client->dev,
 			"%s: i2c failed. ret %d\n", __func__, ret);
@@ -993,16 +993,13 @@ static int ov5693_q_focus_status(struct v4l2_subdev *sd, s32 *value)
 {
 	u32 status = 0;
 	struct ov5693_device *dev = to_ov5693_sensor(sd);
-	struct timespec temptime;
-	const struct timespec timedelay = {
-		0,
+	ktime_t temptime;
+	ktime_t timedelay = ns_to_ktime(
 		min((u32)abs(dev->number_of_steps) * DELAY_PER_STEP_NS,
-		(u32)DELAY_MAX_PER_STEP_NS),
-	};
+		    (u32)DELAY_MAX_PER_STEP_NS));
 
-	getnstimeofday(&temptime);
-	temptime = timespec_sub(temptime, (dev->timestamp_t_focus_abs));
-	if (timespec_compare(&temptime, &timedelay) <= 0) {
+	temptime = ktime_sub(ktime_get(), (dev->timestamp_t_focus_abs));
+	if (ktime_compare(temptime, timedelay) <= 0) {
 		status |= ATOMISP_FOCUS_STATUS_MOVING;
 		status |= ATOMISP_FOCUS_HP_IN_PROGRESS;
 	} else {
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index 2ea63807c56d..68cfcb4a6c3c 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -221,7 +221,7 @@ struct ov5693_device {
 	struct v4l2_ctrl_handler ctrl_handler;
 
 	struct camera_sensor_platform_data *platform_data;
-	struct timespec timestamp_t_focus_abs;
+	ktime_t timestamp_t_focus_abs;
 	int vt_pix_clk_freq_mhz;
 	int fmt_idx;
 	int run_mode;
-- 
2.9.0
