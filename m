Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:16145 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbcDYHC4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 03:02:56 -0400
Message-ID: <1461567768.11415.14.camel@mtksdaap41>
Subject: Re: [PATCH v7 5/8] [media] vcodec: mediatek: Add Mediatek V4L2
 Video Encoder Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Wu-Cheng Li =?UTF-8?Q?=28=E6=9D=8E=E5=8B=99=E8=AA=A0=29?=
	<wuchengli@chromium.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	"Lin PoChun" <PoChun.Lin@mediatek.com>
Date: Mon, 25 Apr 2016 15:02:48 +0800
In-Reply-To: <CAOMLVLj+zM2-s2_O4G0hXH+SWPk1j=VwUZtA3y5wvEyd1VkAEQ@mail.gmail.com>
References: <1461299131-57851-1-git-send-email-tiffany.lin@mediatek.com>
	 <1461299131-57851-2-git-send-email-tiffany.lin@mediatek.com>
	 <1461299131-57851-3-git-send-email-tiffany.lin@mediatek.com>
	 <1461299131-57851-4-git-send-email-tiffany.lin@mediatek.com>
	 <1461299131-57851-5-git-send-email-tiffany.lin@mediatek.com>
	 <1461299131-57851-6-git-send-email-tiffany.lin@mediatek.com>
	 <571A2B70.7040402@xs4all.nl> <1461561405.11415.12.camel@mtksdaap41>
	 <CAOMLVLj+zM2-s2_O4G0hXH+SWPk1j=VwUZtA3y5wvEyd1VkAEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wucheng,

