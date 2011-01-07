Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:36680 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1AGOWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 09:22:06 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Warren, Christina" <cawarren@ti.com>,
	"Boateng, Akwasi" <akwasi.boateng@ti.com>,
	Russell King <rmk@arm.linux.org.uk>
Date: Fri, 7 Jan 2011 08:21:46 -0600
Subject: RE: [Query][videobuf-dma-sg] Pages in Highmem handling
Message-ID: <A24693684029E5489D1D202277BE894485F30B60@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE8944719829DB@dlee02.ent.ti.com>
 <4D0F3CAB.5090501@redhat.com>
In-Reply-To: <4D0F3CAB.5090501@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Monday, December 20, 2010 5:23 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org; Warren, Christina; Boateng, Akwasi;
> Russell King
> Subject: Re: [Query][videobuf-dma-sg] Pages in Highmem handling
> 
> Hi Sergio,
> 
> Em 27-08-2010 11:57, Aguirre, Sergio escreveu:
> > Hi,
> >
> > I see that in current videobuf library, for DMA SG code, these functions
> fail when
> > Detecting a page in Highmem region:
> >
> > - videobuf_pages_to_sg
> > - videobuf_vmalloc_to_sg
> >
> > Now, what's the real reason to not allow handling of Highmem pages?
> > Is it an assumption that _always_ HighMem is not reachable by DMA?
> >
> > I guess my point is, OMAP platform (and maybe other platforms) can
> handle
> > Highmem pages without any problem. I commented these validations:
> >
> > 65 static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char
> *virt,
> > 66                                                   int nr_pages)
> > 67 {
> >
> > ...
> >
> > 77         for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
> > 78                 pg = vmalloc_to_page(virt);
> > 79                 if (NULL == pg)
> > 80                         goto err;
> > 81                 /* BUG_ON(PageHighMem(pg)); */
> >
> > ...
> >
> > 96 static struct scatterlist *videobuf_pages_to_sg(struct page **pages,
> > 97                                                 int nr_pages, int
> offset)
> > 98 {
> >
> > ...
> >
> > 109         /* if (PageHighMem(pages[0])) */
> > 110                 /* DMA to highmem pages might not work */
> > 111                 /* goto highmem; */
> > 112         sg_set_page(&sglist[0], pages[0], PAGE_SIZE - offset,
> offset);
> > 113         for (i = 1; i < nr_pages; i++) {
> > 114                 if (NULL == pages[i])
> > 115                         goto nopage;
> > 116                 /* if (PageHighMem(pages[i]))
> > 117                         goto highmem; */
> > 118                 sg_set_page(&sglist[i], pages[i], PAGE_SIZE, 0);
> > 119         }
> >
> > Can somebody shed any light on this?
> 
> Sorry for taking so long to answer you.
> 

Hey, no worries. That's fine.

> Basically, videobuf code were written at Linux 2.4 days, to be used by
> bttv driver (and later used by cx88 and saa7134). At that time, there
> where
> a hack for the usage of highmem (I think it was called bigmem or something
> like that).
> 
> As I was not maintaining the code on that time, I'm not really sure what
> where
> the issues, but I suspect that this were an arch-implementation limit
> related to DMA transfers at highmem, on that time, due to x86 intrinsic
> limits. I'm not sure about the current limits of newer x86 chips, on 32
> and on 64 bits mode, but i think that this limit doesn't exist anymore.
> 
> So, I suspect that just converting it to a call to dma_capable() should
> be enough to fix the issue.

Ok, sounds reasonable.

> 
> Yet, as videobuf2 is almost ready for merge, maybe the best is to take
> some efforts on testing it, and to be sure that it doesn't contain any
> arch-specific limits inside its code.

So, do you want me to make a patch for this, or is this already taken care
on videobuf2?

Regards,
Sergio

> 
> Cheers,
> Mauro
