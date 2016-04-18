Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:14767 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751335AbcDRFkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2016 01:40:52 -0400
Message-ID: <1460958046.7861.48.camel@mtksdaap41>
Subject: Re: [PATCH 3/7] [Media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 18 Apr 2016 13:40:46 +0800
In-Reply-To: <5710FA3A.2030603@xs4all.nl>
References: <1460548915-17536-1-git-send-email-tiffany.lin@mediatek.com>
	 <1460548915-17536-2-git-send-email-tiffany.lin@mediatek.com>
	 <1460548915-17536-3-git-send-email-tiffany.lin@mediatek.com>
	 <1460548915-17536-4-git-send-email-tiffany.lin@mediatek.com>
	 <5710FA3A.2030603@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


snipped.

> > +
> > +void mtk_vcodec_dec_set_default_params(struct mtk_vcodec_ctx *ctx)
> > +{
> > +	struct mtk_q_data *q_data;
> > +
> > +	ctx->m2m_ctx->q_lock = &ctx->dev->dev_mutex;
> > +	ctx->fh.m2m_ctx = ctx->m2m_ctx;
> > +	ctx->fh.ctrl_handler = &ctx->ctrl_hdl;
> > +	INIT_WORK(&ctx->decode_work, mtk_vdec_worker);
> > +
> > +	q_data = &ctx->q_data[MTK_Q_DATA_SRC];
> > +	memset(q_data, 0, sizeof(struct mtk_q_data));
> > +	q_data->visible_width = DFT_CFG_WIDTH;
> > +	q_data->visible_height = DFT_CFG_HEIGHT;
> > +	q_data->fmt = &mtk_video_formats[OUT_FMT_IDX];
> > +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> > +	q_data->field = V4L2_FIELD_NONE;
> > +	ctx->q_data[MTK_Q_DATA_DST].sizeimage[0] =
> > +		DFT_CFG_WIDTH * DFT_CFG_HEIGHT;
> > +	ctx->q_data[MTK_Q_DATA_DST].bytesperline[0] = 0;
> > +
> > +
> > +	q_data = &ctx->q_data[MTK_Q_DATA_DST];
> > +	memset(q_data, 0, sizeof(struct mtk_q_data));
> > +	q_data->visible_width = DFT_CFG_WIDTH;
> > +	q_data->visible_height = DFT_CFG_HEIGHT;
> > +	q_data->coded_width = DFT_CFG_WIDTH;
> > +	q_data->coded_height = DFT_CFG_HEIGHT;
> > +	q_data->colorspace = V4L2_COLORSPACE_REC709;
> > +	q_data->field = V4L2_FIELD_NONE;
> > +
> > +	q_data->fmt = &mtk_video_formats[CAP_FMT_IDX];
> > +
> > +	v4l_bound_align_image(&q_data->coded_width,
> > +					MTK_VDEC_MIN_W,
> > +					MTK_VDEC_MAX_W, 4,
> > +					&q_data->coded_height,
> > +					MTK_VDEC_MIN_H,
> > +					MTK_VDEC_MAX_H, 5, 6);
> > +
> > +	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
> > +	q_data->bytesperline[0] = q_data->coded_width;
> > +	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
> > +	q_data->bytesperline[1] = q_data->coded_width;
> > +
> > +}
> > +
> > +static int vidioc_vdec_streamon(struct file *file, void *priv,
> > +				enum v4l2_buf_type type)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	mtk_v4l2_debug(3, "[%d] (%d)", ctx->idx, type);
> > +
> > +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> > +}
> > +
> > +static int vidioc_vdec_streamoff(struct file *file, void *priv,
> > +				 enum v4l2_buf_type type)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +
> > +	mtk_v4l2_debug(3, "[%d] (%d)", ctx->idx, type);
> > +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> > +}
> > +
> > +static int vidioc_vdec_reqbufs(struct file *file, void *priv,
> > +			       struct v4l2_requestbuffers *reqbufs)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> > +	int ret;
> > +
> > +	mtk_v4l2_debug(3, "[%d] (%d) count=%d", ctx->idx,
> > +			 reqbufs->type, reqbufs->count);
> > +	ret = v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> > +
> > +	return ret;
> > +}
> 
> Please use the v4l2_m2m_ioctl_* helper functions were applicable.
> 



snipped.
> > +static unsigned int fops_vcodec_poll(struct file *file,
> > +				     struct poll_table_struct *wait)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> > +	struct mtk_vcodec_dev *dev = ctx->dev;
> > +	int ret;
> > +
> > +	mutex_lock(&dev->dev_mutex);
> > +	ret = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> > +	mutex_unlock(&dev->dev_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int fops_vcodec_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> > +
> > +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> > +}
> > +
> > +static const struct v4l2_file_operations mtk_vcodec_fops = {
> > +	.owner				= THIS_MODULE,
> > +	.open				= fops_vcodec_open,
> > +	.release			= fops_vcodec_release,
> > +	.poll				= fops_vcodec_poll,
> > +	.unlocked_ioctl			= video_ioctl2,
> > +	.mmap				= fops_vcodec_mmap,
> 
> You should be able to use the v4l2_m2m_fop helper functions for poll and mmap.
> 

Hi Hans,

We are plaining to remove m2m framework in th feature, although we think
it is easy to use and could save a lot of code similar to what m2m
framework implemented and reduce code size.
The main reason is that in v4l2_m2m_try_schedule, it required that at
least one output buffer and one capture buffer to run device_run.
We want to start device_run without capture buffer queued.
Is there any suggestion that we could use m2m framework but trigger
device_run with only output buffer.
Or we need to remove m2m and write our own implementation.



snipped.


best regards,
Tiffany

