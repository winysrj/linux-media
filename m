Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m56FKtbU030272
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 11:20:55 -0400
Received: from smtp206.iad.emailsrvr.com (smtp206.iad.emailsrvr.com
	[207.97.245.206])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m56FKjXL029883
	for <video4linux-list@redhat.com>; Fri, 6 Jun 2008 11:20:45 -0400
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080605180748.0b8f81cd@gaivota>
References: <1212675977.16563.24.camel@localhost.localdomain>
	<20080605180748.0b8f81cd@gaivota>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:29:52 -0400
Message-Id: <1212762592.16563.54.camel@localhost.localdomain>
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


On Thu, 2008-06-05 at 18:07 -0300, Mauro Carvalho Chehab wrote:
> Does your device support DMA scatter/gather mode (e.g. instead of a continuous
> DMA memory, you would be using a range of non-continuous memory areas)? If not,
> then you'll need to write a different video-buf driver.

I am writing code for both sides, the DSP on the PCI board and the
driver in the linux kernel. The dsp has functionality to write data over
the PCI bus, and I could certainly code this to work in discontinuous
chunks. So I believe it could use sg lists.


> The simplest driver is vivi.c. Yet, it uses videobuf-vmalloc, which is a little
> bit different. However, since this is a fake device, it helps to understand how
> videobuf works. If you get into vivi.c previous versions, at mercurial repo,
> you'll find even a vivi example using the video-buf-dma-sg. Most of stuff
> will be similar. 
> 
> The other two examples for PCI devices are saa7134-video and cx88-video. bttv
> also uses it, but bttv driver is more complex to understand, since its code is
> bigger.

Thanks for pointing these devices out. I will study these and see how
things turn out.

Thanks again,
Jon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
