Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3566 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331Ab3CHJWN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 04:22:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Federico Vaga <federico.vaga@gmail.com>
Subject: [REVIEW PATCH 0/2] Add gfp_flags + silence vb2-dma-sg
Date: Fri,  8 Mar 2013 10:21:55 +0100
Message-Id: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series makes two modifications to videobuf2: the first adds the
gfp_flags field allowing us to easily convert drivers that need GFP_DMA or
__GFP_DMA32 to vb2. The stops the vb2-dma-sg module from logging every time
buffers are allocating or released. Instead add a debug option.

Marek, I understood from our earlier discussion that you are OK with doing
it this way for now. If you can Ack this, then that would be great as that
allows me to make a pull request for my solo driver changes.

One question: I'm OR-ing gfp_flags for dma-contig and dma-sg, but also in
vmalloc. I'm not sure about the last one. I did it for consistency, but it
is pretty useless, so if you think it is better to drop the vmalloc change,
then that's no problem. Your call.

Regards,

	Hans

