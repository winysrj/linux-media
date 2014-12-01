Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59919 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLAWqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 17:46:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 07/12] vb2-dma-sg: add dmabuf import support
Date: Tue, 02 Dec 2014 00:46:48 +0200
Message-ID: <8148639.EErVlQ7yEd@avalon>
In-Reply-To: <5476E896.1070701@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1506297.83XqYLfUIF@avalon> <5476E896.1070701@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 November 2014 10:02:14 Hans Verkuil wrote:
> On 11/26/2014 10:00 PM, Laurent Pinchart wrote:
> > On Tuesday 18 November 2014 13:51:03 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Add support for importing dmabuf to videobuf2-dma-sg.
> >> 
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> Acked-by: Pawel Osciak <pawel@osciak.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/videobuf2-dma-sg.c | 149 ++++++++++++++++++++---
> >>  1 file changed, 136 insertions(+), 13 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> >> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index f671fab..ad6d5c7
> >> 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c

[snip]

> >> @@ -183,7 +192,11 @@ static void vb2_dma_sg_put(void *buf_priv)
> >>  static void vb2_dma_sg_prepare(void *buf_priv)
> >>  {
> >>  	struct vb2_dma_sg_buf *buf = buf_priv;
> >> -	struct sg_table *sgt = &buf->sg_table;
> >> +	struct sg_table *sgt = buf->dma_sgt;
> >> +
> >> +	/* DMABUF exporter will flush the cache for us */
> >> +	if (buf->db_attach)
> >> +		return;
> > 
> > Is this actually true ? If you look at the export code in patch 08/12, I
> > don't see where the exporter would sync the buffer for the importer
> > device.
>
> I think this was true at some point in the past. It ties in with my comment
> for patch 06/12: cpu/device syncing for dma-buf is (and was) broken,
> although nobody has noticed since none of the DMABUF-aware drivers that are
> used as such today need CPU access to the buffer, or are only used on Intel
> architectures where this is all moot. Patches 12-16 of my RFCv6 series
> really fix this. This particular comment was copied from the dma-contig
> version. The basic idea was that when the driver needs CPU access it will
> call the vaddr memop, which will map the buffer for CPU access.
> 
> However, I am not sure whether dmabuf actually did the right thing there
> originally. Later dmabuf was extended with begin/end_for_cpu_access ops to
> make this explicit, but that was never implemented in vb2. That's what the
> second part of RFCv6 does.
> 
> Right now dma-sg is bug-compatible with dma-contig.
> 
> I spend 1-2 hours with Pawel in Düsseldorf figuring this out, it is not
> exactly trivial to understand.

I agree that the situation is a mess, but we'll need to fix it one way or 
another :-/ The more we wait the more painful it will be. Please note that the 
problem isn't specific to CPU access, we need to sync for the device even in 
direct device to device transfers (although in practice that shouldn't be 
strictly required with the platforms we target today).

> >>  	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >>  }

-- 
Regards,

Laurent Pinchart

