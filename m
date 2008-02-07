Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17KZBVa012251
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:35:11 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m17KYetd029794
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 15:34:40 -0500
Date: Thu, 7 Feb 2008 18:34:09 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080207183409.3e788533@gaivota>
In-Reply-To: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
References: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
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

Hi Guennadi,

> thanks for pulling the soc_camera patches, what I am not sure about, have 
> you also pulled these two:
> 
> http://marc.info/?l=linux-video&m=120179057030853&w=2

I suspect that this patch is wrong, since some CONFIG_foo is needed for
videobuf-dma-sg to work properly.

Maybe CONFIG_HAS_DMA ?

Yet, videobuf-dma-sg seems to still have some specific PCI stuff inside, due to
this:
	#include <linux/pci.h>

If the above line is removed, you'll see a large amount of errors:

/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: warning: 'struct pci_dev' declared inside parameter list
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: warning: its scope is only this definition or declaration, which is probably not what you want
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:121: warning: 'struct pci_dev' declared inside parameter list
/home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_init_user_locked':
/home/v4l/master/v4l/videobuf-dma-sg.c:144: error: 'PCI_DMA_FROMDEVICE' undeclared (first use in this function)
/home/v4l/master/v4l/videobuf-dma-sg.c:144: error: (Each undeclared identifier is reported only once
/home/v4l/master/v4l/videobuf-dma-sg.c:144: error: for each function it appears in.)
/home/v4l/master/v4l/videobuf-dma-sg.c:145: error: 'PCI_DMA_TODEVICE' undeclared (first use in this function)
/home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_map':
/home/v4l/master/v4l/videobuf-dma-sg.c:248: error: implicit declaration of function 'pci_map_sg'
/home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_sync':
/home/v4l/master/v4l/videobuf-dma-sg.c:272: error: implicit declaration of function 'pci_dma_sync_sg_for_cpu'
/home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_unmap':
/home/v4l/master/v4l/videobuf-dma-sg.c:285: error: implicit declaration of function 'pci_unmap_sg'
/home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_free':
/home/v4l/master/v4l/videobuf-dma-sg.c:313: error: 'PCI_DMA_NONE' undeclared (first use in this function)
/home/v4l/master/v4l/videobuf-dma-sg.c: At top level:
/home/v4l/master/v4l/videobuf-dma-sg.c:319: warning: 'struct pci_dev' declared inside parameter list
/home/v4l/master/v4l/videobuf-dma-sg.c:320: error: conflicting types for 'videobuf_pci_dma_map'
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: error: previous declaration of 'videobuf_pci_dma_map' was here
/home/v4l/master/v4l/videobuf-dma-sg.c:328: warning: 'struct pci_dev' declared inside parameter list
/home/v4l/master/v4l/videobuf-dma-sg.c:329: error: conflicting types for 'videobuf_pci_dma_unmap'
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:121: error: previous declaration of 'videobuf_pci_dma_unmap' was here
/home/v4l/master/v4l/videobuf-dma-sg.c: In function '__videobuf_iolock':
/home/v4l/master/v4l/videobuf-dma-sg.c:503: error: 'PCI_DMA_FROMDEVICE' undeclared (first use in this function)
/home/v4l/master/v4l/videobuf-dma-sg.c: At top level:
/home/v4l/master/v4l/videobuf-dma-sg.c:757: error: conflicting types for 'videobuf_pci_dma_map'
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: error: previous declaration of 'videobuf_pci_dma_map' was here
/home/v4l/master/v4l/videobuf-dma-sg.c:758: error: conflicting types for 'videobuf_pci_dma_unmap'
/home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:121: error: previous declaration of 'videobuf_pci_dma_unmap' was here

I suspect that you'll need to do some work for it to fully use the generic dma api.

> http://marc.info/?l=linux-video&m=120179045830566&w=2

Hmm... I think I asked your sob for this. Maybe I've lost the e-mail with your
sob. Please, send it again, and I'll commit.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
