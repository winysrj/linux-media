Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60531 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab2HUOHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 10:07:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 20/26] v4l: vb2-dma-contig: add support for DMABUF exporting
Date: Tue, 21 Aug 2012 16:07:43 +0200
Message-ID: <1855841.AYe7JyTi2E@avalon>
In-Reply-To: <50339161.9010209@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1972504.ZFxOnMN9eT@avalon> <50339161.9010209@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tuesday 21 August 2012 15:47:13 Tomasz Stanislawski wrote:
> On 08/21/2012 12:03 PM, Laurent Pinchart wrote:
> > On Tuesday 14 August 2012 17:34:50 Tomasz Stanislawski wrote:
> >> This patch adds support for exporting a dma-contig buffer using
> >> DMABUF interface.
> >> 
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> >> 
> >>  drivers/media/video/videobuf2-dma-contig.c |  204 ++++++++++++++++++++++
> >>  1 file changed, 204 insertions(+)
> >> 
> >> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> >> b/drivers/media/video/videobuf2-dma-contig.c index 7fc71a0..bb2b4ac8
> >> 100644
> >> --- a/drivers/media/video/videobuf2-dma-contig.c
> >> +++ b/drivers/media/video/videobuf2-dma-contig.c
> > 
> > [snip]
> > 
> >> +static struct sg_table *vb2_dc_dmabuf_ops_map(
> >> +	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
> >> +{
> >> +	struct vb2_dc_attachment *attach = db_attach->priv;
> >> +	/* stealing dmabuf mutex to serialize map/unmap operations */
> > 
> > Why isn't this operation serialized by the dma-buf core itself ?
> 
> Indeed, it is a very good question. The lock was introduced in RFCv3 of
> DMABUF patches. It was dedicated to serialize attach/detach calls.
> No requirements for map/unmap serialization were stated so serialization
> was delegated to an exporter.
> 
> A deadlock could occur if dma_map_attachment is called from inside
> of attach ops. IMO, such an operation is invalid because an attachment
> list is not in a valid state while attach ops is being processed.
> 
> Do you think that stealing a lock from dma-buf internals is too hacky?

No, I would be OK with that, but I'd like to make sure that it won't bite us 
back later. If there's a specific reason why the lock is not taken by the 
dmabuf core around map/unmap calls, stealing the same lock might cause 
unforeseen problems. That's why I would like to understand why the core 
doesn't perform locking on its own.

> I prefer not to introduce any extra locks in dma-contig allocator

Agreed.

> but it is not a big deal to add it.
> 
> >> +	struct mutex *lock = &db_attach->dmabuf->lock;
> >> +	struct sg_table *sgt;
> >> +	int ret;
> >> +
> >> +	mutex_lock(lock);
> >> +
> >> +	sgt = &attach->sgt;
> >> +	/* return previously mapped sg table */
> >> +	if (attach->dir == dir) {
> >> +		mutex_unlock(lock);
> >> +		return sgt;
> >> +	}
> >> +
> >> +	/* release any previous cache */
> >> +	if (attach->dir != DMA_NONE) {
> >> +		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> >> +			attach->dir);
> >> +		attach->dir = DMA_NONE;
> >> +	}
> >> +
> >> +	/* mapping to the client with new direction */
> >> +	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
> >> +	if (ret <= 0) {
> >> +		pr_err("failed to map scatterlist\n");
> >> +		mutex_unlock(lock);
> >> +		return ERR_PTR(-EIO);
> >> +	}
> >> +
> >> +	attach->dir = dir;
> >> +
> >> +	mutex_unlock(lock);
> >> +
> >> +	return sgt;
> >> +}

-- 
Regards,

Laurent Pinchart

