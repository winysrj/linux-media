Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:54209 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757056Ab2ILKdG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 06:33:06 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Armando VISCONTI <armando.visconti@st.com>,
	Shiraz HASHIM <shiraz.hashim@st.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Date: Wed, 12 Sep 2012 18:32:16 +0800
Subject: RE: Using MMAP calls on a video capture device having underlying
 NOMMU arch
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FB1E692B3@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FB084B206@EAPEX1MAIL1.st.com>
 <CAHG8p1DnP_=AwS6t8LAftFu=OyWAjX5hp=sYcQD4kpJ7fAaDRg@mail.gmail.com>
In-Reply-To: <CAHG8p1DnP_=AwS6t8LAftFu=OyWAjX5hp=sYcQD4kpJ7fAaDRg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

> -----Original Message-----
> From: Scott Jiang [mailto:scott.jiang.linux@gmail.com]
> Sent: Wednesday, September 12, 2012 3:09 PM
> To: Bhupesh SHARMA
> Cc: linux-media@vger.kernel.org; Laurent Pinchart; Armando VISCONTI;
> Shiraz HASHIM; m.szyprowski@samsung.com; uclinux-dist-
> devel@blackfin.uclinux.org
> Subject: Re: Using MMAP calls on a video capture device having
> underlying NOMMU arch
> 
> >
> > Now, I see that the requested videobuffers are correctly allocated
> via 'vb2_dma_contig_alloc'
> > call (see [3] for reference). But the MMAP call fails in
> 'vb2_dma_contig_alloc' function
> > in mm/nommu.c (see [4] for reference) when it tries to make the
> following check:
> >
> >         if (addr != (pfn << PAGE_SHIFT))
> >                 return -EINVAL;
> >
> > I address Scott also, as I see that he has worked on the Blackfin
> v4l2 capture driver using
> > DMA contiguous method and may have seen this issue (on a NOMMU
> system) with a v4l2 application
> > performing a MMAP operation.
> >
> > Any comments on what I could be doing wrong here?
> >
> 
> int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
>                 unsigned long pfn, unsigned long size, pgprot_t prot)
> {
>         if ((addr & PAGE_MASK) != (pfn << PAGE_SHIFT))
>                 return -EINVAL;
> 
>         vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
>         return 0;
> }
> 
> This patch seems not in current kernel. Hope it can resolve your
> problem.

Thanks for your pointer.
I already referred to this modification a couple of days ago from the Blackfin ucLinux implementation
(http://blackfin.uclinux.org/git/?p=linux-kernel;a=blob;f=mm/nommu.c;h=50dc42ec5f71d56fb418a4adfc3169c2f2e930ce;hb=HEAD)
and can now safely say the MMAP works fine for all v4l2 drivers on my NOMMU architecture
based SoC as well :)

BTW, I was wondering whether a patch for the same is already in the pipe to be included
in the latest linux kernel, because this is a really important fix for MMAP IO method
to work on NOMMU systems (so probably this patch should also be cc'ed to stable kernel list). 

Till then I think this discussion can help others who see a similar issue on their
NOMMU systems.

Regards,
Bhupesh

