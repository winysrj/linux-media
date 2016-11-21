Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:37609 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753067AbcKUQtI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Nov 2016 11:49:08 -0500
From: Hugues FRUCHET <hugues.fruchet@st.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "kernel@stlinux.com" <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean Christophe TROTIN <jean-christophe.trotin@st.com>
Date: Mon, 21 Nov 2016 17:49:02 +0100
Subject: Re: [PATCH v2 05/10] [media] st-delta: STiH4xx multi-format video
 decoder v4l2 driver
Message-ID: <e2be5b10-bdda-49e6-e580-d83cdf255650@st.com>
References: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
 <1479468336-26199-6-git-send-email-hugues.fruchet@st.com>
 <aef3b320-94f4-775d-ca31-264b7b2a8a27@xs4all.nl>
In-Reply-To: <aef3b320-94f4-775d-ca31-264b7b2a8a27@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/21/2016 03:25 PM, Hans Verkuil wrote:
> On 18/11/16 12:25, Hugues Fruchet wrote:
>> This V4L2 driver enables DELTA multi-format video decoder
>> of STMicroelectronics STiH4xx SoC series.
>>
>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
>> ---
>>  drivers/media/platform/Kconfig                |   20 +
>>  drivers/media/platform/Makefile               |    2 +
>>  drivers/media/platform/sti/delta/Makefile     |    2 +
>>  drivers/media/platform/sti/delta/delta-cfg.h  |   60 +
>>  drivers/media/platform/sti/delta/delta-v4l2.c | 1813 +++++++++++++++++++++++++
>>  drivers/media/platform/sti/delta/delta.h      |  514 +++++++
>>  6 files changed, 2411 insertions(+)
>>  create mode 100644 drivers/media/platform/sti/delta/Makefile
>>  create mode 100644 drivers/media/platform/sti/delta/delta-cfg.h
>>  create mode 100644 drivers/media/platform/sti/delta/delta-v4l2.c
>>  create mode 100644 drivers/media/platform/sti/delta/delta.h
>>
>
> <snip>
>
>> +static int delta_s_selection(struct file *file, void *fh,
>> +			     struct v4l2_selection *s)
>> +{
>> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>> +		return -EINVAL;
>> +
>> +	/* reject attempts to write read only targets */
>> +	if ((s->target == V4L2_SEL_TGT_COMPOSE_DEFAULT) ||
>> +	    (s->target == V4L2_SEL_TGT_COMPOSE_BOUNDS) ||
>> +	    (s->target == V4L2_SEL_TGT_COMPOSE_PADDED))
>> +		return -EINVAL;
>> +
>> +	/* decoder don't support crop/compose request from user,
>> +	 * just return silently what we can currently do
>> +	 */
>> +	return delta_g_selection(file, fh, s);
>> +}
>
> Huh? If you don't support s_selection, then just drop it.

yes, seems natural but explicit checks are there in compliance which 
fails if I remove s_selection:
		test Cropping: OK (Not Supported)
		fail: 
sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1457): 
doioctl(node, VIDIOC_S_SELECTION, &sel_compose) != EINVAL
		fail: 
sources/v4l-utils/utils/v4l2-compliance/v4l2-test-formats.cpp(1501): 
testBasicCompose(node, V4L2_BUF_TYPE_VIDEO_CAPTURE)
		test Composing: FAIL


