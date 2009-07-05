Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:29054 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756918AbZGEQd6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 12:33:58 -0400
Date: Sun, 5 Jul 2009 18:43:19 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Wu Zhangjin <wuzhangjin@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mips@linux-mips.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by
 "fbdev: add mutex for fb_mmap locking"
Message-Id: <20090705184319.6e77be82.krzysztof.h1@poczta.fm>
In-Reply-To: <20090705152557.GA10588@linux-sh.org>
References: <1246785112.14240.34.camel@falcon>
	<alpine.LFD.2.01.0907050715490.3210@localhost.localdomain>
	<20090705145203.GA8326@linux-sh.org>
	<alpine.LFD.2.01.0907050756280.3210@localhost.localdomain>
	<20090705150134.GB8326@linux-sh.org>
	<alpine.LFD.2.01.0907050816110.3210@localhost.localdomain>
	<20090705152557.GA10588@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Jul 2009 00:25:57 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> Ok, here is an updated version with an updated matroxfb and the sm501fb
> change reverted.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 

Here is a patch which should fix problem with sm501fb driver:

diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 16d4f4c..924d794 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1540,9 +1540,6 @@ static int sm501fb_init_fb(struct fb_info *fb,
 	if (ret)
 		dev_err(info->dev, "check_var() failed on initial setup?\n");
 
-	/* ensure we've activated our new configuration */
-	(fb->fbops->fb_set_par)(fb);
-
 	return 0;
 }
 

Paul, please test it (without additional initialization of the mm_lock mutext). I will post the patch
if it works for you.

An issue here is that these drivers calls fb_set_par() function (or part of it as the sisfb driver) 
but the register_framebuffer() calls the fb_set_par() also after all structures are set up. There
should be no need to call the fb_set_par() just before the register_framebuffer().

The matroxfb driver is quite far from standard driver framework by now. I vote for fixing it
by adding this early initialization of the mm_mutex for now.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Promocja ubezpieczen komunikacyjnych Ergo Hestia. Sprawdz!
http://link.interia.pl/f222f

