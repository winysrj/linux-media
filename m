Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3361 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965680Ab3E2LBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 15/38] radio: remove g_chip_ident op.
Date: Wed, 29 May 2013 12:59:48 +0200
Message-Id: <1369825211-29770-16-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/saa7706h.c |   10 ----------
 drivers/media/radio/tef6862.c  |   14 --------------
 2 files changed, 24 deletions(-)

diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 06c06cc..d1f30d6 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -25,7 +25,6 @@
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 #define DRIVER_NAME "saa7706h"
 
@@ -349,16 +348,7 @@ static int saa7706h_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 	return -EINVAL;
 }
 
-static int saa7706h_g_chip_ident(struct v4l2_subdev *sd,
-	struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7706H, 0);
-}
-
 static const struct v4l2_subdev_core_ops saa7706h_core_ops = {
-	.g_chip_ident = saa7706h_g_chip_ident,
 	.queryctrl = saa7706h_queryctrl,
 	.g_ctrl = saa7706h_g_ctrl,
 	.s_ctrl = saa7706h_s_ctrl,
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 82c6c94..d78afbb 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 #define DRIVER_NAME "tef6862"
 
@@ -136,14 +135,6 @@ static int tef6862_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
 	return 0;
 }
 
-static int tef6862_g_chip_ident(struct v4l2_subdev *sd,
-	struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TEF6862, 0);
-}
-
 static const struct v4l2_subdev_tuner_ops tef6862_tuner_ops = {
 	.g_tuner = tef6862_g_tuner,
 	.s_tuner = tef6862_s_tuner,
@@ -151,12 +142,7 @@ static const struct v4l2_subdev_tuner_ops tef6862_tuner_ops = {
 	.g_frequency = tef6862_g_frequency,
 };
 
-static const struct v4l2_subdev_core_ops tef6862_core_ops = {
-	.g_chip_ident = tef6862_g_chip_ident,
-};
-
 static const struct v4l2_subdev_ops tef6862_ops = {
-	.core = &tef6862_core_ops,
 	.tuner = &tef6862_tuner_ops,
 };
 
-- 
1.7.10.4

