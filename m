Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33731 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbZDHXSi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 19:18:38 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lrh2R-00013m-A1
	for linux-media@vger.kernel.org; Wed, 08 Apr 2009 23:18:35 +0000
Received: from 63.84.broadband6.iol.cz ([88.101.84.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 23:18:35 +0000
Received: from sustmidown by 63.84.broadband6.iol.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 23:18:35 +0000
To: linux-media@vger.kernel.org
From: Miroslav =?utf-8?b?xaB1c3Rlaw==?= <sustmidown@centrum.cz>
Subject: [PATCH] Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS
Date: Wed, 8 Apr 2009 23:18:24 +0000 (UTC)
Message-ID: <loom.20090408T230421-516@post.gmane.org>
References: <61526.207.214.87.58.1239228654.squirrel@webmail.xs4all.nl> <loom.20090408T221914-837@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Miroslav Šustek <sustmidown <at> centrum.cz> writes:

> Marton Balint sent patch with <linux/div64.h> include and changed 'div_s64_rem'
> to 'div_s64'. But kernels older than 2.26.x have neither 'div_s64' nor
> 'div_s64_rem'.
> 
> Better apply this patch instead that from Marton.

Oh great, <linux/math64.h> (not div64.h like I have written before)
isn't in pre 2.6.26, too (yes I meant 2.6.26.x previously, not 2.26.x). :/

Including <asm/div64.h> works as well for me
and should work on older kernels, too.
Forget about the previous (..._math3) patch :)

- Mirek

----- FILE: cx88-dsp_64bit_math4.patch -----

cx88-dsp: again fixing 64bit math on 32bit kernels

From: Miroslav Sustek <sustmidown@centrum.cz>
Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>


diff -r 77ebdc14cc24 linux/drivers/media/video/cx88/cx88-dsp.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c	Wed Apr 08 14:01:19 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Thu Apr 09 01:14:48 2009 +0200
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <asm/div64.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -101,8 +102,8 @@
 	s32 coeff = 2*int_cos(freq);
 	u32 i;
 
-	s64 tmp;
-	u32 remainder;
+	u64 tmp;
+	u32 divisor;
 
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
@@ -115,7 +116,10 @@
 
 	/* XXX: N must be low enough so that N*N fits in s32.
 	 * Else we need two divisions. */
-	return (u32) div_s64_rem(tmp, N*N, &remainder);
+	divisor = N*N;
+	do_div(tmp, divisor);
+
+	return (u32) tmp;
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)



