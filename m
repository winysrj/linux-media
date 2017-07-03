Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52528 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751705AbdGCMZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 08:25:51 -0400
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
References: <20170623203456.503714406@cogentembedded.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1be1bbb3-1503-022a-ec15-5b9bf759dff8@xs4all.nl>
Date: Mon, 3 Jul 2017 14:25:45 +0200
MIME-Version: 1.0
In-Reply-To: <20170623203456.503714406@cogentembedded.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

Some comments below:

On 06/23/2017 10:34 PM, Sergei Shtylyov wrote:
> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
> 
> The image renderer, or the distortion correction engine, is a drawing
> processor with a simple instruction system capable of referencing video
> capture data or data in an external memory as the 2D texture data and
> performing texture mapping and drawing with respect to any shape that is
> split into triangular objects.
> 
> This V4L2 memory-to-memory device driver only supports image renderer light
> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
> can be added later...
> 
> [Sergei: merged 2 original patches, added  the patch description, removed
> unrelated parts,  added the binding document and the UAPI documentation,
> ported the driver to the modern kernel, renamed the UAPI header file and
> the guard macros to match the driver name, extended the copyrights, fixed
> up Kconfig prompt/depends/help, made use of the BIT/GENMASK() macros,
> sorted  #include's, replaced 'imr_ctx::crop' array with the 'imr_ctx::rect'
> structure, replaced imr_{g|s}_crop() with imr_{g|s}_selection(), completely
> rewrote imr_queue_setup(), removed 'imr_format_info::name', moved the
> applicable code from imr_buf_queue() to imr_buf_prepare() and moved the
> rest of imr_buf_queue() after imr_buf_finish(), assigned 'src_vq->dev' and
> 'dst_vq->dev' in imr_queue_init(), removed imr_start_streaming(), assigned
> 'src_vq->dev' and 'dst_vq->dev' in imr_queue_init(), clarified the math in
> imt_tri_type_{a|b|c}_length(), clarified the pointer math and avoided casts
> to 'void *' in imr_tri_set_type_{a|b|c}(), replaced imr_{reqbufs|querybuf|
> dqbuf|expbuf|streamon|streamoff}() with the generic helpers, implemented
> vidioc_{create_bufs|prepare_buf}() methods, used ALIGN() macro and merged
> the matrix size checks and replaced kmalloc()/copy_from_user() calls with
> memdup_user() call in imr_ioctl_map(), moved setting device capabilities
> from imr_querycap() to imr_probe(), set the valid default queue format in
> imr_probe(), removed leading dots and fixed grammar in the comments, fixed
> up  the indentation  to use  tabs where possible, renamed DLSR, CMRCR.
> DY1{0|2}, and ICR bits to match the manual, changed the prefixes of the
> CMRCR[2]/TRI{M|C}R bits/fields to match the manual, removed non-existent
> TRIMR.D{Y|U}D{X|V}M bits, added/used the IMR/{UV|CP}DPOR/SUSR bits/fields/
> shifts, separated the register offset/bit #define's, sorted instruction
> macros by opcode, removed unsupported LINE instruction, masked the register
> address in WTL[2]/WTS instruction macros, moved the display list #define's
> after the register #define's, removing the redundant comment, avoided
> setting reserved bits when writing CMRCCR[2]/TRIMCR, used the SR bits
> instead of a bare number, removed *inline* from .c file, fixed lines over
> 80 columns, removed useless spaces, comments, parens, operators, casts,
> braces, variables, #include's, statements, and even 1 function, added
> useful local variable, uppercased and spelled out the abbreviations,
> made comment wording more consistent/correct, fixed the comment typos,
> reformatted some multiline comments, inserted empty line after declaration,
> removed extra empty lines,  reordered some local variable desclarations,
> removed calls to 4l2_err() on kmalloc() failure, replaced '*' with 'x'
> in some format strings for v4l2_dbg(), fixed the error returned by
> imr_default(), avoided code duplication in the IRQ handler, used '__packed'
> for the UAPI structures, declared 'imr_map_desc::data' as '__u64' instead
> of 'void *', switched to '__u{16|32}' in the UAPI header, enclosed the
> macro parameters in parens, exchanged the values of IMR_MAP_AUTO{S|D}G
> macros.]

As Geert suggested, just replace this with a 'Based-on' line.

<snip>

> Index: media_tree/drivers/media/platform/rcar_imr.c
> ===================================================================
> --- /dev/null
> +++ media_tree/drivers/media/platform/rcar_imr.c
> @@ -0,0 +1,1877 @@

<snip>

> +/* add reference to the current configuration */
> +static struct imr_cfg *imr_cfg_ref(struct imr_ctx *ctx)

imr_cfg_ref -> imr_cfg_ref_get

> +{
> +	struct imr_cfg *cfg = ctx->cfg;
> +
> +	BUG_ON(!cfg);

Perhaps this can be replaced by:

	if (WARN_ON(!cfg))
		return NULL;

> +	cfg->refcount++;
> +	return cfg;
> +}
> +
> +/* mesh configuration destructor */
> +static void imr_cfg_unref(struct imr_ctx *ctx, struct imr_cfg *cfg)

imr_cfg_unref -> imr_cfg_ref_put

That follows the standard naming conventions for refcounting.

