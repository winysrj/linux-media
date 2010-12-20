Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:4283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0LTLXn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:23:43 -0500
Message-ID: <4D0F3CAB.5090501@redhat.com>
Date: Mon, 20 Dec 2010 09:23:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Warren, Christina" <cawarren@ti.com>,
	"Boateng, Akwasi" <akwasi.boateng@ti.com>,
	Russell King <rmk@arm.linux.org.uk>
Subject: Re: [Query][videobuf-dma-sg] Pages in Highmem handling
References: <A24693684029E5489D1D202277BE8944719829DB@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944719829DB@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

Em 27-08-2010 11:57, Aguirre, Sergio escreveu:
> Hi,
> 
> I see that in current videobuf library, for DMA SG code, these functions fail when
> Detecting a page in Highmem region:
> 
> - videobuf_pages_to_sg
> - videobuf_vmalloc_to_sg
> 
> Now, what's the real reason to not allow handling of Highmem pages?
> Is it an assumption that _always_ HighMem is not reachable by DMA?
> 
> I guess my point is, OMAP platform (and maybe other platforms) can handle
> Highmem pages without any problem. I commented these validations:
> 
> 65 static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt,
> 66                                                   int nr_pages)
> 67 {
> 
> ...
> 
> 77         for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
> 78                 pg = vmalloc_to_page(virt);
> 79                 if (NULL == pg)
> 80                         goto err;
> 81                 /* BUG_ON(PageHighMem(pg)); */
> 
> ...
> 
> 96 static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
> 97                                                 int nr_pages, int offset)
> 98 {
> 
> ...
> 
> 109         /* if (PageHighMem(pages[0])) */
> 110                 /* DMA to highmem pages might not work */
> 111                 /* goto highmem; */
> 112         sg_set_page(&sglist[0], pages[0], PAGE_SIZE - offset, offset);
> 113         for (i = 1; i < nr_pages; i++) {
> 114                 if (NULL == pages[i])
> 115                         goto nopage;
> 116                 /* if (PageHighMem(pages[i]))
> 117                         goto highmem; */
> 118                 sg_set_page(&sglist[i], pages[i], PAGE_SIZE, 0);
> 119         }
> 
> Can somebody shed any light on this?

Sorry for taking so long to answer you.

Basically, videobuf code were written at Linux 2.4 days, to be used by
bttv driver (and later used by cx88 and saa7134). At that time, there where
a hack for the usage of highmem (I think it was called bigmem or something 
like that).

As I was not maintaining the code on that time, I'm not really sure what where
the issues, but I suspect that this were an arch-implementation limit 
related to DMA transfers at highmem, on that time, due to x86 intrinsic
limits. I'm not sure about the current limits of newer x86 chips, on 32
and on 64 bits mode, but i think that this limit doesn't exist anymore.

So, I suspect that just converting it to a call to dma_capable() should 
be enough to fix the issue.

Yet, as videobuf2 is almost ready for merge, maybe the best is to take 
some efforts on testing it, and to be sure that it doesn't contain any
arch-specific limits inside its code.

Cheers,
Mauro 
