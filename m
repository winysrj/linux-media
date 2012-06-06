Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53713 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab2FFHxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 03:53:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 01/12] v4l: vb2-dma-contig: let mmap method to use dma_mmap_coherent call
Date: Wed, 06 Jun 2012 09:53:48 +0200
Message-ID: <33476917.D7DqGc5eti@avalon>
In-Reply-To: <1337778455-27912-2-git-send-email-t.stanislaws@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <1337778455-27912-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wednesday 23 May 2012 15:07:24 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Let mmap method to use dma_mmap_coherent call.  This patch depends on DMA
> mapping redesign patches because the usage of dma_mmap_coherent breaks
> dma-contig allocator for architectures other than ARM and AVR.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Could you please squash 10/12 into this patch ? Then, for both,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

