Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:51509 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751328AbcDZCRv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 22:17:51 -0400
Message-ID: <1461637063.11415.24.camel@mtksdaap41>
Subject: Re: [PATCH v8 5/8] [media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <Andrew-CT.Chen@mediatek.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	"Yingjoe Chen" <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Tue, 26 Apr 2016 10:17:43 +0800
In-Reply-To: <571E1809.3060100@xs4all.nl>
References: <1461587438-59886-1-git-send-email-tiffany.lin@mediatek.com>
	 <1461587438-59886-2-git-send-email-tiffany.lin@mediatek.com>
	 <1461587438-59886-3-git-send-email-tiffany.lin@mediatek.com>
	 <1461587438-59886-4-git-send-email-tiffany.lin@mediatek.com>
	 <1461587438-59886-5-git-send-email-tiffany.lin@mediatek.com>
	 <1461587438-59886-6-git-send-email-tiffany.lin@mediatek.com>
	 <571E1809.3060100@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-04-25 at 15:13 +0200, Hans Verkuil wrote:
> On 04/25/2016 02:30 PM, Tiffany Lin wrote:
> > Add v4l2 layer encoder driver for MT8173
> > 
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > 
> > ---
> >  drivers/media/platform/Kconfig                     |   16 +
> >  drivers/media/platform/Makefile                    |    2 +
> >  drivers/media/platform/mtk-vcodec/Makefile         |   14 +
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  339 +++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1303 ++++++++++++++++++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   58 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  456 +++++++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  137 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h  |   26 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |   56 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   27 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   96 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   87 ++
> >  drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  107 ++
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  165 +++
> >  drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  210 ++++
> >  17 files changed, 3161 insertions(+)
> >  create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> > 
> 
> ...
> 
> > +static int fops_vcodec_open(struct file *file)
> > +{
> > +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> > +	struct mtk_vcodec_ctx *ctx = NULL;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&dev->dev_mutex);
> 
> I would move this to after the kzalloc, since that doesn't need to be
> called with the mutex held.
> 
Will fix this in next version.

> > +
> > +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> > +	if (!ctx) {
> 
> And then you can just do return -ENOMEM here.
> 
Got it.
> > +		ret = -ENOMEM;
> > +		goto err_alloc;
> > +	}
> > +
> > +	ctx->idx = dev->curr_max_idx;
> 
> I'd do:
> 
> 	/*
> 	 * Use simple counter to uniquely identify this context. Only
> 	 * used for logging.
> 	 */
> 	ctx->idx = dev->curr_max_idx++;
> 
> I would also prefer that it is call 'id' instead of idx, since that's really
> what it is, just an ID.
> 
> And the counter is then id_counter instead of curr_max_idx.
> 
Got it, will fix this in next version.

> > +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> > +	file->private_data = &ctx->fh;
> > +	v4l2_fh_add(&ctx->fh);
> > +	INIT_LIST_HEAD(&ctx->list);
> > +	ctx->dev = dev;
> > +	init_waitqueue_head(&ctx->queue);
> > +
> > +	ctx->type = MTK_INST_ENCODER;
> > +	ret = mtk_vcodec_enc_ctrls_setup(ctx);
> > +	if (ret) {
> > +		mtk_v4l2_err("Failed to setup controls() (%d)",
> > +				ret);
> > +		goto err_ctrls_setup;
> > +	}
> > +	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
> > +				&mtk_vcodec_enc_queue_init);
> > +	if (IS_ERR(ctx->m2m_ctx)) {
> > +		ret = PTR_ERR(ctx->m2m_ctx);
> > +		mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
> > +				ret);
> > +		goto err_m2m_ctx_init;
> > +	}
> > +	mtk_vcodec_enc_set_default_params(ctx);
> > +
> > +	if (v4l2_fh_is_singular(&ctx->fh)) {
> > +		/*
> > +		 * vpu_load_firmware checks if it was loaded already and
> > +		 * does nothing in that case
> > +		 */
> > +		ret = vpu_load_firmware(dev->vpu_plat_dev);
> > +		if (ret < 0) {
> > +			/*
> > +			 * Return 0 if downloading firmware successfully,
> > +			 * otherwise it is failed
> > +			 */
> > +			mtk_v4l2_err("vpu_load_firmware failed!");
> > +			goto err_load_fw;
> > +		}
> > +
> > +		dev->enc_capability =
> > +			vpu_get_venc_hw_capa(dev->vpu_plat_dev);
> > +		mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
> > +	}
> > +
> > +	mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p ",
> > +			ctx->idx, ctx, ctx->m2m_ctx);
> > +	dev->curr_max_idx = (dev->curr_max_idx + 1) & 0xffffffffffffffff;
> 
> and drop this line.
> 
Got it.

> > +	dev->num_instances++;
> > +	list_add(&ctx->list, &dev->ctx_list);
> > +
> > +	mutex_unlock(&dev->dev_mutex);
> > +	mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev),
> > +			ctx->idx);
> > +	return ret;
> > +
> > +	/* Deinit when failure occurred */
> > +err_load_fw:
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +err_m2m_ctx_init:
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +err_ctrls_setup:
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	kfree(ctx);
> > +err_alloc:
> > +	mutex_unlock(&dev->dev_mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +static int fops_vcodec_release(struct file *file)
> > +{
> > +	struct mtk_vcodec_dev *dev = video_drvdata(file);
> > +	struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> > +
> > +	mtk_v4l2_debug(1, "[%d] encoder", ctx->idx);
> > +	mutex_lock(&dev->dev_mutex);
> > +
> > +	mtk_vcodec_enc_release(ctx);
> > +	v4l2_fh_del(&ctx->fh);
> > +	v4l2_fh_exit(&ctx->fh);
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +
> > +	list_del_init(&ctx->list);
> > +	dev->num_instances--;
> > +	kfree(ctx);
> > +	mutex_unlock(&dev->dev_mutex);
> > +	return 0;
> > +}
> 
> Tiffany, besides these very small items here is there anything else you are waiting for?
> I'm thinking that if you fix these small issues, merge Julia Lawall's fixes and repost,
> then I can make a pull request. Mauro will still have to review it as well, but I have no
> more comments.
> 
For Julia Lawall's fixes, do you mean we need merge 
1.[PATCH] VPU: mediatek: fix simple_open.cocci warnings
2.[PATCH] VPU: mediatek: fix platform_no_drv_owner.cocci warnings 
to "[PATCH v8 2/8] [media] VPU: mediatek: support Mediatek VPU"
or add these two patches to this patch series?
We are ready for our encoder patch series, I will fix these issues and
repost patches today.
Appreciated for your review comments.


> Regards,
> 
> 	Hans


