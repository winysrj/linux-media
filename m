Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48285 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753553AbbK3U1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/11] cx25840: initialize the standard to NTSC_M
Date: Mon, 30 Nov 2015 21:27:18 +0100
Message-Id: <1448915241-415-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is necessary since the *_std_setup functions rely on a valid state->std
field.

Also fix the cx23888_std_setup() to test for 60Hz instead of NTSC, just like
cx25840_std_setup() does.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/cx25840/cx25840-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index a8b1a03..f2e2c34 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -4977,7 +4977,7 @@ static void cx23888_std_setup(struct i2c_client *client)
 	cx25840_write4(client, 0x4b4, 0x20524030);
 	cx25840_write4(client, 0x47c, 0x010a8263);
 
-	if (std & V4L2_STD_NTSC) {
+	if (std & V4L2_STD_525_60) {
 		v4l_dbg(1, cx25840_debug, client, "%s() Selecting NTSC",
 			__func__);
 
@@ -5268,6 +5268,7 @@ static int cx25840_probe(struct i2c_client *client,
 	state->id = id;
 	state->rev = device_id;
 	state->vbi_regs_offset = id == CX23888_AV ? 0x500 - 0x424 : 0;
+	state->std = V4L2_STD_NTSC_M;
 	v4l2_ctrl_handler_init(&state->hdl, 9);
 	v4l2_ctrl_new_std(&state->hdl, &cx25840_ctrl_ops,
 			V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
-- 
2.6.2