> +{
> +	struct imr_device *imr = ctx->imr;
> +
> +	/* no atomicity is required as operation is locked with device mutex */
> +	if (!cfg || --cfg->refcount)
> +		return;
> +
> +	/* release memory allocated for a display list */
> +	if (cfg->dl_vaddr)
> +		dma_free_writecombine(imr->dev, cfg->dl_size, cfg->dl_vaddr,
> +				      cfg->dl_dma_addr);
> +
> +	/* destroy the configuration structure */
> +	kfree(cfg);

Add:
	ctx->cfg = NULL;

> +
> +	/* decrement number of active configurations (debugging) */
> +	WARN_ON(!ctx->cfg_num--);
> +}
> +
> +/*******************************************************************************
> + * Context processing queue
> + ******************************************************************************/
> +
> +static int imr_queue_setup(struct vb2_queue *vq,
> +			   unsigned int *nbuffers, unsigned int *nplanes,
> +			   unsigned int sizes[], struct device *alloc_devs[])
> +{
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(vq);
> +	struct imr_q_data	*q_data = &ctx->queue
> +					[V4L2_TYPE_IS_OUTPUT(vq->type) ? 0 : 1];
> +
> +	if (*nplanes)
> +		return sizes[0] < q_data->fmt.sizeimage ? -EINVAL : 0;
> +
> +	/* we use only single-plane formats */
> +	*nplanes = 1;
> +	sizes[0] = q_data->fmt.sizeimage;
> +
> +	return 0;
> +}
> +
> +static int imr_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer	*vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue	*q = vb->vb2_queue;
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(q);
> +
> +	WARN_ON_ONCE(!mutex_is_locked(&ctx->imr->mutex));
> +
> +	v4l2_dbg(3, debug, &ctx->imr->v4l2_dev,
> +		 "%sput buffer <0x%08llx> prepared\n",
> +		 q->is_output ? "in" : "out",
> +		 (u64)vb2_dma_contig_plane_dma_addr(vb, 0));
> +
> +	/*
> +	 * for input buffer, put current configuration pointer
> +	 * (add reference)
> +	 */
> +	if (q->is_output)
> +		to_imr_buffer(vbuf)->cfg = imr_cfg_ref(ctx);
> +
> +	return 0;
> +}
> +
> +static void imr_buf_finish(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer	*vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue	*q = vb->vb2_queue;
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(q);
> +
> +	WARN_ON(!mutex_is_locked(&ctx->imr->mutex));
> +
> +	/* any special processing of completed buffer? - TBD */
> +	v4l2_dbg(3, debug, &ctx->imr->v4l2_dev,
> +		 "%sput buffer <0x%08llx> done\n", q->is_output ? "in" : "out",
> +		 (u64)vb2_dma_contig_plane_dma_addr(vb, 0));
> +
> +	/* unref configuration pointer as needed */
> +	if (q->is_output)
> +		imr_cfg_unref(ctx, to_imr_buffer(vbuf)->cfg);
> +}
> +
> +static void imr_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer	*vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_queue	*q = vb->vb2_queue;
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(q);
> +
> +	v4l2_dbg(3, debug, &ctx->imr->v4l2_dev,
> +		 "%sput buffer <0x%08llx> queued\n",
> +		 q->is_output ? "in" : "out",
> +		 (u64)vb2_dma_contig_plane_dma_addr(vb, 0));
> +
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, vbuf);
> +}
> +
> +static void imr_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct imr_ctx		*ctx = vb2_get_drv_priv(vq);
> +	unsigned long		flags;
> +	struct vb2_v4l2_buffer	*vb;
> +
> +	spin_lock_irqsave(&ctx->imr->lock, flags);
> +
> +	/* purge all buffers from a queue */
> +	if (V4L2_TYPE_IS_OUTPUT(vq->type)) {
> +		while ((vb = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)) != NULL)
> +			v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
> +	} else {
> +		while ((vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx)) != NULL)
> +			v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
> +	}
> +
> +	spin_unlock_irqrestore(&ctx->imr->lock, flags);
> +
> +	v4l2_dbg(1, debug, &ctx->imr->v4l2_dev, "%s streaming stopped\n",
> +		 V4L2_TYPE_IS_OUTPUT(vq->type) ? "output" : "capture");
> +}
> +
> +/* buffer queue operations */
> +static struct vb2_ops imr_qops = {
> +	.queue_setup	= imr_queue_setup,
> +	.buf_prepare	= imr_buf_prepare,
> +	.buf_finish	= imr_buf_finish,
> +	.buf_queue	= imr_buf_queue,
> +	.stop_streaming	= imr_stop_streaming,
> +	.wait_prepare	= vb2_ops_wait_prepare,
> +	.wait_finish	= vb2_ops_wait_finish,
> +};
> +
> +/* M2M device processing queue initialization */
> +static int imr_queue_init(void *priv, struct vb2_queue *src_vq,
> +			  struct vb2_queue *dst_vq)
> +{
> +	struct imr_ctx	*ctx = priv;
> +	int		ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;

Why do you need VB2_USERPTR? Unless you have a compelling reason for this
you should drop it here and in dst_vq->io_modes.

It should not be used in combination with contiguous DMA.

> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct imr_buffer);
> +	src_vq->ops = &imr_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +	src_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	src_vq->lock = &ctx->imr->mutex;
> +	src_vq->dev = ctx->imr->v4l2_dev.dev;
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &imr_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +	dst_vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	dst_vq->lock = &ctx->imr->mutex;
> +	dst_vq->dev = ctx->imr->v4l2_dev.dev;
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*******************************************************************************
> + * Operation type decoding helpers
> + ******************************************************************************/
> +
> +static u16 __imr_auto_sg_dg_tcm(u32 type)
> +{
> +	return	(type & IMR_MAP_AUTOSG ? IMR_TRIMR_AUTOSG :
> +		(type & IMR_MAP_AUTODG ? IMR_TRIMR_AUTODG : 0)) |
> +		(type & IMR_MAP_TCM ? IMR_TRIMR_TCM : 0);
> +}
> +
> +static u16 __imr_uvdp(u32 type)
> +{
> +	return (__IMR_MAP_UVDPOR(type) << IMR_UVDPOR_UVDPO_SHIFT) |
> +	       (type & IMR_MAP_DDP ? IMR_UVDPOR_DDP : 0);
> +}
> +
> +static u16 __imr_cpdp(u32 type)
> +{
> +	return (__IMR_MAP_YLDPO(type) << IMR_CPDPOR_YLDPO_SHIFT) |
> +	       (__IMR_MAP_UBDPO(type) << IMR_CPDPOR_UBDPO_SHIFT) |
> +	       (__IMR_MAP_VRDPO(type) << IMR_CPDPOR_VRDPO_SHIFT);
> +}
> +
> +static u16 __imr_luce(u32 type)
> +{
> +	return type & IMR_MAP_LUCE ? IMR_CMRCR_LUCE : 0;
> +}
> +
> +static u16 __imr_clce(u32 type)
> +{
> +	return type & IMR_MAP_CLCE ? IMR_CMRCR_CLCE : 0;
> +}
> +
> +/*******************************************************************************
> + * Type A (absolute coordinates of source/destination) mapping
> + ******************************************************************************/
> +
> +/* return size of the subroutine for type A mapping */
> +static u32 imr_tri_type_a_get_length(struct imr_mesh *mesh, int item_size)
> +{
> +	return ((1 + mesh->columns * (2 * item_size / sizeof(u32))) *
> +		(mesh->rows - 1) + 1) * sizeof(u32);
> +}
> +
> +/* set a mesh rows * columns using absolute coordinates */
> +static u32 *imr_tri_set_type_a(u32 *dl, void *map, struct imr_mesh *mesh,
> +			       int item_size)
> +{
> +	int columns = mesh->columns;
> +	int i, j;
> +
> +	/* convert lattice into set of stripes */
> +	for (i = 0; i < mesh->rows - 1; i++) {
> +		*dl++ = IMR_OP_TRI(2 * columns);
> +		for (j = 0; j < columns; j++) {
> +			memcpy(dl, map, item_size);
> +			dl  += item_size / sizeof(u32);
> +			memcpy(dl, map + columns * item_size, item_size);
> +			dl  += item_size / sizeof(u32);
> +			map += item_size;
> +		}
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * Type B mapping (automatically generated source or destination coordinates)
> + ******************************************************************************/
> +
> +/* calculate length of a type B mapping */
> +static u32 imr_tri_type_b_get_length(struct imr_mesh *mesh, int item_size)
> +{
> +	return (3 + (2 + (mesh->columns * (2 * item_size / sizeof(u32))) *
> +		     (mesh->rows - 1)) + 1) * sizeof(u32);
> +}
> +
> +/* set an auto-generated mesh n * m for a source/destination */
> +static u32 *imr_tri_set_type_b(u32 *dl, void *map, struct imr_mesh *mesh,
> +			       int item_size)
> +{
> +	int columns = mesh->columns;
> +	int i, j, y;
> +
> +	/* set mesh configuration */
> +	*dl++ = IMR_OP_WTS(IMR_AMXSR, mesh->dx);
> +	*dl++ = IMR_OP_WTS(IMR_AMYSR, mesh->dy);
> +
> +	/* origin by X coordinate is the same across all rows */
> +	*dl++ = IMR_OP_WTS(IMR_AMXOR, mesh->x0);
> +
> +	/* convert lattice into set of stripes */
> +	for (i = 0, y = mesh->y0; i < mesh->rows - 1; i++, y += mesh->dy) {
> +		/* set origin by Y coordinate for a current row */
> +		*dl++ = IMR_OP_WTS(IMR_AMYOR, y);
> +		*dl++ = IMR_OP_TRI(2 * columns);
> +		/* fill single row */
> +		for (j = 0; j < columns; j++) {
> +			memcpy(dl, map, item_size);
> +			dl  += item_size / sizeof(u32);
> +			memcpy(dl, map + columns * item_size, item_size);
> +			dl  += item_size / sizeof(u32);
> +			map += item_size;
> +		}
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * Type C mapping (vertex-buffer-object)
> + ******************************************************************************/
> +
> +/* calculate length of a type C mapping */
> +static u32 imr_tri_type_c_get_length(struct imr_vbo *vbo, int item_size)
> +{
> +	return ((1 + 3 * item_size / sizeof(u32)) * vbo->num + 1) * sizeof(u32);
> +}
> +
> +/* set a VBO mapping using absolute coordinates */
> +static u32 *imr_tri_set_type_c(u32 *dl, void *map, struct imr_vbo *vbo,
> +			       int item_size)
> +{
> +	int length = 3 * item_size;
> +	int i;
> +
> +	/* prepare list of triangles to draw */
> +	for (i = 0; i < vbo->num; i++) {
> +		*dl++ = IMR_OP_TRI(3);
> +		memcpy(dl, map, length);
> +		dl  += length / sizeof(u32);
> +		map += length;
> +	}
> +
> +	*dl++ = IMR_OP_RET;
> +	return dl;
> +}
> +
> +/*******************************************************************************
> + * DL program creation
> + ******************************************************************************/
> +
> +/* return length of a DL main program */
> +static u32 imr_dl_program_length(struct imr_ctx *ctx)
> +{
> +	u32 iflags = ctx->queue[0].flags;
> +	u32 oflags = ctx->queue[1].flags;
> +	u32 cflags = __imr_flags_common(iflags, oflags);
> +
> +	/* check if formats are compatible */
> +	if (((iflags & IMR_F_PLANAR) && !(oflags & IMR_F_PLANAR)) || !cflags) {
> +		v4l2_err(&ctx->imr->v4l2_dev,
> +			 "formats are incompatible: if=%x, of=%x, cf=%x\n",
> +			 iflags, oflags, cflags);
> +		return 0;
> +	}
> +
> +	/*
> +	 * maximal possible length of the program is 27 32-bits words;
> +	 * round up to 32
> +	 */
> +	return 32 << 2;
> +}
> +
> +/* setup DL for Y/YUV planar/interleaved processing */
> +static void imr_dl_program_setup(struct imr_ctx *ctx, struct imr_cfg *cfg,
> +				 u32 type, u32 *dl, u32 subaddr)
> +{
> +	u32 iflags = ctx->queue[0].flags;
> +	u32 oflags = ctx->queue[1].flags;
> +	u32 cflags = __imr_flags_common(iflags, oflags);
> +	u16 src_y_fmt = (iflags & IMR_F_Y12 ? IMR_CMRCR_SY12 :
> +			 (iflags & IMR_F_Y10 ? IMR_CMRCR_SY10 : 0));
> +	u16 src_uv_fmt = (iflags & IMR_F_UV12 ? 2 :
> +			  (iflags & IMR_F_UV10 ? 1 : 0)) << IMR_CMRCR_SUV_SHIFT;
> +	u16 dst_y_fmt = (cflags & IMR_F_Y12 ? IMR_CMRCR_Y12 :
> +			 (cflags & IMR_F_Y10 ? IMR_CMRCR_Y10 : 0));
> +	u16 dst_uv_fmt = (cflags & IMR_F_UV12 ? 2 :
> +			  (cflags & IMR_F_UV10 ? 1 : 0)) << IMR_CMRCR_DUV_SHIFT;
> +	int w = ctx->queue[0].fmt.width;
> +	int h = ctx->queue[0].fmt.height;
> +	int W = ctx->queue[1].fmt.width;
> +	int H = ctx->queue[1].fmt.height;
> +
> +	v4l2_dbg(2, debug, &ctx->imr->v4l2_dev,
> +		 "setup %ux%u -> %ux%u mapping (type=%x)\n", w, h, W, H, type);
> +
> +	/* set triangle mode register from user-supplied descriptor */
> +	*dl++ = IMR_OP_WTS(IMR_TRIMCR, 0x004F);
> +
> +	/* set automatic source/destination coordinates generation flags */
> +	*dl++ = IMR_OP_WTS(IMR_TRIMSR, __imr_auto_sg_dg_tcm(type) |
> +			   IMR_TRIMR_BFE | IMR_TRIMR_TME);
> +
> +	/* set source/destination coordinate precision */
> +	*dl++ = IMR_OP_WTS(IMR_UVDPOR, __imr_uvdp(type));
> +
> +	/* set luminance/chromacity correction parameters precision */
> +	*dl++ = IMR_OP_WTS(IMR_CPDPOR, __imr_cpdp(type));
> +
> +	/* reset rendering mode registers */
> +	*dl++ = IMR_OP_WTS(IMR_CMRCCR,  0xDBFE);
> +	*dl++ = IMR_OP_WTS(IMR_CMRCCR2, 0x9065);
> +
> +	/* set source/destination addresses of Y/UV plane */
> +	*dl++ = IMR_OP_WTL(IMR_DSAR, 2);
> +	cfg->dst_pa_ptr[0] = dl++;
> +	cfg->src_pa_ptr[0] = dl++;
> +
> +	/* select planar/interleaved mode basing on input format */
> +	if (iflags & IMR_F_PLANAR) {
> +		/* planar input means planar output; set Y plane precision */
> +		if (cflags & IMR_F_Y8) {
> +			/*
> +			 * setup Y plane processing: YCM=0, SY/DY=xx,
> +			 * SUV/DUV=0
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_CMRCSR, src_y_fmt | src_uv_fmt |
> +					   dst_y_fmt | dst_uv_fmt |
> +					   __imr_luce(type));
> +
> +			/*
> +			 * set source/destination strides basing on Y plane
> +			 * precision
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 1 : 0));
> +			*dl++ = IMR_OP_WTS(IMR_SSTR,
> +					   w << (iflags & IMR_F_Y10 ? 1 : 0));
> +		} else {
> +			/* setup UV plane processing only */
> +			*dl++ = IMR_OP_WTS(IMR_CMRCSR, IMR_CMRCR_YCM |
> +					   src_uv_fmt | dst_uv_fmt |
> +					   __imr_clce(type));
> +
> +			/*
> +			 * set source/destination strides basing on UV plane
> +			 * precision
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_UV10 ? 1 : 0));
> +			*dl++ = IMR_OP_WTS(IMR_SSTR,
> +					   w << (iflags & IMR_F_UV10 ? 1 : 0));
> +		}
> +	} else {
> +		u16 src_fmt = (iflags & IMR_F_UV_SWAP ? IMR_CMRCR2_UVFORM : 0) |
> +			      (iflags & IMR_F_YUV_SWAP ?
> +			       IMR_CMRCR2_YUV422FORM : 0);
> +		u32 dst_fmt = (oflags & IMR_F_YUV_SWAP ? IMR_TRICR_YCFORM : 0);
> +
> +		/* interleaved input; output is either interleaved or planar */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR2, IMR_CMRCR2_YUV422E | src_fmt);
> +
> +		/* destination is always YUYV or UYVY */
> +		*dl++ = IMR_OP_WTL(IMR_TRICR, 1);
> +		*dl++ = dst_fmt;
> +
> +		/* set precision of Y/UV planes and required correction */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR, src_y_fmt | src_uv_fmt |
> +				   dst_y_fmt | dst_uv_fmt | __imr_clce(type) |
> +				   __imr_luce(type));
> +
> +		/* set source stride basing on precision (2 or 4 bytes/pixel) */
> +		*dl++ = IMR_OP_WTS(IMR_SSTR, w << (iflags & IMR_F_Y10 ? 2 : 1));
> +
> +		/* if output is planar, put the offset value */
> +		if (oflags & IMR_F_PLANAR) {
> +			/* specify offset of a destination UV plane */
> +			*dl++ = IMR_OP_WTL(IMR_DSOR, 1);
> +			*dl++ = W * H;
> +
> +			/*
> +			 * destination stride is 1 or 2 bytes/pixel
> +			 * (same for both Y and UV planes)
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 1 : 0));
> +		} else {
> +			/*
> +			 * destination stride if 2 or 4 bytes/pixel
> +			 * (Y and UV planes interleaved)
> +			 */
> +			*dl++ = IMR_OP_WTS(IMR_DSTR,
> +					   W << (cflags & IMR_F_Y10 ? 2 : 1));
> +		}
> +	}
> +
> +	/*
> +	 * set source width/height of Y/UV plane
> +	 * (for Y plane upper part of SUSR is ignored)
> +	 */
> +	*dl++ = IMR_OP_WTL(IMR_SUSR, 2);
> +	*dl++ = ((w - 2) << IMR_SUSR_SUW_SHIFT) |
> +		((w - 1) << IMR_SUSR_SVW_SHIFT);
> +	*dl++ = h - 1;
> +
> +	/* invoke subroutine for drawing triangles */
> +	*dl++ = IMR_OP_GOSUB;
> +	*dl++ = subaddr;
> +
> +	/* if we have a planar output with both Y and UV planes available */
> +	if ((cflags & (IMR_F_PLANAR | IMR_F_Y8 | IMR_F_UV8)) ==
> +	    (IMR_F_PLANAR | IMR_F_Y8 | IMR_F_UV8)) {
> +		/* select UV plane processing mode; put sync before switching */
> +		*dl++ = IMR_OP_SYNCM;
> +
> +		/* setup UV-plane source/destination addresses */
> +		*dl++ = IMR_OP_WTL(IMR_DSAR, 2);
> +		cfg->dst_pa_ptr[1] = dl++;
> +		cfg->src_pa_ptr[1] = dl++;
> +
> +		/* select correction mode */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCSR, IMR_CMRCR_YCM |
> +				   __imr_clce(type));
> +
> +		/* luminance correction bit must be cleared (if it was set) */
> +		*dl++ = IMR_OP_WTS(IMR_CMRCCR, IMR_CMRCR_LUCE);
> +
> +		/* draw triangles */
> +		*dl++ = IMR_OP_GOSUB;
> +		*dl++ = subaddr;
> +	} else {
> +		/*
> +		 * clear pointers to the source/destination UV-planes addresses
> +		 */
> +		cfg->src_pa_ptr[1] = cfg->dst_pa_ptr[1] = NULL;
> +	}
> +
> +	/* signal completion of the operation */
> +	*dl++ = IMR_OP_SYNCM;
> +	*dl++ = IMR_OP_TRAP;
> +}
> +
> +/*******************************************************************************
> + * Mapping specification processing
> + ******************************************************************************/
> +
> +/* set mapping data (function called with video device lock held) */
> +static int imr_ioctl_map(struct imr_ctx *ctx, struct imr_map_desc *desc)
> +{
> +	struct imr_device	*imr = ctx->imr;
> +	struct imr_mesh		*mesh;
> +	struct imr_vbo		*vbo;
> +	struct imr_cfg		*cfg;
> +	void			*buf, *map;
> +	u32                     type;
> +	u32			length, item_size;
> +	u32			tri_length;
> +	void			*dl_vaddr;
> +	u32			dl_size;
> +	u32			dl_start_offset;
> +	dma_addr_t		dl_dma_addr;
> +	int			ret = 0;
> +
> +	/* read remainder of data into temporary buffer */
> +	length = desc->size;
> +	buf  = memdup_user((void __user *)(unsigned long)desc->data, length);
> +	if (IS_ERR(buf)) {
> +		v4l2_err(&imr->v4l2_dev,
> +			 "failed to copy %u bytes of mapping specification\n",
> +			 length);
> +		return PTR_ERR(buf);
> +	}
> +
> +	/* mesh item size calculation */
> +	type = desc->type;
> +	item_size = (type & IMR_MAP_LUCE ? 4 : 0) +
> +		    (type & IMR_MAP_CLCE ? 4 : 0);
> +
> +	/* calculate the length of a display list */
> +	if (type & IMR_MAP_MESH) {
> +		/* assure we have proper mesh descriptor */
> +		if (length < sizeof(struct imr_mesh)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid mesh specification size: %u\n",
> +				 length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		mesh = (struct imr_mesh *)buf;
> +		length -= sizeof(struct imr_mesh);
> +		map = buf + sizeof(struct imr_mesh);
> +
> +		if (type & (IMR_MAP_AUTODG | IMR_MAP_AUTOSG)) {
> +			/*
> +			 * mapping is given using automatic generation pattern;
> +			 * source/destination vertex size is 4 bytes
> +			 */
> +			item_size += 4;
> +
> +			/* calculate size of triangles drawing subroutine */
> +			tri_length = imr_tri_type_b_get_length(mesh, item_size);
> +		} else {
> +			/*
> +			 * mapping is done with absolute coordinates;
> +			 * source/destination vertex size is 8 bytes
> +			 */
> +			item_size += 8;
> +
> +			/* calculate size of triangles drawing subroutine */
> +			tri_length = imr_tri_type_a_get_length(mesh, item_size);
> +		}
> +
> +		/* check size */
> +		if (mesh->rows * mesh->columns * item_size != length) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid mesh size: %u*%u*%u != %u\n",
> +				 mesh->rows, mesh->columns, item_size,
> +				 length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +	} else {
> +		/* assure we have proper VBO descriptor */
> +		if (length < sizeof(struct imr_vbo)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid vbo specification size: %u\n",
> +				 length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/* make sure there is no automatically generation flags */
> +		if (type & (IMR_MAP_AUTODG | IMR_MAP_AUTOSG)) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid auto-dg/sg flags: 0x%x\n", type);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		vbo = (struct imr_vbo *)buf;
> +		length -= sizeof(struct imr_vbo);
> +		map = buf + sizeof(struct imr_vbo);
> +
> +		/* vertex is given with absolute coordinates */
> +		item_size += 8;
> +
> +		/* check that the length is sane */
> +		if (vbo->num * 3 * item_size != length) {
> +			v4l2_err(&imr->v4l2_dev,
> +				 "invalid vbo size: %u*%u*3 != %u\n", vbo->num,
> +				 item_size, length);
> +			ret = -EINVAL;
> +			goto out;
> +		}
> +
> +		/* calculate size of triangles drawing subroutine */
> +		tri_length = imr_tri_type_c_get_length(vbo, item_size);
> +	}
> +
> +	/* DL main program shall start on 8-byte aligned address */
> +	dl_start_offset = ALIGN(tri_length, 8);
> +
> +	/* calculate main routine length */
> +	dl_size = imr_dl_program_length(ctx);
> +	if (!dl_size) {
> +		v4l2_err(&imr->v4l2_dev, "format configuration error\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* we use a single display list, with TRI subroutine prepending MAIN */
> +	dl_size += dl_start_offset;
> +
> +	/* unref current configuration (will not be used by subsequent jobs) */
> +	imr_cfg_unref(ctx, ctx->cfg);
> +
> +	/* create new configuration */
> +	cfg = imr_cfg_create(ctx, dl_size, dl_start_offset);
> +	if (IS_ERR(cfg)) {
> +		ret = PTR_ERR(cfg);
> +		ctx->cfg = NULL;
> +		v4l2_err(&imr->v4l2_dev,
> +			 "failed to create configuration: %d\n", ret);
> +		goto out;
> +	}
> +	ctx->cfg = cfg;
> +
> +	/* get pointer to the new display list */
> +	dl_vaddr = cfg->dl_vaddr;
> +	dl_dma_addr = cfg->dl_dma_addr;
> +
> +	/* prepare a triangles drawing subroutine */
> +	if (type & IMR_MAP_MESH) {
> +		if (type & (IMR_MAP_AUTOSG | IMR_MAP_AUTODG))
> +			imr_tri_set_type_b(dl_vaddr, map, mesh, item_size);
> +		else
> +			imr_tri_set_type_a(dl_vaddr, map, mesh, item_size);
> +	} else {
> +		imr_tri_set_type_c(dl_vaddr, map, vbo, item_size);
> +	}
> +
> +	/* prepare main DL program */
> +	imr_dl_program_setup(ctx, cfg, type, dl_vaddr + dl_start_offset,
> +			     (u32)dl_dma_addr);
> +
> +	/* update cropping parameters */
> +	cfg->dst_subpixel = (type & IMR_MAP_DDP ? 2 : 0);
> +
> +	/* display list updated successfully */
> +	v4l2_dbg(2, debug, &ctx->imr->v4l2_dev,
> +		 "display-list created: #%u[%08X]:%u[%u]\n",
> +		 cfg->id, (u32)dl_dma_addr, dl_size, dl_start_offset);
> +
> +	if (debug >= 4)
> +		print_hex_dump_bytes("DL-", DUMP_PREFIX_OFFSET,
> +				     dl_vaddr + dl_start_offset,
> +				     dl_size  - dl_start_offset);
> +
> +out:
> +	/* release interim buffer */
> +	kfree(buf);
> +
> +	return ret;
> +}
> +
> +/*******************************************************************************
> + * V4L2 I/O controls
> + ******************************************************************************/
> +
> +/* test if a format is supported */
> +static int __imr_try_fmt(struct imr_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct v4l2_pix_format	*pix = &f->fmt.pix;
> +	u32			fourcc = pix->pixelformat;
> +	int			i;
> +
> +	/*
> +	 * both output and capture interface have the same set of
> +	 * supported formats
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(imr_lx4_formats); i++) {
> +		if (fourcc == imr_lx4_formats[i].fourcc) {
> +			/* fix up format specification as needed */
> +			pix->field = V4L2_FIELD_NONE;
> +
> +			v4l2_dbg(1, debug, &ctx->imr->v4l2_dev,
> +				 "format request: '%c%c%c%c', %dx%d\n",
> +				 (fourcc >> 0)	& 0xff,	(fourcc >> 8)  & 0xff,
> +				 (fourcc >> 16) & 0xff, (fourcc >> 24) & 0xff,
> +				 pix->width, pix->height);
> +
> +			/* verify source/destination image dimensions */
> +			if (V4L2_TYPE_IS_OUTPUT(f->type))
> +				v4l_bound_align_image(&pix->width, 128, 2048, 7,
> +						      &pix->height,  1, 2048, 0,
> +						      0);
> +			else
> +				v4l_bound_align_image(&pix->width,  64, 2048, 6,
> +						      &pix->height,  1, 2048, 0,
> +						      0);
> +
> +			return i;
> +		}
> +	}
> +
> +	v4l2_err(&ctx->imr->v4l2_dev,
> +		 "unsupported format request: '%c%c%c%c'\n",
> +		 (fourcc >> 0)  & 0xff, (fourcc >> 8)  & 0xff,
> +		 (fourcc >> 16) & 0xff, (fourcc >> 24) & 0xff);
> +
> +	return -EINVAL;
> +}
> +
> +/* capabilities query */
> +static int imr_querycap(struct file *file, void *priv,
> +			struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
> +	strlcpy(cap->card, DRV_NAME, sizeof(cap->card));
> +	strlcpy(cap->bus_info, DRV_NAME, sizeof(cap->bus_info));
> +
> +	return 0;
> +}
> +
> +/* enumerate supported formats */
> +static int imr_enum_fmt(struct file *file, void *priv, struct v4l2_fmtdesc *f)
> +{
> +	/* no distinction between output/capture formats */
> +	if (f->index < ARRAY_SIZE(imr_lx4_formats)) {
> +		f->pixelformat = imr_lx4_formats[f->index].fourcc;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +/* retrieve current queue format; operation is locked? */
> +static int imr_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct imr_q_data	*q_data;
> +	struct vb2_queue	*vq;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
> +
> +	/* processing is locked? TBD */
> +	f->fmt.pix = q_data->fmt;
> +
> +	return 0;
> +}
> +
> +/* test particular format; operation is not locked */
> +static int imr_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct vb2_queue	*vq;
> +
> +	/* make sure we have a queue of particular type */
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	/* test if format is supported (adjust as appropriate) */
> +	return __imr_try_fmt(ctx, f) >= 0 ? 0 : -EINVAL;
> +}
> +
> +/* apply queue format; operation is locked? */
> +static int imr_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct imr_q_data	*q_data;
> +	struct vb2_queue	*vq;
> +	int			i;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	/* check if queue is busy */
> +	if (vb2_is_busy(vq))
> +		return -EBUSY;
> +
> +	/* test if format is supported (adjust as appropriate) */
> +	i = __imr_try_fmt(ctx, f);
> +	if (i < 0)
> +		return -EINVAL;
> +
> +	/* format is supported; save current format in a queue-specific data */
> +	q_data = &ctx->queue[V4L2_TYPE_IS_OUTPUT(f->type) ? 0 : 1];
> +
> +	/* processing is locked? TBD */
> +	q_data->fmt = f->fmt.pix;
> +	q_data->flags = imr_lx4_formats[i].flags;
> +
> +	/* set default compose factors */
> +	if (!V4L2_TYPE_IS_OUTPUT(f->type)) {
> +		ctx->rect.min.x = 0;
> +		ctx->rect.min.y = f->fmt.pix.width - 1;
> +		ctx->rect.max.x = 0;
> +		ctx->rect.max.y = f->fmt.pix.height - 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int imr_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(priv);
> +
> +	/* operation is protected with a queue lock */
> +	WARN_ON(!mutex_is_locked(&ctx->imr->mutex));

It's guaranteed by the V4L2 core, so this can be dropped safely.

> +
> +	/* verify the configuration is complete */
> +	if (!ctx->cfg) {
> +		v4l2_err(&ctx->imr->v4l2_dev,
> +			 "stream configuration is not complete\n");
> +		return -EINVAL;
> +	}

Shouldn't this test be done in the buf_prepare callback above? It's
what buf_prepare is for.

Then you can drop this function and use the helper function instead.

> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int imr_g_selection(struct file *file, void *priv,
> +			   struct v4l2_selection *s)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(priv);
> +	struct imr_q_data	*q_data = &ctx->queue[1];
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> +		s->r.left = s->r.top = 0;
> +		s->r.width  = q_data->fmt.width;
> +		s->r.height = q_data->fmt.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		s->r.left = ctx->rect.min.x;
> +		s->r.top  = ctx->rect.min.y;
> +		s->r.width  = ctx->rect.max.x - ctx->rect.min.x + 1;
> +		s->r.height = ctx->rect.max.y - ctx->rect.min.y + 1;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int imr_s_selection(struct file *file, void *priv,
> +			   struct v4l2_selection *s)
> +{
> +	struct imr_ctx	*ctx = fh_to_ctx(priv);
> +	struct imr_q_data *q_data = &ctx->queue[1];
> +	struct v4l2_rect r = s->r;
> +	struct v4l2_rect max_rect;
> +
> +	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_TGT_COMPOSE:
> +		/* Make sure compose rect fits inside output format */
> +		max_rect.top = max_rect.left = 0;
> +		max_rect.width  = q_data->fmt.width;
> +		max_rect.height = q_data->fmt.height;
> +		v4l2_rect_map_inside(&r, &max_rect);
> +
> +		/* subpixel resolution of output buffer is not counted here */
> +		ctx->rect.min.x = r.left;
> +		ctx->rect.min.y = r.top;
> +		ctx->rect.max.x = r.left + r.width  - 1;
> +		ctx->rect.max.y = r.top  + r.height - 1;
> +
> +		s->r = r;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/* customized I/O control processing */
> +static long imr_default(struct file *file, void *fh, bool valid_prio,
> +			unsigned int cmd,  void *arg)
> +{
> +	struct imr_ctx *ctx = fh_to_ctx(fh);
> +
> +	switch (cmd) {
> +	case VIDIOC_IMR_MESH:
> +		/* set mesh data */
> +		return imr_ioctl_map(ctx, arg);
> +
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static const struct v4l2_ioctl_ops imr_ioctl_ops = {
> +	.vidioc_querycap		= imr_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap	= imr_enum_fmt,
> +	.vidioc_enum_fmt_vid_out	= imr_enum_fmt,
> +	.vidioc_g_fmt_vid_cap		= imr_g_fmt,
> +	.vidioc_g_fmt_vid_out		= imr_g_fmt,
> +	.vidioc_try_fmt_vid_cap		= imr_try_fmt,
> +	.vidioc_try_fmt_vid_out		= imr_try_fmt,
> +	.vidioc_s_fmt_vid_cap		= imr_s_fmt,
> +	.vidioc_s_fmt_vid_out		= imr_s_fmt,
> +
> +	.vidioc_reqbufs			= v4l2_m2m_ioctl_reqbufs,
> +	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
> +	.vidioc_querybuf		= v4l2_m2m_ioctl_querybuf,
> +	.vidioc_qbuf			= imr_qbuf,
> +	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
> +	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
> +	.vidioc_expbuf			= v4l2_m2m_ioctl_expbuf,
> +	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
> +	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
> +
> +	.vidioc_g_selection		= imr_g_selection,
> +	.vidioc_s_selection		= imr_s_selection,
> +
> +	.vidioc_default			= imr_default,
> +};
> +
> +/*******************************************************************************
> + * Generic device file operations
> + ******************************************************************************/
> +
> +static int imr_open(struct file *file)
> +{
> +	struct imr_device	*imr = video_drvdata(file);
> +	struct video_device	*vfd = video_devdata(file);
> +	struct imr_ctx		*ctx;
> +	int			ret;
> +
> +	/* allocate processing context associated with given instance */
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	/* initialize per-file-handle structure */
> +	v4l2_fh_init(&ctx->fh, vfd);
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +
> +	/* set default source/destination formats - need that? */
> +	ctx->imr = imr;
> +	ctx->queue[0].fmt.pixelformat = V4L2_PIX_FMT_UYVY;
> +	ctx->queue[1].fmt.pixelformat = V4L2_PIX_FMT_UYVY;
> +
> +	/* set default cropping parameters */
> +	ctx->rect.max.x = ctx->rect.max.y = 0x3FF;
> +
> +	/* initialize M2M processing context */
> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(imr->m2m_dev, ctx, imr_queue_init);
> +	if (IS_ERR(ctx->m2m_ctx)) {
> +		ret = PTR_ERR(ctx->m2m_ctx);
> +		goto v4l_prepare_rollback;
> +	}
> +
> +	/* lock access to global device data */
> +	if (mutex_lock_interruptible(&imr->mutex)) {
> +		ret = -ERESTARTSYS;
> +		goto v4l_prepare_rollback;
> +	}
> +
> +	/* bring up device as needed */
> +	if (imr->refcount == 0) {
> +		ret = clk_prepare_enable(imr->clock);
> +		if (ret < 0)
> +			goto device_prepare_rollback;
> +	}
> +
> +	imr->refcount++;
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev, "IMR device opened (refcount=%u)\n",
> +		 imr->refcount);
> +
> +	return 0;
> +
> +device_prepare_rollback:
> +	/* unlock global device data */
> +	mutex_unlock(&imr->mutex);
> +
> +v4l_prepare_rollback:
> +	/* destroy context */
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	return ret;
> +}
> +
> +static int imr_release(struct file *file)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	struct imr_device	*imr = video_drvdata(file);
> +
> +	/* I don't need to get a device scope lock here really - TBD */
> +	mutex_lock(&imr->mutex);
> +
> +	/* destroy M2M device processing context */
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +
> +	/* drop active configuration as needed */
> +	imr_cfg_unref(ctx, ctx->cfg);
> +
> +	/* make sure there are no more active configs */
> +	WARN_ON(ctx->cfg_num);
> +
> +	/* destroy context data */
> +	kfree(ctx);
> +
> +	/* disable hardware operation */
> +	if (--imr->refcount == 0)
> +		clk_disable_unprepare(imr->clock);
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev, "closed device instance\n");
> +
> +	return 0;
> +}
> +
> +static unsigned int imr_poll(struct file *file, struct poll_table_struct *wait)
> +{
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	struct imr_device	*imr = video_drvdata(file);
> +	unsigned int		res;
> +
> +	if (mutex_lock_interruptible(&imr->mutex))
> +		return -ERESTARTSYS;
> +
> +	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&imr->mutex);
> +
> +	return res;
> +}

Set the struct v4l2_m2m_ctx q_lock field to imr->mutex.

Then you can use v4l2_m2m_fop_poll instead.

> +
> +static int imr_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct imr_device	*imr = video_drvdata(file);
> +	struct imr_ctx		*ctx = fh_to_ctx(file->private_data);
> +	int			ret;
> +
> +	/* should we protect all M2M operations with mutex? - TBD */
> +	if (mutex_lock_interruptible(&imr->mutex))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +
> +	mutex_unlock(&imr->mutex);
> +
> +	return ret;
> +}

Use v4l2_m2m_fop_mmap. And this is one file operation where you shouldn't lock.
The vb2 core has a special mutex to handle this.

> +
> +static const struct v4l2_file_operations imr_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= imr_open,
> +	.release	= imr_release,
> +	.poll		= imr_poll,
> +	.mmap		= imr_mmap,
> +	.unlocked_ioctl	= video_ioctl2,
> +};
> +
> +/*******************************************************************************
> + * M2M device interface
> + ******************************************************************************/
> +
> +/* job execution function */
> +static void imr_device_run(void *priv)
> +{
> +	struct imr_ctx		*ctx = priv;
> +	struct imr_device	*imr = ctx->imr;
> +	struct vb2_buffer	*src_buf, *dst_buf;
> +	u32			src_addr,  dst_addr;
> +	unsigned long		flags;
> +	struct imr_cfg		*cfg;
> +
> +	v4l2_dbg(3, debug, &imr->v4l2_dev, "run next job...\n");
> +
> +	/* protect access to internal device state */
> +	spin_lock_irqsave(&imr->lock, flags);
> +
> +	/* retrieve input/output buffers */
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +	/* take configuration pointer associated with input buffer */
> +	cfg = to_imr_buffer(to_vb2_v4l2_buffer(src_buf))->cfg;
> +
> +	/* cancel software reset state as needed */
> +	iowrite32(0, imr->mmio + IMR_CR);
> +
> +	/* set composing data with respect to destination subpixel mode */
> +	iowrite32(ctx->rect.min.x << cfg->dst_subpixel, imr->mmio + IMR_XMINR);
> +	iowrite32(ctx->rect.min.y << cfg->dst_subpixel, imr->mmio + IMR_YMINR);
> +	iowrite32(ctx->rect.max.x << cfg->dst_subpixel, imr->mmio + IMR_XMAXR);
> +	iowrite32(ctx->rect.max.y << cfg->dst_subpixel, imr->mmio + IMR_YMAXR);
> +
> +	/*
> +	 * adjust source/destination parameters of the program
> +	 * (interleaved/semiplanar)
> +	 */
> +	*cfg->src_pa_ptr[0] = src_addr =
> +		(u32)vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	*cfg->dst_pa_ptr[0] = dst_addr =
> +		(u32)vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +
> +	/* adjust source/destination parameters of the UV plane as needed */
> +	if (cfg->src_pa_ptr[1] && cfg->dst_pa_ptr[1]) {
> +		*cfg->src_pa_ptr[1] = src_addr +
> +			ctx->queue[0].fmt.width * ctx->queue[0].fmt.height;
> +		*cfg->dst_pa_ptr[1] = dst_addr +
> +			ctx->queue[1].fmt.width * ctx->queue[1].fmt.height;
> +	}
> +
> +	v4l2_dbg(3, debug, &imr->v4l2_dev,
> +		 "process buffer-pair 0x%08x:0x%08x\n",
> +		 *cfg->src_pa_ptr[0], *cfg->dst_pa_ptr[0]);
> +
> +	/* force clearing of the status register bits */
> +	iowrite32(IMR_SR_TRA | IMR_SR_IER | IMR_SR_INT, imr->mmio + IMR_SRCR);
> +
> +	/* unmask/enable interrupts */
> +	iowrite32(ioread32(imr->mmio + IMR_ICR) |
> +		  (IMR_ICR_TRAENB | IMR_ICR_IERENB | IMR_ICR_INTENB),
> +		  imr->mmio + IMR_ICR);
> +	iowrite32(ioread32(imr->mmio + IMR_IMR) &
> +		  ~(IMR_IMR_TRAM | IMR_IMR_IEM | IMR_IMR_INM),
> +		  imr->mmio + IMR_IMR);
> +
> +	/* set display list address */
> +	iowrite32(cfg->dl_dma_addr + cfg->dl_start_offset,
> +		  imr->mmio + IMR_DLSAR);
> +
> +	/*
> +	 * explicitly flush any pending write operations
> +	 * (don't need that, I guess)
> +	 */
> +	wmb();
> +
> +	/* start rendering operation */
> +	iowrite32(IMR_CR_RS, imr->mmio + IMR_CR);
> +
> +	/* timestamp input buffer */
> +	src_buf->timestamp = ktime_get_ns();
> +
> +	/* unlock device access */
> +	spin_unlock_irqrestore(&imr->lock, flags);
> +
> +	v4l2_dbg(1, debug, &imr->v4l2_dev,
> +		 "rendering started: status=%x, DLSAR=0x%08x, DLPR=0x%08x\n",
> +		 ioread32(imr->mmio + IMR_SR), ioread32(imr->mmio + IMR_DLSAR),
> +		 ioread32(imr->mmio + IMR_DLPR));
> +}
> +
> +/* check whether a job is ready for execution */
> +static int imr_job_ready(void *priv)
> +{
> +	/* no specific requirements on the job readiness */
> +	return 1;
> +}
> +
> +/* abort currently processed job */
> +static void imr_job_abort(void *priv)
> +{
> +	struct imr_ctx		*ctx = priv;
> +	struct imr_device	*imr = ctx->imr;
> +	unsigned long		flags;
> +
> +	/* protect access to internal device state */
> +	spin_lock_irqsave(&imr->lock, flags);
> +
> +	/*
> +	 * make sure current job is still current
> +	 * (may get finished by interrupt already)
> +	 */
> +	if (v4l2_m2m_get_curr_priv(imr->m2m_dev) == ctx) {
> +		v4l2_dbg(1, debug, &imr->v4l2_dev,
> +			 "abort job: status=%x, DLSAR=0x%08x, DLPR=0x%08x\n",
> +			 ioread32(imr->mmio + IMR_SR),
> +			 ioread32(imr->mmio + IMR_DLSAR),
> +			 ioread32(imr->mmio + IMR_DLPR));
> +
> +		/*
> +		 * resetting the module while operation is active may lead to
> +		 * h/w stall
> +		 */
> +		spin_unlock_irqrestore(&imr->lock, flags);
> +	} else {
> +		spin_unlock_irqrestore(&imr->lock, flags);
> +		v4l2_dbg(1, debug, &imr->v4l2_dev,
> +			 "job has completed already\n");
> +	}
> +}
> +
> +/* M2M interface definition */
> +static struct v4l2_m2m_ops imr_m2m_ops = {
> +	.device_run	= imr_device_run,
> +	.job_ready	= imr_job_ready,
> +	.job_abort	= imr_job_abort,
> +};
> +
> +/*******************************************************************************
> + * Interrupt handling
> + ******************************************************************************/
> +
> +static irqreturn_t imr_irq_handler(int irq, void *data)
> +{
> +	struct imr_device	*imr = data;
> +	struct vb2_v4l2_buffer	*src_buf, *dst_buf;
> +	bool			finish = false;
> +	u32			status;
> +	struct imr_ctx		*ctx;
> +
> +	/* check and ack interrupt status */
> +	status = ioread32(imr->mmio + IMR_SR);
> +	iowrite32(status, imr->mmio + IMR_SRCR);
> +	if (!(status & (IMR_SR_INT | IMR_SR_IER | IMR_SR_TRA))) {
> +		v4l2_err(&imr->v4l2_dev, "spurious interrupt: %x\n", status);
> +		return IRQ_NONE;
> +	}
> +
> +	/* protect access to current context */
> +	spin_lock(&imr->lock);
> +
> +	/* get current job context (may have been cancelled already) */
> +	ctx = v4l2_m2m_get_curr_priv(imr->m2m_dev);
> +	if (!ctx) {
> +		v4l2_dbg(3, debug, &imr->v4l2_dev, "no active job\n");
> +		goto handled;
> +	}
> +
> +	/* remove buffers (may have been removed already?) */
> +	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	if (!src_buf || !dst_buf) {
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "no buffers associated with current context\n");
> +		goto handled;
> +	}
> +
> +	finish = true;
> +
> +	/* check for a TRAP interrupt indicating completion of current DL */
> +	if (status & IMR_SR_TRA) {
> +		/* operation completed normally; timestamp output buffer */
> +		dst_buf->vb2_buf.timestamp = ktime_get_ns();
> +		if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE)
> +			dst_buf->timecode = src_buf->timecode;
> +		dst_buf->flags = src_buf->flags &
> +			(V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_KEYFRAME |
> +			 V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME |
> +			 V4L2_BUF_FLAG_TSTAMP_SRC_MASK);
> +		dst_buf->sequence = src_buf->sequence = ctx->sequence++;
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "buffers <0x%08x,0x%08x> done\n",
> +			(u32)vb2_dma_contig_plane_dma_addr
> +				(&src_buf->vb2_buf, 0),
> +			(u32)vb2_dma_contig_plane_dma_addr
> +				(&dst_buf->vb2_buf, 0));
> +	} else {
> +		/*
> +		 * operation completed in error; no way to understand
> +		 * what exactly went wrong
> +		 */
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
> +		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
> +
> +		v4l2_dbg(3, debug, &imr->v4l2_dev,
> +			 "buffers <0x%08x,0x%08x> done in error\n",
> +			 (u32)vb2_dma_contig_plane_dma_addr
> +				(&src_buf->vb2_buf, 0),
> +			 (u32)vb2_dma_contig_plane_dma_addr
> +				(&dst_buf->vb2_buf, 0));
> +	}
> +
> +handled:
> +	spin_unlock(&imr->lock);
> +
> +	/* finish current job (and start any pending) */
> +	if (finish)
> +		v4l2_m2m_job_finish(imr->m2m_dev, ctx->m2m_ctx);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*******************************************************************************
> + * Device probing/removal interface
> + ******************************************************************************/
> +
> +static int imr_probe(struct platform_device *pdev)
> +{
> +	struct imr_device	*imr;
> +	struct resource		*res;
> +	int			ret;
> +
> +	imr = devm_kzalloc(&pdev->dev, sizeof(*imr), GFP_KERNEL);
> +	if (!imr)
> +		return -ENOMEM;
> +
> +	mutex_init(&imr->mutex);
> +	spin_lock_init(&imr->lock);
> +	imr->dev = &pdev->dev;
> +
> +	/* memory-mapped registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	imr->mmio = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(imr->mmio))
> +		return PTR_ERR(imr->mmio);
> +
> +	/* interrupt service routine registration */
> +	imr->irq = ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot find IRQ\n");
> +		return ret;
> +	}
> +
> +	ret = devm_request_irq(&pdev->dev, imr->irq, imr_irq_handler, 0,
> +			       dev_name(&pdev->dev), imr);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot claim IRQ %d\n", imr->irq);
> +		return ret;
> +	}
> +
> +	imr->clock = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(imr->clock)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return PTR_ERR(imr->clock);
> +	}
> +
> +	/* create v4l2 device */
> +	ret = v4l2_device_register(&pdev->dev, &imr->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		return ret;
> +	}
> +
> +	/* create mem2mem device handle */
> +	imr->m2m_dev = v4l2_m2m_init(&imr_m2m_ops);
> +	if (IS_ERR(imr->m2m_dev)) {
> +		v4l2_err(&imr->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(imr->m2m_dev);
> +		goto device_register_rollback;
> +	}
> +
> +	strlcpy(imr->video_dev.name, dev_name(&pdev->dev),
> +		sizeof(imr->video_dev.name));
> +	imr->video_dev.fops	    = &imr_fops;
> +	imr->video_dev.device_caps  = V4L2_CAP_VIDEO_CAPTURE |
> +				      V4L2_CAP_VIDEO_OUTPUT |
> +				      V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;

Only specify V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING.
M2M cannot be combined with CAPTURE and OUTPUT.

> +	imr->video_dev.ioctl_ops    = &imr_ioctl_ops;
> +	imr->video_dev.minor	    = -1;
> +	imr->video_dev.release	    = video_device_release_empty;
> +	imr->video_dev.lock	    = &imr->mutex;
> +	imr->video_dev.v4l2_dev	    = &imr->v4l2_dev;
> +	imr->video_dev.vfl_dir	    = VFL_DIR_M2M;
> +
> +	ret = video_register_device(&imr->video_dev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&imr->v4l2_dev, "Failed to register video device\n");
> +		goto m2m_init_rollback;
> +	}
> +
> +	video_set_drvdata(&imr->video_dev, imr);
> +	platform_set_drvdata(pdev, imr);
> +
> +	v4l2_info(&imr->v4l2_dev,
> +		  "IMR device (pdev: %d) registered as /dev/video%d\n",
> +		  pdev->id, imr->video_dev.num);
> +
> +	return 0;
> +
> +m2m_init_rollback:
> +	v4l2_m2m_release(imr->m2m_dev);
> +
> +device_register_rollback:
> +	v4l2_device_unregister(&imr->v4l2_dev);
> +
> +	return ret;
> +}
> +
> +static int imr_remove(struct platform_device *pdev)
> +{
> +	struct imr_device *imr = platform_get_drvdata(pdev);
> +
> +	video_unregister_device(&imr->video_dev);
> +	v4l2_m2m_release(imr->m2m_dev);
> +	v4l2_device_unregister(&imr->v4l2_dev);
> +
> +	return 0;
> +}
> +
> +/*******************************************************************************
> + * Power management
> + ******************************************************************************/
> +
> +#ifdef CONFIG_PM_SLEEP
> +
> +/* device suspend hook; clock control only - TBD */
> +static int imr_pm_suspend(struct device *dev)
> +{
> +	struct imr_device *imr = dev_get_drvdata(dev);
> +
> +	WARN_ON(mutex_is_locked(&imr->mutex));
> +
> +	if (imr->refcount == 0)
> +		return 0;
> +
> +	clk_disable_unprepare(imr->clock);
> +
> +	return 0;
> +}
> +
> +/* device resume hook; clock control only */
> +static int imr_pm_resume(struct device *dev)
> +{
> +	struct imr_device *imr = dev_get_drvdata(dev);
> +
> +	WARN_ON(mutex_is_locked(&imr->mutex));
> +
> +	if (imr->refcount == 0)
> +		return 0;
> +
> +	clk_prepare_enable(imr->clock);
> +
> +	return 0;
> +}
> +
> +#endif  /* CONFIG_PM_SLEEP */
> +
> +/* power management callbacks */
> +static const struct dev_pm_ops imr_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(imr_pm_suspend, imr_pm_resume)
> +};
> +
> +/* device table */
> +static const struct of_device_id imr_of_match[] = {
> +	{ .compatible = "renesas,imr-lx4" },
> +	{ },
> +};
> +
> +/* platform driver interface */
> +static struct platform_driver imr_platform_driver = {
> +	.probe		= imr_probe,
> +	.remove		= imr_remove,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= "imr",
> +		.pm		= &imr_pm_ops,
> +		.of_match_table = imr_of_match,
> +	},
> +};
> +
> +module_platform_driver(imr_platform_driver);
> +
> +MODULE_ALIAS("imr");
> +MODULE_AUTHOR("Cogent Embedded Inc. <sources@cogentembedded.com>");
> +MODULE_DESCRIPTION("Renesas IMR-LX4 Driver");
> +MODULE_LICENSE("GPL");
> Index: media_tree/include/uapi/linux/rcar_imr.h
> ===================================================================
> --- /dev/null
> +++ media_tree/include/uapi/linux/rcar_imr.h
> @@ -0,0 +1,94 @@
> +/*
> + * rcar_imr.h -- R-Car IMR-LX4 Driver UAPI
> + *
> + * Copyright (C) 2016-2017 Cogent Embedded, Inc. <source@cogentembedded.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __RCAR_IMR_H
> +#define __RCAR_IMR_H
> +
> +#include <linux/videodev2.h>
> +
> +/*******************************************************************************
> + * Mapping specification descriptor
> + ******************************************************************************/
> +
> +struct imr_map_desc {
> +	/* mapping types */
> +	__u32			type;
> +
> +	/* total size of the mesh structure */
> +	__u32			size;
> +
> +	/* map-specific user-pointer */
> +	__u64			data;
> +} __packed;
> +
> +/* regular mesh specification */
> +#define IMR_MAP_MESH		(1 << 0)
> +
> +/* auto-generated source coordinates */
> +#define IMR_MAP_AUTOSG		(1 << 1)
> +
> +/* auto-generated destination coordinates */
> +#define IMR_MAP_AUTODG		(1 << 2)
> +
> +/* luminance correction flag */
> +#define IMR_MAP_LUCE		(1 << 3)
> +
> +/* chromacity correction flag */

