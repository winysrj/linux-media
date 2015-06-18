Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39004 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbbFRTsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 15:48:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mikhail Ulianov <mikhail.ulyanov@cogentembedded.com>
Cc: hverkuil@xs4all.nl, horms@verge.net.au, magnus.damm@gmail.com,
	sergei.shtylyov@cogentembedded.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, Kamil Debski <kamil@wypas.org>
Subject: Re: [PATCH v3 1/1] V4L2: platform: Renesas R-Car JPEG codec driver
Date: Thu, 18 Jun 2015 22:48:58 +0300
Message-ID: <5695336.CA8eQ67zhi@avalon>
In-Reply-To: <20150506010310.24f82a42@bones>
References: <1430344409-11928-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <5004544.CpPfGJfHMn@avalon> <20150506010310.24f82a42@bones>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mikhail,

(CC'ing Kamil Debski)

On Wednesday 06 May 2015 01:03:10 Mikhail Ulianov wrote:
> On Mon, 04 May 2015 02:32:05 +0300 Laurent Pinchart wrote:
> >> +/*
> >> + * ====================================================================
> >> + * video ioctl operations
> >> + * ====================================================================
> >> + */
> >> +static void put_qtbl(u8 *p, const unsigned int *qtbl)
> >> +{
> >> +	unsigned int i;
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(zigzag); i++)
> >> +		*(p + i) = *((const u8 *)qtbl + zigzag[i]);
> >> +}
> >> +
> >> +static void put_htbl(u8 *p, const u8 *htbl, unsigned int len)
> >> +{
> >> +	unsigned int i, j;
> >> +
> >> +	for (i = 0; i < len; i += 4)
> >> +		for (j = 0; j < 4 && (i + j) < len; ++j)
> >> +			p[i + j] = htbl[i + 3 - j];
> >
> > Instead of converting the tables to big endian for every frame, how
> > about generating them in big endian directly and then using a simple
> > memcpy() ?
> 
> I think you got it wrong. It's done only *once* on driver
> initialization.

My bad, you're right.

> And i implemented it this way because size of table(for
> regs initialization) is not equal with one we want to put in header (164
> bytes vs 162 bytes)
> 
> [snip]
> 
> >> +/*
> >> + * ====================================================================
> >> + * Queue operations
> >> + * ====================================================================
> >> + */
> >> +static int jpu_queue_setup(struct vb2_queue *vq,
> >> +			   const struct v4l2_format *fmt,
> >> +			   unsigned int *nbuffers, unsigned int
> >> *nplanes,
> >> +			   unsigned int sizes[], void
> >> *alloc_ctxs[])
> >> +{
> >> +	struct jpu_ctx *ctx = vb2_get_drv_priv(vq);
> >> +	struct jpu_q_data *q_data;
> >> +	unsigned int count = *nbuffers;
> >> +	unsigned int i;
> >> +
> >> +	q_data = jpu_get_q_data(ctx, vq->type);
> >> +
> >> +	*nplanes = q_data->format.num_planes;
> >> +
> >> +	/*
> >> +	 * Header is parsed during decoding and parsed information
> >> stored
> >> +	 * in the context so we do not allow another buffer to
> >> overwrite it.
> >> +	 * For now it works this way, but planned for alternation.
> > 
> > It shouldn't be difficult to create a jpu_buffer structure that
> > inherits from vb2_buffer and store the information there instead of
> > in the context.
> 
> You are absolutely right. But for this version i want to keep it
> simple and also at this moment not everything clear for me with this
> format "autodetection" feature we want to have e.g. for decoder if user
> requested 2 output buffers and then queue first with some valid JPEG
> with format -1-(so we setup queues format here), after that
> another one with format -2-... should we discard second one or just
> change format of queues? what about same situation if user already
> requested capture buffers. I mean relations with buf_prepare and
> queue_setup. AFAIU format should remain the same for all requested
> buffers. I see only one "solid" solution here - get rid of
> "autodetection" feature and rely only on format setted by user, so in
> this case we can just discard queued buffers with inappropriate
> format(kind of format validation in kernel). This solution will also
> work well with NV61, NV21, and semiplanar formats we want to add in next
> version. *But* with this solution header parsing must be done twice(in
> user and kernel spaces).
> I'm a little bit frustrated here :)

Yes, it's a bit frustrating indeed. I'm not sure what to advise, I'm not too 
familiar with the m2m API for JPEG.

Kamil, do you have a comment on that ?

> [snip]
> 
> >> +	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
> >> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
> >> +
> >> +	if (ctx->encoder) {
> >> +		unsigned long src_1_addr, src_2_addr, dst_addr;
> >> +		unsigned int redu, inft, w, h;
> >> +		u8 *dst_vaddr;
> >> +		struct jpu_q_data *q_data = &ctx->out_q;
> >> +		unsigned char subsampling =
> >> q_data->fmtinfo->subsampling; +
> >> +		src_1_addr =
> >> vb2_dma_contig_plane_dma_addr(src_buf, 0);
> >> +		src_2_addr =
> >> vb2_dma_contig_plane_dma_addr(src_buf, 1); +
> >> +		dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf,
> >> 0);
> >> +		dst_vaddr = vb2_plane_vaddr(dst_buf, 0);
> >> +
> >> +		w = q_data->format.width;
> >> +		h = q_data->format.height;
> >> +		bpl = q_data->format.plane_fmt[0].bytesperline;
> >> +
> >> +		memcpy(dst_vaddr, jpeg_hdrs[ctx->compr_quality],
> >> +			JPU_JPEG_HDR_SIZE);
> >> +		*(u16 *)(dst_vaddr + JPU_JPEG_HEIGHT_OFFSET) =
> >> cpu_to_be16(h);
> >> +		*(u16 *)(dst_vaddr + JPU_JPEG_WIDTH_OFFSET) =
> >> cpu_to_be16(w);
> >> +		*(dst_vaddr + JPU_JPEG_SUBS_OFFSET) = subsampling;
> > 
> > At this point I think the buffer belongs to the device. Have you
> > considered possible caching issues ? Would it make sense to write the
> > header when the buffer is prepared ?
> 
> AFAIU if header will be aligned to cache line there shouldn't be any
> problems and v4l2_m2m_buf_done -> vb2_dc_finish will do rest of work.
> Not sure what "when the buffer is prepared" mean. You mean after
> v4l2_m2m_buf_done?

I meant in the queue .buffer_prepare() operation.

> {snip]
> 
> >> +#ifdef CONFIG_PM_SLEEP
> >> +static int jpu_suspend(struct device *dev)
> >> +{
> >> +	struct jpu *jpu = dev_get_drvdata(dev);
> >> +
> >> +	if (jpu->ref_count == 0)
> >> +		return 0;
> >> +
> >> +	clk_disable_unprepare(jpu->clk);
> > 
> > Have you tested system suspend and resume ? I've recently received a
> > patch for the VSP1 driver that stops and restarts the device in the
> > suspend and resume operations, as just disabling and enabling the
> > clock wasn't enough. I'm wondering whether the same would apply to
> > the JPU.
> 
> It works just fine.

OK, good to know.

-- 
Regards,

Laurent Pinchart

