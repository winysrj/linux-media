Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35649 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdGWPf6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 11:35:58 -0400
Date: Sun, 23 Jul 2017 17:35:55 +0200
From: JB Van Puyvelde <jbvanpuyvelde@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        fengguang.wu@intel.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: imx: fix non-static declarations
Message-ID: <20170723173555.4980ce01@kyle>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add static keywords to fix this kind of sparse warnings:
warning: symbol 'imx_t_vcm_timing' was not declared. Should it be static?

Signed-off-by: JB Van Puyvelde <jbvanpuyvelde@gmail.com>
---
 drivers/staging/media/atomisp/i2c/imx/imx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/imx/imx.c b/drivers/staging/media/atomisp/i2c/imx/imx.c
index 408a7b945153..fb32cb2f2dd1 100644
--- a/drivers/staging/media/atomisp/i2c/imx/imx.c
+++ b/drivers/staging/media/atomisp/i2c/imx/imx.c
@@ -1084,7 +1084,7 @@ static int imx_g_bin_factor_y(struct v4l2_subdev *sd, s32 *val)
 	return 0;
 }
 
-int imx_vcm_power_up(struct v4l2_subdev *sd)
+static int imx_vcm_power_up(struct v4l2_subdev *sd)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->power_up)
@@ -1092,7 +1092,7 @@ int imx_vcm_power_up(struct v4l2_subdev *sd)
 	return 0;
 }
 
-int imx_vcm_power_down(struct v4l2_subdev *sd)
+static int imx_vcm_power_down(struct v4l2_subdev *sd)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->power_down)
@@ -1100,7 +1100,7 @@ int imx_vcm_power_down(struct v4l2_subdev *sd)
 	return 0;
 }
 
-int imx_vcm_init(struct v4l2_subdev *sd)
+static int imx_vcm_init(struct v4l2_subdev *sd)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->init)
@@ -1108,7 +1108,7 @@ int imx_vcm_init(struct v4l2_subdev *sd)
 	return 0;
 }
 
-int imx_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
+static int imx_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->t_focus_vcm)
@@ -1116,14 +1116,15 @@ int imx_t_focus_vcm(struct v4l2_subdev *sd, u16 val)
 	return 0;
 }
 
-int imx_t_focus_abs(struct v4l2_subdev *sd, s32 value)
+static int imx_t_focus_abs(struct v4l2_subdev *sd, s32 value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->t_focus_abs)
 		return dev->vcm_driver->t_focus_abs(sd, value);
 	return 0;
 }
-int imx_t_focus_rel(struct v4l2_subdev *sd, s32 value)
+
+static int imx_t_focus_rel(struct v4l2_subdev *sd, s32 value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->t_focus_rel)
@@ -1131,7 +1132,7 @@ int imx_t_focus_rel(struct v4l2_subdev *sd, s32 value)
 	return 0;
 }
 
-int imx_q_focus_status(struct v4l2_subdev *sd, s32 *value)
+static int imx_q_focus_status(struct v4l2_subdev *sd, s32 *value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->q_focus_status)
@@ -1139,7 +1140,7 @@ int imx_q_focus_status(struct v4l2_subdev *sd, s32 *value)
 	return 0;
 }
 
-int imx_q_focus_abs(struct v4l2_subdev *sd, s32 *value)
+static int imx_q_focus_abs(struct v4l2_subdev *sd, s32 *value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->q_focus_abs)
@@ -1147,7 +1148,7 @@ int imx_q_focus_abs(struct v4l2_subdev *sd, s32 *value)
 	return 0;
 }
 
-int imx_t_vcm_slew(struct v4l2_subdev *sd, s32 value)
+static int imx_t_vcm_slew(struct v4l2_subdev *sd, s32 value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->t_vcm_slew)
@@ -1155,7 +1156,7 @@ int imx_t_vcm_slew(struct v4l2_subdev *sd, s32 value)
 	return 0;
 }
 
-int imx_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
+static int imx_t_vcm_timing(struct v4l2_subdev *sd, s32 value)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
 	if (dev->vcm_driver && dev->vcm_driver->t_vcm_timing)
@@ -2105,8 +2106,7 @@ imx_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *param)
 	return 0;
 }
 
-int
-imx_g_frame_interval(struct v4l2_subdev *sd,
+static int imx_g_frame_interval(struct v4l2_subdev *sd,
 				struct v4l2_subdev_frame_interval *interval)
 {
 	struct imx_device *dev = to_imx_sensor(sd);
-- 
2.11.0
