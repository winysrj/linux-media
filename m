Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53577 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276AbbK3U1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/11] cx25840: fix VBI support for cx23888
Date: Mon, 30 Nov 2015 21:27:14 +0100
Message-Id: <1448915241-415-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx23888 has the VBI registers at different addresses compared to
the other variants. In most cases it is a fixed offset, but not always.

Update the code so the right registers are written for the cx23888.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 20 ++++++++++----------
 drivers/media/i2c/cx25840/cx25840-core.h |  1 +
 drivers/media/i2c/cx25840/cx25840-vbi.c  | 32 +++++++++++++++++++++++---------
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 181fdc1..ec11ba7 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -666,7 +666,7 @@ static void cx23885_initialize(struct i2c_client *client)
 	cx25840_write4(client, 0x404, 0x0010253e);
 
 	/* CC on  - Undocumented Register */
-	cx25840_write(client, 0x42f, 0x66);
+	cx25840_write(client, state->vbi_regs_offset + 0x42f, 0x66);
 
 	/* HVR-1250 / HVR1850 DIF related */
 	/* Power everything up */
@@ -1122,15 +1122,14 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 			else
 				cx25840_write4(client, 0x420, 0x001c8282);
 
-			cx25840_write4(client, 0x42c, 0x42600000);
-			cx25840_write4(client, 0x430, 0x0000039b);
-			cx25840_write4(client, 0x438, 0x00000000);
-
-			cx25840_write4(client, 0x440, 0xF8E3E824);
-			cx25840_write4(client, 0x444, 0x401040dc);
-			cx25840_write4(client, 0x448, 0xcd3f02a0);
-			cx25840_write4(client, 0x44c, 0x161f1000);
-			cx25840_write4(client, 0x450, 0x00000802);
+			cx25840_write4(client, state->vbi_regs_offset + 0x42c, 0x42600000);
+			cx25840_write4(client, state->vbi_regs_offset + 0x430, 0x0000039b);
+			cx25840_write4(client, state->vbi_regs_offset + 0x438, 0x00000000);
+			cx25840_write4(client, state->vbi_regs_offset + 0x440, 0xF8E3E824);
+			cx25840_write4(client, state->vbi_regs_offset + 0x444, 0x401040dc);
+			cx25840_write4(client, state->vbi_regs_offset + 0x448, 0xcd3f02a0);
+			cx25840_write4(client, state->vbi_regs_offset + 0x44c, 0x161f1000);
+			cx25840_write4(client, state->vbi_regs_offset + 0x450, 0x00000802);
 
 			cx25840_write4(client, 0x91c, 0x01000000);
 			cx25840_write4(client, 0x8e0, 0x03063870);
@@ -5264,6 +5263,7 @@ static int cx25840_probe(struct i2c_client *client,
 	state->vbi_line_offset = 8;
 	state->id = id;
 	state->rev = device_id;
+	state->vbi_regs_offset = id == CX23888_AV ? 0x500 - 0x424 : 0;
 	v4l2_ctrl_handler_init(&state->hdl, 9);
 	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index fdea48c..254ef45 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -69,6 +69,7 @@ struct cx25840_state {
 	enum cx25840_model id;
 	u32 rev;
 	int is_initialized;
+	unsigned vbi_regs_offset;
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
 	struct work_struct fw_work;   /* work entry for fw load */
 	struct cx25840_ir_state *ir_state;
diff --git a/drivers/media/i2c/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
index 04034c5..0470bb6 100644
--- a/drivers/media/i2c/cx25840/cx25840-vbi.c
+++ b/drivers/media/i2c/cx25840/cx25840-vbi.c
@@ -104,7 +104,8 @@ int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 
 	if (is_pal) {
 		for (i = 7; i <= 23; i++) {
-			u8 v = cx25840_read(client, 0x424 + i - 7);
+			u8 v = cx25840_read(client,
+				 state->vbi_regs_offset + 0x424 + i - 7);
 
 			svbi->service_lines[0][i] = lcr2vbi[v >> 4];
 			svbi->service_lines[1][i] = lcr2vbi[v & 0xf];
@@ -113,7 +114,8 @@ int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 		}
 	} else {
 		for (i = 10; i <= 21; i++) {
-			u8 v = cx25840_read(client, 0x424 + i - 10);
+			u8 v = cx25840_read(client,
+				state->vbi_regs_offset + 0x424 + i - 10);
 
 			svbi->service_lines[0][i] = lcr2vbi[v >> 4];
 			svbi->service_lines[1][i] = lcr2vbi[v & 0xf];
@@ -135,7 +137,10 @@ int cx25840_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
 	cx25840_std_setup(client);
 
 	/* VBI Offset */
-	cx25840_write(client, 0x47f, vbi_offset);
+	if (is_cx23888(state))
+		cx25840_write(client, 0x54f, vbi_offset);
+	else
+		cx25840_write(client, 0x47f, vbi_offset);
 	cx25840_write(client, 0x404, 0x2e);
 	return 0;
 }
@@ -158,7 +163,10 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 	/* Sliced VBI */
 	cx25840_write(client, 0x404, 0x32);	/* Ancillary data */
 	cx25840_write(client, 0x406, 0x13);
-	cx25840_write(client, 0x47f, vbi_offset);
+	if (is_cx23888(state))
+		cx25840_write(client, 0x54f, vbi_offset);
+	else
+		cx25840_write(client, 0x47f, vbi_offset);
 
 	if (is_pal) {
 		for (i = 0; i <= 6; i++)
@@ -194,17 +202,23 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
 	}
 
 	if (is_pal) {
-		for (x = 1, i = 0x424; i <= 0x434; i++, x++)
+		for (x = 1, i = state->vbi_regs_offset + 0x424;
+		     i <= state->vbi_regs_offset + 0x434; i++, x++)
 			cx25840_write(client, i, lcr[6 + x]);
 	} else {
-		for (x = 1, i = 0x424; i <= 0x430; i++, x++)
+		for (x = 1, i = state->vbi_regs_offset + 0x424;
+		     i <= state->vbi_regs_offset + 0x430; i++, x++)
 			cx25840_write(client, i, lcr[9 + x]);
-		for (i = 0x431; i <= 0x434; i++)
+		for (i = state->vbi_regs_offset + 0x431;
+		     i <= state->vbi_regs_offset + 0x434; i++)
 			cx25840_write(client, i, 0);
 	}
 
-	cx25840_write(client, 0x43c, 0x16);
-	cx25840_write(client, 0x474, is_pal ? 0x2a : 0x22);
+	cx25840_write(client, state->vbi_regs_offset + 0x43c, 0x16);
+	if (is_cx23888(state))
+		cx25840_write(client, 0x428, is_pal ? 0x2a : 0x22);
+	else
+		cx25840_write(client, 0x474, is_pal ? 0x2a : 0x22);
 	return 0;
 }
 
-- 
2.6.2

