Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3704 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3LNL3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:29:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 08/15] saa6752hs: drop compat control code.
Date: Sat, 14 Dec 2013 12:28:30 +0100
Message-Id: <1387020517-26242-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The saa7134 driver is now converted to the control framework, so drop the
control compat code in saa6752hs.c.

Also add 'const' to several static arrays.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa6752hs.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa6752hs.c b/drivers/media/pci/saa7134/saa6752hs.c
index 8ac4b1f..8272c0b 100644
--- a/drivers/media/pci/saa7134/saa6752hs.c
+++ b/drivers/media/pci/saa7134/saa6752hs.c
@@ -33,11 +33,11 @@
 #include <linux/i2c.h>
 #include <linux/types.h>
 #include <linux/videodev2.h>
+#include <linux/init.h>
+#include <linux/crc32.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-common.h>
-#include <linux/init.h>
-#include <linux/crc32.h>
 
 #define MPEG_VIDEO_TARGET_BITRATE_MAX  27000
 #define MPEG_VIDEO_MAX_BITRATE_MAX     27000
@@ -124,7 +124,7 @@ static inline struct saa6752hs_state *to_state(struct v4l2_subdev *sd)
 
 /* ---------------------------------------------------------------------- */
 
-static u8 PAT[] = {
+static const u8 PAT[] = {
 	0xc2, /* i2c register */
 	0x00, /* table number for encoder */
 
@@ -150,7 +150,7 @@ static u8 PAT[] = {
 	0x00, 0x00, 0x00, 0x00 /* CRC32 */
 };
 
-static u8 PMT[] = {
+static const u8 PMT[] = {
 	0xc2, /* i2c register */
 	0x01, /* table number for encoder */
 
@@ -179,7 +179,7 @@ static u8 PMT[] = {
 	0x00, 0x00, 0x00, 0x00 /* CRC32 */
 };
 
-static u8 PMT_AC3[] = {
+static const u8 PMT_AC3[] = {
 	0xc2, /* i2c register */
 	0x01, /* table number for encoder(1) */
 	0x47, /* sync */
@@ -212,7 +212,7 @@ static u8 PMT_AC3[] = {
 	0xED, 0xDE, 0x2D, 0xF3 /* CRC32 BE */
 };
 
-static struct saa6752hs_mpeg_params param_defaults =
+static const struct saa6752hs_mpeg_params param_defaults =
 {
 	.ts_pid_pmt      = 16,
 	.ts_pid_video    = 260,
@@ -643,13 +643,6 @@ static const struct v4l2_ctrl_ops saa6752hs_ctrl_ops = {
 
 static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
 	.init = saa6752hs_init,
-	.g_ext_ctrls = v4l2_subdev_g_ext_ctrls,
-	.try_ext_ctrls = v4l2_subdev_try_ext_ctrls,
-	.s_ext_ctrls = v4l2_subdev_s_ext_ctrls,
-	.g_ctrl = v4l2_subdev_g_ctrl,
-	.s_ctrl = v4l2_subdev_s_ctrl,
-	.queryctrl = v4l2_subdev_queryctrl,
-	.querymenu = v4l2_subdev_querymenu,
 	.s_std = saa6752hs_s_std,
 };
 
-- 
1.8.4.3

