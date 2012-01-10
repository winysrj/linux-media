Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:42628 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab2AJBek convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2012 20:34:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAF6AEGsTGOxyTX6Xijvm8UXGjtVTtYg5X5xfJo8D+47o+xU+bA@mail.gmail.com>
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com>
	<1322816252-19955-2-git-send-email-sumit.semwal@ti.com>
	<CAAQKjZPFh6666JKc-XJfKYePQ_F0MNF6FkY=zKypWb52VVX3YQ@mail.gmail.com>
	<20120109081030.GA3723@phenom.ffwll.local>
	<CAAQKjZMEsuib18RYE7OvZPUqhKnvrZ8i3+EMuZSXr9KPVygo_Q@mail.gmail.com>
	<CAF6AEGsTGOxyTX6Xijvm8UXGjtVTtYg5X5xfJo8D+47o+xU+bA@mail.gmail.com>
Date: Tue, 10 Jan 2012 10:34:39 +0900
Message-ID: <CAAQKjZNM51Oenhi-S-9kyq_mLYHBEsMQA3M6=6L_XNnKu5pLbA@mail.gmail.com>
Subject: Re: [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
From: InKi Dae <daeinki@gmail.com>
To: Rob Clark <rob@ti.com>
Cc: Sumit Semwal <sumit.semwal@ti.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de,
	jesse.barker@linaro.org, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>,
	daniel@ffwll.ch
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/1/10 Rob Clark <rob@ti.com>:
> On Mon, Jan 9, 2012 at 4:10 AM, InKi Dae <daeinki@gmail.com> wrote:
>> note : in case of sharing a buffer between v4l2 and drm driver, the
>> memory info would be copied vb2_xx_buf to xx_gem or xx_gem to
>> vb2_xx_buf through sg table. in this case, only memory info is used to
>> share, not some objects.
>
> which v4l2/vb2 patches are you looking at? �The patches I was using,
> vb2 holds a reference to the 'struct dma_buf *' internally, not just
> keeping the sg_table
>

yes, not keeping the sg_table. I mean... see a example below please.

static void vb2_dma_contig_map_dmabuf(void *mem_priv)
{
    struct sg_table *sg;
     ...
     sg = dma_buf_map_attachment(buf->db_attach, dir);
     ...
     buf->dma_addr = sg_dma_address(sg->sgl);
     ...
}

at least with no IOMMU, the memory information(containing physical
memory address) would be copied to vb2_xx_buf object if drm gem
exported its own buffer and vb2 wants to use that buffer at this time,
sg table is used to share that buffer. and the problem I pointed out
is that this buffer(also physical memory region) could be released by
vb2 framework(as you know, vb2_xx_buf object and the memory region for
buf->dma_addr pointing) but the Exporter(drm gem) couldn't know that
so some problems would be induced once drm gem tries to release or
access that buffer. and I have tried to resolve this issue adding
get_shared_cnt() callback to dma-buf.h but I'm not sure that this is
good way. maybe there would be better way.

Thanks.

> BR,
> -R
