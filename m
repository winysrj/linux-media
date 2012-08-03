Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2416 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2HCIt4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 04:49:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Richard Zhao <richard.zhao@freescale.com>
Subject: Re: [v7] media: coda: Add driver for Coda video codec.
Date: Fri, 3 Aug 2012 10:47:01 +0200
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de, linuxzsc@gmail.com, shawn.guo@linaro.org
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com> <20120803082442.GE29944@b20223-02.ap.freescale.net>
In-Reply-To: <20120803082442.GE29944@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208031047.01174.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri August 3 2012 10:24:43 Richard Zhao wrote:
> Hi Javier,
> 
> Glad to see the vpu patch. I'd like to try it on imx6. What else
> do I need to do besides add vpu devices in dts? Do you have a gst
> plugin or any other test program to test it?
> 
> Please also see below comments.
> 
> On Mon, Jul 23, 2012 at 11:31:01AM +0000, Javier Martin wrote:
> > Coda is a range of video codecs from Chips&Media that
> > support H.264, H.263, MPEG4 and other video standards.
> > 
> > Currently only support for the codadx6 included in the
> > i.MX27 SoC is added. H.264 and MPEG4 video encoding
> > are the only supported capabilities by now.
> > 
> > Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > 
> > ---
> > Changes since v6:
> >  - Cosmetic fixes pointed out by Sakari.
> >  - Now passes 'v4l2-compliance'.
> > 
> > ---
> >  drivers/media/video/Kconfig  |    9 +
> >  drivers/media/video/Makefile |    1 +
> >  drivers/media/video/coda.c   | 1848 ++++++++++++++++++++++++++++++++++++++++++
> >  drivers/media/video/coda.h   |  216 +++++
> >  4 files changed, 2074 insertions(+)
> >  create mode 100644 drivers/media/video/coda.c
> >  create mode 100644 drivers/media/video/coda.h
> > 
> 
> [...]
> 
> > +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> > +{
> > +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> > +	struct v4l2_device *v4l2_dev = &ctx->dev->v4l2_dev;
> > +	u32 bitstream_buf, bitstream_size;
> > +	struct coda_dev *dev = ctx->dev;
> > +	struct coda_q_data *q_data_src, *q_data_dst;
> > +	u32 dst_fourcc;
> > +	struct vb2_buffer *buf;
> > +	struct vb2_queue *src_vq;
> > +	u32 value;
> > +	int i = 0;
> > +
> > +	if (count < 1)
> > +		return -EINVAL;
> > +
> > +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
> > +		ctx->rawstreamon = 1;
> > +	else
> > +		ctx->compstreamon = 1;
> > +
> > +	/* Don't start the coda unless both queues are on */
> > +	if (!(ctx->rawstreamon & ctx->compstreamon))
> > +		return 0;
> > +		
> Remove spaces above.
> > +	ctx->gopcounter = ctx->params.gop_size - 1;
> > +
> > +	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > +	buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> > +	bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
> > +	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +	bitstream_size = q_data_dst->sizeimage;
> > +	dst_fourcc = q_data_dst->fmt->fourcc;
> > +
> > +	/* Find out whether coda must encode or decode */
> > +	if (q_data_src->fmt->type == CODA_FMT_RAW &&
> > +	    q_data_dst->fmt->type == CODA_FMT_ENC) {
> > +		ctx->inst_type = CODA_INST_ENCODER;
> > +	} else if (q_data_src->fmt->type == CODA_FMT_ENC &&
> > +		   q_data_dst->fmt->type == CODA_FMT_RAW) {
> > +		ctx->inst_type = CODA_INST_DECODER;
> > +		v4l2_err(v4l2_dev, "decoding not supported.\n");
> > +		return -EINVAL;
> > +	} else {
> > +		v4l2_err(v4l2_dev, "couldn't tell instance type.\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!coda_is_initialized(dev)) {
> > +		v4l2_err(v4l2_dev, "coda is not initialized.\n");
> > +		return -EFAULT;
> > +	}
> > +	coda_write(dev, ctx->parabuf.paddr, CODA_REG_BIT_PARA_BUF_ADDR);
> > +	coda_write(dev, bitstream_buf, CODA_REG_BIT_RD_PTR(ctx->idx));
> > +	coda_write(dev, bitstream_buf, CODA_REG_BIT_WR_PTR(ctx->idx));
> > +	switch (dev->devtype->product) {
> > +	case CODA_DX6:
> > +		coda_write(dev, CODADX6_STREAM_BUF_DYNALLOC_EN |
> > +			CODADX6_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> > +		break;
> > +	default:
> > +		coda_write(dev, CODA7_STREAM_BUF_DYNALLOC_EN |
> > +			CODA7_STREAM_BUF_PIC_RESET, CODA_REG_BIT_STREAM_CTRL);
> > +	}
> > +
> > +	/* Configure the coda */
> > +	coda_write(dev, 0xffff4c00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> > +
> > +	/* Could set rotation here if needed */
> > +	switch (dev->devtype->product) {
> > +	case CODA_DX6:
> > +		value = (q_data_src->width & CODADX6_PICWIDTH_MASK) << CODADX6_PICWIDTH_OFFSET;
> longer than 80 characters. Could you run checkpatch to do further check?

This is a checkpatch warning, not an error. One should use one's own judgement whether
to take action or not. It is more important that the code is readable than that it fits
within 80 characters, although long lines can be an indication of poor readability.

In this case I personally don't think it will be easier to read if this line is split up.

Regards,

	Hans
