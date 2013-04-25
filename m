Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35074 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758845Ab3DYQTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 12:19:24 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00AV9K078KA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 17:19:21 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
 <1366889768-16677-5-git-send-email-k.debski@samsung.com>
 <1366905070.4419.21.camel@pizza.hi.pengutronix.de>
In-reply-to: <1366905070.4419.21.camel@pizza.hi.pengutronix.de>
Subject: RE: [PATCH 4/7 v2] coda: Add copy time stamp handling
Date: Thu, 25 Apr 2013 18:19:10 +0200
Message-id: <001f01ce41d0$9fdb3770$df91a650$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for testing the patch. I would love to add your Tested-by tag to the
commit, but I had already sent the pull request to Mauro. It was already very
late to post fixes.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Thursday, April 25, 2013 5:51 PM
> To: Kamil Debski
> Cc: linux-media@vger.kernel.org; Kyungmin Park; Javier Martin; Fabio
> Estevam
> Subject: Re: [PATCH 4/7 v2] coda: Add copy time stamp handling
> 
> Hi Kamil,
> 
> Am Donnerstag, den 25.04.2013, 13:36 +0200 schrieb Kamil Debski:
> > Since the introduction of the timestamp_type field, it is necessary
> > that the driver chooses which type it will use. This patch adds
> > support for the timestamp_type.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Philipp Zabel <p.zabel@pengutronix.de>
> > Cc: Javier Martin <javier.martin@vista-silicon.com>
> > Cc: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> > ---
> >  drivers/media/platform/coda.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/drivers/media/platform/coda.c
> > b/drivers/media/platform/coda.c index 20827ba..5612329 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -1422,6 +1422,7 @@ static int coda_queue_init(void *priv, struct
> vb2_queue *src_vq,
> >  	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> >  	src_vq->ops = &coda_qops;
> >  	src_vq->mem_ops = &vb2_dma_contig_memops;
> > +	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> >
> >  	ret = vb2_queue_init(src_vq);
> >  	if (ret)
> > @@ -1433,6 +1434,7 @@ static int coda_queue_init(void *priv, struct
> vb2_queue *src_vq,
> >  	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> >  	dst_vq->ops = &coda_qops;
> >  	dst_vq->mem_ops = &vb2_dma_contig_memops;
> > +	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
> >
> >  	return vb2_queue_init(dst_vq);
> >  }
> > @@ -1628,6 +1630,9 @@ static irqreturn_t coda_irq_handler(int irq,
> void *data)
> >  		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> >  	}
> >
> > +	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
> > +	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
> > +
> >  	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> >  	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> >
> 
> regards
> Philipp


