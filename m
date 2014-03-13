Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57437 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaCMPBK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 11:01:10 -0400
From: Kamil Debski <k.debski@samsung.com>
To: 'Archit Taneja' <archit@ti.com>, hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
References: <1394526833-24805-1-git-send-email-archit@ti.com>
 <1394711056-10878-1-git-send-email-archit@ti.com>
 <1394711056-10878-7-git-send-email-archit@ti.com>
In-reply-to: <1394711056-10878-7-git-send-email-archit@ti.com>
Subject: RE: [PATCH v4 06/14] v4l: ti-vpe: Fix some params in VPE data
 descriptors
Date: Thu, 13 Mar 2014 16:01:06 +0100
Message-id: <001001cf3ecd$0fdf1650$2f9d42f0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Archit Taneja [mailto:archit@ti.com]
> Sent: Thursday, March 13, 2014 12:44 PM
> To: k.debski@samsung.com; hverkuil@xs4all.nl
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org; Archit
> Taneja
> Subject: [PATCH v4 06/14] v4l: ti-vpe: Fix some params in VPE data
> descriptors
> 
> Some parameters of the VPE descriptors were understood incorrectly.
> They are now fixed. The fixes are explained as follows:
> 
> - When adding an inbound data descriptor to the VPDMA descriptor list,
> we intend
>   to use c_rect as the cropped region fetched by VPDMA. Therefore,
> c_rect->width
>   shouldn't be used to calculate the line stride, the original image
> width
>   should be used for that. We add a 'width' argument which gives the
> buffer
>   width in memory.
> 
> - frame_width and frame_height describe the complete width and height
> of the
>   client to which the channel is connected. If there are multiple
> channels
>   fetching data and providing to the same client, the above 2 arguments
> should
>   be the width and height of the region covered by all the channels. In
> the case
>   where there is only one channel providing pixel data to the client
>   (like in VPE), frame_width and frame_height should be the cropped
> width and
>   cropped height respectively. The calculation of these params is done
> in the
>   vpe driver now.
> 
> - start_h and start_v is also used in the case of multiple channels to
> describe
>   where each channel should start filling pixel data. We don't use this
> in VPE,
>   and pass 0s to the vpdma_add_in_dtd() helper.
> 
> - Some minor changes are made to the vpdma_add_out_dtd() helper. The
> c_rect
>   param is used for specifying the 'composition' target, and 'width'
> is added
>   to calculate the line stride.

This patch looks ok. Passes checkpatch and compiles. I can't say much more
as I have limited knowledge of the internals of VPE and don't have the
hardware.

