Return-path: <linux-media-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:34089 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZDKMFP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 08:05:15 -0400
Date: Sat, 11 Apr 2009 22:05:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Marton Balint <cus@fazekas.hu>, linux-media@vger.kernel.org
Subject: Re: linux-next: Tree for April 9
Message-Id: <20090411220508.501e5c7d.sfr@canb.auug.org.au>
In-Reply-To: <20090411080953.0c22cf4e@pedra.chehab.org>
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au>
	<20090410231158.33b85dc1.akpm@linux-foundation.org>
	<20090411080953.0c22cf4e@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sat, 11 Apr 2009 08:09:53 -0300 Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
>
> On Fri, 10 Apr 2009 23:11:58 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 9 Apr 2009 16:33:05 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > 
> > > I have created today's linux-next tree at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> > 
> > It has a link failure with i386 allmodconfig due to missing __divdi3.
> > 
> > It's due to this statement in drivers/media/video/cx88/cx88-dsp.c's
> > int_goertzel():
> > 
> >         return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
> >                       (s64)coeff*s_prev2*s_prev/32768)/N/N);
> > 
> > that gem will need to be converted to use div64() or similar, please.
> 
> Updated to use do_div().

Thank you.  It will be included in next-20090414.

Andrew, I have included the patch below in case you need it before then.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

commit ec0a97d2dd33e156283dd04c37d77603cb4dbaf7
Author: Miroslav Sustek <sustmidown@centrum.cz>
Date:   Mon Apr 6 20:07:04 2009 -0300

    V4L/DVB (11441): cx88-dsp: fixing 64bit math
    
    cx88-dsp: fixing 64bit math on 32bit kernels
    
    Some gcc versions report the missing of __divdi3
    
    Signed-off-by: Miroslav Sustek <sustmidown@centrum.cz>
    [mchehab.redhat.com: CodingStyle fixes]
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-dsp.c b/drivers/media/video/cx88/cx88-dsp.c
index a78286e..3e5eaf3 100644
--- a/drivers/media/video/cx88/cx88-dsp.c
+++ b/drivers/media/video/cx88/cx88-dsp.c
@@ -22,6 +22,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
+#include <asm/div64.h>
 
 #include "cx88.h"
 #include "cx88-reg.h"
@@ -100,13 +101,25 @@ static u32 int_goertzel(s16 x[], u32 N, u32 freq)
 	s32 s_prev2 = 0;
 	s32 coeff = 2*int_cos(freq);
 	u32 i;
+
+	u64 tmp;
+	u32 divisor;
+
 	for (i = 0; i < N; i++) {
 		s32 s = x[i] + ((s64)coeff*s_prev/32768) - s_prev2;
 		s_prev2 = s_prev;
 		s_prev = s;
 	}
-	return (u32)(((s64)s_prev2*s_prev2 + (s64)s_prev*s_prev -
-		      (s64)coeff*s_prev2*s_prev/32768)/N/N);
+
+	tmp = (s64)s_prev2 * s_prev2 + (s64)s_prev * s_prev -
+		      (s64)coeff * s_prev2 * s_prev / 32768;
+
+	/* XXX: N must be low enough so that N*N fits in s32.
+	 * Else we need two divisions. */
+	divisor = N * N;
+	do_div(tmp, divisor);
+
+	return (u32) tmp;
 }
 
 static u32 freq_magnitude(s16 x[], u32 N, u32 freq)
