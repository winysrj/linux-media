Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m17Lhk0e008544
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 16:43:46 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m17LhDd1007643
	for <video4linux-list@redhat.com>; Thu, 7 Feb 2008 16:43:13 -0500
Date: Thu, 7 Feb 2008 22:43:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080207183409.3e788533@gaivota>
Message-ID: <Pine.LNX.4.64.0802072146210.9064@axis700.grange>
References: <Pine.LNX.4.64.0802071617420.5383@axis700.grange>
	<20080207183409.3e788533@gaivota>
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

On Thu, 7 Feb 2008, Mauro Carvalho Chehab wrote:

> Hi Guennadi,
> 
> > thanks for pulling the soc_camera patches, what I am not sure about, have 
> > you also pulled these two:
> > 
> > http://marc.info/?l=linux-video&m=120179057030853&w=2
> 
> I suspect that this patch is wrong, since some CONFIG_foo is needed for
> videobuf-dma-sg to work properly.
> 
> Maybe CONFIG_HAS_DMA ?
> 
> Yet, videobuf-dma-sg seems to still have some specific PCI stuff inside, due to
> this:
> 	#include <linux/pci.h>
> 
> If the above line is removed, you'll see a large amount of errors:
> 
> /home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: warning: 'struct pci_dev' declared inside parameter list
> /home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:120: warning: its scope is only this definition or declaration, which is probably not what you want
> /home/v4l/master/v4l/../linux/include/media/videobuf-dma-sg.h:121: warning: 'struct pci_dev' declared inside parameter list
> /home/v4l/master/v4l/videobuf-dma-sg.c: In function 'videobuf_dma_init_user_locked':
> /home/v4l/master/v4l/videobuf-dma-sg.c:144: error: 'PCI_DMA_FROMDEVICE' undeclared (first use in this function)
[trimmed]

I think, "#include <linux/pci.h>" is needed for the current version of 
videobuf-dma-sg.c, which, however, doesn't necessarily mean, it works only 
on PCI-enabled platforms. Perhaps, the right fix would be to convert 
videobuf-dma-sg.c to purely dma API. In fact, it wouldn't be a very 
difficult task. Only these two prototypes in videobuf-dma-sg.h

int videobuf_pci_dma_map(struct pci_dev *pci,struct videobuf_dmabuf *dma);
int videobuf_pci_dma_unmap(struct pci_dev *pci,struct videobuf_dmabuf *dma);

and their implementations in videobuf-dma-sg.c should indeed be placed 
under #ifdef CONFIG_PCI. You would use enum dma_data_direction instead of 
PCI_DMA_FROMDEVICE and friends, call dma mapping and syncing functions 
directly, instead of their pci analogs, etc.

Your proposal to use CONFIG_HAS_DMA might be a good interim solution. This 
is also in a way confirmed in a comment in 
include/asm-generic/dma-mapping-broken.h. The "dummy" pci-dma API 
conversions are defined in include/asm-generic/pci-dma-compat.h. Now

grep -r pci-dma-compat.h include/asm*
include/asm/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-arm/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-cris/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-frv/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-ia64/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-mips/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-parisc/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-powerpc/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-ppc/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-sh/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-x86/pci.h:#include <asm-generic/pci-dma-compat.h>
include/asm-xtensa/pci.h:#include <asm-generic/pci-dma-compat.h>

and

grep "[^_]NO_DMA" `find . -name "Kconfig*"`
./lib/Kconfig:  depends on !NO_DMA
./arch/h8300/Kconfig:config NO_DMA
./arch/cris/Kconfig:config NO_DMA
./arch/m32r/Kconfig:config NO_DMA
./arch/m68k/Kconfig:config NO_DMA
./arch/sparc/Kconfig:config NO_DMA
./arch/s390/Kconfig:config NO_DMA

So, the only intersection is cris... And it really confuses me. And there 
are a couple more platforms that don't do either, like alpha, avr32, 
blackfin,...

> I suspect that you'll need to do some work for it to fully use the generic dma api.

Right, so, what would be your preference on this? It would be puty to hold 
off the patches ony because of this. If you want, I can try to look into 
converting videobuf-dma-sg.c to pci-free API, hopefully, for -rc2? And in 
the meantime maybe we could use the CONFIG_HAS_DMA?

> > http://marc.info/?l=linux-video&m=120179045830566&w=2
> 
> Hmm... I think I asked your sob for this. Maybe I've lost the e-mail with your
> sob. Please, send it again, and I'll commit.

I did reply to that your email with my sob, but maybe you wanted a 
complete patch again. Just resent it too.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
