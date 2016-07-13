Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46536
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbcGMS64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 14:58:56 -0400
Date: Wed, 13 Jul 2016 15:58:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH 14/28] gpu: ipu-ic: Add complete image conversion
 support with tiling
Message-ID: <20160713155831.696f202f@recife.lan>
In-Reply-To: <1467846418-12913-15-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
	<1467846418-12913-1-git-send-email-steve_longerbeam@mentor.com>
	<1467846418-12913-15-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed,  6 Jul 2016 16:06:44 -0700
Steve Longerbeam <slongerbeam@gmail.com> escreveu:

> This patch implements complete image conversion support to ipu-ic,
> with tiling to support scaling to and from images up to 4096x4096.
> Image rotation is also supported.
> 
> The internal API is subsystem agnostic (no V4L2 dependency except
> for the use of V4L2 fourcc pixel formats).
> 
> Callers prepare for image conversion by calling
> ipu_image_convert_prepare(), which initializes the parameters of
> the conversion. The caller passes in the ipu_ic task to use for
> the conversion, the input and output image formats, a rotation mode,
> and a completion callback and completion context pointer:
> 
> struct image_converter_ctx *
> ipu_image_convert_prepare(struct ipu_ic *ic,
>                           struct ipu_image *in, struct ipu_image *out,
>                           enum ipu_rotate_mode rot_mode,
>                           image_converter_cb_t complete,
>                           void *complete_context);
> 
> The caller is given a new conversion context that must be passed to
> the further APIs:
> 
> struct image_converter_run *
> ipu_image_convert_run(struct image_converter_ctx *ctx,
>                       dma_addr_t in_phys, dma_addr_t out_phys);
> 
> This queues a new image conversion request to a run queue, and
> starts the conversion immediately if the run queue is empty. Only
> the physaddr's of the input and output image buffers are needed,
> since the conversion context was created previously with
> ipu_image_convert_prepare(). Returns a new run object pointer. When
> the conversion completes, the run pointer is returned to the
> completion callback.
> 
> void image_convert_abort(struct image_converter_ctx *ctx);
> 
> This will abort any active or pending conversions for this context.
> Any currently active or pending runs belonging to this context are
> returned via the completion callback with an error status.
> 
> void ipu_image_convert_unprepare(struct image_converter_ctx *ctx);
> 
> Unprepares the conversion context. Any active or pending runs will
> be aborted by calling image_convert_abort().
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c | 1691 ++++++++++++++++++++++++++++++++++++++++++-
>  include/video/imx-ipu-v3.h  |   57 +-
>  2 files changed, 1736 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index 5329bfe..f6a1125 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -17,6 +17,8 @@
>  #include <linux/bitrev.h>
>  #include <linux/io.h>
>  #include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
>  #include "ipu-prv.h"
>  
>  /* IC Register Offsets */
> @@ -82,6 +84,40 @@
>  #define IC_IDMAC_3_PP_WIDTH_MASK        (0x3ff << 20)
>  #define IC_IDMAC_3_PP_WIDTH_OFFSET      20
>  
> +/*
> + * The IC Resizer has a restriction that the output frame from the
> + * resizer must be 1024 or less in both width (pixels) and height
> + * (lines).
> + *
> + * The image conversion support attempts to split up a conversion when
> + * the desired output (converted) frame resolution exceeds the IC resizer
> + * limit of 1024 in either dimension.
> + *
> + * If either dimension of the output frame exceeds the limit, the
> + * dimension is split into 1, 2, or 4 equal stripes, for a maximum
> + * of 4*4 or 16 tiles. A conversion is then carried out for each
> + * tile (but taking care to pass the full frame stride length to
> + * the DMA channel's parameter memory!). IDMA double-buffering is used
> + * to convert each tile back-to-back when possible (see note below
> + * when double_buffering boolean is set).
> + *
> + * Note that the input frame must be split up into the same number
> + * of tiles as the output frame.
> + */
> +#define MAX_STRIPES_W    4
> +#define MAX_STRIPES_H    4
> +#define MAX_TILES (MAX_STRIPES_W * MAX_STRIPES_H)
> +
> +#define MIN_W     128
> +#define MIN_H     128
> +#define MAX_W     4096
> +#define MAX_H     4096
> +
> +enum image_convert_type {
> +	IMAGE_CONVERT_IN = 0,
> +	IMAGE_CONVERT_OUT,
> +};
> +
>  struct ic_task_regoffs {
>  	u32 rsc;
>  	u32 tpmem_csc[2];
> @@ -96,6 +132,16 @@ struct ic_task_bitfields {
>  	u32 ic_cmb_galpha_bit;
>  };
>  
> +struct ic_task_channels {
> +	int in;
> +	int out;
> +	int rot_in;
> +	int rot_out;
> +	int vdi_in_p;
> +	int vdi_in;
> +	int vdi_in_n;
> +};
> +
>  static const struct ic_task_regoffs ic_task_reg[IC_NUM_TASKS] = {
>  	[IC_TASK_ENCODER] = {
>  		.rsc = IC_PRP_ENC_RSC,
> @@ -138,12 +184,159 @@ static const struct ic_task_bitfields ic_task_bit[IC_NUM_TASKS] = {
>  	},
>  };
>  
> +static const struct ic_task_channels ic_task_ch[IC_NUM_TASKS] = {
> +	[IC_TASK_ENCODER] = {
> +		.out = IPUV3_CHANNEL_IC_PRP_ENC_MEM,
> +		.rot_in = IPUV3_CHANNEL_MEM_ROT_ENC,
> +		.rot_out = IPUV3_CHANNEL_ROT_ENC_MEM,
> +	},
> +	[IC_TASK_VIEWFINDER] = {
> +		.in = IPUV3_CHANNEL_MEM_IC_PRP_VF,
> +		.out = IPUV3_CHANNEL_IC_PRP_VF_MEM,
> +		.rot_in = IPUV3_CHANNEL_MEM_ROT_VF,
> +		.rot_out = IPUV3_CHANNEL_ROT_VF_MEM,
> +		.vdi_in_p = IPUV3_CHANNEL_MEM_VDI_P,
> +		.vdi_in = IPUV3_CHANNEL_MEM_VDI,
> +		.vdi_in_n = IPUV3_CHANNEL_MEM_VDI_N,
> +	},
> +	[IC_TASK_POST_PROCESSOR] = {
> +		.in = IPUV3_CHANNEL_MEM_IC_PP,
> +		.out = IPUV3_CHANNEL_IC_PP_MEM,
> +		.rot_in = IPUV3_CHANNEL_MEM_ROT_PP,
> +		.rot_out = IPUV3_CHANNEL_ROT_PP_MEM,
> +	},
> +};
> +
> +struct ipu_ic_dma_buf {
> +	void          *virt;
> +	dma_addr_t    phys;
> +	unsigned long len;
> +};
> +
> +/* dimensions of one tile */
> +struct ipu_ic_tile {
> +	unsigned int width;
> +	unsigned int height;
> +	/* size and strides are in bytes */
> +	unsigned int size;
> +	unsigned int stride;
> +	unsigned int rot_stride;
> +};
> +
> +struct ipu_ic_tile_off {
> +	/* start Y or packed offset of this tile */
> +	u32     offset;
> +	/* offset from start to tile in U plane, for planar formats */
> +	u32     u_off;
> +	/* offset from start to tile in V plane, for planar formats */
> +	u32     v_off;
> +};
> +
> +struct ipu_ic_pixfmt {
> +	char	*name;
> +	u32	fourcc;        /* V4L2 fourcc */
> +	int     bpp;           /* total bpp */
> +	int     y_depth;       /* depth of Y plane for planar formats */
> +	int     uv_width_dec;  /* decimation in width for U/V planes */
> +	int     uv_height_dec; /* decimation in height for U/V planes */
> +	bool    uv_swapped;    /* U and V planes are swapped */
> +	bool    uv_packed;     /* partial planar (U and V in same plane) */
> +};
> +
> +struct ipu_ic_image {
> +	struct ipu_image base;
> +	enum image_convert_type type;
> +
> +	const struct ipu_ic_pixfmt *fmt;
> +	unsigned int stride;
> +
> +	/* # of rows (horizontal stripes) if dest height is > 1024 */
> +	unsigned int num_rows;
> +	/* # of columns (vertical stripes) if dest width is > 1024 */
> +	unsigned int num_cols;
> +
> +	struct ipu_ic_tile tile;
> +	struct ipu_ic_tile_off tile_off[MAX_TILES];
> +};
> +
> +struct image_converter_ctx;
> +struct image_converter;
>  struct ipu_ic_priv;
> +struct ipu_ic;
> +
> +struct image_converter_run {
> +	struct image_converter_ctx *ctx;
> +
> +	dma_addr_t in_phys;
> +	dma_addr_t out_phys;
> +
> +	int status;
> +
> +	struct list_head list;
> +};
> +
> +struct image_converter_ctx {
> +	struct image_converter *cvt;
> +
> +	image_converter_cb_t complete;
> +	void *complete_context;
> +
> +	/* Source/destination image data and rotation mode */
> +	struct ipu_ic_image in;
> +	struct ipu_ic_image out;
> +	enum ipu_rotate_mode rot_mode;
> +
> +	/* intermediate buffer for rotation */
> +	struct ipu_ic_dma_buf rot_intermediate[2];
> +
> +	/* current buffer number for double buffering */
> +	int cur_buf_num;
> +
> +	bool aborting;
> +	struct completion aborted;
> +
> +	/* can we use double-buffering for this conversion operation? */
> +	bool double_buffering;
> +	/* num_rows * num_cols */
> +	unsigned int num_tiles;
> +	/* next tile to process */
> +	unsigned int next_tile;
> +	/* where to place converted tile in dest image */
> +	unsigned int out_tile_map[MAX_TILES];
> +
> +	struct list_head list;
> +};
> +
> +struct image_converter {
> +	struct ipu_ic *ic;
> +
> +	struct ipuv3_channel *in_chan;
> +	struct ipuv3_channel *out_chan;
> +	struct ipuv3_channel *rotation_in_chan;
> +	struct ipuv3_channel *rotation_out_chan;
> +
> +	/* the IPU end-of-frame irqs */
> +	int out_eof_irq;
> +	int rot_out_eof_irq;
> +
> +	spinlock_t irqlock;
> +
> +	/* list of convert contexts */
> +	struct list_head ctx_list;
> +	/* queue of conversion runs */
> +	struct list_head pending_q;
> +	/* queue of completed runs */
> +	struct list_head done_q;
> +
> +	/* the current conversion run */
> +	struct image_converter_run *current_run;
> +};
>  
>  struct ipu_ic {
>  	enum ipu_ic_task task;
>  	const struct ic_task_regoffs *reg;
>  	const struct ic_task_bitfields *bit;
> +	const struct ic_task_channels *ch;
>  
>  	enum ipu_color_space in_cs, g_in_cs;
>  	enum ipu_color_space out_cs;
> @@ -151,6 +344,8 @@ struct ipu_ic {
>  	bool rotation;
>  	bool in_use;
>  
> +	struct image_converter cvt;
> +
>  	struct ipu_ic_priv *priv;
>  };
>  
> @@ -619,7 +814,7 @@ int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
>  	ipu_ic_write(ic, ic_idmac_2, IC_IDMAC_2);
>  	ipu_ic_write(ic, ic_idmac_3, IC_IDMAC_3);
>  
> -	if (rot >= IPU_ROTATE_90_RIGHT)
> +	if (ipu_rot_mode_is_irt(rot))
>  		ic->rotation = true;
>  
>  unlock:
> @@ -661,6 +856,1480 @@ static void ipu_irt_disable(struct ipu_ic *ic)
>  		priv->irt_use_count = 0;
>  }
>  
> +/*
> + * Complete image conversion support follows
> + */
> +
> +static const struct ipu_ic_pixfmt ipu_ic_formats[] = {
> +	{
> +		.name	= "RGB565",
> +		.fourcc	= V4L2_PIX_FMT_RGB565,
> +		.bpp    = 16,
> +	}, {
> +		.name	= "RGB24",
> +		.fourcc	= V4L2_PIX_FMT_RGB24,
> +		.bpp    = 24,
> +	}, {
> +		.name	= "BGR24",
> +		.fourcc	= V4L2_PIX_FMT_BGR24,
> +		.bpp    = 24,
> +	}, {
> +		.name	= "RGB32",
> +		.fourcc	= V4L2_PIX_FMT_RGB32,
> +		.bpp    = 32,
> +	}, {
> +		.name	= "BGR32",
> +		.fourcc	= V4L2_PIX_FMT_BGR32,
> +		.bpp    = 32,
> +	}, {
> +		.name	= "4:2:2 packed, YUYV",
> +		.fourcc	= V4L2_PIX_FMT_YUYV,
> +		.bpp    = 16,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 1,
> +	}, {
> +		.name	= "4:2:2 packed, UYVY",
> +		.fourcc	= V4L2_PIX_FMT_UYVY,
> +		.bpp    = 16,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 1,
> +	}, {
> +		.name	= "4:2:0 planar, YUV",
> +		.fourcc	= V4L2_PIX_FMT_YUV420,
> +		.bpp    = 12,
> +		.y_depth = 8,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 2,
> +	}, {
> +		.name	= "4:2:0 planar, YVU",
> +		.fourcc	= V4L2_PIX_FMT_YVU420,
> +		.bpp    = 12,
> +		.y_depth = 8,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 2,
> +		.uv_swapped = true,
> +	}, {
> +		.name   = "4:2:0 partial planar, NV12",
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.bpp    = 12,
> +		.y_depth = 8,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 2,
> +		.uv_packed = true,
> +	}, {
> +		.name   = "4:2:2 planar, YUV",
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.bpp    = 16,
> +		.y_depth = 8,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 1,
> +	}, {
> +		.name   = "4:2:2 partial planar, NV16",
> +		.fourcc = V4L2_PIX_FMT_NV16,
> +		.bpp    = 16,
> +		.y_depth = 8,
> +		.uv_width_dec = 2,
> +		.uv_height_dec = 1,
> +		.uv_packed = true,
> +	},
> +};
> +
> +static const struct ipu_ic_pixfmt *ipu_ic_get_format(u32 fourcc)
> +{
> +	const struct ipu_ic_pixfmt *ret = NULL;
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(ipu_ic_formats); i++) {
> +		if (ipu_ic_formats[i].fourcc == fourcc) {
> +			ret = &ipu_ic_formats[i];
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static void ipu_ic_dump_format(struct image_converter_ctx *ctx,
> +			       struct ipu_ic_image *ic_image)
> +{
> +	struct ipu_ic_priv *priv = ctx->cvt->ic->priv;
> +
> +	dev_dbg(priv->ipu->dev,
> +		"ctx %p: %s format: %dx%d (%dx%d tiles of size %dx%d), %c%c%c%c\n",
> +		ctx,
> +		ic_image->type == IMAGE_CONVERT_OUT ? "Output" : "Input",
> +		ic_image->base.pix.width, ic_image->base.pix.height,
> +		ic_image->num_cols, ic_image->num_rows,
> +		ic_image->tile.width, ic_image->tile.height,
> +		ic_image->fmt->fourcc & 0xff,
> +		(ic_image->fmt->fourcc >> 8) & 0xff,
> +		(ic_image->fmt->fourcc >> 16) & 0xff,
> +		(ic_image->fmt->fourcc >> 24) & 0xff);
> +}
> +
> +int ipu_image_convert_enum_format(int index, const char **desc, u32 *fourcc)
> +{
> +	const struct ipu_ic_pixfmt *fmt;
> +
> +	if (index >= (int)ARRAY_SIZE(ipu_ic_formats))
> +		return -EINVAL;
> +
> +	/* Format found */
> +	fmt = &ipu_ic_formats[index];
> +	*desc = fmt->name;
> +	*fourcc = fmt->fourcc;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_enum_format);
> +
> +static void ipu_ic_free_dma_buf(struct ipu_ic_priv *priv,
> +				struct ipu_ic_dma_buf *buf)
> +{
> +	if (buf->virt)
> +		dma_free_coherent(priv->ipu->dev,
> +				  buf->len, buf->virt, buf->phys);
> +	buf->virt = NULL;
> +	buf->phys = 0;
> +}
> +
> +static int ipu_ic_alloc_dma_buf(struct ipu_ic_priv *priv,
> +				struct ipu_ic_dma_buf *buf,
> +				int size)
> +{
> +	unsigned long newlen = PAGE_ALIGN(size);
> +
> +	if (buf->virt) {
> +		if (buf->len == newlen)
> +			return 0;
> +		ipu_ic_free_dma_buf(priv, buf);
> +	}
> +
> +	buf->len = newlen;
> +	buf->virt = dma_alloc_coherent(priv->ipu->dev, buf->len, &buf->phys,
> +				       GFP_DMA | GFP_KERNEL);
> +	if (!buf->virt) {
> +		dev_err(priv->ipu->dev, "failed to alloc dma buffer\n");
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int ipu_ic_num_stripes(int dim)
> +{
> +	if (dim <= 1024)
> +		return 1;
> +	else if (dim <= 2048)
> +		return 2;
> +	else
> +		return 4;
> +}
> +
> +static void ipu_ic_calc_tile_dimensions(struct image_converter_ctx *ctx,
> +					struct ipu_ic_image *image)
> +{
> +	struct ipu_ic_tile *tile = &image->tile;
> +
> +	tile->height = image->base.pix.height / image->num_rows;
> +	tile->width = image->base.pix.width / image->num_cols;
> +	tile->size = ((tile->height * image->fmt->bpp) >> 3) * tile->width;
> +
> +	if (image->fmt->y_depth) {
> +		tile->stride = (image->fmt->y_depth * tile->width) >> 3;
> +		tile->rot_stride = (image->fmt->y_depth * tile->height) >> 3;
> +	} else {
> +		tile->stride = (image->fmt->bpp * tile->width) >> 3;
> +		tile->rot_stride = (image->fmt->bpp * tile->height) >> 3;
> +	}
> +}
> +
> +/*
> + * Use the rotation transformation to find the tile coordinates
> + * (row, col) of a tile in the destination frame that corresponds
> + * to the given tile coordinates of a source frame. The destination
> + * coordinate is then converted to a tile index.
> + */
> +static int ipu_ic_transform_tile_index(struct image_converter_ctx *ctx,
> +				       int src_row, int src_col)
> +{

We don't do image rotation in software inside the Kernel! This is
something that should be done either by some hardware block or
in userspace.

> +	struct ipu_ic_priv *priv = ctx->cvt->ic->priv;
> +	struct ipu_ic_image *s_image = &ctx->in;
> +	struct ipu_ic_image *d_image = &ctx->out;
> +	int cos, sin, dst_row, dst_col;
> +
> +	/* with no rotation it's a 1:1 mapping */
> +	if (ctx->rot_mode == IPU_ROTATE_NONE)
> +		return src_row * s_image->num_cols + src_col;
> +
> +	if (ctx->rot_mode & IPU_ROT_BIT_90) {
> +		cos = 0;
> +		sin = 1;
> +	} else {
> +		cos = 1;
> +		sin = 0;
> +	}
> +
> +	/*
> +	 * before doing the transform, first we have to translate
> +	 * source row,col for an origin in the center of s_image
> +	 */
> +	src_row *= 2;
> +	src_col *= 2;
> +	src_row -= s_image->num_rows - 1;
> +	src_col -= s_image->num_cols - 1;
> +
> +	/* do the rotation transform */
> +	dst_col = src_col * cos - src_row * sin;
> +	dst_row = src_col * sin + src_row * cos;
> +
> +	/* apply flip */
> +	if (ctx->rot_mode & IPU_ROT_BIT_HFLIP)
> +		dst_col = -dst_col;
> +	if (ctx->rot_mode & IPU_ROT_BIT_VFLIP)
> +		dst_row = -dst_row;
> +
> +	dev_dbg(priv->ipu->dev, "ctx %p: [%d,%d] --> [%d,%d]\n",
> +		ctx, src_col, src_row, dst_col, dst_row);
> +
> +	/*
> +	 * finally translate dest row,col using an origin in upper
> +	 * left of d_image
> +	 */
> +	dst_row += d_image->num_rows - 1;
> +	dst_col += d_image->num_cols - 1;
> +	dst_row /= 2;
> +	dst_col /= 2;
> +
> +	return dst_row * d_image->num_cols + dst_col;
> +}
> +
> +/*
> + * Fill the out_tile_map[] with transformed destination tile indeces.
> + */
> +static void ipu_ic_calc_out_tile_map(struct image_converter_ctx *ctx)
> +{
> +	struct ipu_ic_image *s_image = &ctx->in;
> +	unsigned int row, col, tile = 0;
> +
> +	for (row = 0; row < s_image->num_rows; row++) {
> +		for (col = 0; col < s_image->num_cols; col++) {
> +			ctx->out_tile_map[tile] =
> +				ipu_ic_transform_tile_index(ctx, row, col);
> +			tile++;
> +		}
> +	}
> +}
> +
> +static void ipu_ic_calc_tile_offsets_planar(struct image_converter_ctx *ctx,
> +					    struct ipu_ic_image *image)
> +{

We also don't do image conversions inside the Kernel. Same applies
to other similar codes on this patch.

> +	struct ipu_ic_priv *priv = ctx->cvt->ic->priv;
> +	const struct ipu_ic_pixfmt *fmt = image->fmt;
> +	unsigned int row, col, tile = 0;
> +	u32 H, w, h, y_depth, y_stride, uv_stride;
> +	u32 uv_row_off, uv_col_off, uv_off, u_off, v_off, tmp;
> +	u32 y_row_off, y_col_off, y_off;
> +	u32 y_size, uv_size;
> +
> +	/* setup some convenience vars */
> +	H = image->base.pix.height;
> +	w = image->tile.width;
> +	h = image->tile.height;
> +
> +	y_depth = fmt->y_depth;
> +	y_stride = image->stride;
> +	uv_stride = y_stride / fmt->uv_width_dec;
> +	if (fmt->uv_packed)
> +		uv_stride *= 2;
> +
> +	y_size = H * y_stride;
> +	uv_size = y_size / (fmt->uv_width_dec * fmt->uv_height_dec);
> +
> +	for (row = 0; row < image->num_rows; row++) {
> +		y_row_off = row * h * y_stride;
> +		uv_row_off = (row * h * uv_stride) / fmt->uv_height_dec;
> +
> +		for (col = 0; col < image->num_cols; col++) {
> +			y_col_off = (col * w * y_depth) >> 3;
> +			uv_col_off = y_col_off / fmt->uv_width_dec;
> +			if (fmt->uv_packed)
> +				uv_col_off *= 2;
> +
> +			y_off = y_row_off + y_col_off;
> +			uv_off = uv_row_off + uv_col_off;
> +
> +			u_off = y_size - y_off + uv_off;
> +			v_off = (fmt->uv_packed) ? 0 : u_off + uv_size;
> +			if (fmt->uv_swapped) {
> +				tmp = u_off;
> +				u_off = v_off;
> +				v_off = tmp;
> +			}
> +
> +			image->tile_off[tile].offset = y_off;
> +			image->tile_off[tile].u_off = u_off;
> +			image->tile_off[tile++].v_off = v_off;
> +
> +			dev_dbg(priv->ipu->dev,
> +				"ctx %p: %s@[%d,%d]: y_off %08x, u_off %08x, v_off %08x\n",
> +				ctx, image->type == IMAGE_CONVERT_IN ?
> +				"Input" : "Output", row, col,
> +				y_off, u_off, v_off);
> +		}
> +	}
> +}
> +
> +static void ipu_ic_calc_tile_offsets_packed(struct image_converter_ctx *ctx,
> +					    struct ipu_ic_image *image)
> +{
> +	struct ipu_ic_priv *priv = ctx->cvt->ic->priv;
> +	const struct ipu_ic_pixfmt *fmt = image->fmt;
> +	unsigned int row, col, tile = 0;
> +	u32 w, h, bpp, stride;
> +	u32 row_off, col_off;
> +
> +	/* setup some convenience vars */
> +	w = image->tile.width;
> +	h = image->tile.height;
> +	stride = image->stride;
> +	bpp = fmt->bpp;
> +
> +	for (row = 0; row < image->num_rows; row++) {
> +		row_off = row * h * stride;
> +
> +		for (col = 0; col < image->num_cols; col++) {
> +			col_off = (col * w * bpp) >> 3;
> +
> +			image->tile_off[tile].offset = row_off + col_off;
> +			image->tile_off[tile].u_off = 0;
> +			image->tile_off[tile++].v_off = 0;
> +
> +			dev_dbg(priv->ipu->dev,
> +				"ctx %p: %s@[%d,%d]: phys %08x\n", ctx,
> +				image->type == IMAGE_CONVERT_IN ?
> +				"Input" : "Output", row, col,
> +				row_off + col_off);
> +		}
> +	}
> +}
> +
> +static void ipu_ic_calc_tile_offsets(struct image_converter_ctx *ctx,
> +				     struct ipu_ic_image *image)
> +{
> +	memset(image->tile_off, 0, sizeof(image->tile_off));
> +
> +	if (image->fmt->y_depth)
> +		ipu_ic_calc_tile_offsets_planar(ctx, image);
> +	else
> +		ipu_ic_calc_tile_offsets_packed(ctx, image);
> +}
> +
> +/*
> + * return the number of runs in given queue (pending_q or done_q)
> + * for this context. hold irqlock when calling.
> + */
> +static int ipu_ic_get_run_count(struct image_converter_ctx *ctx,
> +				struct list_head *q)
> +{
> +	struct image_converter_run *run;
> +	int count = 0;
> +
> +	list_for_each_entry(run, q, list) {
> +		if (run->ctx == ctx)
> +			count++;
> +	}
> +
> +	return count;
> +}
> +
> +/* hold irqlock when calling */
> +static void ipu_ic_convert_stop(struct image_converter_run *run)
> +{
> +	struct image_converter_ctx *ctx = run->ctx;
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +
> +	dev_dbg(priv->ipu->dev, "%s: stopping ctx %p run %p\n",
> +		__func__, ctx, run);
> +
> +	/* disable IC tasks and the channels */
> +	ipu_ic_task_disable(cvt->ic);
> +	ipu_idmac_disable_channel(cvt->in_chan);
> +	ipu_idmac_disable_channel(cvt->out_chan);
> +
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		ipu_idmac_disable_channel(cvt->rotation_in_chan);
> +		ipu_idmac_disable_channel(cvt->rotation_out_chan);
> +		ipu_idmac_unlink(cvt->out_chan, cvt->rotation_in_chan);
> +	}
> +
> +	ipu_ic_disable(cvt->ic);
> +}
> +
> +/* hold irqlock when calling */
> +static void init_idmac_channel(struct image_converter_ctx *ctx,
> +			       struct ipuv3_channel *channel,
> +			       struct ipu_ic_image *image,
> +			       enum ipu_rotate_mode rot_mode,
> +			       bool rot_swap_width_height)
> +{
> +	struct image_converter *cvt = ctx->cvt;
> +	unsigned int burst_size;
> +	u32 width, height, stride;
> +	dma_addr_t addr0, addr1 = 0;
> +	struct ipu_image tile_image;
> +	unsigned int tile_idx[2];
> +
> +	if (image->type == IMAGE_CONVERT_OUT) {
> +		tile_idx[0] = ctx->out_tile_map[0];
> +		tile_idx[1] = ctx->out_tile_map[1];
> +	} else {
> +		tile_idx[0] = 0;
> +		tile_idx[1] = 1;
> +	}
> +
> +	if (rot_swap_width_height) {
> +		width = image->tile.height;
> +		height = image->tile.width;
> +		stride = image->tile.rot_stride;
> +		addr0 = ctx->rot_intermediate[0].phys;
> +		if (ctx->double_buffering)
> +			addr1 = ctx->rot_intermediate[1].phys;
> +	} else {
> +		width = image->tile.width;
> +		height = image->tile.height;
> +		stride = image->stride;
> +		addr0 = image->base.phys0 +
> +			image->tile_off[tile_idx[0]].offset;
> +		if (ctx->double_buffering)
> +			addr1 = image->base.phys0 +
> +				image->tile_off[tile_idx[1]].offset;
> +	}
> +
> +	ipu_cpmem_zero(channel);
> +
> +	memset(&tile_image, 0, sizeof(tile_image));
> +	tile_image.pix.width = tile_image.rect.width = width;
> +	tile_image.pix.height = tile_image.rect.height = height;
> +	tile_image.pix.bytesperline = stride;
> +	tile_image.pix.pixelformat =  image->fmt->fourcc;
> +	tile_image.phys0 = addr0;
> +	tile_image.phys1 = addr1;
> +	ipu_cpmem_set_image(channel, &tile_image);
> +
> +	if (image->fmt->y_depth && !rot_swap_width_height)
> +		ipu_cpmem_set_uv_offset(channel,
> +					image->tile_off[tile_idx[0]].u_off,
> +					image->tile_off[tile_idx[0]].v_off);
> +
> +	if (rot_mode)
> +		ipu_cpmem_set_rotation(channel, rot_mode);
> +
> +	if (channel == cvt->rotation_in_chan ||
> +	    channel == cvt->rotation_out_chan) {
> +		burst_size = 8;
> +		ipu_cpmem_set_block_mode(channel);
> +	} else
> +		burst_size = (width % 16) ? 8 : 16;
> +
> +	ipu_cpmem_set_burstsize(channel, burst_size);
> +
> +	ipu_ic_task_idma_init(cvt->ic, channel, width, height,
> +			      burst_size, rot_mode);
> +
> +	ipu_cpmem_set_axi_id(channel, 1);
> +
> +	ipu_idmac_set_double_buffer(channel, ctx->double_buffering);
> +}
> +
> +/* hold irqlock when calling */
> +static int ipu_ic_convert_start(struct image_converter_run *run)
> +{
> +	struct image_converter_ctx *ctx = run->ctx;
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct ipu_ic_image *s_image = &ctx->in;
> +	struct ipu_ic_image *d_image = &ctx->out;
> +	enum ipu_color_space src_cs, dest_cs;
> +	unsigned int dest_width, dest_height;
> +	int ret;
> +
> +	dev_dbg(priv->ipu->dev, "%s: starting ctx %p run %p\n",
> +		__func__, ctx, run);
> +
> +	src_cs = ipu_pixelformat_to_colorspace(s_image->fmt->fourcc);
> +	dest_cs = ipu_pixelformat_to_colorspace(d_image->fmt->fourcc);
> +
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		/* swap width/height for resizer */
> +		dest_width = d_image->tile.height;
> +		dest_height = d_image->tile.width;
> +	} else {
> +		dest_width = d_image->tile.width;
> +		dest_height = d_image->tile.height;
> +	}
> +
> +	/* setup the IC resizer and CSC */
> +	ret = ipu_ic_task_init(cvt->ic,
> +			       s_image->tile.width,
> +			       s_image->tile.height,
> +			       dest_width,
> +			       dest_height,
> +			       src_cs, dest_cs);
> +	if (ret) {
> +		dev_err(priv->ipu->dev, "ipu_ic_task_init failed, %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* init the source MEM-->IC PP IDMAC channel */
> +	init_idmac_channel(ctx, cvt->in_chan, s_image,
> +			   IPU_ROTATE_NONE, false);
> +
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		/* init the IC PP-->MEM IDMAC channel */
> +		init_idmac_channel(ctx, cvt->out_chan, d_image,
> +				   IPU_ROTATE_NONE, true);
> +
> +		/* init the MEM-->IC PP ROT IDMAC channel */
> +		init_idmac_channel(ctx, cvt->rotation_in_chan, d_image,
> +				   ctx->rot_mode, true);
> +
> +		/* init the destination IC PP ROT-->MEM IDMAC channel */
> +		init_idmac_channel(ctx, cvt->rotation_out_chan, d_image,
> +				   IPU_ROTATE_NONE, false);
> +
> +		/* now link IC PP-->MEM to MEM-->IC PP ROT */
> +		ipu_idmac_link(cvt->out_chan, cvt->rotation_in_chan);
> +	} else {
> +		/* init the destination IC PP-->MEM IDMAC channel */
> +		init_idmac_channel(ctx, cvt->out_chan, d_image,
> +				   ctx->rot_mode, false);
> +	}
> +
> +	/* enable the IC */
> +	ipu_ic_enable(cvt->ic);
> +
> +	/* set buffers ready */
> +	ipu_idmac_select_buffer(cvt->in_chan, 0);
> +	ipu_idmac_select_buffer(cvt->out_chan, 0);
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode))
> +		ipu_idmac_select_buffer(cvt->rotation_out_chan, 0);
> +	if (ctx->double_buffering) {
> +		ipu_idmac_select_buffer(cvt->in_chan, 1);
> +		ipu_idmac_select_buffer(cvt->out_chan, 1);
> +		if (ipu_rot_mode_is_irt(ctx->rot_mode))
> +			ipu_idmac_select_buffer(cvt->rotation_out_chan, 1);
> +	}
> +
> +	/* enable the channels! */
> +	ipu_idmac_enable_channel(cvt->in_chan);
> +	ipu_idmac_enable_channel(cvt->out_chan);
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		ipu_idmac_enable_channel(cvt->rotation_in_chan);
> +		ipu_idmac_enable_channel(cvt->rotation_out_chan);
> +	}
> +
> +	ipu_ic_task_enable(cvt->ic);
> +
> +	ipu_cpmem_dump(cvt->in_chan);
> +	ipu_cpmem_dump(cvt->out_chan);
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		ipu_cpmem_dump(cvt->rotation_in_chan);
> +		ipu_cpmem_dump(cvt->rotation_out_chan);
> +	}
> +
> +	ipu_dump(priv->ipu);
> +
> +	return 0;
> +}
> +
> +/* hold irqlock when calling */
> +static int ipu_ic_run(struct image_converter_run *run)
> +{
> +	struct image_converter_ctx *ctx = run->ctx;
> +	struct image_converter *cvt = ctx->cvt;
> +
> +	ctx->in.base.phys0 = run->in_phys;
> +	ctx->out.base.phys0 = run->out_phys;
> +
> +	ctx->cur_buf_num = 0;
> +	ctx->next_tile = 1;
> +
> +	/* remove run from pending_q and set as current */
> +	list_del(&run->list);
> +	cvt->current_run = run;
> +
> +	return ipu_ic_convert_start(run);
> +}
> +
> +/* hold irqlock when calling */
> +static void ipu_ic_run_next(struct image_converter *cvt)
> +{
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_run *run, *tmp;
> +	int ret;
> +
> +	list_for_each_entry_safe(run, tmp, &cvt->pending_q, list) {
> +		/* skip contexts that are aborting */
> +		if (run->ctx->aborting) {
> +			dev_dbg(priv->ipu->dev,
> +				 "%s: skipping aborting ctx %p run %p\n",
> +				 __func__, run->ctx, run);
> +			continue;
> +		}
> +
> +		ret = ipu_ic_run(run);
> +		if (!ret)
> +			break;
> +
> +		/*
> +		 * something went wrong with start, add the run
> +		 * to done q and continue to the next run in the
> +		 * pending q.
> +		 */
> +		run->status = ret;
> +		list_add_tail(&run->list, &cvt->done_q);
> +		cvt->current_run = NULL;
> +	}
> +}
> +
> +static void ipu_ic_empty_done_q(struct image_converter *cvt)
> +{
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_run *run;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	while (!list_empty(&cvt->done_q)) {
> +		run = list_entry(cvt->done_q.next,
> +				 struct image_converter_run,
> +				 list);
> +
> +		list_del(&run->list);
> +
> +		dev_dbg(priv->ipu->dev,
> +			"%s: completing ctx %p run %p with %d\n",
> +			__func__, run->ctx, run, run->status);
> +
> +		/* call the completion callback and free the run */
> +		spin_unlock_irqrestore(&cvt->irqlock, flags);
> +		run->ctx->complete(run->ctx->complete_context, run,
> +				   run->status);
> +		kfree(run);
> +		spin_lock_irqsave(&cvt->irqlock, flags);
> +	}
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +}
> +
> +/*
> + * the bottom half thread clears out the done_q, calling the
> + * completion handler for each.
> + */
> +static irqreturn_t ipu_ic_bh(int irq, void *dev_id)
> +{
> +	struct image_converter *cvt = dev_id;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_ctx *ctx;
> +	unsigned long flags;
> +
> +	dev_dbg(priv->ipu->dev, "%s: enter\n", __func__);
> +
> +	ipu_ic_empty_done_q(cvt);
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	/*
> +	 * the done_q is cleared out, signal any contexts
> +	 * that are aborting that abort can complete.
> +	 */
> +	list_for_each_entry(ctx, &cvt->ctx_list, list) {
> +		if (ctx->aborting) {
> +			dev_dbg(priv->ipu->dev,
> +				 "%s: signaling abort for ctx %p\n",
> +				 __func__, ctx);
> +			complete(&ctx->aborted);
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	dev_dbg(priv->ipu->dev, "%s: exit\n", __func__);
> +	return IRQ_HANDLED;
> +}
> +
> +/* hold irqlock when calling */
> +static irqreturn_t ipu_ic_doirq(struct image_converter_run *run)
> +{
> +	struct image_converter_ctx *ctx = run->ctx;
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_tile_off *src_off, *dst_off;
> +	struct ipu_ic_image *s_image = &ctx->in;
> +	struct ipu_ic_image *d_image = &ctx->out;
> +	struct ipuv3_channel *outch;
> +	unsigned int dst_idx;
> +
> +	outch = ipu_rot_mode_is_irt(ctx->rot_mode) ?
> +		cvt->rotation_out_chan : cvt->out_chan;
> +
> +	/*
> +	 * It is difficult to stop the channel DMA before the channels
> +	 * enter the paused state. Without double-buffering the channels
> +	 * are always in a paused state when the EOF irq occurs, so it
> +	 * is safe to stop the channels now. For double-buffering we
> +	 * just ignore the abort until the operation completes, when it
> +	 * is safe to shut down.
> +	 */
> +	if (ctx->aborting && !ctx->double_buffering) {
> +		ipu_ic_convert_stop(run);
> +		run->status = -EIO;
> +		goto done;
> +	}
> +
> +	if (ctx->next_tile == ctx->num_tiles) {
> +		/*
> +		 * the conversion is complete
> +		 */
> +		ipu_ic_convert_stop(run);
> +		run->status = 0;
> +		goto done;
> +	}
> +
> +	/*
> +	 * not done, place the next tile buffers.
> +	 */
> +	if (!ctx->double_buffering) {
> +
> +		src_off = &s_image->tile_off[ctx->next_tile];
> +		dst_idx = ctx->out_tile_map[ctx->next_tile];
> +		dst_off = &d_image->tile_off[dst_idx];
> +
> +		ipu_cpmem_set_buffer(cvt->in_chan, 0,
> +				     s_image->base.phys0 + src_off->offset);
> +		ipu_cpmem_set_buffer(outch, 0,
> +				     d_image->base.phys0 + dst_off->offset);
> +		if (s_image->fmt->y_depth)
> +			ipu_cpmem_set_uv_offset(cvt->in_chan,
> +						src_off->u_off,
> +						src_off->v_off);
> +		if (d_image->fmt->y_depth)
> +			ipu_cpmem_set_uv_offset(outch,
> +						dst_off->u_off,
> +						dst_off->v_off);
> +
> +		ipu_idmac_select_buffer(cvt->in_chan, 0);
> +		ipu_idmac_select_buffer(outch, 0);
> +
> +	} else if (ctx->next_tile < ctx->num_tiles - 1) {
> +
> +		src_off = &s_image->tile_off[ctx->next_tile + 1];
> +		dst_idx = ctx->out_tile_map[ctx->next_tile + 1];
> +		dst_off = &d_image->tile_off[dst_idx];
> +
> +		ipu_cpmem_set_buffer(cvt->in_chan, ctx->cur_buf_num,
> +				     s_image->base.phys0 + src_off->offset);
> +		ipu_cpmem_set_buffer(outch, ctx->cur_buf_num,
> +				     d_image->base.phys0 + dst_off->offset);
> +
> +		ipu_idmac_select_buffer(cvt->in_chan, ctx->cur_buf_num);
> +		ipu_idmac_select_buffer(outch, ctx->cur_buf_num);
> +
> +		ctx->cur_buf_num ^= 1;
> +	}
> +
> +	ctx->next_tile++;
> +	return IRQ_HANDLED;
> +done:
> +	list_add_tail(&run->list, &cvt->done_q);
> +	cvt->current_run = NULL;
> +	ipu_ic_run_next(cvt);
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t ipu_ic_norotate_irq(int irq, void *data)
> +{
> +	struct image_converter *cvt = data;
> +	struct image_converter_ctx *ctx;
> +	struct image_converter_run *run;
> +	unsigned long flags;
> +	irqreturn_t ret;
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	/* get current run and its context */
> +	run = cvt->current_run;
> +	if (!run) {
> +		ret = IRQ_NONE;
> +		goto out;
> +	}
> +
> +	ctx = run->ctx;
> +
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		/* this is a rotation operation, just ignore */
> +		spin_unlock_irqrestore(&cvt->irqlock, flags);
> +		return IRQ_HANDLED;
> +	}
> +
> +	ret = ipu_ic_doirq(run);
> +out:
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +	return ret;
> +}
> +
> +static irqreturn_t ipu_ic_rotate_irq(int irq, void *data)
> +{
> +	struct image_converter *cvt = data;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_ctx *ctx;
> +	struct image_converter_run *run;
> +	unsigned long flags;
> +	irqreturn_t ret;
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	/* get current run and its context */
> +	run = cvt->current_run;
> +	if (!run) {
> +		ret = IRQ_NONE;
> +		goto out;
> +	}
> +
> +	ctx = run->ctx;
> +
> +	if (!ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		/* this was NOT a rotation operation, shouldn't happen */
> +		dev_err(priv->ipu->dev, "Unexpected rotation interrupt\n");
> +		spin_unlock_irqrestore(&cvt->irqlock, flags);
> +		return IRQ_HANDLED;
> +	}
> +
> +	ret = ipu_ic_doirq(run);
> +out:
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +	return ret;
> +}
> +
> +/*
> + * try to force the completion of runs for this ctx. Called when
> + * abort wait times out in ipu_image_convert_abort().
> + */
> +static void ipu_ic_force_abort(struct image_converter_ctx *ctx)
> +{
> +	struct image_converter *cvt = ctx->cvt;
> +	struct image_converter_run *run;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	run = cvt->current_run;
> +	if (run && run->ctx == ctx) {
> +		ipu_ic_convert_stop(run);
> +		run->status = -EIO;
> +		list_add_tail(&run->list, &cvt->done_q);
> +		cvt->current_run = NULL;
> +		ipu_ic_run_next(cvt);
> +	}
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	ipu_ic_empty_done_q(cvt);
> +}
> +
> +static void ipu_ic_release_ipu_resources(struct image_converter *cvt)
> +{
> +	if (cvt->out_eof_irq >= 0)
> +		free_irq(cvt->out_eof_irq, cvt);
> +	if (cvt->rot_out_eof_irq >= 0)
> +		free_irq(cvt->rot_out_eof_irq, cvt);
> +
> +	if (!IS_ERR_OR_NULL(cvt->in_chan))
> +		ipu_idmac_put(cvt->in_chan);
> +	if (!IS_ERR_OR_NULL(cvt->out_chan))
> +		ipu_idmac_put(cvt->out_chan);
> +	if (!IS_ERR_OR_NULL(cvt->rotation_in_chan))
> +		ipu_idmac_put(cvt->rotation_in_chan);
> +	if (!IS_ERR_OR_NULL(cvt->rotation_out_chan))
> +		ipu_idmac_put(cvt->rotation_out_chan);
> +
> +	cvt->in_chan = cvt->out_chan = cvt->rotation_in_chan =
> +		cvt->rotation_out_chan = NULL;
> +	cvt->out_eof_irq = cvt->rot_out_eof_irq = -1;
> +}
> +
> +static int ipu_ic_get_ipu_resources(struct image_converter *cvt)
> +{
> +	const struct ic_task_channels *chan = cvt->ic->ch;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	int ret;
> +
> +	/* get IDMAC channels */
> +	cvt->in_chan = ipu_idmac_get(priv->ipu, chan->in);
> +	cvt->out_chan = ipu_idmac_get(priv->ipu, chan->out);
> +	if (IS_ERR(cvt->in_chan) || IS_ERR(cvt->out_chan)) {
> +		dev_err(priv->ipu->dev, "could not acquire idmac channels\n");
> +		ret = -EBUSY;
> +		goto err;
> +	}
> +
> +	cvt->rotation_in_chan = ipu_idmac_get(priv->ipu, chan->rot_in);
> +	cvt->rotation_out_chan = ipu_idmac_get(priv->ipu, chan->rot_out);
> +	if (IS_ERR(cvt->rotation_in_chan) || IS_ERR(cvt->rotation_out_chan)) {
> +		dev_err(priv->ipu->dev,
> +			"could not acquire idmac rotation channels\n");
> +		ret = -EBUSY;
> +		goto err;
> +	}
> +
> +	/* acquire the EOF interrupts */
> +	cvt->out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
> +						cvt->out_chan,
> +						IPU_IRQ_EOF);
> +
> +	ret = request_threaded_irq(cvt->out_eof_irq,
> +				   ipu_ic_norotate_irq, ipu_ic_bh,
> +				   0, "ipu-ic", cvt);
> +	if (ret < 0) {
> +		dev_err(priv->ipu->dev, "could not acquire irq %d\n",
> +			 cvt->out_eof_irq);
> +		cvt->out_eof_irq = -1;
> +		goto err;
> +	}
> +
> +	cvt->rot_out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
> +						     cvt->rotation_out_chan,
> +						     IPU_IRQ_EOF);
> +
> +	ret = request_threaded_irq(cvt->rot_out_eof_irq,
> +				   ipu_ic_rotate_irq, ipu_ic_bh,
> +				   0, "ipu-ic", cvt);
> +	if (ret < 0) {
> +		dev_err(priv->ipu->dev, "could not acquire irq %d\n",
> +			cvt->rot_out_eof_irq);
> +		cvt->rot_out_eof_irq = -1;
> +		goto err;
> +	}
> +
> +	return 0;
> +err:
> +	ipu_ic_release_ipu_resources(cvt);
> +	return ret;
> +}
> +
> +static int ipu_ic_fill_image(struct image_converter_ctx *ctx,
> +			     struct ipu_ic_image *ic_image,
> +			     struct ipu_image *image,
> +			     enum image_convert_type type)
> +{
> +	struct ipu_ic_priv *priv = ctx->cvt->ic->priv;
> +
> +	ic_image->base = *image;
> +	ic_image->type = type;
> +
> +	ic_image->fmt = ipu_ic_get_format(image->pix.pixelformat);
> +	if (!ic_image->fmt) {
> +		dev_err(priv->ipu->dev, "pixelformat not supported for %s\n",
> +			type == IMAGE_CONVERT_OUT ? "Output" : "Input");
> +		return -EINVAL;
> +	}
> +
> +	if (ic_image->fmt->y_depth)
> +		ic_image->stride = (ic_image->fmt->y_depth *
> +				    ic_image->base.pix.width) >> 3;
> +	else
> +		ic_image->stride  = ic_image->base.pix.bytesperline;
> +
> +	ipu_ic_calc_tile_dimensions(ctx, ic_image);
> +	ipu_ic_calc_tile_offsets(ctx, ic_image);
> +
> +	return 0;
> +}
> +
> +/* borrowed from drivers/media/v4l2-core/v4l2-common.c */
> +static unsigned int clamp_align(unsigned int x, unsigned int min,
> +				unsigned int max, unsigned int align)
> +{
> +	/* Bits that must be zero to be aligned */
> +	unsigned int mask = ~((1 << align) - 1);
> +
> +	/* Clamp to aligned min and max */
> +	x = clamp(x, (min + ~mask) & mask, max & mask);
> +
> +	/* Round to nearest aligned value */
> +	if (align)
> +		x = (x + (1 << (align - 1))) & mask;
> +
> +	return x;
> +}
> +
> +/*
> + * We have to adjust the tile width such that the tile physaddrs and
> + * U and V plane offsets are multiples of 8 bytes as required by
> + * the IPU DMA Controller. For the planar formats, this corresponds
> + * to a pixel alignment of 16 (but use a more formal equation since
> + * the variables are available). For all the packed formats, 8 is
> + * good enough.
> + */
> +static inline u32 tile_width_align(const struct ipu_ic_pixfmt *fmt)
> +{
> +	return fmt->y_depth ? (64 * fmt->uv_width_dec) / fmt->y_depth : 8;
> +}
> +
> +/*
> + * For tile height alignment, we have to ensure that the output tile
> + * heights are multiples of 8 lines if the IRT is required by the
> + * given rotation mode (the IRT performs rotations on 8x8 blocks
> + * at a time). If the IRT is not used, or for input image tiles,
> + * 2 lines are good enough.
> + */
> +static inline u32 tile_height_align(enum image_convert_type type,
> +				    enum ipu_rotate_mode rot_mode)
> +{
> +	return (type == IMAGE_CONVERT_OUT &&
> +		ipu_rot_mode_is_irt(rot_mode)) ? 8 : 2;
> +}
> +
> +/* Adjusts input/output images to IPU restrictions */
> +int ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
> +			     enum ipu_rotate_mode rot_mode)
> +{
> +	const struct ipu_ic_pixfmt *infmt, *outfmt;
> +	unsigned int num_in_rows, num_in_cols;
> +	unsigned int num_out_rows, num_out_cols;
> +	u32 w_align, h_align;
> +
> +	infmt = ipu_ic_get_format(in->pix.pixelformat);
> +	outfmt = ipu_ic_get_format(out->pix.pixelformat);
> +
> +	/* set some defaults if needed */
> +	if (!infmt) {
> +		in->pix.pixelformat = V4L2_PIX_FMT_RGB24;
> +		infmt = ipu_ic_get_format(V4L2_PIX_FMT_RGB24);
> +	}
> +	if (!outfmt) {
> +		out->pix.pixelformat = V4L2_PIX_FMT_RGB24;
> +		outfmt = ipu_ic_get_format(V4L2_PIX_FMT_RGB24);
> +	}
> +
> +	if (!in->pix.width || !in->pix.height) {
> +		in->pix.width = 640;
> +		in->pix.height = 480;
> +	}
> +	if (!out->pix.width || !out->pix.height) {
> +		out->pix.width = 640;
> +		out->pix.height = 480;
> +	}
> +
> +	/* image converter does not handle fields */
> +	in->pix.field = out->pix.field = V4L2_FIELD_NONE;
> +
> +	/* resizer cannot downsize more than 4:1 */
> +	if (ipu_rot_mode_is_irt(rot_mode)) {
> +		out->pix.height = max_t(__u32, out->pix.height,
> +					in->pix.width / 4);
> +		out->pix.width = max_t(__u32, out->pix.width,
> +				       in->pix.height / 4);
> +	} else {
> +		out->pix.width = max_t(__u32, out->pix.width,
> +				       in->pix.width / 4);
> +		out->pix.height = max_t(__u32, out->pix.height,
> +					in->pix.height / 4);
> +	}
> +
> +	/* get tiling rows/cols from output format */
> +	num_out_rows = ipu_ic_num_stripes(out->pix.height);
> +	num_out_cols = ipu_ic_num_stripes(out->pix.width);
> +	if (ipu_rot_mode_is_irt(rot_mode)) {
> +		num_in_rows = num_out_cols;
> +		num_in_cols = num_out_rows;
> +	} else {
> +		num_in_rows = num_out_rows;
> +		num_in_cols = num_out_cols;
> +	}
> +
> +	/* align input width/height */
> +	w_align = ilog2(tile_width_align(infmt) * num_in_cols);
> +	h_align = ilog2(tile_height_align(IMAGE_CONVERT_IN, rot_mode) *
> +			num_in_rows);
> +	in->pix.width = clamp_align(in->pix.width, MIN_W, MAX_W, w_align);
> +	in->pix.height = clamp_align(in->pix.height, MIN_H, MAX_H, h_align);
> +
> +	/* align output width/height */
> +	w_align = ilog2(tile_width_align(outfmt) * num_out_cols);
> +	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, rot_mode) *
> +			num_out_rows);
> +	out->pix.width = clamp_align(out->pix.width, MIN_W, MAX_W, w_align);
> +	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
> +
> +	/* set input/output strides and image sizes */
> +	in->pix.bytesperline = (in->pix.width * infmt->bpp) >> 3;
> +	in->pix.sizeimage = in->pix.height * in->pix.bytesperline;
> +	out->pix.bytesperline = (out->pix.width * outfmt->bpp) >> 3;
> +	out->pix.sizeimage = out->pix.height * out->pix.bytesperline;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_adjust);
> +
> +/*
> + * this is used by ipu_image_convert_prepare() to verify set input and
> + * output images are valid before starting the conversion. Clients can
> + * also call it before calling ipu_image_convert_prepare().
> + */
> +int ipu_image_convert_verify(struct ipu_image *in, struct ipu_image *out,
> +			     enum ipu_rotate_mode rot_mode)
> +{
> +	struct ipu_image testin, testout;
> +	int ret;
> +
> +	testin = *in;
> +	testout = *out;
> +
> +	ret = ipu_image_convert_adjust(&testin, &testout, rot_mode);
> +	if (ret)
> +		return ret;
> +
> +	if (testin.pix.width != in->pix.width ||
> +	    testin.pix.height != in->pix.height ||
> +	    testout.pix.width != out->pix.width ||
> +	    testout.pix.height != out->pix.height)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_verify);
> +
> +/*
> + * Call ipu_image_convert_prepare() to prepare for the conversion of
> + * given images and rotation mode. Returns a new conversion context.
> + */
> +struct image_converter_ctx *
> +ipu_image_convert_prepare(struct ipu_ic *ic,
> +			  struct ipu_image *in, struct ipu_image *out,
> +			  enum ipu_rotate_mode rot_mode,
> +			  image_converter_cb_t complete,
> +			  void *complete_context)
> +{
> +	struct ipu_ic_priv *priv = ic->priv;
> +	struct image_converter *cvt = &ic->cvt;
> +	struct ipu_ic_image *s_image, *d_image;
> +	struct image_converter_ctx *ctx;
> +	unsigned long flags;
> +	bool get_res;
> +	int ret;
> +
> +	if (!ic || !in || !out || !complete)
> +		return ERR_PTR(-EINVAL);
> +
> +	/* verify the in/out images before continuing */
> +	ret = ipu_image_convert_verify(in, out, rot_mode);
> +	if (ret) {
> +		dev_err(priv->ipu->dev, "%s: in/out formats invalid\n",
> +			__func__);
> +		return ERR_PTR(ret);
> +	}
> +
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +	if (!ctx)
> +		return ERR_PTR(-ENOMEM);
> +
> +	dev_dbg(priv->ipu->dev, "%s: ctx %p\n", __func__, ctx);
> +
> +	ctx->cvt = cvt;
> +	init_completion(&ctx->aborted);
> +
> +	s_image = &ctx->in;
> +	d_image = &ctx->out;
> +
> +	/* set tiling and rotation */
> +	d_image->num_rows = ipu_ic_num_stripes(out->pix.height);
> +	d_image->num_cols = ipu_ic_num_stripes(out->pix.width);
> +	if (ipu_rot_mode_is_irt(rot_mode)) {
> +		s_image->num_rows = d_image->num_cols;
> +		s_image->num_cols = d_image->num_rows;
> +	} else {
> +		s_image->num_rows = d_image->num_rows;
> +		s_image->num_cols = d_image->num_cols;
> +	}
> +
> +	ctx->num_tiles = d_image->num_cols * d_image->num_rows;
> +	ctx->rot_mode = rot_mode;
> +
> +	ret = ipu_ic_fill_image(ctx, s_image, in, IMAGE_CONVERT_IN);
> +	if (ret)
> +		goto out_free;
> +	ret = ipu_ic_fill_image(ctx, d_image, out, IMAGE_CONVERT_OUT);
> +	if (ret)
> +		goto out_free;
> +
> +	ipu_ic_calc_out_tile_map(ctx);
> +
> +	ipu_ic_dump_format(ctx, s_image);
> +	ipu_ic_dump_format(ctx, d_image);
> +
> +	ctx->complete = complete;
> +	ctx->complete_context = complete_context;
> +
> +	/*
> +	 * Can we use double-buffering for this operation? If there is
> +	 * only one tile (the whole image can be converted in a single
> +	 * operation) there's no point in using double-buffering. Also,
> +	 * the IPU's IDMAC channels allow only a single U and V plane
> +	 * offset shared between both buffers, but these offsets change
> +	 * for every tile, and therefore would have to be updated for
> +	 * each buffer which is not possible. So double-buffering is
> +	 * impossible when either the source or destination images are
> +	 * a planar format (YUV420, YUV422P, etc.).
> +	 */
> +	ctx->double_buffering = (ctx->num_tiles > 1 &&
> +				 !s_image->fmt->y_depth &&
> +				 !d_image->fmt->y_depth);
> +
> +	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
> +		ret = ipu_ic_alloc_dma_buf(priv, &ctx->rot_intermediate[0],
> +					   d_image->tile.size);
> +		if (ret)
> +			goto out_free;
> +		if (ctx->double_buffering) {
> +			ret = ipu_ic_alloc_dma_buf(priv,
> +						   &ctx->rot_intermediate[1],
> +						   d_image->tile.size);
> +			if (ret)
> +				goto out_free_dmabuf0;
> +		}
> +	}
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	get_res = list_empty(&cvt->ctx_list);
> +
> +	list_add_tail(&ctx->list, &cvt->ctx_list);
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	if (get_res) {
> +		ret = ipu_ic_get_ipu_resources(cvt);
> +		if (ret)
> +			goto out_free_dmabuf1;
> +	}
> +
> +	return ctx;
> +
> +out_free_dmabuf1:
> +	ipu_ic_free_dma_buf(priv, &ctx->rot_intermediate[1]);
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +	list_del(&ctx->list);
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +out_free_dmabuf0:
> +	ipu_ic_free_dma_buf(priv, &ctx->rot_intermediate[0]);
> +out_free:
> +	kfree(ctx);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_prepare);
> +
> +/*
> + * Carry out a single image conversion. Only the physaddr's of the input
> + * and output image buffers are needed. The conversion context must have
> + * been created previously with ipu_image_convert_prepare(). Returns the
> + * new run object.
> + */
> +struct image_converter_run *
> +ipu_image_convert_run(struct image_converter_ctx *ctx,
> +		      dma_addr_t in_phys, dma_addr_t out_phys)
> +{
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_run *run;
> +	unsigned long flags;
> +	int ret = 0;
> +
> +	run = kzalloc(sizeof(*run), GFP_KERNEL);
> +	if (!run)
> +		return ERR_PTR(-ENOMEM);
> +
> +	run->ctx = ctx;
> +	run->in_phys = in_phys;
> +	run->out_phys = out_phys;
> +
> +	dev_dbg(priv->ipu->dev, "%s: ctx %p run %p\n", __func__,
> +		ctx, run);
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	if (ctx->aborting) {
> +		ret = -EIO;
> +		goto unlock;
> +	}
> +
> +	list_add_tail(&run->list, &cvt->pending_q);
> +
> +	if (!cvt->current_run) {
> +		ret = ipu_ic_run(run);
> +		if (ret)
> +			cvt->current_run = NULL;
> +	}
> +unlock:
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	if (ret) {
> +		kfree(run);
> +		run = ERR_PTR(ret);
> +	}
> +
> +	return run;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_run);
> +
> +/* Abort any active or pending conversions for this context */
> +void ipu_image_convert_abort(struct image_converter_ctx *ctx)
> +{
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	struct image_converter_run *run, *active_run, *tmp;
> +	unsigned long flags;
> +	int run_count, ret;
> +	bool need_abort;
> +
> +	reinit_completion(&ctx->aborted);
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	/* move all remaining pending runs in this context to done_q */
> +	list_for_each_entry_safe(run, tmp, &cvt->pending_q, list) {
> +		if (run->ctx != ctx)
> +			continue;
> +		run->status = -EIO;
> +		list_move_tail(&run->list, &cvt->done_q);
> +	}
> +
> +	run_count = ipu_ic_get_run_count(ctx, &cvt->done_q);
> +	active_run = (cvt->current_run && cvt->current_run->ctx == ctx) ?
> +		cvt->current_run : NULL;
> +
> +	need_abort = (run_count || active_run);
> +
> +	ctx->aborting = need_abort;
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	if (!need_abort) {
> +		dev_dbg(priv->ipu->dev, "%s: no abort needed for ctx %p\n",
> +			__func__, ctx);
> +		return;
> +	}
> +
> +	dev_dbg(priv->ipu->dev,
> +		 "%s: wait for completion: %d runs, active run %p\n",
> +		 __func__, run_count, active_run);
> +
> +	ret = wait_for_completion_timeout(&ctx->aborted,
> +					  msecs_to_jiffies(10000));
> +	if (ret == 0) {
> +		dev_warn(priv->ipu->dev, "%s: timeout\n", __func__);
> +		ipu_ic_force_abort(ctx);
> +	}
> +
> +	ctx->aborting = false;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_abort);
> +
> +/* Unprepare image conversion context */
> +void ipu_image_convert_unprepare(struct image_converter_ctx *ctx)
> +{
> +	struct image_converter *cvt = ctx->cvt;
> +	struct ipu_ic_priv *priv = cvt->ic->priv;
> +	unsigned long flags;
> +	bool put_res;
> +
> +	/* make sure no runs are hanging around */
> +	ipu_image_convert_abort(ctx);
> +
> +	dev_dbg(priv->ipu->dev, "%s: removing ctx %p\n", __func__, ctx);
> +
> +	spin_lock_irqsave(&cvt->irqlock, flags);
> +
> +	list_del(&ctx->list);
> +
> +	put_res = list_empty(&cvt->ctx_list);
> +
> +	spin_unlock_irqrestore(&cvt->irqlock, flags);
> +
> +	if (put_res)
> +		ipu_ic_release_ipu_resources(cvt);
> +
> +	ipu_ic_free_dma_buf(priv, &ctx->rot_intermediate[1]);
> +	ipu_ic_free_dma_buf(priv, &ctx->rot_intermediate[0]);
> +
> +	kfree(ctx);
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_unprepare);
> +
> +/*
> + * "Canned" asynchronous single image conversion. On successful return
> + * caller must call ipu_image_convert_unprepare() after conversion completes.
> + * Returns the new conversion context.
> + */
> +struct image_converter_ctx *
> +ipu_image_convert(struct ipu_ic *ic,
> +		  struct ipu_image *in, struct ipu_image *out,
> +		  enum ipu_rotate_mode rot_mode,
> +		  image_converter_cb_t complete,
> +		  void *complete_context)
> +{
> +	struct image_converter_ctx *ctx;
> +	struct image_converter_run *run;
> +
> +	ctx = ipu_image_convert_prepare(ic, in, out, rot_mode,
> +					complete, complete_context);
> +	if (IS_ERR(ctx))
> +		return ctx;
> +
> +	run = ipu_image_convert_run(ctx, in->phys0, out->phys0);
> +	if (IS_ERR(run)) {
> +		ipu_image_convert_unprepare(ctx);
> +		return ERR_PTR(PTR_ERR(run));
> +	}
> +
> +	return ctx;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert);
> +
> +/* "Canned" synchronous single image conversion */
> +static void image_convert_sync_complete(void *data,
> +					struct image_converter_run *run,
> +					int err)
> +{
> +	struct completion *comp = data;
> +
> +	complete(comp);
> +}
> +
> +int ipu_image_convert_sync(struct ipu_ic *ic,
> +			   struct ipu_image *in, struct ipu_image *out,
> +			   enum ipu_rotate_mode rot_mode)
> +{
> +	struct image_converter_ctx *ctx;
> +	struct completion comp;
> +	int ret;
> +
> +	init_completion(&comp);
> +
> +	ctx = ipu_image_convert(ic, in, out, rot_mode,
> +				image_convert_sync_complete, &comp);
> +	if (IS_ERR(ctx))
> +		return PTR_ERR(ctx);
> +
> +	ret = wait_for_completion_timeout(&comp, msecs_to_jiffies(10000));
> +	ret = (ret == 0) ? -ETIMEDOUT : 0;
> +
> +	ipu_image_convert_unprepare(ctx);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ipu_image_convert_sync);
> +
>  int ipu_ic_enable(struct ipu_ic *ic)
>  {
>  	struct ipu_ic_priv *priv = ic->priv;
> @@ -759,6 +2428,7 @@ int ipu_ic_init(struct ipu_soc *ipu, struct device *dev,
>  	ipu->ic_priv = priv;
>  
>  	spin_lock_init(&priv->lock);
> +
>  	priv->base = devm_ioremap(dev, base, PAGE_SIZE);
>  	if (!priv->base)
>  		return -ENOMEM;
> @@ -771,10 +2441,21 @@ int ipu_ic_init(struct ipu_soc *ipu, struct device *dev,
>  	priv->ipu = ipu;
>  
>  	for (i = 0; i < IC_NUM_TASKS; i++) {
> -		priv->task[i].task = i;
> -		priv->task[i].priv = priv;
> -		priv->task[i].reg = &ic_task_reg[i];
> -		priv->task[i].bit = &ic_task_bit[i];
> +		struct ipu_ic *ic = &priv->task[i];
> +		struct image_converter *cvt = &ic->cvt;
> +
> +		ic->task = i;
> +		ic->priv = priv;
> +		ic->reg = &ic_task_reg[i];
> +		ic->bit = &ic_task_bit[i];
> +		ic->ch = &ic_task_ch[i];
> +
> +		cvt->ic = ic;
> +		spin_lock_init(&cvt->irqlock);
> +		INIT_LIST_HEAD(&cvt->ctx_list);
> +		INIT_LIST_HEAD(&cvt->pending_q);
> +		INIT_LIST_HEAD(&cvt->done_q);
> +		cvt->out_eof_irq = cvt->rot_out_eof_irq = -1;
>  	}
>  
>  	return 0;
> diff --git a/include/video/imx-ipu-v3.h b/include/video/imx-ipu-v3.h
> index 8f77ddb..5938a69 100644
> --- a/include/video/imx-ipu-v3.h
> +++ b/include/video/imx-ipu-v3.h
> @@ -63,17 +63,25 @@ enum ipu_csi_dest {
>  /*
>   * Enumeration of IPU rotation modes
>   */
> +#define IPU_ROT_BIT_VFLIP (1 << 0)
> +#define IPU_ROT_BIT_HFLIP (1 << 1)
> +#define IPU_ROT_BIT_90    (1 << 2)
> +
>  enum ipu_rotate_mode {
>  	IPU_ROTATE_NONE = 0,
> -	IPU_ROTATE_VERT_FLIP,
> -	IPU_ROTATE_HORIZ_FLIP,
> -	IPU_ROTATE_180,
> -	IPU_ROTATE_90_RIGHT,
> -	IPU_ROTATE_90_RIGHT_VFLIP,
> -	IPU_ROTATE_90_RIGHT_HFLIP,
> -	IPU_ROTATE_90_LEFT,
> +	IPU_ROTATE_VERT_FLIP = IPU_ROT_BIT_VFLIP,
> +	IPU_ROTATE_HORIZ_FLIP = IPU_ROT_BIT_HFLIP,
> +	IPU_ROTATE_180 = (IPU_ROT_BIT_VFLIP | IPU_ROT_BIT_HFLIP),
> +	IPU_ROTATE_90_RIGHT = IPU_ROT_BIT_90,
> +	IPU_ROTATE_90_RIGHT_VFLIP = (IPU_ROT_BIT_90 | IPU_ROT_BIT_VFLIP),
> +	IPU_ROTATE_90_RIGHT_HFLIP = (IPU_ROT_BIT_90 | IPU_ROT_BIT_HFLIP),
> +	IPU_ROTATE_90_LEFT = (IPU_ROT_BIT_90 |
> +			      IPU_ROT_BIT_VFLIP | IPU_ROT_BIT_HFLIP),
>  };
>  
> +/* 90-degree rotations require the IRT unit */
> +#define ipu_rot_mode_is_irt(m) ((m) >= IPU_ROTATE_90_RIGHT)
> +
>  enum ipu_color_space {
>  	IPUV3_COLORSPACE_RGB,
>  	IPUV3_COLORSPACE_YUV,
> @@ -320,6 +328,7 @@ enum ipu_ic_task {
>  };
>  
>  struct ipu_ic;
> +
>  int ipu_ic_task_init(struct ipu_ic *ic,
>  		     int in_width, int in_height,
>  		     int out_width, int out_height,
> @@ -335,6 +344,40 @@ int ipu_ic_task_idma_init(struct ipu_ic *ic, struct ipuv3_channel *channel,
>  			  u32 width, u32 height, int burst_size,
>  			  enum ipu_rotate_mode rot);
>  int ipu_ic_set_src(struct ipu_ic *ic, int csi_id, bool vdi);
> +
> +struct image_converter_ctx;
> +struct image_converter_run;
> +
> +typedef void (*image_converter_cb_t)(void *ctx,
> +				     struct image_converter_run *run,
> +				     int err);
> +
> +int ipu_image_convert_enum_format(int index, const char **desc, u32 *fourcc);
> +int ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
> +			     enum ipu_rotate_mode rot_mode);
> +int ipu_image_convert_verify(struct ipu_image *in, struct ipu_image *out,
> +			     enum ipu_rotate_mode rot_mode);
> +struct image_converter_ctx *
> +ipu_image_convert_prepare(struct ipu_ic *ic,
> +			  struct ipu_image *in, struct ipu_image *out,
> +			  enum ipu_rotate_mode rot_mode,
> +			  image_converter_cb_t complete,
> +			  void *complete_context);
> +void ipu_image_convert_unprepare(struct image_converter_ctx *ctx);
> +struct image_converter_run *
> +ipu_image_convert_run(struct image_converter_ctx *ctx,
> +		      dma_addr_t in_phys, dma_addr_t out_phys);
> +void ipu_image_convert_abort(struct image_converter_ctx *ctx);
> +struct image_converter_ctx *
> +ipu_image_convert(struct ipu_ic *ic,
> +		  struct ipu_image *in, struct ipu_image *out,
> +		  enum ipu_rotate_mode rot_mode,
> +		  image_converter_cb_t complete,
> +		  void *complete_context);
> +int ipu_image_convert_sync(struct ipu_ic *ic,
> +			   struct ipu_image *in, struct ipu_image *out,
> +			   enum ipu_rotate_mode rot_mode);
> +
>  int ipu_ic_enable(struct ipu_ic *ic);
>  int ipu_ic_disable(struct ipu_ic *ic);
>  struct ipu_ic *ipu_ic_get(struct ipu_soc *ipu, enum ipu_ic_task task);



Thanks,
Mauro
