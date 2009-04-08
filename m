Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54781 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZDHW4M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2009 18:56:12 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Lrggl-0000ET-4X
	for linux-media@vger.kernel.org; Wed, 08 Apr 2009 22:56:11 +0000
Received: from 63.84.broadband6.iol.cz ([88.101.84.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 22:56:11 +0000
Received: from sustmidown by 63.84.broadband6.iol.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 08 Apr 2009 22:56:11 +0000
To: linux-media@vger.kernel.org
From: Miroslav =?utf-8?b?xaB1c3Rlaw==?= <sustmidown@centrum.cz>
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,      2.6.16-2.6.21: WARNINGS
Date: Wed, 8 Apr 2009 22:56:00 +0000 (UTC)
Message-ID: <loom.20090408T221914-837@post.gmane.org>
References: <61526.207.214.87.58.1239228654.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil <at> xs4all.nl> writes:
> 
> Can someone take a look at these warnings and errors? Looking at the log
> these seem to be pretty easy to fix (compat stuff for the most part).
> 
> I don't have the time for this for several more days, so I'd appreciate it
> if someone could take a look at this for me.
> 
> Thanks,
> 
>         Hans
> 

Yes, it looks like my version of kernel luckily built, but other (older)
versions have problems.

Here: http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4400
Marton Balint sent patch with <linux/div64.h> include and changed 'div_s64_rem'
to 'div_s64'. But kernels older than 2.26.x have neither 'div_s64' nor
'div_s64_rem'.

Better apply this patch instead that from Marton.
It uses 'do_div' which is much longer supported.

With 'do_div' results should be same but for completeness here are some
appointments:

 * 'do_div' does computation with unsigned numbers.
 * So we need to pass dividend as unsigned (its ABS) and then alter the sign of
the result (if dividend was negative).
 * But function 'int_goertzel' returns u32 so if we pass dividend as u64 (cast
from s64), then no sign change is needed before returning. */
 * Also, divisor is N*N, so it will be always non-negative.
 * I think that some implementations(platforms) of 'do_div' requires divisor to
be 32bit. That's why I rather use u32 for divisor (and not u64). (Here
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/4337
Marton wrote that N is at most 576.)


----- FILE: cx88-dsp_64bit_math3.patch -----

cx88-dsp: again fixing 64bit math on 32bit kernels

From: Miroslav Sustek <sustmidown@centrum.cz>
Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>


diff -r 77ebdc14cc24 linux/drivers/media/video/cx88/cx88-dsp.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c	Wed Apr 08 14:01:19 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Thu Apr 09 00:52:27 2009 +0200
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <linux/math64.h>
 
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

