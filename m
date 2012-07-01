Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51555 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2GAUPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:54 -0400
Received: by mail-qa0-f53.google.com with SMTP id s11so1561997qaa.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:54 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 2/6] cx25840: fix regression in HVR-1800 analog support hue/saturation controls
Date: Sun,  1 Jul 2012 16:15:10 -0400
Message-Id: <1341173714-23627-3-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The changes made for the cx23888 caused regressions in the analog support
for cx23885/cx23887 based boards (partly due to changes in the locations of
the hue/saturation controls).  As a result the wrong registers were being
overwritten.

Add code to use the correct registers if it's a cx23888

Validated with the following boards:

HVR-1800 retail (0070:7801)
HVR-1800 OEM (0070:7809)
HVR-1850 retail (0070:8541)

Thanks to Steven Toth and Hauppauge for	loaning	me various boards to
regression test	 with.

Reported-by: Jonathan <sitten74490@mypacks.net>
Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx25840/cx25840-core.c |   33 +++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index a82b704..e12b3b0 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -1106,9 +1106,23 @@ static int set_input(struct i2c_client *client, enum cx25840_video_input vid_inp
 
 			cx25840_write4(client, 0x410, 0xffff0dbf);
 			cx25840_write4(client, 0x414, 0x00137d03);
-			cx25840_write4(client, 0x418, 0x01008080);
+
+			/* on the 887, 0x418 is HSCALE_CTRL, on the 888 it is 
+			   CHROMA_CTRL */
+			if (is_cx23888(state))
+				cx25840_write4(client, 0x418, 0x01008080);
+			else
+				cx25840_write4(client, 0x418, 0x01000000);
+
 			cx25840_write4(client, 0x41c, 0x00000000);
-			cx25840_write4(client, 0x420, 0x001c3e0f);
+
+			/* on the 887, 0x420 is CHROMA_CTRL, on the 888 it is 
+			   CRUSH_CTRL */
+			if (is_cx23888(state))
+				cx25840_write4(client, 0x420, 0x001c3e0f);
+			else
+				cx25840_write4(client, 0x420, 0x001c8282);
+
 			cx25840_write4(client, 0x42c, 0x42600000);
 			cx25840_write4(client, 0x430, 0x0000039b);
 			cx25840_write4(client, 0x438, 0x00000000);
@@ -1315,6 +1329,7 @@ static int set_v4lstd(struct i2c_client *client)
 static int cx25840_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
+	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
 	switch (ctrl->id) {
@@ -1327,12 +1342,20 @@ static int cx25840_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 
 	case V4L2_CID_SATURATION:
-		cx25840_write(client, 0x420, ctrl->val << 1);
-		cx25840_write(client, 0x421, ctrl->val << 1);
+		if (is_cx23888(state)) {
+			cx25840_write(client, 0x418, ctrl->val << 1);
+			cx25840_write(client, 0x419, ctrl->val << 1);
+		} else {
+			cx25840_write(client, 0x420, ctrl->val << 1);
+			cx25840_write(client, 0x421, ctrl->val << 1);
+		}
 		break;
 
 	case V4L2_CID_HUE:
-		cx25840_write(client, 0x422, ctrl->val);
+		if (is_cx23888(state))
+			cx25840_write(client, 0x41a, ctrl->val);
+		else
+			cx25840_write(client, 0x422, ctrl->val);
 		break;
 
 	default:
-- 
1.7.1

