Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18K6fB8003752
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 15:06:41 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m18K68QD002054
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 15:06:08 -0500
Date: Fri, 8 Feb 2008 21:06:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080208104635.4a7c9227@gaivota>
Message-ID: <Pine.LNX.4.64.0802082101500.8364@axis700.grange>
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

> If you disable all things on arch/pxa, but v4l (and the minimum required
> dependencies), do it compile and work? If so, this would be ok. Otherwise, you
> may need something like:
> depends on PCI || (ARCH_PXA && CONFIG_HAS_DMA)
> 
> This approach can be an interim solution.

After this patch

http://lkml.org/lkml/2008/2/8/352

is accepted, videobuf-dma-sg should be fine depending on PCI || PXA. I'll 
wait a day or too and then submit such a patch instead of the previous 
one, removing the dependency completely, would this be ok?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
