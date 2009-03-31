Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:36409 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZCaWOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 2 of 3] cx88: audio thread: if stereo detection is hw
	supported don't do it manually
Message-Id: <d2cbecf047e8f45f49f2.1238536912@roadrunner.athome>
In-Reply-To: <patchbomb.1238536910@roadrunner.athome>
Date: Wed, 01 Apr 2009 00:01:52 +0200
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1238462516 -7200
# Node ID d2cbecf047e8f45f49f20bd19b95dfd86c134e33
# Parent  32593e0b3a9253e4f3d2cb415cb3143136f61504
cx88: audio thread: if stereo detection is hw supported don't do it manually

From: Marton Balint <cus@fazekas.hu>

The sole purpose of the audio thread is to detect if stereo transmission is
available, and if it is, then switch to stereo mode (and switch back, if it's
no longer available). This manual autodetection is useful for some audio
standards (e.g. A2) where cx88_get_stereo CAN detect stereo sound, but the
cx2388x chip CANNOT auto-detect stereo sound.

However, for other audio standards, the cx2388x chip CAN auto-detect the stereo
sound, so the manual autodetection in the audio thread is not needed. In fact,
it can cause serious problems because for some of these audio standards,
cx88_get_stereo CANNOT detect the presence of stereo sound.  Besides that, if
the hardware automatically detects stereo/mono sound, you cannot set
core->audiomode_current to the real current audio mode on channel change.

With this patch, the manual autodetection is only used if audiomode_current is
known after a channel change (because of the initial mono mode), and
hardware-based stereo autodetecion is not applicable for the current audio
standard.

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 32593e0b3a92 -r d2cbecf047e8 linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Mar 31 03:08:15 2009 +0200
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Mar 31 03:21:56 2009 +0200
@@ -998,24 +998,39 @@
 			break;
 		try_to_freeze();
 
-		/* just monitor the audio status for now ... */
-		memset(&t, 0, sizeof(t));
-		cx88_get_stereo(core, &t);
+		switch (core->tvaudio) {
+		case WW_BG:
+		case WW_DK:
+		case WW_M:
+		case WW_I:
+		case WW_L:
+			if (core->use_nicam)
+				goto hw_autodetect;
 
-		if (UNSET != core->audiomode_manual)
-			/* manually set, don't do anything. */
-			continue;
+			/* just monitor the audio status for now ... */
+			memset(&t, 0, sizeof(t));
+			cx88_get_stereo(core, &t);
 
-		/* monitor signal */
-		if (t.rxsubchans & V4L2_TUNER_SUB_STEREO)
-			mode = V4L2_TUNER_MODE_STEREO;
-		else
-			mode = V4L2_TUNER_MODE_MONO;
-		if (mode == core->audiomode_current)
-			continue;
+			if (UNSET != core->audiomode_manual)
+				/* manually set, don't do anything. */
+				continue;
 
-		/* automatically switch to best available mode */
-		cx88_set_stereo(core, mode, 0);
+			/* monitor signal and set stereo if available */
+			if (t.rxsubchans & V4L2_TUNER_SUB_STEREO)
+				mode = V4L2_TUNER_MODE_STEREO;
+			else
+				mode = V4L2_TUNER_MODE_MONO;
+			if (mode == core->audiomode_current)
+				continue;
+			/* automatically switch to best available mode */
+			cx88_set_stereo(core, mode, 0);
+			break;
+		default:
+hw_autodetect:
+			/* stereo autodetection is supported by hardware so
+			   we don't need to do it manually. Do nothing. */
+			break;
+		}
 	}
 
 	dprintk("cx88: tvaudio thread exiting\n");
