Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4917 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655Ab3E2LA4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:00:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv1 16/38] indycam: remove g_chip_ident op.
Date: Wed, 29 May 2013 12:59:49 +0200
Message-Id: <1369825211-29770-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is no longer needed since the core now handles this through DBG_G_CHIP_INFO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/indycam.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/media/platform/indycam.c b/drivers/media/platform/indycam.c
index 5482363..f1d192b 100644
--- a/drivers/media/platform/indycam.c
+++ b/drivers/media/platform/indycam.c
@@ -23,7 +23,6 @@
 #include <linux/videodev2.h>
 #include <linux/i2c.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 
 #include "indycam.h"
 
@@ -283,20 +282,9 @@ static int indycam_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 
 /* I2C-interface */
 
-static int indycam_g_chip_ident(struct v4l2_subdev *sd,
-		struct v4l2_dbg_chip_ident *chip)
-{
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct indycam *camera = to_indycam(sd);
-
-	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_INDYCAM,
-		       camera->version);
-}
-
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops indycam_core_ops = {
-	.g_chip_ident = indycam_g_chip_ident,
 	.g_ctrl = indycam_g_ctrl,
 	.s_ctrl = indycam_s_ctrl,
 };
-- 
1.7.10.4

