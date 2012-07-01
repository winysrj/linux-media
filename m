Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2GAUPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jul 2012 16:15:52 -0400
Received: by qcro28 with SMTP id o28so2600569qcr.19
        for <linux-media@vger.kernel.org>; Sun, 01 Jul 2012 13:15:51 -0700 (PDT)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: [PATCH 1/6] cx25840: fix regression in HVR-1800 analog support
Date: Sun,  1 Jul 2012 16:15:09 -0400
Message-Id: <1341173714-23627-2-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
References: <1341173714-23627-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The refactoring of the cx25840 driver to support the cx23888 caused breakage
with the existing support for cx23885/cx23887 analog support.  Rework the
routines such that the new code is only used for the 888.

Validated with the following boards:

HVR-1800 retail (0070:7801)
HVR-1800 OEM (0070:7809)
HVR_1850 retail (0070:8541)

Thanks to Steven Toth and Hauppauge for loaning me various boards to
regression test with.

Reported-by: Jonathan <sitten74490@mypacks.net>
Thanks-to: Steven Toth <stoth@kernellabs.com>
Signed-off-by: Devin Heitmueler <dheitmueller@kernellabs.com>
---
 drivers/media/video/cx25840/cx25840-core.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index fc1ff69..a82b704 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -84,7 +84,7 @@ MODULE_PARM_DESC(debug, "Debugging messages [0=Off (default) 1=On]");
 
 
 /* ----------------------------------------------------------------------- */
-static void cx23885_std_setup(struct i2c_client *client);
+static void cx23888_std_setup(struct i2c_client *client);
 
 int cx25840_write(struct i2c_client *client, u16 addr, u8 value)
 {
@@ -638,10 +638,13 @@ static void cx23885_initialize(struct i2c_client *client)
 	finish_wait(&state->fw_wait, &wait);
 	destroy_workqueue(q);
 
-	/* Call the cx23885 specific std setup func, we no longer rely on
+	/* Call the cx23888 specific std setup func, we no longer rely on
 	 * the generic cx24840 func.
 	 */
-	cx23885_std_setup(client);
+	if (is_cx23888(state))
+		cx23888_std_setup(client);
+	else
+		cx25840_std_setup(client);
 
 	/* (re)set input */
 	set_input(client, state->vid_input, state->aud_input);
@@ -1298,8 +1301,8 @@ static int set_v4lstd(struct i2c_client *client)
 	}
 	cx25840_and_or(client, 0x400, ~0xf, fmt);
 	cx25840_and_or(client, 0x403, ~0x3, pal_m);
-	if (is_cx2388x(state))
-		cx23885_std_setup(client);
+	if (is_cx23888(state))
+		cx23888_std_setup(client);
 	else
 		cx25840_std_setup(client);
 	if (!is_cx2583x(state))
@@ -1782,8 +1785,8 @@ static int cx25840_s_video_routing(struct v4l2_subdev *sd,
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (is_cx2388x(state))
-		cx23885_std_setup(client);
+	if (is_cx23888(state))
+		cx23888_std_setup(client);
 
 	return set_input(client, input, state->aud_input);
 }
@@ -1794,8 +1797,8 @@ static int cx25840_s_audio_routing(struct v4l2_subdev *sd,
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
-	if (is_cx2388x(state))
-		cx23885_std_setup(client);
+	if (is_cx23888(state))
+		cx23888_std_setup(client);
 	return set_input(client, state->vid_input, input);
 }
 
@@ -4939,7 +4942,7 @@ void cx23885_dif_setup(struct i2c_client *client, u32 ifHz)
 	}
 }
 
-static void cx23885_std_setup(struct i2c_client *client)
+static void cx23888_std_setup(struct i2c_client *client)
 {
 	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
 	v4l2_std_id std = state->std;
-- 
1.7.1

