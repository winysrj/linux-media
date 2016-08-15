Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:29463 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932171AbcHODrJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 23:47:09 -0400
Message-ID: <1471232822.22671.2.camel@mtksdaap41>
Subject: Re: [PATCH] vcodec: mediatek: bug fix and code refine for mt8173
 v4l2 Encoder
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>
Date: Mon, 15 Aug 2016 11:47:02 +0800
In-Reply-To: <04b80466-4d83-63f8-46a3-c1ab273f5dae@xs4all.nl>
References: <1471012549-19849-1-git-send-email-tiffany.lin@mediatek.com>
	 <04b80466-4d83-63f8-46a3-c1ab273f5dae@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, 2016-08-14 at 13:40 +0200, Hans Verkuil wrote:
> On 08/12/2016 04:35 PM, Tiffany Lin wrote:
> >     This patch include fixs:
> >     1. Remove unused include in mtk_vcodec_drv.h
> >     2. Fix visible_height larger than coded_height issue in s_fmt_out
> >     3. Add timestamp and timecode copy
> >     4. Fix mtk_vcodec_vdec_release should be called after v4l2_m2m_ctx_release
> >     5. Remove unused define MTK_INST_WORK_THREAD_ABORT_DONE
> >     6. Add support V4L2_MPEG_VIDEO_H264_LEVEL_4_2
> >     4. Refine  venc_h264_if.c and venc_vp8_if.c
> 
> I would prefer it if this can be split up into separate patches, one for each fix.
> 
> Also, should this be merged for v4.8 or can this wait for 4.9? When you split it
> up you can use [PATCH for v4.8] as prefix for those patches that should go to v4.8.
> 
I split up this patch into separate patches and resent them.
Please note there is dependency between these patches.

best regards,
Tiffany