> Signed-off-by: Archit Taneja <archit@ti.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> ---
>  drivers/media/platform/ti-vpe/vpdma.c | 60
> +++++++++++++++++++++++++++--------
>  drivers/media/platform/ti-vpe/vpdma.h | 10 +++---
>  drivers/media/platform/ti-vpe/vpe.c   | 18 +++++++----
>  3 files changed, 64 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c
> b/drivers/media/platform/ti-vpe/vpdma.c
> index 73dd38e..a51a013 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -614,8 +614,17 @@ static void dump_dtd(struct vpdma_dtd *dtd)
>  /*
>   * append an outbound data transfer descriptor to the given descriptor
> list,
>   * this sets up a 'client to memory' VPDMA transfer for the given
> VPDMA channel
> + *
> + * @list: vpdma desc list to which we add this decriptor
> + * @width: width of the image in pixels in memory
> + * @c_rect: compose params of output image
> + * @fmt: vpdma data format of the buffer
> + * dma_addr: dma address as seen by VPDMA
> + * chan: VPDMA channel
> + * flags: VPDMA flags to configure some descriptor fileds
>   */
> -void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect
> *c_rect,
> +void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
> +		const struct v4l2_rect *c_rect,
>  		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
>  		enum vpdma_channel chan, u32 flags)
>  {
> @@ -623,6 +632,7 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list,
> struct v4l2_rect *c_rect,
>  	int field = 0;
>  	int notify = 1;
>  	int channel, next_chan;
> +	struct v4l2_rect rect = *c_rect;
>  	int depth = fmt->depth;
>  	int stride;
>  	struct vpdma_dtd *dtd;
> @@ -630,11 +640,15 @@ void vpdma_add_out_dtd(struct vpdma_desc_list
> *list, struct v4l2_rect *c_rect,
>  	channel = next_chan = chan_info[chan].num;
> 
>  	if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV &&
> -			fmt->data_type == DATA_TYPE_C420)
> +			fmt->data_type == DATA_TYPE_C420) {
> +		rect.height >>= 1;
> +		rect.top >>= 1;
>  		depth = 8;
> +	}
> 
> -	stride = ALIGN((depth * c_rect->width) >> 3, VPDMA_STRIDE_ALIGN);
> -	dma_addr += (c_rect->left * depth) >> 3;
> +	stride = ALIGN((depth * width) >> 3, VPDMA_STRIDE_ALIGN);
> +
> +	dma_addr += rect.top * stride + (rect.left * depth >> 3);
> 
>  	dtd = list->next;
>  	WARN_ON((void *)(dtd + 1) > (list->buf.addr + list->buf.size));
> @@ -664,31 +678,48 @@ void vpdma_add_out_dtd(struct vpdma_desc_list
> *list, struct v4l2_rect *c_rect,
>  /*
>   * append an inbound data transfer descriptor to the given descriptor
> list,
>   * this sets up a 'memory to client' VPDMA transfer for the given
> VPDMA channel
> + *
> + * @list: vpdma desc list to which we add this decriptor
> + * @width: width of the image in pixels in memory(not the cropped
> + width)
> + * @c_rect: crop params of input image
> + * @fmt: vpdma data format of the buffer
> + * dma_addr: dma address as seen by VPDMA
> + * chan: VPDMA channel
> + * field: top or bottom field info of the input image
> + * flags: VPDMA flags to configure some descriptor fileds
> + * frame_width/height: the complete width/height of the image
> presented to the
> + *			client (this makes sense when multiple channels are
> + *			connected to the same client, forming a larger
frame)
> + * start_h, start_v: position where the given channel starts providing
> pixel
> + *			data to the client (makes sense when multiple
> channels
> + *			contribute to the client)
>   */
> -void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
> -		int frame_height, struct v4l2_rect *c_rect,
> +void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
> +		const struct v4l2_rect *c_rect,
>  		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
> -		enum vpdma_channel chan, int field, u32 flags)
> +		enum vpdma_channel chan, int field, u32 flags, int
> frame_width,
> +		int frame_height, int start_h, int start_v)
>  {
>  	int priority = 0;
>  	int notify = 1;
>  	int depth = fmt->depth;
>  	int channel, next_chan;
> +	struct v4l2_rect rect = *c_rect;
>  	int stride;
> -	int height = c_rect->height;
>  	struct vpdma_dtd *dtd;
> 
>  	channel = next_chan = chan_info[chan].num;
> 
>  	if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV &&
>  			fmt->data_type == DATA_TYPE_C420) {
> -		height >>= 1;
> -		frame_height >>= 1;
> +		rect.height >>= 1;
> +		rect.top >>= 1;
>  		depth = 8;
>  	}
> 
> -	stride = ALIGN((depth * c_rect->width) >> 3, VPDMA_STRIDE_ALIGN);
> -	dma_addr += (c_rect->left * depth) >> 3;
> +	stride = ALIGN((depth * width) >> 3, VPDMA_STRIDE_ALIGN);
> +
> +	dma_addr += rect.top * stride + (rect.left * depth >> 3);
> 
>  	dtd = list->next;
>  	WARN_ON((void *)(dtd + 1) > (list->buf.addr + list->buf.size));
> @@ -701,13 +732,14 @@ void vpdma_add_in_dtd(struct vpdma_desc_list
> *list, int frame_width,
>  					!!(flags &
VPDMA_DATA_ODD_LINE_SKIP),
>  					stride);
> 
> -	dtd->xfer_length_height = dtd_xfer_length_height(c_rect->width,
> height);
> +	dtd->xfer_length_height = dtd_xfer_length_height(rect.width,
> +					rect.height);
>  	dtd->start_addr = (u32) dma_addr;
>  	dtd->pkt_ctl = dtd_pkt_ctl(!!(flags & VPDMA_DATA_MODE_TILED),
>  				DTD_DIR_IN, channel, priority, next_chan);
>  	dtd->frame_width_height = dtd_frame_width_height(frame_width,
>  					frame_height);
> -	dtd->start_h_v = dtd_start_h_v(c_rect->left, c_rect->top);
> +	dtd->start_h_v = dtd_start_h_v(start_h, start_v);
>  	dtd->client_attr0 = 0;
>  	dtd->client_attr1 = 0;
> 
> diff --git a/drivers/media/platform/ti-vpe/vpdma.h
> b/drivers/media/platform/ti-vpe/vpdma.h
> index bf5f8bb..2bd8fb0 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.h
> +++ b/drivers/media/platform/ti-vpe/vpdma.h
> @@ -186,13 +186,15 @@ void vpdma_add_cfd_adb(struct vpdma_desc_list
> *list, int client,
>  		struct vpdma_buf *adb);
>  void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
>  		enum vpdma_channel chan);
> -void vpdma_add_out_dtd(struct vpdma_desc_list *list, struct v4l2_rect
> *c_rect,
> +void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
> +		const struct v4l2_rect *c_rect,
>  		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
>  		enum vpdma_channel chan, u32 flags);
> -void vpdma_add_in_dtd(struct vpdma_desc_list *list, int frame_width,
> -		int frame_height, struct v4l2_rect *c_rect,
> +void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
> +		const struct v4l2_rect *c_rect,
>  		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
> -		enum vpdma_channel chan, int field, u32 flags);
> +		enum vpdma_channel chan, int field, u32 flags, int
> frame_width,
> +		int frame_height, int start_h, int start_v);
> 
>  /* vpdma list interrupt management */
>  void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int
> list_num, diff --git a/drivers/media/platform/ti-vpe/vpe.c
> b/drivers/media/platform/ti-vpe/vpe.c
> index dbdc338..ece9b96 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -986,7 +986,6 @@ static void add_out_dtd(struct vpe_ctx *ctx, int
> port)
>  	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_DST];
>  	const struct vpe_port_data *p_data = &port_data[port];
>  	struct vb2_buffer *vb = ctx->dst_vb;
> -	struct v4l2_rect *c_rect = &q_data->c_rect;
>  	struct vpe_fmt *fmt = q_data->fmt;
>  	const struct vpdma_data_format *vpdma_fmt;
>  	int mv_buf_selector = !ctx->src_mv_buf_selector; @@ -1015,8
> +1014,8 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
>  	if (q_data->flags & Q_DATA_MODE_TILED)
>  		flags |= VPDMA_DATA_MODE_TILED;
> 
> -	vpdma_add_out_dtd(&ctx->desc_list, c_rect, vpdma_fmt, dma_addr,
> -		p_data->channel, flags);
> +	vpdma_add_out_dtd(&ctx->desc_list, q_data->width, &q_data->c_rect,
> +		vpdma_fmt, dma_addr, p_data->channel, flags);
>  }
> 
>  static void add_in_dtd(struct vpe_ctx *ctx, int port) @@ -1024,11
> +1023,11 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
>  	struct vpe_q_data *q_data = &ctx->q_data[Q_DATA_SRC];
>  	const struct vpe_port_data *p_data = &port_data[port];
>  	struct vb2_buffer *vb = ctx->src_vbs[p_data->vb_index];
> -	struct v4l2_rect *c_rect = &q_data->c_rect;
>  	struct vpe_fmt *fmt = q_data->fmt;
>  	const struct vpdma_data_format *vpdma_fmt;
>  	int mv_buf_selector = ctx->src_mv_buf_selector;
>  	int field = vb->v4l2_buf.field == V4L2_FIELD_BOTTOM;
> +	int frame_width, frame_height;
>  	dma_addr_t dma_addr;
>  	u32 flags = 0;
> 
> @@ -1055,8 +1054,15 @@ static void add_in_dtd(struct vpe_ctx *ctx, int
> port)
>  	if (q_data->flags & Q_DATA_MODE_TILED)
>  		flags |= VPDMA_DATA_MODE_TILED;
> 
> -	vpdma_add_in_dtd(&ctx->desc_list, q_data->width, q_data->height,
> -		c_rect, vpdma_fmt, dma_addr, p_data->channel, field, flags);
> +	frame_width = q_data->c_rect.width;
> +	frame_height = q_data->c_rect.height;
> +
> +	if (p_data->vb_part && fmt->fourcc == V4L2_PIX_FMT_NV12)
> +		frame_height /= 2;
> +
> +	vpdma_add_in_dtd(&ctx->desc_list, q_data->width, &q_data->c_rect,
> +		vpdma_fmt, dma_addr, p_data->channel, field, flags,
> frame_width,
> +		frame_height, 0, 0);
>  }
> 
>  /*
> --
> 1.8.3.2

