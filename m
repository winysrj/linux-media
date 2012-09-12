Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45885 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2ILJip (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 05:38:45 -0400
Received: by obbuo13 with SMTP id uo13so2300863obb.19
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 02:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FB084B206@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FB084B206@EAPEX1MAIL1.st.com>
Date: Wed, 12 Sep 2012 17:38:44 +0800
Message-ID: <CAHG8p1DnP_=AwS6t8LAftFu=OyWAjX5hp=sYcQD4kpJ7fAaDRg@mail.gmail.com>
Subject: Re: Using MMAP calls on a video capture device having underlying
 NOMMU arch
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Armando VISCONTI <armando.visconti@st.com>,
	Shiraz HASHIM <shiraz.hashim@st.com>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Now, I see that the requested videobuffers are correctly allocated via 'vb2_dma_contig_alloc'
> call (see [3] for reference). But the MMAP call fails in 'vb2_dma_contig_alloc' function
> in mm/nommu.c (see [4] for reference) when it tries to make the following check:
>
>         if (addr != (pfn << PAGE_SHIFT))
>                 return -EINVAL;
>
> I address Scott also, as I see that he has worked on the Blackfin v4l2 capture driver using
> DMA contiguous method and may have seen this issue (on a NOMMU system) with a v4l2 application
> performing a MMAP operation.
>
> Any comments on what I could be doing wrong here?
>

int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
                unsigned long pfn, unsigned long size, pgprot_t prot)
{
        if ((addr & PAGE_MASK) != (pfn << PAGE_SHIFT))
                return -EINVAL;

        vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
        return 0;
}

This patch seems not in current kernel. Hope it can resolve your problem.
