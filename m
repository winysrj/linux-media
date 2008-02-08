Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m18BT1Od006981
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 06:29:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m18BSYgm009488
	for <video4linux-list@redhat.com>; Fri, 8 Feb 2008 06:28:34 -0500
Date: Fri, 8 Feb 2008 09:28:21 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080208092821.52872e1d@gaivota>
In-Reply-To: <Pine.LNX.4.64.0802072146210.9064@axis700.grange>
References: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
	<20080207183409.3e788533@gaivota>
	<Pine.LNX.4.64.0802072146210.9064@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

> I think, "#include <linux/pci.h>" is needed for the current version of 
> videobuf-dma-sg.c, which, however, doesn't necessarily mean, it works only 
> on PCI-enabled platforms. Perhaps, the right fix would be to convert 
> videobuf-dma-sg.c to purely dma API. In fact, it wouldn't be a very 
> difficult task. Only these two prototypes in videobuf-dma-sg.h
> 
> int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma);
> int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma);
> 
> and their implementations in videobuf-dma-sg.c should indeed be placed 
> under #ifdef CONFIG_PCI. You would use enum dma_data_direction instead of 
> PCI_DMA_FROMDEVICE and friends, call dma mapping and syncing functions 
> directly, instead of their pci analogs, etc.

Yes. This seems to be the proper direction to me also.
> 
> Your proposal to use CONFIG_HAS_DMA might be a good interim solution. This 
> is also in a way confirmed in a comment in 
> include/asm-generic/dma-mapping-broken.h. The "dummy" pci-dma API 
> conversions are defined in include/asm-generic/pci-dma-compat.h.

I think this won't work for some platforms. I remember someone adding PCI or
other DMA dependency to some drivers, due to this (sorry, I can't remember the
details of those patches).

> Right, so, what would be your preference on this? It would be puty to hold 
> off the patches ony because of this. If you want, I can try to look into 
> converting videobuf-dma-sg.c to pci-free API, hopefully, for -rc2? And in 
> the meantime maybe we could use the CONFIG_HAS_DMA?

Touching on videobuf-dma-sg is something very sensitive, since it affects most
drivers. I would prefer to have this kind of commit happening during a
merge window.

If we can't manage to have this happening for 2.6.25 window, let's postpone the
PCI specific changesets to 2.6.26, merging they only at -mm series.

> > Hmm... I think I asked your sob for this. Maybe I've lost the e-mail with your
> > sob. Please, send it again, and I'll commit.
> 
> I did reply to that your email with my sob, but maybe you wanted a 
> complete patch again. Just resent it too.

I have a serious outage on my email provider. Maybe your message got lost
during the recovering process of my old maildir boxes.

I've committed your patch locally. It seems that linuxtv.org is not working
right now. I'll push there as soon as it returns back.

> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
