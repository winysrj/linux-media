Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:36410 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCaWOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 18:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 3] cx88: avoid reprogramming every audio register on A2
	stereo/mono change
Message-Id: <119acaa1dee387960325.1238536913@roadrunner.athome>
In-Reply-To: <patchbomb.1238536910@roadrunner.athome>
Date: Wed, 01 Apr 2009 00:01:53 +0200
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1238535357 -7200
# Node ID 119acaa1dee387960325ba637c6257af2b0fd3af
# Parent  d2cbecf047e8f45f49f20bd19b95dfd86c134e33
cx88: avoid reprogramming every audio register on A2 stereo/mono change

From: Marton Balint <cus@fazekas.hu>

This patch changes cx88_set_stereo to avoid resetting all of the audio
registers on stereo/mono change if the audio standard is A2, and set only the
AUD_CTL register. The benefit of this method is that it eliminates the annoying
clicking noise on setting the audio mode to stereo or mono.

The driver had used the same method 1.5 years ago (and for FM radio it still
does), but a pretty big cleanup commit changed it to the "complete audio reset"
method, although the reason for this move was not clear. (If somebody knows why
it was necessary, please let me know!)

The original commit: http://linuxtv.org/hg/v4l-dvb/rev/ffe313541d7d

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r d2cbecf047e8 -r 119acaa1dee3 linux/drivers/media/video/cx88/cx88-tvaudio.c
--- a/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Mar 31 03:21:56 2009 +0200
+++ b/linux/drivers/media/video/cx88/cx88-tvaudio.c	Tue Mar 31 23:35:57 2009 +0200
@@ -938,20 +938,18 @@
 				set_audio_standard_A2(core, EN_A2_FORCE_MONO1);
 			} else {
 				/* TODO: Add A2 autodection */
+				mask = 0x3f;
 				switch (mode) {
 				case V4L2_TUNER_MODE_MONO:
 				case V4L2_TUNER_MODE_LANG1:
-					set_audio_standard_A2(core,
-							      EN_A2_FORCE_MONO1);
+					ctl = EN_A2_FORCE_MONO1;
 					break;
 				case V4L2_TUNER_MODE_LANG2:
-					set_audio_standard_A2(core,
-							      EN_A2_FORCE_MONO2);
+					ctl = EN_A2_FORCE_MONO2;
 					break;
 				case V4L2_TUNER_MODE_STEREO:
 				case V4L2_TUNER_MODE_LANG1_LANG2:
-					set_audio_standard_A2(core,
-							      EN_A2_FORCE_STEREO);
+					ctl = EN_A2_FORCE_STEREO;
 					break;
 				}
 			}
