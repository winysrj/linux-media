Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3646 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLqn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/42] saa7115: improve querystd handling for the saa7115.
Date: Mon, 11 Mar 2013 12:45:43 +0100
Message-Id: <dfc8b4b4926bd343cd08f81ba64a42325c748470.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The saa7115 has better PAL/NTSC detection, so it can detect PAL even
though the chip is currently set up for NTSC.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/saa7115.c |   56 +++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index f249b20..d301442 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1360,6 +1360,34 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	 */
 
 	reg1f = saa711x_read(sd, R_1F_STATUS_BYTE_2_VD_DEC);
+
+	if (state->ident == V4L2_IDENT_SAA7115) {
+		reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
+
+		v4l2_dbg(1, debug, sd, "Status byte 1 (0x1e)=0x%02x\n", reg1e);
+
+		switch (reg1e & 0x03) {
+		case 1:
+			*std &= V4L2_STD_NTSC;
+			break;
+		case 2:
+			/*
+			 * V4L2_STD_PAL just cover the european PAL standards.
+			 * This is wrong, as the device could also be using an
+			 * other PAL standard.
+			 */
+			*std &= V4L2_STD_PAL   | V4L2_STD_PAL_N  | V4L2_STD_PAL_Nc |
+				V4L2_STD_PAL_M | V4L2_STD_PAL_60;
+			break;
+		case 3:
+			*std &= V4L2_STD_SECAM;
+			break;
+		default:
+			/* Can't detect anything */
+			break;
+		}
+	}
+
 	v4l2_dbg(1, debug, sd, "Status byte 2 (0x1f)=0x%02x\n", reg1f);
 
 	/* horizontal/vertical not locked */
@@ -1371,34 +1399,6 @@ static int saa711x_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 	else
 		*std &= V4L2_STD_625_50;
 
-	if (state->ident != V4L2_IDENT_SAA7115)
-		goto ret;
-
-	reg1e = saa711x_read(sd, R_1E_STATUS_BYTE_1_VD_DEC);
-
-	switch (reg1e & 0x03) {
-	case 1:
-		*std &= V4L2_STD_NTSC;
-		break;
-	case 2:
-		/*
-		 * V4L2_STD_PAL just cover the european PAL standards.
-		 * This is wrong, as the device could also be using an
-		 * other PAL standard.
-		 */
-		*std &= V4L2_STD_PAL   | V4L2_STD_PAL_N  | V4L2_STD_PAL_Nc |
-			V4L2_STD_PAL_M | V4L2_STD_PAL_60;
-		break;
-	case 3:
-		*std &= V4L2_STD_SECAM;
-		break;
-	default:
-		/* Can't detect anything */
-		break;
-	}
-
-	v4l2_dbg(1, debug, sd, "Status byte 1 (0x1e)=0x%02x\n", reg1e);
-
 ret:
 	v4l2_dbg(1, debug, sd, "detected std mask = %08Lx\n", *std);
 
-- 
1.7.10.4

