Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m55L8Kje027924
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:08:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m55L83P1023300
	for <video4linux-list@redhat.com>; Thu, 5 Jun 2008 17:08:03 -0400
Date: Thu, 5 Jun 2008 18:07:48 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: jon.dufresne@infinitevideocorporation.com
Message-ID: <20080605180748.0b8f81cd@gaivota>
In-Reply-To: <1212675977.16563.24.camel@localhost.localdomain>
References: <1212675977.16563.24.camel@localhost.localdomain>
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

On Thu, 05 Jun 2008 10:26:17 -0400
Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:

> Hi,
> 
> I'm in the process of writing my first v4l2 linux driver. I have written
> drivers in the past but this is my first time with a video device. I
> have read as much documentation as I could get my hands on.
> 
> My device is a pci capture device and I am trying to use streaming
> mmaped buffers. Right now I am trying to integrate the video-buf helper
> functions to do the actual frame grabbing. I am quite confused as how
> this all fits together. 

Does your device support DMA scatter/gather mode (e.g. instead of a continuous
DMA memory, you would be using a range of non-continuous memory areas)? If not,
then you'll need to write a different video-buf driver.
> 
> Is there a good guide on using video-buf for video dma transfer? I did
> quite a few google searches but I didn't find anything.
> 
> What is the simplest example of a capture device using video-buf for a
> streaming device in the source tree to use as an example? I've looked at
> a few, but I want to look at the simplest one.

The simplest driver is vivi.c. Yet, it uses videobuf-vmalloc, which is a little
bit different. However, since this is a fake device, it helps to understand how
videobuf works. If you get into vivi.c previous versions, at mercurial repo,
you'll find even a vivi example using the video-buf-dma-sg. Most of stuff
will be similar. 

The other two examples for PCI devices are saa7134-video and cx88-video. bttv
also uses it, but bttv driver is more complex to understand, since its code is
bigger.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
