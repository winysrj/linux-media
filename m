Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56FUZke005814
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 11:30:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56FUOMo005707
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 11:30:24 -0400
Date: Fri, 6 Jun 2008 12:30:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: jon.dufresne@infinitevideocorporation.com
Message-ID: <20080606123016.681e24e8@gaivota>
In-Reply-To: <1212762592.16563.54.camel@localhost.localdomain>
References: <1212675977.16563.24.camel@localhost.localdomain>
	<20080605180748.0b8f81cd@gaivota>
	<1212762592.16563.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Writing first v4l2 driver
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

On Fri, 06 Jun 2008 10:29:52 -0400
Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:

> 
> On Thu, 2008-06-05 at 18:07 -0300, Mauro Carvalho Chehab wrote:
> > Does your device support DMA scatter/gather mode (e.g. instead of a continuous
> > DMA memory, you would be using a range of non-continuous memory areas)? If not,
> > then you'll need to write a different video-buf driver.
> 
> I am writing code for both sides, the DSP on the PCI board and the
> driver in the linux kernel. The dsp has functionality to write data over
> the PCI bus, and I could certainly code this to work in discontinuous
> chunks. So I believe it could use sg lists.

This is the better solution, if you can work on both sides. Continuous stream
buffer for video is generally very large, and may lead into some troubles if
the memory is too fragmented before you allocate such memory (the drivers that
work with non sg DMA returns -ENOMEM if you don't have a continuous block with
enough size to allocate the buffer).

> > The simplest driver is vivi.c. Yet, it uses videobuf-vmalloc, which is a little
> > bit different. However, since this is a fake device, it helps to understand how
> > videobuf works. If you get into vivi.c previous versions, at mercurial repo,
> > you'll find even a vivi example using the video-buf-dma-sg. Most of stuff
> > will be similar. 
> > 
> > The other two examples for PCI devices are saa7134-video and cx88-video. bttv
> > also uses it, but bttv driver is more complex to understand, since its code is
> > bigger.
> 
> Thanks for pointing these devices out. I will study these and see how
> things turn out.

Anytime.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
