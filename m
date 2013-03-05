Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63049 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3CEKnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 05:43:37 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJ6009LGO6JMF90@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Mar 2013 10:43:35 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MJ6003I3OGCT330@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Mar 2013 10:43:35 +0000 (GMT)
Message-id: <5135CC4C.1030905@samsung.com>
Date: Tue, 05 Mar 2013 11:43:24 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	Pawel Osciak <p.osciak@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] Adding additional flags when allocating buffer memory
References: <201303011944.00532.hverkuil@xs4all.nl>
 <5135BAC6.5050703@samsung.com> <201303051059.50277.hverkuil@xs4all.nl>
In-reply-to: <201303051059.50277.hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/5/2013 10:59 AM, Hans Verkuil wrote:
> On Tue 5 March 2013 10:28:38 Marek Szyprowski wrote:
> > Hello,
> >
> > On 3/1/2013 7:44 PM, Hans Verkuil wrote:
> > > Hi all,
> > >
> > > This patch is based on an idea from Federico:
> > >
> > > http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg24669.html
> > >
> > > While working on converting the solo6x10 driver to vb2 I realized that the
> > > same thing was needed for the dma-sg case: the solo6x10 has 32-bit PCI DMA,
> > > so you want to specify __GFP_DMA32 to prevent bounce buffers from being created.
> > >
> > > Rather than patching all drivers as the patch above does (error prone IMHO),
> > > I've decided to just add a gfp_flags field to vb2_queue and pass that to the
> > > alloc mem_op. The various alloc implementations will just OR it in.
> >
> > I agree that the gfp_flags is needed. It should be there from the
> > beginning,
> > but there is not DMA zone on our hardware and we missed that point. Our
> > fault.
> > However IMHO the better place for gfp_flags is the allocator context
> > structure
> > instead of vb2_queue. vb2_dma_contig_init_ctx() would need to be
> > extended and
> > similar function should be added for dma sg.
>
> Why is this better? It seems a huge amount of work for something that is
> useful for pretty much any allocator. Note that most PCI drivers are 32-bit
> only and need __GFP_DMA32. So this is not a rare case, it just that we
> haven't converted them yet.
>
> I don't mind doing the work, but I'd like to know the reasoning behind it.

I would like to keep the logical separation between queue and buffer 
allocators.
Putting gfp flags to vb2_queue suggests that those flags will be used for
allocating queue internal structures, what is something different from 
allocating
buffer itself.

DMA SG allocator also needs to have the context structure (which should 
contain
device pointer and gfp flags) as well as the redesign in the mapping 
approach
(the buffers should be mapped by the allocator not the driver) and the
'descriptor' structure (sgtable should be used instead of the custom 
thing).
This requires significant amount of work, so I don't expect You to do it 
atm.

For the target solution I would like to have gfp flags in the context 
structure,
but for fixing v3.9-rc / v3.8 the patch you have proposed can be used. I 
will
just rebase my work-in-progress patches on top of that one day.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


