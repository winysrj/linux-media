Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18GY9md021756
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 11:34:09 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m18GXcNr031106
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 11:33:39 -0500
Date: Fri, 8 Feb 2008 17:33:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080208104635.4a7c9227@gaivota>
Message-ID: <Pine.LNX.4.64.0802081357210.5301@axis700.grange>
References: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
	<20080207183409.3e788533@gaivota>
	<Pine.LNX.4.64.0802072146210.9064@axis700.grange>
	<20080208092821.52872e1d@gaivota>
	<Pine.LNX.4.64.0802081235210.5301@axis700.grange>
	<20080208104635.4a7c9227@gaivota>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: Two more patches required for soc_camera
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 8 Feb 2008, Mauro Carvalho Chehab wrote:

> On Fri, 8 Feb 2008 12:40:18 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:
> > 
> > Ok, how about
> > 
> > 	depends on PCI || ARCH_PXA
> > 
> > ? I think, this way we are safe.
> 
> If you disable all things on arch/pxa, but v4l (and the minimum required
> dependencies), do it compile and work? If so, this would be ok. Otherwise, you
> may need something like:
> depends on PCI || (ARCH_PXA && CONFIG_HAS_DMA)
> 
> This approach can be an interim solution.

ARM never defines NO_DMA (see my email from yesterday), so, CONFIG_HAS_DMA 
would be redundant. And

#include <asm-generic/pci-dma-compat.h>

is the first line in include/arch-arm/pci.h, so, we are safe with this. 
However, to be 100% sure, I did what you suggested - switched off all I 
could in the config... and indeed videobuf-dma-sg.c refused to build. And 
you know which option it needs? CONFIG_BLOCK... But this must be a bug 
elswhere in the kbuild system. if CONFIG_BLOCK is off, the whole lib/lib.a 
doesn't get linked into vmlinux, although it does appear on the ld command 
line...

So, I would suggest that we just do (PCI || PXA) for now and I try to 
clarify the problem with the ARM people. What do you think?

> > If we do accept the above solution, would we still want to move to dma 
> > API?
> 
> I think so. The above approach is an workaround. It is not nice to have a
> non-pci thing including pci.h. Future patches may break the workaround.
> 
> > And would you like me to try to do this or you'd prefer to do this 
> > yourself?
> 
> Please do it and submit it to us, for testing.

Ok, I'll try to manage it before .26.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
