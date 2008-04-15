Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FEBIKJ015924
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 10:11:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3FEApfJ017927
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 10:11:02 -0400
Date: Tue, 15 Apr 2008 11:10:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <bphilips@suse.de>
Message-ID: <20080415111044.5ac8b719@gaivota>
In-Reply-To: <20080415021558.GA22068@plankton.ifup.org>
References: <patchbomb.1206699511@localhost>
	<ab74ebf10c01d6a8a54a.1206699517@localhost>
	<20080405131236.7c083554@gaivota>
	<20080406080011.GA3596@plankton.ifup.org>
	<20080407183226.703217fc@gaivota>
	<20080408152238.GA8438@plankton.public.utexas.edu>
	<20080408154046.36766131@gaivota>
	<20080408204514.GA6844@plankton.public.utexas.edu>
	<20080408183740.143c3dee@gaivota>
	<20080415021558.GA22068@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: [PATCH 6 of 9] videobuf-vmalloc.c: Fix hack of postponing mmap
 on remap failure
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


> 
> Sorry for taking a while to get back to you.
> 
> With my patch and this little change it is possible to QBUF before
> running mmap().  This causes dma-sg devices to use a bounce buffer if
> QBUF is done before being mmap'd.

Interesting. However, I don't see much advantages of doing that, especially if
this behaviour will work only with dma-sg drivers. I think that the better is
to require mmap() before QBUF at V4L2 API.

We have a bad experience with V4L1 apps that were abusing on relaxed checks at
the API. Those apps (like vlc) first starts streaming, then changes the buffer
size, by altering the image size. This bad behaviour is still not supported by
V4L1 compat layer.

IMO, the V4L2 API should define the valid command order of ioctls for stream to
work.


> The current code on em28xx-vb is canceling the entire queue when one
> buffer is unmapped.

Yes.

> This is certainly not what an application would
> expect:
> 
> http://linuxtv.org/hg/~mchehab/em28xx-vb/rev/e1a2b9e33bd2

Hmm.. I think I got your point. It should be cancelling only the affected
buffer. I can't see any sense of continuing the stream for the cancelled
buffer.
 
> It is clear now that we need to do reference counting on the buffers.
> 
> Reference takers:
>  - reqbuf
>  - vm_open
>  - driver when it grabs buffer from queue
> 
> Reference releasers:
>  - streamoff
>  - vm_close
>  - driver when it finishes with buffer
> 
> Does that seem sane?  I will submit a patch tomorrow.

It seems sane.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
