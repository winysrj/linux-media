Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:56572 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbZDFAgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Apr 2009 20:36:15 -0400
Date: Mon, 6 Apr 2009 02:36:01 +0200 (CEST)
From: Marton Balint <cus@fazekas.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1 of 3] cx88: Add support for stereo and sap detection
 for A2
In-Reply-To: <20090405190257.060906ee@pedra.chehab.org>
Message-ID: <Pine.LNX.4.64.0904060201380.438@cinke.fazekas.hu>
References: <patchbomb.1238536910@roadrunner.athome>
 <32593e0b3a9253e4f3d2.1238536911@roadrunner.athome> <20090405190257.060906ee@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Mauro Carvalho Chehab wrote:

> Hi Marton,
> 
> I suspect that you will need to use div64 math or some othe way to calculate the freq:
> 
> /home/v4l/master/v4l/cx88-dsp.c: In function 'detect_a2_a2m_eiaj':
> /home/v4l/master/v4l/cx88-dsp.c:147: error: SSE register return with SSE disabled
> make[3]: *** [/home/v4l/master/v4l/cx88-dsp.o] Error 1
> make[3]: *** Waiting for unfinished jobs....

Gcc should have optimised away the floating point operations and the 
__builtin_remainder function. Hmm, it seems that older gcc's don't do 
this. Would you try the attached patch? It uses integer modulo instead 
of __builtin_remainder, so only basic floating point operations needs 
optimising, hopefully every common gcc version will be able to do it.

Regards,
  Marton

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1238977280 -7200
# Node ID 5a396f71d463b738c363c12bf53a3e446016aa95
# Parent  119acaa1dee387960325ba637c6257af2b0fd3af
cx88: dsp: more gcc compatible remainder function

From: Marton Balint <cus@fazekas.hu>

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 119acaa1dee3 -r 5a396f71d463 linux/drivers/media/video/cx88/cx88-dsp.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c	Tue Mar 31 23:35:57 2009 +0200
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Mon Apr 06 02:21:20 2009 +0200
@@ -28,8 +28,11 @@
 
 #define INT_PI			((s32)(3.141592653589 * 32768.0))
 
+#define compat_remainder(a, b) \
+	 ((float)(((s32)((a)*100))%((s32)((b)*100)))/100.0)
+
 #define baseband_freq(carrier, srate, tone) ((s32)( \
-	 (__builtin_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
+	 (compat_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
 
 /* We calculate the baseband frequencies of the carrier and the pilot tones
  * based on the the sampling rate of the audio rds fifo. */
