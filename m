Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n03JPBjH029180
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 14:25:11 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n03JOlUO006390
	for <video4linux-list@redhat.com>; Sat, 3 Jan 2009 14:24:48 -0500
Date: Sat, 3 Jan 2009 20:25:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <alpine.LRH.2.00.0901031550530.3513@caramujo.chehab.org>
Message-ID: <Pine.LNX.4.64.0901032014440.15363@axis700.grange>
References: <f17812d70901020716n2e6bb9cas2958ea4df2a19af8@mail.gmail.com>
	<Pine.LNX.4.64.0901021625420.4694@axis700.grange>
	<20090103104338.6822c576@pedra.chehab.org>
	<Pine.LNX.4.64.0901031415060.3955@axis700.grange>
	<alpine.LRH.2.00.0901031400260.3513@caramujo.chehab.org>
	<Pine.LNX.4.64.0901031714150.3955@axis700.grange>
	<alpine.LRH.2.00.0901031550530.3513@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Russell King <linux@arm.linux.org.uk>, video4linux-list@redhat.com
Subject: Re: [PATCH] pxa-camera: fix redefinition warnings and missing DMA
 definitions
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

On Sat, 3 Jan 2009, Mauro Carvalho Chehab wrote:

> > And now, Mauro, what do we do with this specific case? Are you going to
> > fix it in your hg-/git-trees or are you expecting anything from me / Eric?
> 
> Please send me a patch fixing the issue, and I'll send it forward. You can
> write it against -hg or -git, since both trees are syncronized.

Ok, the patch from Eric should fix it, but I cannot test it:

  CC [M]  drivers/media/video/videobuf-dma-sg.o
drivers/media/video/videobuf-dma-sg.c: In function 'videobuf_vm_fault':
drivers/media/video/videobuf-dma-sg.c:391: error: implicit declaration of 
function 'clear_user_page'

which means, the highmem patches that have been previously dropped from 
next (IIRC) are there again and ARM has no clear_user_page again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
