Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1LKIZcU021529
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 15:18:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1LKI3lL011123
	for <video4linux-list@redhat.com>; Thu, 21 Feb 2008 15:18:03 -0500
Date: Thu, 21 Feb 2008 21:18:19 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
In-Reply-To: <Pine.LNX.4.64.0802191317370.6077@axis700.grange>
Message-ID: <Pine.LNX.4.64.0802212115270.7967@axis700.grange>
References: <Pine.LNX.4.64.0802191317370.6077@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
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

On Tue, 19 Feb 2008, Guennadi Liakhovetski wrote:

> videobuf-dma-sg does not need to depend on PCI. Switch it to using generic 
> DMA API, convert all affected drivers, relax Kconfig restriction, improve 
> compile-time type checking, fix some Coding Style violations while at it.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de

Forgot to mention - tested on a PC with a bt878 PCI radr and on my PXA270 
development system with soc-camera. So, please test further and consider 
for inclusion.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
