Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54907 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab1HXJEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 05:04:20 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQF002ILD768W@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Aug 2011 10:04:18 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQF00C6KD756F@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Aug 2011 10:04:17 +0100 (BST)
Date: Wed, 24 Aug 2011 11:04:14 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: More vb2 notes
In-reply-to: <201108231554.12786.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: 'Pawel Osciak' <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <019901cc623c$cbd167c0$63743740$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <201108231554.12786.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tuesday, August 23, 2011 3:54 PM Hans Verkuil wrote:

> I've been converting a Cisco internal driver to vb2 and while doing that I
> found a few issues.
> 
> 1) I noticed that struct vb2_buffer doesn't have a list_head that the driver
> can use to hook it in its dma queue. That forces you to make your own
> buffer struct just to have your own list_head.

This is done on purpose to keep clear separation between videobuf2 internal
entries and the entries altered by the driver. Drivers usually embed struct
vb2_buffer into their own structure, so adding a struct list head entry there
is not a problem anyway.

I really hated the old videobuf for the fact that it messed around driver's 
list entries (and requiring drivers to mess with videobuf list entries as 
well).
 
> I think vb2_buffer should either get a driver_entry or the 'done_entry' field
> can be assigned for driver use (since a buffer can't be owned by the driver
> and be on the done list at the same time). I abused 'done_entry' for now.

Please don't do it! One more struct list_head doesn't really cost much.
Using separate entry makes also the code much easier to understand.

> 2) videobuf2-dma-sg.c no longer calls dma_(un)map_sg()! The old
> videobuf-dma-sg.c did that for you. Is there any reason for this change?
> I had to manually add it to my driver.

Right, this has been changed mainly because we had no experience with dma
sg api. You are right that this should be moved back to the memory allocator.
This can be done together with adding new memory allocator ops for buffer
synchronization (buf_prepare/buf_finish), so dma_sync_* operations will be
also moved to the allocator.

> 3) videobuf2-core.c uses this in __fill_v4l2_buffer:
> 
>         if (vb->num_planes_mapped == vb->num_planes)
>                 b->flags |= V4L2_BUF_FLAG_MAPPED;
> 
> However, I see no code that ever decreases num_planes_mapped. And I also
> wonder what happens if vb2_mmap is called multiple times: num_planes_mapped
> will be increased so vb->num_planes_mapped > vb->num_planes and the MAPPED
> flag is no longer set.
> 
> This is a particular problem with libv4l2 since that tests for the MAPPED
> flag and will refuse e.g. format changes if it is set.

Hmmm. I didn't know that there is anything that relies on the MAPPED flag. 
I will add support for this missing feature/bug asap.

> 4) It is not clear to me when vb2_queue_release should be called. Is it in
> close() when you close a filehandle that was used for streaming?

Yes, this is the best place to call it.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


