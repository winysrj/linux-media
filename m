Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1120 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab3LJNZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:25:19 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mats Randgaard <matrandg@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 12/15] adv7604: improve HDMI audio handling
Date: Tue, 10 Dec 2013 14:23:17 +0100
Message-Id: <e42778dd2849b04b31fac91a5196cadbdb15abea.1386681716.git.hans.verkuil@cisco.com>
In-Reply-To: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
References: <1386681800-6787-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
References: <0e2706623dab5b0bba9603d9877d0e5153ad1627.1386681716.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

- Mute audio before switching inputs to avoid noise/pops
- Mute audio if audio FIFO over-/underflows (AD Recommended setting)
- Reset FIFO if it over-/underflows (AD Recommended setting)

Signed-off-by: Mats Randgaard <matrandg@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 50f0279..cbeda0f 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1387,14 +1387,12 @@ static void enable_input(struct v4l2_subdev *sd)
 	struct adv7604_state *state = to_state(sd);
 
 	if (is_analog_input(sd)) {
-		/* enable */
 		io_write(sd, 0x15, 0xb0);   /* Disable Tristate of Pins (no audio) */
 	} else if (is_digital_input(sd)) {
-		/* enable */
 		hdmi_write_and_or(sd, 0x00, 0xfc, state->selected_input);
-		hdmi_write(sd, 0x1a, 0x0a); /* Unmute audio */
 		hdmi_write(sd, 0x01, 0x00); /* Enable HDMI clock terminators */
 		io_write(sd, 0x15, 0xa0);   /* Disable Tristate of Pins */
+		hdmi_write_and_or(sd, 0x1a, 0xef, 0x00); /* Unmute audio */
 	} else {
 		v4l2_dbg(2, debug, sd, "%s: Unknown port %d selected\n",
 				__func__, state->selected_input);
@@ -1403,9 +1401,9 @@ static void enable_input(struct v4l2_subdev *sd)
 
 static void disable_input(struct v4l2_subdev *sd)
 {
-	/* disable */
+	hdmi_write_and_or(sd, 0x1a, 0xef, 0x10); /* Mute audio */
+	msleep(16); /* 512 samples with >= 32 kHz sample rate [REF_03, c. 7.16.10] */
 	io_write(sd, 0x15, 0xbe);   /* Tristate all outputs from video core */
-	hdmi_write(sd, 0x1a, 0x1a); /* Mute audio */
 	hdmi_write(sd, 0x01, 0x78); /* Disable HDMI clock terminators */
 }
 
@@ -2044,6 +2042,11 @@ static int adv7604_core_init(struct v4l2_subdev *sd)
 	cp_write(sd, 0xc9, 0x2d); /* use prim_mode and vid_std as free run resolution
 				     for digital formats */
 
+	/* HDMI audio */
+	hdmi_write_and_or(sd, 0x15, 0xfc, 0x03); /* Mute on FIFO over-/underflow [REF_01, c. 1.2.18] */
+	hdmi_write_and_or(sd, 0x1a, 0xf1, 0x08); /* Wait 1 s before unmute */
+	hdmi_write_and_or(sd, 0x68, 0xf9, 0x06); /* FIFO reset on over-/underflow [REF_01, c. 1.2.19] */
+
 	/* TODO from platform data */
 	afe_write(sd, 0xb5, 0x01);  /* Setting MCLK to 256Fs */
 
-- 
1.8.4.rc3