On Mon, 2016-04-25 at 13:42 +0800, Wu-Cheng Li (李務誠) wrote:
> > >
> > > ...
> > >
> > > > +static int fops_vcodec_open(struct file *file)
> > > > +{
> > > > +   struct video_device *vfd = video_devdata(file);
> > > > +   struct mtk_vcodec_dev *dev = video_drvdata(file);
> > > > +   struct mtk_vcodec_ctx *ctx = NULL;
> > > > +   int ret = 0;
> > > > +
> > > > +   if (dev->instance_mask == ~0UL) {
> > > > +           /* ffz Undefined if no zero exists, err handling here */
> > > > +           mtk_v4l2_err("Too many open contexts");
> > > > +           ret = -EBUSY;
> > > > +           goto err_alloc;
> > >
> > > I'm not happy seeing this here. You should always be able to open the device.
> > > I would expect to see a check like this in e.g. start_streaming, since that's
> > > where you start to use the hardware for real, and checking if you have enough
> > > resources there is perfectly fine.
> > >
> > > If this is an artificial constraint (i.e. not based on a real hardware limitation),
> > > then it should perhaps just be dropped. Such constraints tend to be pointless.
> > > If you want to encode 20 streams simultaneously, then why not? It will be very
> > > slow, but that's not this driver's problem :-)
> > >
> > We use ffz to get instance index.
> > This only make sure that instance id is correct since in ffz
> > description,
> > "Undefined if no zero exists, so code should check against ~0UL first."
> > In this case, it may not be able to move to start_streaming.
> > Any suggestion that how we do this?
> The instance index is only used for printing the debug information.
> No? If that's the case, you can remove instance index and print
> mtk_vcodec_ctx address for debugging.
> >
Got it, will remove it in next version.


best regards,
Tiffany
> >
> > > > +   }
> > > > +
> > > > +   mutex_lock(&dev->dev_mutex);
> > > > +
> > > > +   ctx = devm_kzalloc(&dev->plat_dev->dev, sizeof(*ctx), GFP_KERNEL);
> > >
> > > Why is this a devm_ call? It is not managed by a device, so it seems to me that
> > > a regular kzalloc is good enough here.
> > >
> > > > +   if (!ctx) {
> > > > +           ret = -ENOMEM;
> > > > +           goto err_alloc;
> > > > +   }
> > > > +
> > > > +   ctx->idx = ffz(dev->instance_mask);
> > > > +   v4l2_fh_init(&ctx->fh, video_devdata(file));
> > > > +   file->private_data = &ctx->fh;
> > > > +   v4l2_fh_add(&ctx->fh);
> > > > +   INIT_LIST_HEAD(&ctx->list);
> > > > +   ctx->dev = dev;
> > > > +   init_waitqueue_head(&ctx->queue);
> > > > +
> > > > +   if (vfd == dev->vfd_enc) {
> > > > +           ctx->type = MTK_INST_ENCODER;
> > > > +           ret = mtk_vcodec_enc_ctrls_setup(ctx);
> > > > +           if (ret) {
> > > > +                   mtk_v4l2_err("Failed to setup controls() (%d)",
> > > > +                                  ret);
> > > > +                   goto err_ctrls_setup;
> > > > +           }
> > > > +           ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev_enc, ctx,
> > > > +                                            &mtk_vcodec_enc_queue_init);
> > > > +           if (IS_ERR(ctx->m2m_ctx)) {
> > > > +                   ret = PTR_ERR(ctx->m2m_ctx);
> > > > +                   mtk_v4l2_err("Failed to v4l2_m2m_ctx_init() (%d)",
> > > > +                                  ret);
> > > > +                   goto err_m2m_ctx_init;
> > > > +           }
> > > > +           mtk_vcodec_enc_set_default_params(ctx);
> > > > +   } else {
> > > > +           mtk_v4l2_err("Invalid vfd !");
> > >
> > > This shouldn't be possible at all. I would just drop the 'if (vfd == dev->vfd_enc)' check.
> > Got it, will remove in next version.
> >
> > >
> > > > +           ret = -ENOENT;
> > > > +           goto err_m2m_ctx_init;
> > > > +   }
> > > > +
> > > > +   if (v4l2_fh_is_singular(&ctx->fh)) {
> > > > +           ret = vpu_load_firmware(dev->vpu_plat_dev);
> > > > +           if (ret < 0) {
> > > > +                   /*
> > > > +                     * Return 0 if downloading firmware successfully,
> > > > +                     * otherwise it is failed
> > > > +                     */
> > > > +                   mtk_v4l2_err("vpu_load_firmware failed!");
> > > > +                   goto err_load_fw;
> > > > +           }
> > >
> > > The fw load seems to be a one-time thing, but here it is done every time
> > > someone opens the device and nobody else had it open.
> > >
> > > If this is a one time thing, then using a bool 'loaded_fw' makes more sense.
> > >
> > More than one module use vpu firmware, encoder/decoder/mdp...etc.
> > If this is first encode instance, we need to check and load vpu
> > firmware.
> > vpu_load_firmware will check and load firmware when necessary.
> >
> > best regards,
> > Tiffany
> > > > +
> > > > +           dev->enc_capability =
> > > > +                   vpu_get_venc_hw_capa(dev->vpu_plat_dev);
> > > > +           mtk_v4l2_debug(0, "encoder capability %x", dev->enc_capability);
> > > > +   }
> > > > +
> > > > +   mtk_v4l2_debug(2, "Create instance [%d]@%p m2m_ctx=%p ",
> > > > +                    ctx->idx, ctx, ctx->m2m_ctx);
> > > > +   set_bit(ctx->idx, &dev->instance_mask);
> > > > +   dev->num_instances++;
> > > > +   list_add(&ctx->list, &dev->ctx_list);
> > > > +
> > > > +   mutex_unlock(&dev->dev_mutex);
> > > > +   mtk_v4l2_debug(0, "%s encoder [%d]", dev_name(&dev->plat_dev->dev),
> > > > +                              ctx->idx);
> > > > +   return ret;
> > > > +
> > > > +   /* Deinit when failure occurred */
> > > > +err_load_fw:
> > > > +   v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > > > +err_m2m_ctx_init:
> > > > +   v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > > > +err_ctrls_setup:
> > > > +   v4l2_fh_del(&ctx->fh);
> > > > +   v4l2_fh_exit(&ctx->fh);
> > > > +   devm_kfree(&dev->plat_dev->dev, ctx);
> > > > +err_alloc:
> > > > +   mutex_unlock(&dev->dev_mutex);
> > > > +
> > > > +   return ret;
> > > > +}
> > > > +
> > > > +static int fops_vcodec_release(struct file *file)
> > > > +{
> > > > +   struct mtk_vcodec_dev *dev = video_drvdata(file);
> > > > +   struct mtk_vcodec_ctx *ctx = fh_to_ctx(file->private_data);
> > > > +
> > > > +   mtk_v4l2_debug(1, "[%d] encoder", ctx->idx);
> > > > +   mutex_lock(&dev->dev_mutex);
> > > > +
> > > > +   mtk_vcodec_enc_release(ctx);
> > > > +   v4l2_fh_del(&ctx->fh);
> > > > +   v4l2_fh_exit(&ctx->fh);
> > > > +   v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > > > +   v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > > > +
> > > > +   list_del_init(&ctx->list);
> > > > +   dev->num_instances--;
> > > > +   clear_bit(ctx->idx, &dev->instance_mask);
> > > > +   devm_kfree(&dev->plat_dev->dev, ctx);
> > > > +   mutex_unlock(&dev->dev_mutex);
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +static const struct v4l2_file_operations mtk_vcodec_fops = {
> > > > +   .owner                          = THIS_MODULE,
> > > > +   .open                           = fops_vcodec_open,
> > > > +   .release                        = fops_vcodec_release,
> > > > +   .poll                           = v4l2_m2m_fop_poll,
> > > > +   .unlocked_ioctl                 = video_ioctl2,
> > > > +   .mmap                           = v4l2_m2m_fop_mmap,
> > > > +};
> > > > +
> > > > +static int mtk_vcodec_probe(struct platform_device *pdev)
> > > > +{
> > > > +   struct mtk_vcodec_dev *dev;
> > > > +   struct video_device *vfd_enc;
> > > > +   struct resource *res;
> > > > +   int i, j, ret;
> > > > +   DEFINE_DMA_ATTRS(attrs);
> > > > +
> > > > +   dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> > > > +   if (!dev)
> > > > +           return -ENOMEM;
> > > > +
> > > > +   INIT_LIST_HEAD(&dev->ctx_list);
> > > > +   dev->plat_dev = pdev;
> > > > +
> > > > +   dev->vpu_plat_dev = vpu_get_plat_device(dev->plat_dev);
> > > > +   if (dev->vpu_plat_dev == NULL) {
> > > > +           mtk_v4l2_err("[VPU] vpu device in not ready");
> > > > +           return -EPROBE_DEFER;
> > > > +   }
> > > > +
> > > > +   vpu_wdt_reg_handler(dev->vpu_plat_dev, mtk_vcodec_enc_reset_handler,
> > > > +                                           dev, VPU_RST_ENC);
> > > > +
> > > > +   ret = mtk_vcodec_init_enc_pm(dev);
> > > > +   if (ret < 0) {
> > > > +           dev_err(&pdev->dev, "Failed to get mt vcodec clock source!");
> > > > +           return ret;
> > > > +   }
> > > > +
> > > > +   for (i = VENC_SYS, j = 0; i < NUM_MAX_VCODEC_REG_BASE; i++, j++) {
> > > > +           res = platform_get_resource(pdev, IORESOURCE_MEM, j);
> > > > +           if (res == NULL) {
> > > > +                   dev_err(&pdev->dev, "get memory resource failed.");
> > > > +                   ret = -ENXIO;
> > > > +                   goto err_res;
> > > > +           }
> > > > +           dev->reg_base[i] = devm_ioremap_resource(&pdev->dev, res);
> > > > +           if (IS_ERR(dev->reg_base[i])) {
> > > > +                   dev_err(&pdev->dev,
> > > > +                           "devm_ioremap_resource %d failed.", i);
> > > > +                   ret = PTR_ERR(dev->reg_base[i]);
> > > > +                   goto err_res;
> > > > +           }
> > > > +           mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[i]);
> > > > +   }
> > > > +
> > > > +   res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> > > > +   if (res == NULL) {
> > > > +           dev_err(&pdev->dev, "failed to get irq resource");
> > > > +           ret = -ENOENT;
> > > > +           goto err_res;
> > > > +   }
> > > > +
> > > > +   dev->enc_irq = platform_get_irq(pdev, 0);
> > > > +   ret = devm_request_irq(&pdev->dev, dev->enc_irq,
> > > > +                          mtk_vcodec_enc_irq_handler,
> > > > +                          0, pdev->name, dev);
> > > > +   if (ret) {
> > > > +           dev_err(&pdev->dev, "Failed to install dev->enc_irq %d (%d)",
> > > > +                   dev->enc_irq,
> > > > +                   ret);
> > > > +           ret = -EINVAL;
> > > > +           goto err_res;
> > > > +   }
> > > > +
> > > > +   dev->enc_lt_irq = platform_get_irq(pdev, 1);
> > > > +   ret = devm_request_irq(&pdev->dev,
> > > > +                          dev->enc_lt_irq, mtk_vcodec_enc_lt_irq_handler,
> > > > +                          0, pdev->name, dev);
> > > > +   if (ret) {
> > > > +           dev_err(&pdev->dev,
> > > > +                   "Failed to install dev->enc_lt_irq %d (%d)",
> > > > +                   dev->enc_lt_irq, ret);
> > > > +           ret = -EINVAL;
> > > > +           goto err_res;
> > > > +   }
> > > > +
> > > > +   disable_irq(dev->enc_irq);
> > > > +   disable_irq(dev->enc_lt_irq); /* VENC_LT */
> > > > +   mutex_init(&dev->enc_mutex);
> > > > +   mutex_init(&dev->dev_mutex);
> > > > +   spin_lock_init(&dev->irqlock);
> > > > +
> > > > +   snprintf(dev->v4l2_dev.name, sizeof(dev->v4l2_dev.name), "%s",
> > > > +            "[MTK_V4L2_VENC]");
> > > > +
> > > > +   ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> > > > +   if (ret) {
> > > > +           mtk_v4l2_err("v4l2_device_register err=%d", ret);
> > > > +           goto err_res;
> > > > +   }
> > > > +
> > > > +   init_waitqueue_head(&dev->queue);
> > > > +
> > > > +   /* allocate video device for encoder and register it */
> > > > +   vfd_enc = video_device_alloc();
> > > > +   if (!vfd_enc) {
> > > > +           mtk_v4l2_err("Failed to allocate video device");
> > > > +           ret = -ENOMEM;
> > > > +           goto err_enc_alloc;
> > > > +   }
> > > > +   vfd_enc->fops           = &mtk_vcodec_fops;
> > > > +   vfd_enc->ioctl_ops      = &mtk_venc_ioctl_ops;
> > > > +   vfd_enc->release        = video_device_release;
> > > > +   vfd_enc->lock           = &dev->dev_mutex;
> > > > +   vfd_enc->v4l2_dev       = &dev->v4l2_dev;
> > > > +   vfd_enc->vfl_dir        = VFL_DIR_M2M;
> > > > +   vfd_enc->device_caps    = V4L2_CAP_VIDEO_M2M_MPLANE |
> > > > +                                           V4L2_CAP_STREAMING;
> > > > +
> > > > +   snprintf(vfd_enc->name, sizeof(vfd_enc->name), "%s",
> > > > +            MTK_VCODEC_ENC_NAME);
> > > > +   video_set_drvdata(vfd_enc, dev);
> > > > +   dev->vfd_enc = vfd_enc;
> > > > +   platform_set_drvdata(pdev, dev);
> > > > +
> > > > +   dev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> > > > +   if (IS_ERR(dev->alloc_ctx)) {
> > > > +           dev->alloc_ctx = NULL;
> > > > +           mtk_v4l2_err("Failed to alloc vb2 dma context 0");
> > > > +           ret = PTR_ERR(dev->alloc_ctx);
> > > > +           goto err_vb2_ctx_init;
> > > > +   }
> > > > +
> > > > +   dev->m2m_dev_enc = v4l2_m2m_init(&mtk_venc_m2m_ops);
> > > > +   if (IS_ERR(dev->m2m_dev_enc)) {
> > > > +           mtk_v4l2_err("Failed to init mem2mem enc device");
> > > > +           ret = PTR_ERR(dev->m2m_dev_enc);
> > > > +           goto err_enc_mem_init;
> > > > +   }
> > > > +
> > > > +   dev->encode_workqueue =
> > > > +                   alloc_ordered_workqueue(MTK_VCODEC_ENC_NAME,
> > > > +                                                           WQ_MEM_RECLAIM |
> > > > +                                                           WQ_FREEZABLE);
> > > > +   if (!dev->encode_workqueue) {
> > > > +           mtk_v4l2_err("Failed to create encode workqueue");
> > > > +           ret = -EINVAL;
> > > > +           goto err_event_workq;
> > > > +   }
> > > > +
> > > > +   ret = video_register_device(vfd_enc, VFL_TYPE_GRABBER, 1);
> > > > +   if (ret) {
> > > > +           mtk_v4l2_err("Failed to register video device");
> > > > +           goto err_enc_reg;
> > > > +   }
> > > > +
> > > > +   /* Avoid the iommu eat big hunks */
> > > > +   dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
> > > > +
> > > > +   mtk_v4l2_debug(0, "encoder registered as /dev/video%d",
> > > > +                    vfd_enc->num);
> > > > +
> > > > +   return 0;
> > > > +
> > > > +err_enc_reg:
> > > > +   destroy_workqueue(dev->encode_workqueue);
> > > > +err_event_workq:
> > > > +   v4l2_m2m_release(dev->m2m_dev_enc);
> > > > +err_enc_mem_init:
> > > > +   vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> > > > +err_vb2_ctx_init:
> > > > +   video_unregister_device(vfd_enc);
> > > > +err_enc_alloc:
> > > > +   v4l2_device_unregister(&dev->v4l2_dev);
> > > > +err_res:
> > > > +   mtk_vcodec_release_enc_pm(dev);
> > > > +   return ret;
> > > > +}
> > > > +
> > > > +static const struct of_device_id mtk_vcodec_enc_match[] = {
> > > > +   {.compatible = "mediatek,mt8173-vcodec-enc",},
> > > > +   {},
> > > > +};
> > > > +MODULE_DEVICE_TABLE(of, mtk_vcodec_enc_match);
> > > > +
> > > > +static int mtk_vcodec_enc_remove(struct platform_device *pdev)
> > > > +{
> > > > +   struct mtk_vcodec_dev *dev = platform_get_drvdata(pdev);
> > > > +
> > > > +   mtk_v4l2_debug_enter();
> > > > +   flush_workqueue(dev->encode_workqueue);
> > > > +   destroy_workqueue(dev->encode_workqueue);
> > > > +   if (dev->m2m_dev_enc)
> > > > +           v4l2_m2m_release(dev->m2m_dev_enc);
> > > > +   if (dev->alloc_ctx)
> > > > +           vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
> > > > +
> > > > +   if (dev->vfd_enc)
> > > > +           video_unregister_device(dev->vfd_enc);
> > > > +
> > > > +   v4l2_device_unregister(&dev->v4l2_dev);
> > > > +   mtk_vcodec_release_enc_pm(dev);
> > > > +   return 0;
> > > > +}
> > > > +
> > > > +static struct platform_driver mtk_vcodec_enc_driver = {
> > > > +   .probe  = mtk_vcodec_probe,
> > > > +   .remove = mtk_vcodec_enc_remove,
> > > > +   .driver = {
> > > > +           .name   = MTK_VCODEC_ENC_NAME,
> > > > +           .owner  = THIS_MODULE,
> > > > +           .of_match_table = mtk_vcodec_enc_match,
> > > > +   },
> > > > +};
> > > > +
> > > > +module_platform_driver(mtk_vcodec_enc_driver);
> > > > +
> > > > +
> > > > +MODULE_LICENSE("GPL v2");
> > > > +MODULE_DESCRIPTION("Mediatek video codec V4L2 encoder driver");
> > >
> > > Regards,
> > >
> > >       Hans
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


