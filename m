Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2CMbUNA002981
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 18:37:30 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2CMavfZ032407
	for <video4linux-list@redhat.com>; Wed, 12 Mar 2008 18:36:57 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
In-Reply-To: <Pine.LNX.4.64.0803120831380.3804@axis700.grange>
References: <47C40563.5000702@claranet.fr> <47D24404.9050708@claranet.fr>
	<Pine.LNX.4.64.0803081026230.3639@axis700.grange>
	<47D3A2AA.7040608@claranet.fr>
	<Pine.LNX.4.64.0803091204060.3408@axis700.grange>
	<Pine.LNX.4.64.0803112257260.9070@axis700.grange>
	<1205281392.5927.117.camel@pc08.localdom.local>
	<Pine.LNX.4.64.0803120831380.3804@axis700.grange>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 23:28:55 +0100
Message-Id: <1205360935.5924.9.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: kernel oops since changeset e3b8fb8cc214
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

Hi Guennadi,

Am Mittwoch, den 12.03.2008, 08:34 +0100 schrieb Guennadi Liakhovetski:
> Hi Hermann,
> 
> On Wed, 12 Mar 2008, hermann pitton wrote:
> 
> > you are definitely going into the right direction, as it was meant
> > already years back and also like Mauro did pick it up.
> 
> You mean this has already been discussed before? Have you got links to 
> ML-archive threads?

it came up over the time that video-buf can be utilized for more then
only bttv and saa7134. It changed somehow from Gerd's early comment here

/*
 * generic helper functions for video4linux capture buffers, to handle
 * memory management and PCI DMA.  Right now bttv + saa7134 use it.
 *
 * The functions expect the hardware being able to scatter gatter
 * (i.e. the buffers are not linear in physical memory, but fragmented
 * into PAGE_SIZE chunks).  They also assume the driver does not need
 * to touch the video data (thus it is probably not useful for USB 1.1
 * as data often must be uncompressed by the drivers).
 * 
 * (c) 2001-2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]

to "make use of it when you can", for example with the then upcoming USB
2.0 and the hybrid devices.

> > Don't take any rants seriously, but we just need something to settle
> > down in between safely until the next steps can be achieved.
> 
> No problem, just trying to help solve the puzzle and wondering how my 
> patch could have triggered this.

Hopefully can be found soon, can't even trigger it on my saa7134 stuff.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
