Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48424 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3CEKfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 05:35:03 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so5513682wgb.20
        for <linux-media@vger.kernel.org>; Tue, 05 Mar 2013 02:35:01 -0800 (PST)
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Pawel Osciak <p.osciak@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] Adding additional flags when allocating buffer memory
Date: Tue, 05 Mar 2013 11:34:49 +0100
Message-ID: <3247859.PQ5PWHrG8h@harkonnen>
In-Reply-To: <201303051059.50277.hverkuil@xs4all.nl>
References: <201303011944.00532.hverkuil@xs4all.nl> <5135BAC6.5050703@samsung.com> <201303051059.50277.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

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

My 2 cent

When I did the patch to add gfp_flags to the contig allocator, I did like 
Marek suggestion. But now I think that Hans solution is better because it is 
more flexible and future-proof. As Hans said, it is not a rare case and this 
patch apply to every allocator. 

/My 2 cent

-- 
Federico Vaga