>
> <snip>
>
>> +static int delta_vb2_au_start_streaming(struct vb2_queue *q,
>> +					unsigned int count)
>> +{
>> +	struct delta_ctx *ctx = vb2_get_drv_priv(q);
>> +	struct delta_dev *delta = ctx->dev;
>> +	const struct delta_dec *dec = ctx->dec;
>> +	struct delta_au *au;
>> +	int ret = 0;
>> +	struct vb2_v4l2_buffer *vbuf = NULL;
>> +	struct delta_streaminfo *streaminfo = &ctx->streaminfo;
>> +	struct delta_frameinfo *frameinfo = &ctx->frameinfo;
>> +
>> +	if ((ctx->state != DELTA_STATE_WF_FORMAT) &&
>> +	    (ctx->state != DELTA_STATE_WF_STREAMINFO))
>> +		return 0;
>> +
>> +	if (ctx->state == DELTA_STATE_WF_FORMAT) {
>> +		/* open decoder if not yet done */
>> +		ret = delta_open_decoder(ctx,
>> +					 ctx->streaminfo.streamformat,
>> +					 ctx->frameinfo.pixelformat, &dec);
>> +		if (ret)
>> +			return ret;
>
> This should be 'goto err;'. I mentioned this in the original review as
> well, but
> apparently you forgot to fix it.

Very sorry for this, seems like I encountered last minute merge trouble 
as for q->dev...

>
>> +		ctx->dec = dec;
>> +		ctx->state = DELTA_STATE_WF_STREAMINFO;
>> +	}
>> +
>> +	/* first buffer should contain stream header,
>> +	 * decode it to get the infos related to stream
>> +	 * such as width, height, dpb, ...
>> +	 */
>> +	vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
>> +	if (!vbuf) {
>> +		dev_err(delta->dev, "%s failed to start streaming, no stream header buffer enqueued\n",
>> +			ctx->name);
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +	au = to_au(vbuf);
>> +	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
>> +	au->dts = vbuf->vb2_buf.timestamp;
>> +
>> +	delta_push_dts(ctx, au->dts);
>> +
>> +	/* dump access unit */
>> +	dump_au(ctx, au);
>> +
>> +	/* decode this access unit */
>> +	ret = call_dec_op(dec, decode, ctx, au);
>> +	if (ret) {
>> +		dev_err(delta->dev, "%s failed to start streaming, header decoding failed (%d)\n",
>> +			ctx->name, ret);
>> +		goto err;
>> +	}
>> +
>> +	ret = call_dec_op(dec, get_streaminfo, ctx, streaminfo);
>> +	if (ret) {
>> +		dev_dbg_ratelimited(delta->dev,
>> +				    "%s failed to start streaming, valid stream header not yet decoded\n",
>> +				    ctx->name);
>> +		goto err;
>> +	}
>> +	ctx->flags |= DELTA_FLAG_STREAMINFO;
>> +
>> +	ret = call_dec_op(dec, get_frameinfo, ctx, frameinfo);
>> +	if (ret)
>> +		goto err;
>> +	ctx->flags |= DELTA_FLAG_FRAMEINFO;
>> +
>> +	ctx->state = DELTA_STATE_READY;
>> +
>> +	delta_au_done(ctx, au, ret);
>> +	return 0;
>> +
>> +err:
>> +	/* return all buffers to vb2 in QUEUED state.
>> +	 * This will give ownership back to userspace
>> +	 */
>> +	if (vbuf)
>> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
>> +
>> +	while ((vbuf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
>> +		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_QUEUED);
>> +	return ret;
>> +}
>
> <snip>
>
>> +static int queue_init(void *priv,
>> +		      struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
>> +{
>> +	struct vb2_queue *q;
>> +	struct delta_ctx *ctx = priv;
>> +	struct delta_dev *delta = ctx->dev;
>> +	int ret;
>> +
>> +	/* setup vb2 queue for stream input */
>> +	q = src_vq;
>> +	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
>> +	q->io_modes = VB2_MMAP | VB2_DMABUF;
>> +	q->drv_priv = ctx;
>> +	/* overload vb2 buf with private au struct */
>> +	q->buf_struct_size = sizeof(struct delta_au);
>> +	q->ops = &delta_vb2_au_ops;
>> +	q->mem_ops = &vb2_dma_contig_memops;
>> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +	q->lock = &delta->lock;
>
> q->dev is still not set. It is not clear to me why this apparently works
> for you.
> It should fail when q->dev is NULL.

Yes it is failing, I suspect merge issue.

>
>> +	ret = vb2_queue_init(q);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* setup vb2 queue for frame output */
>> +	q = dst_vq;
>> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes = VB2_MMAP | VB2_DMABUF;
>> +	q->drv_priv = ctx;
>> +	/* overload vb2 buf with private frame struct */
>> +	q->buf_struct_size = sizeof(struct delta_frame)
>> +			     + DELTA_MAX_FRAME_PRIV_SIZE;
>> +	q->ops = &delta_vb2_frame_ops;
>> +	q->mem_ops = &vb2_dma_contig_memops;
>> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>> +	q->lock = &delta->lock;
>
> Ditto.
>
>> +
>> +	return vb2_queue_init(q);
>> +}
>
> Regards,
>
> 	Hans
>