chromacity? You probably mean just plain 'chroma'. Ditto below.

> +#define IMR_MAP_CLCE		(1 << 4)
> +
> +/* vertex clockwise-mode order */
> +#define IMR_MAP_TCM		(1 << 5)
> +
> +/* source coordinate decimal point position */
> +#define __IMR_MAP_UVDPOR_SHIFT	8
> +#define __IMR_MAP_UVDPOR(v)	(((v) >> __IMR_MAP_UVDPOR_SHIFT) & 0x7)
> +#define IMR_MAP_UVDPOR(n)	(((n) & 0x7) << __IMR_MAP_UVDPOR_SHIFT)
> +
> +/* destination coordinate sub-pixel mode */
> +#define IMR_MAP_DDP		(1 << 11)
> +
> +/* luminance correction offset decimal point position */
> +#define __IMR_MAP_YLDPO_SHIFT	12
> +#define __IMR_MAP_YLDPO(v)	(((v) >> __IMR_MAP_YLDPO_SHIFT) & 0x7)
> +#define IMR_MAP_YLDPO(n)	(((n) & 0x7) << __IMR_MAP_YLDPO_SHIFT)
> +
> +/* chromacity (U) correction offset decimal point position */
> +#define __IMR_MAP_UBDPO_SHIFT	15
> +#define __IMR_MAP_UBDPO(v)	(((v) >> __IMR_MAP_UBDPO_SHIFT) & 0x7)
> +#define IMR_MAP_UBDPO(n)	(((n) & 0x7) << __IMR_MAP_UBDPO_SHIFT)
> +
> +/* chromacity (V) correction offset decimal point position */
> +#define __IMR_MAP_VRDPO_SHIFT	18
> +#define __IMR_MAP_VRDPO(v)	(((v) >> __IMR_MAP_VRDPO_SHIFT) & 0x7)
> +#define IMR_MAP_VRDPO(n)	(((n) & 0x7) << __IMR_MAP_VRDPO_SHIFT)
> +
> +/* regular mesh specification */
> +struct imr_mesh {
> +	/* rectangular mesh size */
> +	__u16			rows, columns;
> +
> +	/* mesh parameters */
> +	__u16			x0, y0, dx, dy;
> +} __packed;
> +
> +/* vertex-buffer-object (VBO) descriptor */
> +struct imr_vbo {
> +	/* number of triangles */
> +	__u16			num;
> +} __packed;
> +
> +/*******************************************************************************
> + * Private IOCTL codes
> + ******************************************************************************/
> +
> +#define VIDIOC_IMR_MESH _IOW('V', BASE_VIDIOC_PRIVATE + 0, struct imr_map_desc)
> +
> +#endif /* __RCAR_IMR_H */
> 

I'll post a review of the uapi mesh documentation separately.

Regards,

	Hans
