Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63723 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab2LQLUS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 06:20:18 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MF600053AA0MD80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 11:22:53 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MF6000GLA555P20@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 17 Dec 2012 11:20:16 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <20121115220627.GB29863@valkosipuli.retiisi.org.uk>
 <1353017207-370-4-git-send-email-sakari.ailus@iki.fi>
 <201211161455.20781.hverkuil@xs4all.nl>
In-reply-to: <201211161455.20781.hverkuil@xs4all.nl>
Subject: RE: [PATCH 4/4] v4l: Tell user space we're using monotonic timestamps
Date: Mon, 17 Dec 2012 12:19:51 +0100
Message-id: <000101cddc48$6fe977e0$4fbc67a0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Sakari,

A quick question follows inline.

[snip]

> > diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> > b/drivers/media/v4l2-core/videobuf2-core.c
> > index 432df11..19a5866 100644
> > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > @@ -40,9 +40,10 @@ module_param(debug, int, 0644);
> >  #define call_qop(q, op, args...)					\
> >  	(((q)->ops->op) ? ((q)->ops->op(args)) : 0)
> >
> > -#define V4L2_BUFFER_STATE_FLAGS	(V4L2_BUF_FLAG_MAPPED |
> V4L2_BUF_FLAG_QUEUED | \
> > +#define V4L2_BUFFER_MASK_FLAGS	(V4L2_BUF_FLAG_MAPPED |
> V4L2_BUF_FLAG_QUEUED | \
> >  				 V4L2_BUF_FLAG_DONE | V4L2_BUF_FLAG_ERROR |
\
> > -				 V4L2_BUF_FLAG_PREPARED)
> > +				 V4L2_BUF_FLAG_PREPARED | \
> > +				 V4L2_BUF_FLAG_TIMESTAMP_MASK)
> >
> >  /**
> >   * __vb2_buf_mem_alloc() - allocate video memory for the given
> buffer
> > @@ -367,7 +368,8 @@ static void __fill_v4l2_buffer(struct vb2_buffer
> *vb, struct v4l2_buffer *b)
> >  	/*
> >  	 * Clear any buffer state related flags.
> >  	 */
> > -	b->flags &= ~V4L2_BUFFER_STATE_FLAGS;
> > +	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
> > +	b->flags |= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;

As far as I know, after __fill_v4l2_buffer is run driver has no means
to change flags. Right?

So how should a driver, which is not using the MONOTONIC timestamps inform
the user space about it?

> >
> >  	switch (vb->state) {
> >  	case VB2_BUF_STATE_QUEUED:
> > @@ -863,7 +865,7 @@ static void __fill_vb2_buffer(struct vb2_buffer
> > *vb, const struct v4l2_buffer *b
> >
> >  	vb->v4l2_buf.field = b->field;
> >  	vb->v4l2_buf.timestamp = b->timestamp;
> > -	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_STATE_FLAGS;
> > +	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> >  }
> >
> >  /**
> >
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


