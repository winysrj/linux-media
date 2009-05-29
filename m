Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator3.ecc.gatech.edu ([130.207.185.173]:59750 "EHLO
	deliverator3.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbZE2A1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 20:27:43 -0400
Message-ID: <4A1F2BFB.6010109@gatech.edu>
Date: Thu, 28 May 2009 20:27:39 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] cx18: Use do_div for 64-bit division to fix 32-bit kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the do_div macro for 64-bit division.  Otherwise, the module will 
reference __udivdi3 under 32-bit kernels, which is not allowed in kernel 
space.  Follows style used in cx88 module.

Signed-off-by: David Ward <david.ward@gatech.edu>

diff -r 65ec132f20df -r 91b89f13adb7 
linux/drivers/media/video/cx18/cx18-av-core.c
--- a/linux/drivers/media/video/cx18/cx18-av-core.c    Wed May 27 
15:53:00 2009 -0300
+++ b/linux/drivers/media/video/cx18/cx18-av-core.c    Thu May 28 
19:16:10 2009 -0400
@@ -447,6 +447,7 @@ void cx18_av_std_setup(struct cx18 *cx)

      if (pll_post) {
          int fsc, pll;
+        u64 tmp64;

          pll = (28636360L * ((((u64)pll_int) << 25) + pll_frac)) >> 25;
          pll /= pll_post;
@@ -459,7 +460,9 @@ void cx18_av_std_setup(struct cx18 *cx)
                      "= %d.%03d\n", src_decimation / 256,
                      ((src_decimation % 256) * 1000) / 256);

-        fsc = ((((u64)sc) * 28636360)/src_decimation) >> 13L;
+        tmp64 = ((u64)sc) * 28636360;
+        do_div(tmp64, src_decimation);
+        fsc = ((u32)(tmp64 >> 13L));
          CX18_DEBUG_INFO_DEV(sd,
                      "Chroma sub-carrier initial freq = %d.%06d "
                      "MHz\n", fsc / 1000000, fsc % 1000000);

