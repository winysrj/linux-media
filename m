Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087Ab1JCSry (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Oct 2011 14:47:54 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org, isely@isely.net
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 1/2] [media] saa7115: Fix standards detection
Date: Mon,  3 Oct 2011 15:47:36 -0300
Message-Id: <1317667657-4081-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several bugs at saa7115 standards detection:

After the fix, the driver is returning the proper standards,
as tested with 3 different broadcast sources:

On an invalid channel (without any TV signal):
[ 4394.931630] saa7115 15-0021: Status byte 2 (0x1f)=0xe0
[ 4394.931635] saa7115 15-0021: detected std mask = 00ffffff

With a PAL/M signal:
[ 4410.836855] saa7115 15-0021: Status byte 2 (0x1f)=0xb1
[ 4410.837727] saa7115 15-0021: Status byte 1 (0x1e)=0x82
[ 4410.837731] saa7115 15-0021: detected std mask = 00000900

With a NTSC/M signal:
[ 4422.383893] saa7115 15-0021: Status byte 2 (0x1f)=0xb1
[ 4422.384768] saa7115 15-0021: Status byte 1 (0x1e)=0x81
[ 4422.384772] saa7115 15-0021: detected std mask = 0000b000

Tests were done with a WinTV PVR USB2 Model 29xx card.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/video/saa7115.c |   47 +++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index cee98ea..86627a8 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1344,35 +1344,52 @@ static int saa711x_g_vbi_data(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_dat
 static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
 	struct saa711x_state *state = to_state(sd);
-	int reg1e;
+	int reg1f, reg1e;
 
-	*std = V4L2_STD_ALL;
-	if (state->ident != V4L2_IDENT_SAA7115) {
-		int reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
-
-		if (reg1f & 0x20)
-			*std = V4L2_STD_525_60;
-		else
-			*std = V4L2_STD_625_50;
-
-		return 0;
+	reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
+	v4l2_dbg(1, debug, sd, "Status byte 2 (0x1f)=0x%02x\n", reg1f);
+	if (reg1f & 0x40) {
+		/* horizontal/vertical not locked */
+		*std = V4L2_STD_ALL;
+		goto ret;
 	}
+	if (reg1f & 0x20)
+		*std = V4L2_STD_525_60;
+	else
+		*std = V4L2_STD_625_50;
+
+	if (state->ident != V4L2_IDENT_SAA7115)
+		goto ret;
 
 	reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
 
 	switch (reg1e & 0x03) {
 	case 1:
-		*std = V4L2_STD_NTSC;
+		*std &= V4L2_STD_NTSC;
 		break;
 	case 2:
-		*std = V4L2_STD_PAL;
+		/*
+		 * V4L2_STD_PAL just cover the european PAL standards.
+		 * This is wrong, as the device could also be using an
+		 * other PAL standard.
+		 */
+		*std &= V4L2_STD_PAL   | V4L2_STD_PAL_N  | V4L2_STD_PAL_Nc |
+			V4L2_STD_PAL_M | V4L2_STD_PAL_60;
 		break;
 	case 3:
-		*std = V4L2_STD_SECAM;
+		*std &= V4L2_STD_SECAM;
 		break;
 	default:
+		/* Can't detect anything */
+		*std = V4L2_STD_ALL;
 		break;
 	}
+
+	v4l2_dbg(1, debug, sd, "Status byte 1 (0x1e)=0x%02x\n", reg1e);
+
+ret:
+	v4l2_dbg(1, debug, sd, "detected std mask = %08Lx\n", *std);
+
 	return 0;
 }
 
-- 
1.7.6.4

