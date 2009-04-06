Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46217 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZDFXKH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 19:10:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Lqxx4-0008AQ-Vf
	for linux-media@vger.kernel.org; Mon, 06 Apr 2009 23:10:03 +0000
Received: from 63.84.broadband6.iol.cz ([88.101.84.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2009 23:10:02 +0000
Received: from sustmidown by 63.84.broadband6.iol.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2009 23:10:02 +0000
To: linux-media@vger.kernel.org
From: Miroslav =?utf-8?b?xaB1c3Rlaw==?= <sustmidown@centrum.cz>
Subject: [PATCH] Re: cx88-dsp.c: missing =?utf-8?b?X19kaXZkaTM=?= on 32bit kernel
Date: Mon, 6 Apr 2009 23:07:04 +0000 (UTC)
Message-ID: <loom.20090406T230214-297@post.gmane.org>
References: <200904062233.30966@centrum.cz> <200904062234.8192@centrum.cz> <200904062235.15206@centrum.cz> <200904062236.31983@centrum.cz> <200904062237.27161@centrum.cz> <200904062238.10335@centrum.cz> <200904062239.877@centrum.cz> <200904062240.9520@centrum.cz> <200904062240.1773@centrum.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well this patch should solve it.

I don't know how many samples are processed so:
First patch is for situation when N*N fits in s32.
Second one uses two divisions, but doesn't have any abnormal restrictions for N.

Personally I think that two divisions won't hurt. :)



----- FILE: cx88-dsp_64bit_math1.patch -----

cx88-dsp: fixing 64bit math on 32bit kernels

Note the limitation of N.
Personally I know nothing about possible size of samples array.

From: Miroslav Sustek <sustmidown@centrum.cz>
Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>

diff -r 8aa1d865373c linux/drivers/media/video/cx88/cx88-dsp.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c	Wed Apr 01 20:25:00 2009 +0000
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Tue Apr 07 00:08:48 2009 +0200
@@ -100,13 +100,22 @@
 	s32 s_prev2 = 0;
 	s32 coeff = 2*int_cos(freq);
 	u32 i;
+
+	s64 tmp;
+	u32 remainder;
+
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
-	return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
-		      (s64)coeff*s_prev2*s_prev/32768)/N/N);
+
+	tmp = (s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
+		      (s64)coeff*s_prev2*s_prev/32768;
+
+	/* XXX: N must be low enough so that N*N fits in s32.
+	 * Else we need two divisions. */
+	return (u32) div_s64_rem(tmp, N*N, &remainder);
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)



----- FILE: cx88-dsp_64bit_math2.patch -----

cx88-dsp: fixing 64bit math on 32bit kernels

From: Miroslav Sustek <sustmidown@centrum.cz>
Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>

diff -r 8aa1d865373c linux/drivers/media/video/cx88/cx88-dsp.c
--- a/linux/drivers/media/video/cx88/cx88-dsp.c	Wed Apr 01 20:25:00 2009 +0000
+++ b/linux/drivers/media/video/cx88/cx88-dsp.c	Tue Apr 07 00:26:10 2009 +0200
@@ -100,13 +100,22 @@
 	s32 s_prev2 = 0;
 	s32 coeff = 2*int_cos(freq);
 	u32 i;
+
+	s64 tmp;
+	u32 remainder;
+
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
-	return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
-		      (s64)coeff*s_prev2*s_prev/32768)/N/N);
+
+	tmp = (s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
+		      (s64)coeff*s_prev2*s_prev/32768;
+
+	tmp = div_s64_rem(tmp, N, &remainder);
+
+	return (u32)div_s64_rem(tmp, N, &remainder);
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)

