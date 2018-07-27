Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:45942 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388701AbeG0SgE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 14:36:04 -0400
Message-ID: <901b48718fa525b6bb8f868bb8cf93f1a3e78413.camel@collabora.com>
Subject: Re: [PATCH 3/3] media: add Rockchip VPU driver
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>
Date: Fri, 27 Jul 2018 14:13:08 -0300
In-Reply-To: <3ea4cbc3-d7df-5860-46ec-9302b19bd713@xs4all.nl>
References: <20180705172819.5588-1-ezequiel@collabora.com>
         <20180705172819.5588-4-ezequiel@collabora.com>
         <3ea4cbc3-d7df-5860-46ec-9302b19bd713@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks a lot for the review.

On Wed, 2018-07-18 at 11:58 +0200, Hans Verkuil wrote:
> > 
> > +
> > +static int
> > +queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
> > +{
> > +	struct rockchip_vpu_ctx *ctx = priv;
> > +	int ret;
> > +
> > +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> 
> Any reason for setting USERPTR?
> 
> > +	src_vq->drv_priv = ctx;
> > +	src_vq->ops = &rockchip_vpu_enc_queue_ops;
> > +	src_vq->mem_ops = &vb2_dma_contig_memops;
> 
> It isn't really useful in combination with dma_contig.
> 

Right! I think I just missed it.

> > 
> > +
> > +fallback:
> > +	/* Default to full frame for incorrect settings. */
> > +	ctx->src_crop.width = fmt->width;
> > +	ctx->src_crop.height = fmt->height;
> > +	return 0;
> > +}
> 
> Replace crop by the selection API. The old crop API is no longer allowed
> in new drivers.

I have a question about the selection API. There is a comment that says
MPLANE types shouldn't be used:

/**
 * struct v4l2_selection - selection info
 * @type:       buffer type (do not use *_MPLANE types)

What is the meaning of that?

[..]
> 
> I skipped the review of the colorspace handling. I'll see if I can come back
> to that later today. I'm not sure if it is correct, but to be honest I doubt
> that there is any JPEG encoder that does this right anyway.
> 

And I'd say it's probably wrong, since we let the user change the colorspace,
but we do not use that for anything.

> BTW, please show the 'v4l2-compliance -s' output in the cover letter for the
> next version.
> 

OK, no problem.

Thanks!
Eze
