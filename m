Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2041 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965688Ab3E2LBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCHv1 19/38] cx25840: remove the v4l2-chip-ident.h include
Date: Wed, 29 May 2013 12:59:52 +0200
Message-Id: <1369825211-29770-20-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace the V4L2_IDENT_ macros from v4l2-chip-ident.h with driver specific
defines.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/i2c/cx25840/cx25840-core.c |   50 +++++++++++++++---------------
 drivers/media/i2c/cx25840/cx25840-core.h |   34 +++++++++++++-------
 2 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index 6fbdad4..2e3771d 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -497,7 +497,7 @@ static void cx23885_initialize(struct i2c_client *client)
 
 	/* Sys PLL */
 	switch (state->id) {
-	case V4L2_IDENT_CX23888_AV:
+	case CX23888_AV:
 		/*
 		 * 50.0 MHz * (0xb + 0xe8ba26/0x2000000)/4 = 5 * 28.636363 MHz
 		 * 572.73 MHz before post divide
@@ -510,7 +510,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		cx25840_write4(client, 0x42c, 0x42600000);
 		cx25840_write4(client, 0x44c, 0x161f1000);
 		break;
-	case V4L2_IDENT_CX23887_AV:
+	case CX23887_AV:
 		/*
 		 * 25.0 MHz * (0x16 + 0x1d1744c/0x2000000)/4 = 5 * 28.636363 MHz
 		 * 572.73 MHz before post divide
@@ -518,7 +518,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		cx25840_write4(client, 0x11c, 0x01d1744c);
 		cx25840_write4(client, 0x118, 0x00000416);
 		break;
-	case V4L2_IDENT_CX23885_AV:
+	case CX23885_AV:
 	default:
 		/*
 		 * 28.636363 MHz * (0x14 + 0x0/0x2000000)/4 = 5 * 28.636363 MHz
@@ -545,7 +545,7 @@ static void cx23885_initialize(struct i2c_client *client)
 
 	/* HVR1850 */
 	switch (state->id) {
-	case V4L2_IDENT_CX23888_AV:
+	case CX23888_AV:
 		/* 888/HVR1250 specific */
 		cx25840_write4(client, 0x10c, 0x13333333);
 		cx25840_write4(client, 0x108, 0x00000515);
@@ -569,7 +569,7 @@ static void cx23885_initialize(struct i2c_client *client)
 	 * 48 ksps, 16 bits/sample, x16 multiplier = 12.288 MHz
 	 */
 	switch (state->id) {
-	case V4L2_IDENT_CX23888_AV:
+	case CX23888_AV:
 		/*
 		 * 50.0 MHz * (0x7 + 0x0bedfa4/0x2000000)/3 = 122.88 MHz
 		 * 368.64 MHz before post divide
@@ -579,7 +579,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		cx25840_write4(client, 0x114, 0x017dbf48);
 		cx25840_write4(client, 0x110, 0x000a030e);
 		break;
-	case V4L2_IDENT_CX23887_AV:
+	case CX23887_AV:
 		/*
 		 * 25.0 MHz * (0xe + 0x17dbf48/0x2000000)/3 = 122.88 MHz
 		 * 368.64 MHz before post divide
@@ -588,7 +588,7 @@ static void cx23885_initialize(struct i2c_client *client)
 		cx25840_write4(client, 0x114, 0x017dbf48);
 		cx25840_write4(client, 0x110, 0x000a030e);
 		break;
-	case V4L2_IDENT_CX23885_AV:
+	case CX23885_AV:
 	default:
 		/*
 		 * 28.636363 MHz * (0xc + 0x1bf0c9e/0x2000000)/3 = 122.88 MHz
@@ -5110,18 +5110,18 @@ static u32 get_cx2388x_ident(struct i2c_client *client)
 		ret = cx25840_read4(client, 0x300);
 		if (((ret & 0xffff0000) >> 16) == (ret & 0xffff)) {
 			/* No DIF */
-			ret = V4L2_IDENT_CX23885_AV;
+			ret = CX23885_AV;
 		} else {
 			/* CX23887 has a broken DIF, but the registers
 			 * appear valid (but unused), good enough to detect. */
-			ret = V4L2_IDENT_CX23887_AV;
+			ret = CX23887_AV;
 		}
 	} else if (cx25840_read4(client, 0x300) & 0x0fffffff) {
 		/* DIF PLL Freq Word reg exists; chip must be a CX23888 */
-		ret = V4L2_IDENT_CX23888_AV;
+		ret = CX23888_AV;
 	} else {
 		v4l_err(client, "Unable to detect h/w, assuming cx23887\n");
-		ret = V4L2_IDENT_CX23887_AV;
+		ret = CX23887_AV;
 	}
 
 	/* Back into digital power down */
@@ -5135,7 +5135,7 @@ static int cx25840_probe(struct i2c_client *client,
 	struct cx25840_state *state;
 	struct v4l2_subdev *sd;
 	int default_volume;
-	u32 id = V4L2_IDENT_NONE;
+	u32 id;
 	u16 device_id;
 
 	/* Check if the adapter supports the needed features */
@@ -5151,14 +5151,14 @@ static int cx25840_probe(struct i2c_client *client,
 	/* The high byte of the device ID should be
 	 * 0x83 for the cx2583x and 0x84 for the cx2584x */
 	if ((device_id & 0xff00) == 0x8300) {
-		id = V4L2_IDENT_CX25836 + ((device_id >> 4) & 0xf) - 6;
+		id = CX25836 + ((device_id >> 4) & 0xf) - 6;
 	} else if ((device_id & 0xff00) == 0x8400) {
-		id = V4L2_IDENT_CX25840 + ((device_id >> 4) & 0xf);
+		id = CX25840 + ((device_id >> 4) & 0xf);
 	} else if (device_id == 0x0000) {
 		id = get_cx2388x_ident(client);
 	} else if ((device_id & 0xfff0) == 0x5A30) {
 		/* The CX23100 (0x5A3C = 23100) doesn't have an A/V decoder */
-		id = V4L2_IDENT_CX2310X_AV;
+		id = CX2310X_AV;
 	} else if ((device_id & 0xff) == (device_id >> 8)) {
 		v4l_err(client,
 			"likely a confused/unresponsive cx2388[578] A/V decoder"
@@ -5180,26 +5180,26 @@ static int cx25840_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
 
 	switch (id) {
-	case V4L2_IDENT_CX23885_AV:
+	case CX23885_AV:
 		v4l_info(client, "cx23885 A/V decoder found @ 0x%x (%s)\n",
 			 client->addr << 1, client->adapter->name);
 		break;
-	case V4L2_IDENT_CX23887_AV:
+	case CX23887_AV:
 		v4l_info(client, "cx23887 A/V decoder found @ 0x%x (%s)\n",
 			 client->addr << 1, client->adapter->name);
 		break;
-	case V4L2_IDENT_CX23888_AV:
+	case CX23888_AV:
 		v4l_info(client, "cx23888 A/V decoder found @ 0x%x (%s)\n",
 			 client->addr << 1, client->adapter->name);
 		break;
-	case V4L2_IDENT_CX2310X_AV:
+	case CX2310X_AV:
 		v4l_info(client, "cx%d A/V decoder found @ 0x%x (%s)\n",
 			 device_id, client->addr << 1, client->adapter->name);
 		break;
-	case V4L2_IDENT_CX25840:
-	case V4L2_IDENT_CX25841:
-	case V4L2_IDENT_CX25842:
-	case V4L2_IDENT_CX25843:
+	case CX25840:
+	case CX25841:
+	case CX25842:
+	case CX25843:
 		/* Note: revision '(device_id & 0x0f) == 2' was never built. The
 		   marking skips from 0x1 == 22 to 0x3 == 23. */
 		v4l_info(client, "cx25%3x-2%x found @ 0x%x (%s)\n",
@@ -5208,8 +5208,8 @@ static int cx25840_probe(struct i2c_client *client,
 						: (device_id & 0x0f),
 			 client->addr << 1, client->adapter->name);
 		break;
-	case V4L2_IDENT_CX25836:
-	case V4L2_IDENT_CX25837:
+	case CX25836:
+	case CX25837:
 	default:
 		v4l_info(client, "cx25%3x-%x found @ 0x%x (%s)\n",
 			 (device_id & 0xfff0) >> 4, device_id & 0x0f,
diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
index bd4ada2..37bc042 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.h
+++ b/drivers/media/i2c/cx25840/cx25840-core.h
@@ -23,12 +23,24 @@
 
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/v4l2-ctrls.h>
 #include <linux/i2c.h>
 
 struct cx25840_ir_state;
 
+enum cx25840_model {
+	CX23885_AV,
+	CX23887_AV,
+	CX23888_AV,
+	CX2310X_AV,
+	CX25840,
+	CX25841,
+	CX25842,
+	CX25843,
+	CX25836,
+	CX25837,
+};
+
 struct cx25840_state {
 	struct i2c_client *c;
 	struct v4l2_subdev sd;
@@ -46,7 +58,7 @@ struct cx25840_state {
 	u32 audclk_freq;
 	int audmode;
 	int vbi_line_offset;
-	u32 id;
+	enum cx25840_model id;
 	u32 rev;
 	int is_initialized;
 	wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
@@ -66,35 +78,35 @@ static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
 
 static inline bool is_cx2583x(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX25836 ||
-	       state->id == V4L2_IDENT_CX25837;
+	return state->id == CX25836 ||
+	       state->id == CX25837;
 }
 
 static inline bool is_cx231xx(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX2310X_AV;
+	return state->id == CX2310X_AV;
 }
 
 static inline bool is_cx2388x(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX23885_AV ||
-	       state->id == V4L2_IDENT_CX23887_AV ||
-	       state->id == V4L2_IDENT_CX23888_AV;
+	return state->id == CX23885_AV ||
+	       state->id == CX23887_AV ||
+	       state->id == CX23888_AV;
 }
 
 static inline bool is_cx23885(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX23885_AV;
+	return state->id == CX23885_AV;
 }
 
 static inline bool is_cx23887(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX23887_AV;
+	return state->id == CX23887_AV;
 }
 
 static inline bool is_cx23888(struct cx25840_state *state)
 {
-	return state->id == V4L2_IDENT_CX23888_AV;
+	return state->id == CX23888_AV;
 }
 
 /* ----------------------------------------------------------------------- */
-- 
1.7.10.4

