Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3002 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965597Ab3E2OT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 10:19:27 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [RFC PATCH 01/14] adv7183: fix querystd
Date: Wed, 29 May 2013 16:18:54 +0200
Message-Id: <1369837147-8747-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
References: <1369837147-8747-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If no signal is detected, return V4L2_STD_UNKNOWN. Otherwise AND the standard
with the detected standards.

Note that the v4l2 core initializes the std with tvnorms before calling the
querystd ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/i2c/adv7183.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index 7c48e22..b5e51d8 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -375,28 +375,28 @@ static int adv7183_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	reg = adv7183_read(sd, ADV7183_STATUS_1);
 	switch ((reg >> 0x4) & 0x7) {
 	case 0:
-		*std = V4L2_STD_NTSC;
+		*std &= V4L2_STD_NTSC;
 		break;
 	case 1:
-		*std = V4L2_STD_NTSC_443;
+		*std &= V4L2_STD_NTSC_443;
 		break;
 	case 2:
-		*std = V4L2_STD_PAL_M;
+		*std &= V4L2_STD_PAL_M;
 		break;
 	case 3:
-		*std = V4L2_STD_PAL_60;
+		*std &= V4L2_STD_PAL_60;
 		break;
 	case 4:
-		*std = V4L2_STD_PAL;
+		*std &= V4L2_STD_PAL;
 		break;
 	case 5:
-		*std = V4L2_STD_SECAM;
+		*std &= V4L2_STD_SECAM;
 		break;
 	case 6:
-		*std = V4L2_STD_PAL_Nc;
+		*std &= V4L2_STD_PAL_Nc;
 		break;
 	case 7:
-		*std = V4L2_STD_SECAM;
+		*std &= V4L2_STD_SECAM;
 		break;
 	default:
 		*std = V4L2_STD_UNKNOWN;
-- 
1.7.10.4

