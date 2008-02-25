Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1P4EDjo023377
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 23:14:13 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1P4Dg5R002410
	for <video4linux-list@redhat.com>; Sun, 24 Feb 2008 23:13:42 -0500
Date: Mon, 25 Feb 2008 01:11:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080225011156.198a6df9@areia>
In-Reply-To: <Pine.LNX.4.64.0802212115270.7967@axis700.grange>
References: <Pine.LNX.4.64.0802191317370.6077@axis700.grange>
	<Pine.LNX.4.64.0802212115270.7967@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Convert videobuf-dma-sg to generic DMA API
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

On Thu, 21 Feb 2008 21:18:19 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@pengutronix.de> wrote:

> On Tue, 19 Feb 2008, Guennadi Liakhovetski wrote:
> 
> > videobuf-dma-sg does not need to depend on PCI. Switch it to using generic 
> > DMA API, convert all affected drivers, relax Kconfig restriction, improve 
> > compile-time type checking, fix some Coding Style violations while at it.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de
> 
> Forgot to mention - tested on a PC with a bt878 PCI radr and on my PXA270 
> development system with soc-camera. So, please test further and consider 
> for inclusion.

Tested here on a saa7134 pcmcia board. Seems OK. I've committed the changeset.
Thanks.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
