Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3360 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3HBOkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 10:40:53 -0400
Message-ID: <51FBC4D7.2010802@xs4all.nl>
Date: Fri, 02 Aug 2013 16:40:23 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Archit Taneja <archit@ti.com>
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	dagriego@biglakesoftware.com, dale@farnsworth.org,
	pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com, tomi.valkeinen@ti.com
Subject: Re: [PATCH 4/6] v4l: ti-vpe: Add de-interlacer support in VPE
References: <1375452223-30524-1-git-send-email-archit@ti.com> <1375452223-30524-5-git-send-email-archit@ti.com>
In-Reply-To: <1375452223-30524-5-git-send-email-archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

More comments...

On 08/02/2013 04:03 PM, Archit Taneja wrote:
> Add support for the de-interlacer block in VPE.
> 
> For de-interlacer to work, we need to enable 2 more sets of VPE input ports
> which fetch data from the 'last' and 'last to last' fields of the interlaced
> video. Apart from that, we need to enable the Motion vector output and input
> ports, and also allocate DMA buffers for them.
> 
> We need to make sure that two most recent fields in the source queue are
> available and in the 'READY' state. Once a mem2mem context gets access to the
> VPE HW(in device_run), it extracts the addresses of the 3 buffers, and provides
> it to the data descriptors for the 3 sets of input ports((LUMA1, CHROMA1),
> (LUMA2, CHROMA2), and (LUMA3, CHROMA3)) respectively for the 3 consecutive
> fields. The motion vector and output port descriptors are configured and the
> list is submitted to VPDMA.
> 
> Once the transaction is done, the v4l2 buffer corresponding to the oldest
> field(the 3rd one) is changed to the state 'DONE', and the buffers corresponding
> to 1st and 2nd fields become the 2nd and 3rd field for the next de-interlace
> operation. This way, for each deinterlace operation, we have the 3 most recent
> fields. After each transaction, we also swap the motion vector buffers, the new
> input motion vector buffer contains the resultant motion information of all the
> previous frames, and the new output motion vector buffer will be used to hold
> the updated motion vector to capture the motion changes in the next field.
> 
> The de-interlacer is removed from bypass mode, it requires some extra default
> configurations which are now added. The chrominance upsampler coefficients are
> added for interlaced frames. Some VPDMA parameters like frame start event and
> line mode are configured for the 2 extra sets of input ports.
> 
> Signed-off-by: Archit Taneja <archit@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 372 ++++++++++++++++++++++++++++++++----
>  1 file changed, 337 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 14a292b..5b1410c 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c

...

> @@ -1035,7 +1310,8 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
>  
>  	if (pix->field == V4L2_FIELD_ANY)
>  		pix->field = V4L2_FIELD_NONE;
> -	else if (V4L2_FIELD_NONE != pix->field)
> +	else if (V4L2_FIELD_NONE != pix->field &&
> +			V4L2_FIELD_ALTERNATE != pix->field)
>  		return -EINVAL;

As mentioned before, this shouldn't result in an error, but map to a valid
field format.

For a deinterlacer I would expect NONE for the output of the deinterlacer (or
capture buffer type) and ALTERNATE for the input of the deinterlacer (or output
buffer type).

>  
>  	v4l_bound_align_image(&pix->width, MIN_W, MAX_W, W_ALIGN,
> @@ -1104,6 +1380,7 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
>  	q_data->width		= pix->width;
>  	q_data->height		= pix->height;
>  	q_data->colorspace	= pix->colorspace;
> +	q_data->field		= pix->field;
>  
>  	for (i = 0; i < pix->num_planes; i++) {
>  		plane_fmt = &pix->plane_fmt[i];
> @@ -1117,6 +1394,11 @@ static int __vpe_s_fmt(struct vpe_ctx *ctx, struct v4l2_format *f)
>  	q_data->c_rect.width	= q_data->width;
>  	q_data->c_rect.height	= q_data->height;
>  
> +	if (q_data->field == V4L2_FIELD_ALTERNATE)
> +		q_data->flags |= Q_DATA_INTERLACED;
> +	else
> +		q_data->flags &= ~Q_DATA_INTERLACED;
> +
>  	vpe_dbg(ctx->dev, "Setting format for type %d, wxh: %dx%d, fmt: %d bpl_y %d",
>  		f->type, q_data->width, q_data->height, q_data->fmt->fourcc,
>  		q_data->bytesperline[VPE_LUMA]);
> @@ -1194,6 +1476,22 @@ static int vpe_streamoff(struct file *file, void *priv, enum v4l2_buf_type type)
>  	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
>  }
>  
> +static void set_dei_shadow_registers(struct vpe_ctx *ctx)
> +{
> +	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
> +	u32 *dei_mmr = &mmr_adb->dei_regs[0];
> +	struct vpe_dei_regs *cur = &dei_regs;
> +
> +	dei_mmr[2]  = cur->mdt_spacial_freq_thr_reg;
> +	dei_mmr[3]  = cur->edi_config_reg;
> +	dei_mmr[4]  = cur->edi_lut_reg0;
> +	dei_mmr[5]  = cur->edi_lut_reg1;
> +	dei_mmr[6]  = cur->edi_lut_reg2;
> +	dei_mmr[7]  = cur->edi_lut_reg3;
> +
> +	ctx->load_mmrs = true;
> +}
> +
>  #define V4L2_CID_TRANS_NUM_BUFS		(V4L2_CID_USER_BASE)
>  
>  static int vpe_s_ctrl(struct v4l2_ctrl *ctrl)
> @@ -1425,6 +1723,7 @@ static int vpe_open(struct file *file)
>  	s_q_data->sizeimage[VPE_LUMA] = (s_q_data->width * s_q_data->height *
>  			s_q_data->fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
>  	s_q_data->colorspace = V4L2_COLORSPACE_SMPTE240M;
> +	s_q_data->field = V4L2_FIELD_NONE;
>  	s_q_data->c_rect.left = 0;
>  	s_q_data->c_rect.top = 0;
>  	s_q_data->c_rect.width = s_q_data->width;
> @@ -1433,6 +1732,7 @@ static int vpe_open(struct file *file)
>  
>  	ctx->q_data[Q_DATA_DST] = *s_q_data;
>  
> +	set_dei_shadow_registers(ctx);
>  	set_src_registers(ctx);
>  	set_dst_registers(ctx);
>  	ret = set_srcdst_params(ctx);
> @@ -1487,6 +1787,8 @@ static int vpe_release(struct file *file)
>  	vpe_dbg(dev, "releasing instance %p\n", ctx);
>  
>  	mutex_lock(&dev->dev_mutex);
> +	free_vbs(ctx);
> +	free_mv_buffers(ctx);
>  	vpdma_free_desc_list(&ctx->desc_list);
>  	vpdma_buf_free(&ctx->mmr_adb);
>  
> 

Regards,

	Hans
