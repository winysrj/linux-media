Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5JDpqB6025231
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 09:51:52 -0400
Received: from smtp176.iad.emailsrvr.com (smtp176.iad.emailsrvr.com
	[207.97.245.176])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5JDpInK016716
	for <video4linux-list@redhat.com>; Thu, 19 Jun 2008 09:51:18 -0400
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080606123016.681e24e8@gaivota>
References: <1212675977.16563.24.camel@localhost.localdomain>
	<20080605180748.0b8f81cd@gaivota>
	<1212762592.16563.54.camel@localhost.localdomain>
	<20080606123016.681e24e8@gaivota>
Content-Type: text/plain
Date: Thu, 19 Jun 2008 09:51:12 -0400
Message-Id: <1213883472.7578.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Writing first v4l2 driver
Reply-To: jon.dufresne@infinitevideocorporation.com
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


On Fri, 2008-06-06 at 12:30 -0300, Mauro Carvalho Chehab wrote:
> On Fri, 06 Jun 2008 10:29:52 -0400
> Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:
> 
> > 
> > On Thu, 2008-06-05 at 18:07 -0300, Mauro Carvalho Chehab wrote:
> > > Does your device support DMA scatter/gather mode (e.g. instead of a continuous
> > > DMA memory, you would be using a range of non-continuous memory areas)? If not,
> > > then you'll need to write a different video-buf driver.
> > 
> > I am writing code for both sides, the DSP on the PCI board and the
> > driver in the linux kernel. The dsp has functionality to write data over
> > the PCI bus, and I could certainly code this to work in discontinuous
> > chunks. So I believe it could use sg lists.
> 
> This is the better solution, if you can work on both sides. Continuous stream
> buffer for video is generally very large, and may lead into some troubles if
> the memory is too fragmented before you allocate such memory (the drivers that
> work with non sg DMA returns -ENOMEM if you don't have a continuous block with
> enough size to allocate the buffer).
> 
> > > The simplest driver is vivi.c. Yet, it uses videobuf-vmalloc, which is a little
> > > bit different. However, since this is a fake device, it helps to understand how
> > > videobuf works. If you get into vivi.c previous versions, at mercurial repo,
> > > you'll find even a vivi example using the video-buf-dma-sg. Most of stuff
> > > will be similar. 
> > > 
> > > The other two examples for PCI devices are saa7134-video and cx88-video. bttv
> > > also uses it, but bttv driver is more complex to understand, since its code is
> > > bigger.
> > 
> > Thanks for pointing these devices out. I will study these and see how
> > things turn out.
> 
> Anytime.

Thank you for the help. I have been able to successfully get streaming
video to work using sg lists and the video buf help file. There are a
few things I'm still confused about and hoping someone can clear them up
for me.

What exactly are the operations that should be performed by the queue
ops. I'll explain what I think they should do, please correct me if I am
wrong:

buf_setup;
	Assign the size of the video frame the driver expects and the number of
buffers the driver allows. Right now I have just have the accept as many
buffers as was requested. When is this a bad thing?

buf_prepare:
	Not really sure about this. Right now I just call the iolock function
from the video-buf module. I think this sets up the sg list for me.

buf_queue:
	Puts the buffer into a list. If it is the first to enter the list it
tells the hardware to begin a dma transfer, otherwise it just appends to
the list.

Upon receiving an interrupt from the hardware, the buffer is removed
from the list and considered "STATE_DONE", at which point the memory
contains the frame data. In this interrupt the driver looks at the next
buffer in the list and tells it to start the dma again.

buf_release:
	Currently my release does nothing.



Another issue I've noticed is that sometimes the DQBUF ioctl will return
-EINVAL. I traced this back in the code and it appears this occurs with
the error message "stream running..." I'm not clear what this means.


Thanks for any help,
Jon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
