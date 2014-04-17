Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:43078 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471AbaDQNNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 09:13:17 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4600M2OFE4CA40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Apr 2014 09:13:16 -0400 (EDT)
Date: Thu, 17 Apr 2014 10:13:10 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
Message-id: <20140417101310.0111d236@samsung.com>
In-reply-to: <534FA3BF.2010308@xs4all.nl>
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl>
 <1394454049-12879-4-git-send-email-hverkuil@xs4all.nl>
 <20140416192343.30a5a8fc@samsung.com> <534F0553.2000808@xs4all.nl>
 <20140416231730.6252aae7@samsung.com> <534FA3BF.2010308@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Apr 2014 11:49:51 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/17/2014 04:17 AM, Mauro Carvalho Chehab wrote:
> > Em Thu, 17 Apr 2014 00:33:55 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 04/17/2014 12:23 AM, Mauro Carvalho Chehab wrote:
> >>> Em Mon, 10 Mar 2014 13:20:49 +0100
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>
> >>>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>>
> >>>> Convert the saa7134 driver to vb2.
> >>>>
> >>>> Note that while this uses the vb2-dma-sg version, the VB2_USERPTR mode is
> >>>> disabled. The DMA hardware only supports DMAing full pages, and in the
> >>>> USERPTR memory model the first and last scatter-gather buffer is almost
> >>>> never a full page.
> >>>>
> >>>> In practice this means that we can't use the VB2_USERPTR mode.
> >>>
> >>> Why not? Provided that the buffer is equal or bigger than the number of
> >>> pages required by saa7134, that should be OK.
> >>>
> >>> All the driver needs to do is to check if the USERPTR buffer condition is met,
> >>> returning an error otherwise (and likely printing a msg at dmesg).
> >>
> >> Yuck. Well, I'll take a look at this.
> >>
> >> It has in my view the same problem as abusing USERPTR to pass pointers to
> >> physically contiguous memory: yes, it 'supports' USERPTR, but it has additional
> >> requirements which userspace has no way of knowing or detecting.
> >>
> >> It's really not USERPTR at all, it is PAGE_ALIGNED_USERPTR.
> >>
> >> Quite different.
> > 
> > Hmm... If I remember well, mmapped memory (being userptr or not) are always
> > page aligned, at least on systems with MMU.
> 
> Not malloc()ed memory. That's what userptr is about.

Take a look at videobuf_dma_init_user_locked at
drivers/media/v4l2-core/videobuf-dma-sg.c:

	first = (data          & PAGE_MASK) >> PAGE_SHIFT;
	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
	dma->offset = data & ~PAGE_MASK;
	dma->size = size;
	dma->nr_pages = last-first+1;
	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page *), GFP_KERNEL);

The physical memory is always page aligned, even if VM memory isn't.
The offset there is actually used just to subtract the size, at
videobuf_pages_to_sg().

So, with VB1, USERPTR works fine, and no special care is needed on
userspace to align the offset.

Btw, it seems that VB2 also does the same. Take a look at
vb2_dma_sg_get_userptr().

> >> I would prefer that you have to enable it explicitly through e.g. a module option.
> >> That way you can still do it, but you really have to know what you are doing.
> >>
> >>> I suspect that this change will break some userspace programs used
> >>> for video surveillance equipment.
> >>>
> >>>> This has been tested with raw video, compressed video, VBI, radio, DVB and
> >>>> video overlays.
> >>>>
> >>>> Unfortunately, a vb2 conversion is one of those things you cannot split
> >>>> up in smaller patches, it's all or nothing. This patch switches the whole
> >>>> driver over to vb2, using the vb2 ioctl and fop helper functions.
> >>>
> >>> Not quite true. This patch contains lots of non-vb2 stuff, like:
> >>> 	- Coding Style fixes;
> >>> 	- Removal of res_get/res_set/res_free;
> >>> 	- Functions got moved from one place to another one.
> >>
> >> I will see if there is anything sensible that I can split up. I'm not aware
> >> of any particular coding style issues, but I'll review it.
> > 
> > There are several, like:
> > 
> > -	dprintk("buffer_finish %p\n",q->curr);
> > +	dprintk("buffer_finish %p\n", q->curr);
> > 
> > Also, it seems that you moved some functions, like:
> > 
> > ts_reset_encoder(struct saa7134_dev* dev) that was moved
> > to some other part of the code and renamed as stop_streaming().
> > 
> > There are several of such cases, with makes hard to really see the
> > VB2 changes, and what it might be some code dropped by mistake.
> > 
> >>
> >> The removal of the resource functions is not something I can split up. It
> >> is replaced by the resource handling that's built into the vb2 helper functions.
> > 
> > Well, currently, it is really hard to see that all the checks between
> > empress and normal video streams are still done right, as the patch
> > become big and messy.
> 
> The original checks were never correct. This driver was buggy as hell once
> you tried to use multiple streams at the same time.
> 
> I have split it up some more, but the actual vb2 conversion remains a big
> patch.

Ok.

> Regards,
> 
> 	Hans
> 
> > 
> > Please try to break it into a more granular set of patches that
> > would help to check if everything is there.
> > 
> > Thanks,
> > Mauro
> > 
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>> It is really hard to review it, as is, as the real changes are mixed with
> >>> the above code cleanups/changes.
> >>>
> >>> Please split this patch in a way that it allows reviewing the changes
> >>> there.

-- 

Regards,
Mauro