> Regards,
> 
> 	Hans
> 
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > ---
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |    1 -
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   42 ++++++++++++--------
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    6 ++-
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |    1 -
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   11 ++---
> >  .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |   16 ++++----
> >  .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |   16 ++++----
> >  7 files changed, 52 insertions(+), 41 deletions(-)
> > 
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> > index 94f0a42..3a8e695 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> > @@ -23,7 +23,6 @@
> >  #include <media/v4l2-ioctl.h>
> >  #include <media/videobuf2-core.h>
> >  
> > -#include "mtk_vcodec_util.h"
> >  
> >  #define MTK_VCODEC_DRV_NAME	"mtk_vcodec_drv"
> >  #define MTK_VCODEC_ENC_NAME	"mtk-vcodec-enc"
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > index 0a895e0..34fd89c 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> > @@ -487,7 +487,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
> >  	struct mtk_q_data *q_data;
> >  	int ret, i;
> >  	struct mtk_video_fmt *fmt;
> > -	unsigned int pitch_w_div16;
> >  	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
> >  
> >  	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> > @@ -530,15 +529,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
> >  	q_data->coded_width = f->fmt.pix_mp.width;
> >  	q_data->coded_height = f->fmt.pix_mp.height;
> >  
> > -	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
> > -	if (pitch_w_div16 % 8 != 0) {
> > -		/* Adjust returned width/height, so application could correctly
> > -		 * allocate hw required memory
> > -		 */
> > -		q_data->visible_height += 32;
> > -		vidioc_try_fmt(f, q_data->fmt);
> > -	}
> > -
> >  	q_data->field = f->fmt.pix_mp.field;
> >  	ctx->colorspace = f->fmt.pix_mp.colorspace;
> >  	ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
> > @@ -945,7 +935,8 @@ static int mtk_venc_encode_header(void *priv)
> >  {
> >  	struct mtk_vcodec_ctx *ctx = priv;
> >  	int ret;
> > -	struct vb2_buffer *dst_buf;
> > +	struct vb2_buffer *src_buf, *dst_buf;
> > +	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
> >  	struct mtk_vcodec_mem bs_buf;
> >  	struct venc_done_result enc_result;
> >  
> > @@ -978,6 +969,15 @@ static int mtk_venc_encode_header(void *priv)
> >  		mtk_v4l2_err("venc_if_encode failed=%d", ret);
> >  		return -EINVAL;
> >  	}
> > +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> > +	if (src_buf) {
> > +		src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
> > +		dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
> > +		dst_buf->timestamp = src_buf->timestamp;
> > +		dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
> > +	} else {
> > +		mtk_v4l2_err("No timestamp for the header buffer.");
> > +	}
> >  
> >  	ctx->state = MTK_STATE_HEADER;
> >  	dst_buf->planes[0].bytesused = enc_result.bs_size;
> > @@ -1070,7 +1070,7 @@ static void mtk_venc_worker(struct work_struct *work)
> >  	struct mtk_vcodec_mem bs_buf;
> >  	struct venc_done_result enc_result;
> >  	int ret, i;
> > -	struct vb2_v4l2_buffer *vb2_v4l2;
> > +	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
> >  
> >  	/* check dst_buf, dst_buf may be removed in device_run
> >  	 * to stored encdoe header so we need check dst_buf and
> > @@ -1110,9 +1110,14 @@ static void mtk_venc_worker(struct work_struct *work)
> >  	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
> >  			     &frm_buf, &bs_buf, &enc_result);
> >  
> > -	vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
> > +	src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
> > +	dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
> > +
> > +	dst_buf->timestamp = src_buf->timestamp;
> > +	dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
> > +
> >  	if (enc_result.is_key_frm)
> > -		vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
> > +		dst_vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
> >  
> >  	if (ret) {
> >  		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
> > @@ -1284,7 +1289,7 @@ int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
> >  			0, V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE);
> >  	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
> >  			V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
> > -			0, V4L2_MPEG_VIDEO_H264_PROFILE_MAIN);
> > +			0, V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
> >  	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_H264_LEVEL,
> >  			V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
> >  			0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
> > @@ -1355,5 +1360,10 @@ int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
> >  
> >  void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx)
> >  {
> > -	venc_if_deinit(ctx);
> > +	int ret = venc_if_deinit(ctx);
> > +
> > +	if (ret)
> > +		mtk_v4l2_err("venc_if_deinit failed=%d", ret);
> > +
> > +	ctx->state = MTK_STATE_FREE;
> >  }
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> > index c7806ec..5cd2151 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> > @@ -218,11 +218,15 @@ static int fops_vcodec_release(struct file *file)
> >  	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
> >  	mutex_lock(&dev->dev_mutex);
> >  
> > +	/*
> > +	 * Call v4l2_m2m_ctx_release to make sure the worker thread is not
> > +	 * running after venc_if_deinit.
> > +	 */
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> >  	mtk_vcodec_enc_release(ctx);
> >  	v4l2_fh_del(&ctx->fh);
> >  	v4l2_fh_exit(&ctx->fh);
> >  	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > -	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> >  
> >  	list_del_init(&ctx->list);
> >  	dev->num_instances--;
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> > index 33e890f..1213185 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> > @@ -16,7 +16,6 @@
> >  #define _MTK_VCODEC_INTR_H_
> >  
> >  #define MTK_INST_IRQ_RECEIVED		0x1
> > -#define MTK_INST_WORK_THREAD_ABORT_DONE	0x2
> >  
> >  struct mtk_vcodec_ctx;
> >  
> > diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> > index 5e36513..21c9b81 100644
> > --- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> > +++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> > @@ -81,14 +81,15 @@ void mtk_vcodec_mem_free(struct mtk_vcodec_ctx *data,
> >  		return;
> >  	}
> >  
> > -	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
> > -	mem->va = NULL;
> > -	mem->dma_addr = 0;
> > -	mem->size = 0;
> > -
> >  	mtk_v4l2_debug(3, "[%d]  - va      = %p", ctx->id, mem->va);
> >  	mtk_v4l2_debug(3, "[%d]  - dma     = 0x%lx", ctx->id,
> >  		       (unsigned long)mem->dma_addr);
> >  	mtk_v4l2_debug(3, "[%d]    size = 0x%lx", ctx->id, size);
> > +
> > +	dma_free_coherent(dev, size, mem->va, mem->dma_addr);
> > +	mem->va = NULL;
> > +	mem->dma_addr = 0;
> > +	mem->size = 0;
> >  }
> >  EXPORT_SYMBOL(mtk_vcodec_mem_free);
> > +
> > diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > index 9a60052..63d4be4 100644
> > --- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > +++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> > @@ -61,6 +61,8 @@ enum venc_h264_bs_mode {
> >  
> >  /*
> >   * struct venc_h264_vpu_config - Structure for h264 encoder configuration
> > + *                               AP-W/R : AP is writer/reader on this item
> > + *                               VPU-W/R: VPU is write/reader on this item
> >   * @input_fourcc: input fourcc
> >   * @bitrate: target bitrate (in bps)
> >   * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
> > @@ -94,13 +96,13 @@ struct venc_h264_vpu_config {
> >  
> >  /*
> >   * struct venc_h264_vpu_buf - Structure for buffer information
> > - * @align: buffer alignment (in bytes)
> > + *                            AP-W/R : AP is writer/reader on this item
> > + *                            VPU-W/R: VPU is write/reader on this item
> >   * @iova: IO virtual address
> >   * @vpua: VPU side memory addr which is used by RC_CODE
> >   * @size: buffer size (in bytes)
> >   */
> >  struct venc_h264_vpu_buf {
> > -	u32 align;
> >  	u32 iova;
> >  	u32 vpua;
> >  	u32 size;
> > @@ -108,6 +110,8 @@ struct venc_h264_vpu_buf {
> >  
> >  /*
> >   * struct venc_h264_vsi - Structure for VPU driver control and info share
> > + *                        AP-W/R : AP is writer/reader on this item
> > + *                        VPU-W/R: VPU is write/reader on this item
> >   * This structure is allocated in VPU side and shared to AP side.
> >   * @config: h264 encoder configuration
> >   * @work_bufs: working buffer information in VPU side
> > @@ -150,12 +154,6 @@ struct venc_h264_inst {
> >  	struct mtk_vcodec_ctx *ctx;
> >  };
> >  
> > -static inline void h264_write_reg(struct venc_h264_inst *inst, u32 addr,
> > -				  u32 val)
> > -{
> > -	writel(val, inst->hw_base + addr);
> > -}
> > -
> >  static inline u32 h264_read_reg(struct venc_h264_inst *inst, u32 addr)
> >  {
> >  	return readl(inst->hw_base + addr);
> > @@ -214,6 +212,8 @@ static unsigned int h264_get_level(struct venc_h264_inst *inst,
> >  		return 40;
> >  	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
> >  		return 41;
> > +	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
> > +		return 42;
> >  	default:
> >  		mtk_vcodec_debug(inst, "unsupported level %d", level);
> >  		return 31;
> > diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> > index 60bbcd2..6d97584 100644
> > --- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> > +++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> > @@ -56,6 +56,8 @@ enum venc_vp8_vpu_work_buf {
> >  
> >  /*
> >   * struct venc_vp8_vpu_config - Structure for vp8 encoder configuration
> > + *                              AP-W/R : AP is writer/reader on this item
> > + *                              VPU-W/R: VPU is write/reader on this item
> >   * @input_fourcc: input fourcc
> >   * @bitrate: target bitrate (in bps)
> >   * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
> > @@ -83,14 +85,14 @@ struct venc_vp8_vpu_config {
> >  };
> >  
> >  /*
> > - * struct venc_vp8_vpu_buf -Structure for buffer information
> > - * @align: buffer alignment (in bytes)
> > + * struct venc_vp8_vpu_buf - Structure for buffer information
> > + *                           AP-W/R : AP is writer/reader on this item
> > + *                           VPU-W/R: VPU is write/reader on this item
> >   * @iova: IO virtual address
> >   * @vpua: VPU side memory addr which is used by RC_CODE
> >   * @size: buffer size (in bytes)
> >   */
> >  struct venc_vp8_vpu_buf {
> > -	u32 align;
> >  	u32 iova;
> >  	u32 vpua;
> >  	u32 size;
> > @@ -98,6 +100,8 @@ struct venc_vp8_vpu_buf {
> >  
> >  /*
> >   * struct venc_vp8_vsi - Structure for VPU driver control and info share
> > + *                       AP-W/R : AP is writer/reader on this item
> > + *                       VPU-W/R: VPU is write/reader on this item
> >   * This structure is allocated in VPU side and shared to AP side.
> >   * @config: vp8 encoder configuration
> >   * @work_bufs: working buffer information in VPU side
> > @@ -138,12 +142,6 @@ struct venc_vp8_inst {
> >  	struct mtk_vcodec_ctx *ctx;
> >  };
> >  
> > -static inline void vp8_enc_write_reg(struct venc_vp8_inst *inst, u32 addr,
> > -				     u32 val)
> > -{
> > -	writel(val, inst->hw_base + addr);
> > -}
> > -
> >  static inline u32 vp8_enc_read_reg(struct venc_vp8_inst *inst, u32 addr)
> >  {
> >  	return readl(inst->hw_base + addr);
> > 


