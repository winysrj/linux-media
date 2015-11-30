Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:55421 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbK3U1j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 05/11] cx25840: more cx23888 register address changes
Date: Mon, 30 Nov 2015 21:27:15 +0100
Message-Id: <1448915241-415-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx23888 also moves the following registers around:

!cx23888	cx23888
--------	-------
0x418, 0x41c	0x434, 0x438
0x420		0x418 (expect for bit 29 which has a different meaning)
0x478		0x454

Also drop the set_input code where the scaler is changed: this does not
belong here, changing the input should not change the scaler.

And that's besides the fact that that code is plain wrong.

After this change the cx23888 behaves much better. In particular, calling
set_input no longer changes the saturation to 0, causing a grayscale
image.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 49 +++++++++++++++-----------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index ec11ba7..a741c30 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -559,7 +559,10 @@ static void cx23885_initialize(struct i2c_client *client)
 	cx25840_write4(client, 0x414, 0x00107d12);
 
 	/* Chroma */
-	cx25840_write4(client, 0x420, 0x3d008282);
+	if (is_cx23888(state))
+		cx25840_write4(client, 0x418, 0x1d008282);
+	else
+		cx25840_write4(client, 0x420, 0x3d008282);
 
 	/*
 	 * Aux PLL
@@ -673,7 +676,10 @@ static void cx23885_initialize(struct i2c_client *client)
 	cx25840_write4(client, 0x130, 0x0);
 
 	/* Undocumented */
-	cx25840_write4(client, 0x478, 0x6628021F);
+	if (is_cx23888(state))
+		cx25840_write4(client, 0x454, 0x6628021F);
+	else
+		cx25840_write4(client, 0x478, 0x6628021F);
 
 	/* AFE_CLK_OUT_CTRL - Select the clock output source as output */
 	cx25840_write4(client, 0x144, 0x5);
@@ -1106,25 +1112,10 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 			cx25840_write4(client, 0x410, 0xffff0dbf);
 			cx25840_write4(client, 0x414, 0x00137d03);
 
-			/* on the 887, 0x418 is HSCALE_CTRL, on the 888 it is 
-			   CHROMA_CTRL */
-			if (is_cx23888(state))
-				cx25840_write4(client, 0x418, 0x01008080);
-			else
-				cx25840_write4(client, 0x418, 0x01000000);
-
-			cx25840_write4(client, 0x41c, 0x00000000);
-
-			/* on the 887, 0x420 is CHROMA_CTRL, on the 888 it is 
-			   CRUSH_CTRL */
-			if (is_cx23888(state))
-				cx25840_write4(client, 0x420, 0x001c3e0f);
-			else
-				cx25840_write4(client, 0x420, 0x001c8282);
-
 			cx25840_write4(client, state->vbi_regs_offset + 0x42c, 0x42600000);
 			cx25840_write4(client, state->vbi_regs_offset + 0x430, 0x0000039b);
 			cx25840_write4(client, state->vbi_regs_offset + 0x438, 0x00000000);
+
 			cx25840_write4(client, state->vbi_regs_offset + 0x440, 0xF8E3E824);
 			cx25840_write4(client, state->vbi_regs_offset + 0x444, 0x401040dc);
 			cx25840_write4(client, state->vbi_regs_offset + 0x448, 0xcd3f02a0);
@@ -1425,14 +1416,20 @@ static int cx25840_set_fmt(struct v4l2_subdev *sd,
 			fmt->width, fmt->height, HSC, VSC);
 
 	/* HSCALE=HSC */
-	cx25840_write(client, 0x418, HSC & 0xff);
-	cx25840_write(client, 0x419, (HSC >> 8) & 0xff);
-	cx25840_write(client, 0x41a, HSC >> 16);
-	/* VSCALE=VSC */
-	cx25840_write(client, 0x41c, VSC & 0xff);
-	cx25840_write(client, 0x41d, VSC >> 8);
-	/* VS_INTRLACE=1 VFILT=filter */
-	cx25840_write(client, 0x41e, 0x8 | filter);
+	if (is_cx23888(state)) {
+		cx25840_write4(client, 0x434, HSC | (1 << 24));
+		/* VSCALE=VSC VS_INTRLACE=1 VFILT=filter */
+		cx25840_write4(client, 0x438, VSC | (1 << 19) | (filter << 16));
+	} else {
+		cx25840_write(client, 0x418, HSC & 0xff);
+		cx25840_write(client, 0x419, (HSC >> 8) & 0xff);
+		cx25840_write(client, 0x41a, HSC >> 16);
+		/* VSCALE=VSC */
+		cx25840_write(client, 0x41c, VSC & 0xff);
+		cx25840_write(client, 0x41d, VSC >> 8);
+		/* VS_INTRLACE=1 VFILT=filter */
+		cx25840_write(client, 0x41e, 0x8 | filter);
+	}
 	return 0;
 }
 
-- 
2.6.2

