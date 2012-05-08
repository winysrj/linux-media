Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49148 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2EHFlS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 01:41:18 -0400
Message-ID: <4FA8B1F4.2000200@gmail.com>
Date: Tue, 08 May 2012 11:11:08 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, mchehab@redhat.com, linux-doc@vger.kernel.org,
	g.liakhovetski@gmx.de,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: Re: [PATCHv5 08/13] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
References: <1334933134-4688-1-git-send-email-t.stanislaws@samsung.com> <1334933134-4688-9-git-send-email-t.stanislaws@samsung.com> <4FA7DE61.7000705@gmail.com> <4FA7E623.2060500@samsung.com>
In-Reply-To: <4FA7E623.2060500@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomasz,

I have extended the MFC-FIMC testcase posted by Kamil sometime ago to 
sanity test the UMM patches. This test is multi-threaded(further 
explanation for developers who may not have seen it yet), where thread 
one parses the encoded stream and feeds into the codec  IP driver(aka 
MFC driver). Second thread will dequeue the buffer from MFC driver 
(DMA_BUF export) and queues it into a CSC IP(aka FIMC) driver(DMA_BUF 
import). Third thread dequeues the frame from FIMC driver and either 
pushes it into LCD driver for display or dumps to a flat file for analysis.

MFC driver exports the fd's and FIMC driver imports and attaches it. 
During FIMC QBUF (thats when the attach and map happens), it is observed 
that in the function vb2_dc_map_dmabuf() call to 
vb2_dc_get_contiguous_size() fails. This is because contig_size < 
buf->size. contig_size is calculated from the SGT which we would have 
constructed in the function vb2_dc_pages_to_sgt().

Let me know if you need more details.

Regards,
Subash

On 05/07/2012 08:41 PM, Tomasz Stanislawski wrote:
> Hi Subash,
> Could you provide a detailed description of a test case
> that causes a failure of vb2_dc_pages_to_sgt?
>
> Regards,
> Tomasz Stanislawski
