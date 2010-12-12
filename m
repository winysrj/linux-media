Return-path: <mchehab@gaivota>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4678 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0LLSd0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Dec 2010 13:33:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [RFC/PATCH 03/19] cx18: Use the control framework.
Date: Sun, 12 Dec 2010 19:33:21 +0100
Cc: linux-media@vger.kernel.org
References: <8lcku8q5u511tsmore3i7sls.1292177376794@email.android.com>
In-Reply-To: <8lcku8q5u511tsmore3i7sls.1292177376794@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012121933.21498.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday, December 12, 2010 19:09:36 Andy Walls wrote:
> Hans,
> 
> This has at least the same two problems the change for cx25840 had:
> 
> 1. Volume control init should use 65535 not 65335
> 
> 2. You cannot trust reg 0x8d4 to have a value in it for the default volume that won't give an ERANGE error when you go to init the volume control.  Subdev probe will fail. See my previous cx25840 patches sent to the list, awaiting action.
> 
> (The cx25840 code that trusts the volume register to be in range is already in 2.6.36 and breaks IR and analog for CX23885/7/8 chips.)
> 
> I'll give this whole patch a harder look later this evening if I can.
> 
> Regards,
> Andy
> 

Would the patch below fix these issues? It compiles, but I didn't test it.

Regards,

	Hans

diff --git a/drivers/media/video/cx18/cx18-av-core.c b/drivers/media/video/cx18/cx18-av-core.c
index e1f58f1..73b6f4d 100644
--- a/drivers/media/video/cx18/cx18-av-core.c
+++ b/drivers/media/video/cx18/cx18-av-core.c
@@ -248,8 +248,22 @@ static void cx18_av_initialize(struct v4l2_subdev *sd)
 /*      	CxDevWrReg(CXADEC_SRC_COMB_CFG, 0x6628021F); */
 /*    } */
 	cx18_av_write4(cx, CXADEC_SRC_COMB_CFG, 0x6628021F);
-	default_volume = 228 - cx18_av_read(cx, 0x8d4);
-	default_volume = ((default_volume / 2) + 23) << 9;
+	default_volume = cx18_av_read(cx, 0x8d4);
+	/*
+	 * Enforce the legacy volume scale mapping limits to avoid -ERANGE
+	 * errors when initializing the volume control
+	 */
+	if (default_volume > 228) {
+		/* Bottom out at -96 dB, v4l2 vol range 0x2e00-0x2fff */
+		default_volume = 228;
+		cx18_av_write(cx, 0x8d4, 228);
+	}
+	else if (default_volume < 20) {
+		/* Top out at + 8 dB, v4l2 vol range 0xfe00-0xffff */
+		default_volume = 20;
+		cx18_av_write(cx, 0x8d4, 20);
+	}
+	default_volume = (((228 - default_volume) >> 1) + 23) << 9;
 	state->volume->cur.val = state->volume->default_value = default_volume;
 	v4l2_ctrl_handler_setup(&state->hdl);
 }
@@ -1359,7 +1373,7 @@ int cx18_av_probe(struct cx18 *cx)
 
 	state->volume = v4l2_ctrl_new_std(&state->hdl,
 			&cx18_av_audio_ctrl_ops, V4L2_CID_AUDIO_VOLUME,
-			0, 65335, 65535 / 100, 0);
+			0, 65535, 65535 / 100, 0);
 	v4l2_ctrl_new_std(&state->hdl,
 			&cx18_av_audio_ctrl_ops, V4L2_CID_AUDIO_MUTE,
 			0, 1, 1, 0);

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
