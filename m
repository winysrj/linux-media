Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:43304 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290Ab1FINMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 09:12:12 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3.0] soc_camera: OMAP1: stop falling back to dma-sg on single -ENOMEM
Date: Thu, 9 Jun 2011 15:10:59 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201106091310.31674.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1106091345520.21107@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1106091345520.21107@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106091511.13215.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu 09 Jun 2011 at 14:07:22 Guennadi Liakhovetski wrote:
> Hi Janusz
> 
> On Thu, 9 Jun 2011, Janusz Krzysztofik wrote:
> > Since commit 6d3163ce86dd386b4f7bda80241d7fea2bc0bb1d, "mm: check
> > if any page in a pageblock is reserved before marking it
> > MIGRATE_RESERVE", the OMAP1 camera driver behaviour while in
> > videobuf-dma-contig mode can be observed as much more stable than
> > before. Once all application programs are started up and nothing
> > unexpected happens in the system, consecutive device open()s tend
> > to succeed with almost 100% reliability.
> > 
> > While the result is still not perfect, still prone to occasional
> > -ENOMEM failures, I think there is no longer a need to fall back
> > to more reliable but less effective, more resource hungry
> > videobuf-dma-sg mode if a single open() fails, as long as users
> > are still able to switch DMA modes from user space over the driver
> > provided sysfs interface, should videobuf-dma-contig mode still
> > happen to keep failing for them.
> > 
> > Tested on Amstrad Delta.
> > 
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > ---
> > Hi,
> > While this patch is not a classic fix, not correcting anything that
> > could be considered as a bug or regression, it is a simple
> > consequence of unexpected but very welcome enhancement introduced
> > during this merge window, so I hope it can be accepted in the rc
> > cycle for that reason. Moreover, it provides no new, but
> > simplifies existing code by removing no longer needed bits.
> 
> Thanks for the patch.
> 
> Hm... First of all, I'm not sure I'd try to push this after the -rc2.

No problem.

> Secondly, I'm having a hard time seeing this as an improvement at
> all... Your driver is capable to work in two modes: contiguous and
> sg, right? Fortunately also, you are able to automatically switch to
> the less efficient, but easier to obtain mode at open() time

No, not at the just failing open() time, but only on next open(). While 
developing this feature, I didn't find a better way of implementing it, 
and I'm probably still not able to, without replicating parts of 
videobuf-dma-contig layer with custom modifications, because of 
different pre-open() videobuf setup steps required.

> - I see
> this as an advantage. You say, after the quoted commit the contig
> DMA "almost" never fails. I believe, it almost never fails in your
> configuration. But if you put your system under a higher memory
> pressure, it still will fail repeatedly, right? And I'm not sure, it
> is always intuitive to the user, that they have to retry starting an
> application, after it fails with -ENOMEM. 

They do now, once on first fault, and based on my test results I could 
expect they might still have to do it only once from 3.0 on, even 
without auto fall back.

> If you really want to be
> able to prohibit falling back to SG, maybe you can add one more
> module parameter to enforce dma-contig? Is the reason, why you want
> to do this, because for your situation you'd prefer open() to fail
> rather to switch to SG?

The reason was simple: after system start-up, open() usually fails for 
me only once, then keeps working quite reliably. But you are right 
saying that my test results may be not reproducible in a different 
environment.

So, maybe let's forgot about this patch and wait until 
dma_alloc_coherent() starts working 100% reliably on OMAP1, or a 
different, more reliable than dma-contig videobuf/videobuf2 option is 
available.

Thanks,
Janusz
