Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77486C43381
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 06:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2EAEF2184E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 06:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfCMGyZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 02:54:25 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:22458 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfCMGyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 02:54:25 -0400
X-UUID: 8aa9afad69504f198deb13217416988b-20190313
X-UUID: 8aa9afad69504f198deb13217416988b-20190313
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <jungo.lin@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1604464045; Wed, 13 Mar 2019 14:54:06 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Mar 2019 14:54:05 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 13 Mar 2019 14:54:04 +0800
Message-ID: <1552460044.13953.114.camel@mtksdccf07>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
From:   Jungo Lin <jungo.lin@mediatek.com>
To:     Tomasz Figa <tfiga@chromium.org>
CC:     Frederic Chen <frederic.chen@mediatek.com>,
        Sean Cheng =?UTF-8?Q?=28=E9=84=AD=E6=98=87=E5=BC=98=29?= 
        <Sean.Cheng@mediatek.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Rynn Wu =?UTF-8?Q?=28=E5=90=B3=E8=82=B2=E6=81=A9=29?= 
        <Rynn.Wu@mediatek.com>,
        Christie Yu =?UTF-8?Q?=28=E6=B8=B8=E9=9B=85=E6=83=A0=29?= 
        <christie.yu@mediatek.com>, <srv_heupstream@mediatek.com>,
        Holmes Chiou =?UTF-8?Q?=28=E9=82=B1=E6=8C=BA=29?= 
        <holmes.chiou@mediatek.com>,
        "Jerry-ch Chen" <Jerry-ch.Chen@mediatek.com>,
        Sj Huang <sj.huang@mediatek.com>, <yuzhao@chromium.org>,
        <linux-mediatek@lists.infradead.org>, <zwisler@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg 
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Date:   Wed, 13 Mar 2019 14:54:04 +0800
In-Reply-To: <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
         <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
         <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: FAB3ACBE3DFA27249E7C98C8239F4C4CC54D8E00FC2453C7541DAA119D9771582000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 2019-03-12 at 19:04 +0900, Tomasz Figa wrote:
> Hi Frederic, Jungo,
> 
> Please see more comments inline.
> 

Hi Tomasz:

Thanks for your part 3 comments.
Below is our feedback.

> > +static int mtk_cam_vb2_queue_setup(struct vb2_queue *vq,
> > +                                  unsigned int *num_buffers,
> > +                               unsigned int *num_planes,
> > +                               unsigned int sizes[],
> > +                               struct device *alloc_devs[])
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> > +       struct mtk_cam_dev_video_device *node =
> > +               mtk_cam_vbq_to_isp_node(vq);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       struct device *dev = &isp_dev->pdev->dev;
> > +       void *buf_alloc_ctx = NULL;
> 
> Don't initialize by default, if not strictly necessary.
> 

Ok, fixed in next patch.

> > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +
> > +       /* Get V4L2 format with the following method */
> > +       const struct v4l2_format *fmt = &node->vdev_fmt;
> > +
> > +       *num_planes = 1;
> 
> This doesn't handle VIDIOC_CREATE_BUFS, which triggers a
> .queue_setup() call with *num_planes > 0 and sizes[] already
> initialized. The driver needs to validate that the sizes and number of
> planes are valid in that case and return -EINVAL otherwise. Perhaps
> you should try running v4l2-compliance
> (https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance) on
> this driver, which should catch issues like this.
> 

Ok, we will add code check logic for this user case.
The function will be similar to below:
https://elixir.bootlin.com/linux/latest/source/drivers/media/platform/vivid/vivid-vid-cap.c#L87
https://elixir.bootlin.com/linux/latest/source/drivers/staging/media/ipu3/ipu3-v4l2.c#L388

> > +       *num_buffers = clamp_val(*num_buffers, 1, VB2_MAX_FRAME);
> > +
> > +       if (isp_dev->ctx.queue[queue_id].desc.smem_alloc) {
> > +               buf_alloc_ctx = isp_dev->ctx.smem_vb2_alloc_ctx;
> > +               dev_dbg(dev, "Select smem_vb2_alloc_ctx(%llx)\n",
> > +                       (unsigned long long)buf_alloc_ctx);
> 
> Use %p for printing pointers.
> 

For security reason, we will change to use "%pK" for printing kernel
pointers.

> > +       } else {
> > +               buf_alloc_ctx = isp_dev->ctx.default_vb2_alloc_ctx;
> > +               dev_dbg(dev, "Select default_vb2_alloc_ctx(%llx)\n",
> > +                       (unsigned long long)buf_alloc_ctx);
> > +       }
> > +
> > +       vq->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
> > +       dev_dbg(dev, "queue(%d): cached mmap enabled\n", queue_id);
> 
> This isn't supported in upstream. (By the way, neither it is in Chrome
> OS 4.19 kernel. If we really need cached mmap for some reason, we
> should propose a proper solution upstream. I'd still first investigate
> why write-combine mmap is slow for operations that should be simple
> one-time writes or reads.)
> 

Ok, we will remove this in upstream version and follow your suggestion
to find out better solution.

> > +
> > +       if (vq->type == V4L2_BUF_TYPE_META_CAPTURE ||
> > +           vq->type == V4L2_BUF_TYPE_META_OUTPUT)
> > +               sizes[0] = fmt->fmt.meta.buffersize;
> > +       else
> > +               sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
> > +
> > +       alloc_devs[0] = (struct device *)buf_alloc_ctx;
> 
> Please don't add random type casts. If the compiler gives a type
> error, that normally means that there is something wrong elsewhere in
> the code (i.e. the type of buf_alloc_ctx variable is wrong here - it
> should be struct device *) and casting just masks the original
> problem.
> 

Ok, we will fix this coding defect.

> > +
> > +       dev_dbg(dev, "queue(%d):type(%d),size(%d),alloc_ctx(%llx)\n",
> > +               queue_id, vq->type, sizes[0],
> > +               (unsigned long long)buf_alloc_ctx);
> > +
> > +       /* Initialize buffer queue */
> > +       INIT_LIST_HEAD(&node->buffers);
> 
> This is incorrect. .queue_setup() can be also called on
> VIDIOC_CREATE_BUFS, which must preserve the other buffers in the
> queue.
> 

In our new version, we have removed this for request-API new design.

> > +
> > +       return 0;
> > +}
> [snip]
> > +static int mtk_cam_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> > +       struct mtk_cam_dev_video_device *node =
> > +               mtk_cam_vbq_to_isp_node(vq);
> > +       int r;
> 
> nit: "ret" is more common and already used by some other functions in
> this patch.
> 

We will rename this variable in next patch and try to unify the variable
naming in our driver.

> > +
> > +       if (m2m2->streaming) {
> > +               r = -EBUSY;
> > +               goto fail_return_bufs;
> > +       }
> 
> We shouldn't need to check this ourselves. It's not possible to have
> this call on an already streaming vb2 queue. Since we start streaming
> the m2m2 subdev only when all video nodes start streaming, this should
> never happen.
> 

Ok, we will remove this redundant checking in next patch.

> > +
> > +       if (!node->enabled) {
> > +               pr_err("Node (%ld) is not enable\n", node - m2m2->nodes);
> > +               r = -EINVAL;
> > +               goto fail_return_bufs;
> > +       }
> > +
> > +       r = media_pipeline_start(&node->vdev.entity, &m2m2->pipeline);
> > +       if (r < 0) {
> > +               pr_err("Node (%ld) media_pipeline_start failed\n",
> > +                      node - m2m2->nodes);
> > +               goto fail_return_bufs;
> > +       }
> > +
> > +       if (!mtk_cam_all_nodes_streaming(m2m2, node))
> > +               return 0;
> > +
> > +       /* Start streaming of the whole pipeline now */
> > +
> > +       r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 1);
> > +       if (r < 0) {
> > +               pr_err("Node (%ld) v4l2_subdev_call s_stream failed\n",
> > +                      node - m2m2->nodes);
> > +               goto fail_stop_pipeline;
> > +       }
> > +       return 0;
> > +
> > +fail_stop_pipeline:
> > +       media_pipeline_stop(&node->vdev.entity);
> > +fail_return_bufs:
> > +       mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_QUEUED);
> > +
> > +       return r;
> > +}
> > +
> > +static void mtk_cam_vb2_stop_streaming(struct vb2_queue *vq)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> > +       struct mtk_cam_dev_video_device *node =
> > +               mtk_cam_vbq_to_isp_node(vq);
> > +       int r;
> > +
> > +       WARN_ON(!node->enabled);
> > +
> > +       /* Was this the first node with streaming disabled? */
> > +       if (mtk_cam_all_nodes_streaming(m2m2, node)) {
> > +               /* Yes, really stop streaming now */
> > +               r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 0);
> > +               if (r)
> > +                       dev_err(m2m2->dev, "failed to stop streaming\n");
> > +       }
> > +
> > +       mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_ERROR);
> > +       media_pipeline_stop(&node->vdev.entity);
> > +}
> > +
> > +static int mtk_cam_videoc_querycap(struct file *file, void *fh,
> > +                                  struct v4l2_capability *cap)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       int queue_id =
> > +               mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +       struct mtk_cam_ctx_queue *node_ctx = &isp_dev->ctx.queue[queue_id];
> 
> It feels like this could be just stored as node->ctx.
> 

After refactoring this function, the node_ctx is removed.
Moreover, we will follow your suggestion to store mtk_cam_ctx_queue
pointer in mtk_cam_dev_video_device for better access.

> > +
> > +       strlcpy(cap->driver, m2m2->name, sizeof(cap->driver));
> > +       strlcpy(cap->card, m2m2->model, sizeof(cap->card));
> > +       snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> > +                node->name);
> > +
> > +       cap->device_caps =
> > +               mtk_cam_node_get_v4l2_cap(node_ctx) | V4L2_CAP_STREAMING;
> > +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> No need to set these 2 fields manually. They are filled in
> automatically from struct video_device::device_caps.
> 

We will remove this redundant code.

> > +
> > +       return 0;
> > +}
> > +
> > +/* Propagate forward always the format from the mtk_cam_dev subdev */
> 
> It doesn't seem to match what the function is doing, i.e. returning
> the format structure of the node itself. I'd just drop this comment.
> The code should be written in a self-explaining way anyway.
> 

Ok, we will remove this comment to avoid misunderstanding.

> > +static int mtk_cam_videoc_g_fmt(struct file *file, void *fh,
> > +                               struct v4l2_format *f)
> > +{
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +
> > +       f->fmt = node->vdev_fmt.fmt;
> > +
> > +       return 0;
> > +}
> > +
> > +static int mtk_cam_videoc_try_fmt(struct file *file,
> > +                                 void *fh,
> > +        struct v4l2_format *f)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +       int queue_id =
> > +               mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +       int ret = 0;
> > +
> > +       ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
> > +                                     &f->fmt.pix_mp,
> > +               &node->vdev_fmt.fmt.pix_mp);
> 
> Doesn't this actually change the current node format? VIDIOC_TRY_FMT
> must not have any side effects on current driver state.
> 

This is a bug in our implementation. We will fix it in next patch.

> > +
> > +       /* Simply set the format to the node context in the initial version */
> > +       if (ret) {
> > +               pr_warn("Fmt(%d) not support for queue(%d), will load default fmt\n",
> > +                       f->fmt.pix_mp.pixelformat, queue_id);
> 
> No need for this warning.
> 

Ok, we will remove this in next patch.

> > +
> > +               ret =   mtk_cam_ctx_format_load_default_fmt
> > +                       (&dev_ctx->queue[queue_id], f);
> 
> Wouldn't this also change the current node state?
> 
> Also, something wrong with the number of spaces after "ret =".
> 

Ditto.

> > +       }
> > +
> > +       if (!ret) {
> > +               node->vdev_fmt.fmt.pix_mp = f->fmt.pix_mp;
> > +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
> 
> Ditto.
> 
> > +       }
> > +
> > +       return ret;
> 
> VIDIOC_TRY_FMT must not return an error unless for the cases described
> in https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
> .
> 

Ok, we will try to follow the VIDIOC_TYPE_FMT  API description of V4L2
manual.

> > +}
> > +
> > +static int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
> > +                               struct v4l2_format *f)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +       int ret = 0;
> > +
> > +       ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
> > +                                     &f->fmt.pix_mp,
> > +               &node->vdev_fmt.fmt.pix_mp);
> > +
> > +       /* Simply set the format to the node context in the initial version */
> > +       if (!ret)
> > +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
> > +       else
> > +               dev_warn(&isp_dev->pdev->dev,
> > +                        "s_fmt, format not support\n");
> 
> No need for error messages for userspace errors.
> 

Ok, we will remove this check.

> > +
> > +       return ret;
> 
> Instead of opencoding most of this function, one would normally call
> mtk_cam_videoc_try_fmt() first to adjust the format struct and then
> just update the driver state with the adjusted format.
> 
> Also, similarly to VIDIOC_TRY_FMT, VIDIOC_SET_FMT doesn't fail unless
> in the very specific cases, as described in
> https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
> .
> 

Ok, below is our revised version of this function.

int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
			 struct v4l2_format *f)
{
	struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
	struct mtk_cam_dev *cam_dev = mtk_cam_m2m_to_dev(m2m2);
	struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);

	/* Get the valid format*/
	mtk_cam_videoc_try_fmt(file, fh, f);
	/* Configure to video device */
	mtk_cam_ctx_fmt_set_img(&cam_dev->pdev->dev,
				&node->vdev_fmt.fmt.pix_mp,
				&f->fmt.pix_mp,
				node->queue_id);

	return 0;
}

> > +}
> > +
> > +static int mtk_cam_enum_framesizes(struct file *filp, void *priv,
> > +                                  struct v4l2_frmsizeenum *sizes)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(filp);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       struct mtk_cam_dev_video_device *node =
> > +               file_to_mtk_cam_node(filp);
> > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +
> > +       if (sizes->index != 0)
> > +               return -EINVAL;
> > +
> > +       if (queue_id == MTK_CAM_CTX_P1_MAIN_STREAM_OUT) {
> > +               sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> > +               sizes->stepwise.max_width = CAM_B_MAX_WIDTH;
> > +               sizes->stepwise.min_width = CAM_MIN_WIDTH;
> > +               sizes->stepwise.max_height = CAM_B_MAX_HEIGHT;
> > +               sizes->stepwise.min_height = CAM_MIN_HEIGHT;
> > +               sizes->stepwise.step_height = 1;
> > +               sizes->stepwise.step_width = 1;
> > +       } else if (queue_id == MTK_CAM_CTX_P1_PACKED_BIN_OUT) {
> > +               sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> > +               sizes->stepwise.max_width = RRZ_MAX_WIDTH;
> > +               sizes->stepwise.min_width = RRZ_MIN_WIDTH;
> > +               sizes->stepwise.max_height = RRZ_MAX_HEIGHT;
> > +               sizes->stepwise.min_height = RRZ_MIN_HEIGHT;
> > +               sizes->stepwise.step_height = 1;
> > +               sizes->stepwise.step_width = 1;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +static int mtk_cam_meta_enum_format(struct file *file,
> > +                                   void *fh, struct v4l2_fmtdesc *f)
> > +{
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +
> > +       if (f->index > 0 || f->type != node->vbq.type)
> > +               return -EINVAL;
> 
> f->type is already checked by the V4L2 core. See v4l_enum_fmt().
> 

We will remove the redundant checking in next patch.

> > +
> > +       f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
> > +
> > +       return 0;
> > +}
> > +
> > +static int mtk_cam_videoc_s_meta_fmt(struct file *file,
> > +                                    void *fh, struct v4l2_format *f)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > +
> 
> No need for this blank line.
> 

We will fix this coding style in next patch.

> > +       int ret = 0;
> 
> Please don't default-initialize without a good reason.
> 

Ok, fix in next patch.

> > +
> > +       if (f->type != node->vbq.type)
> > +               return -EINVAL;
> 
> Ditto.
> 

Ok, fix in next patch.

> > +
> > +       ret = mtk_cam_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
> > +
> 
> No need for this blank line.
> 

Ok, fix in next patch.

> > +       if (!ret) {
> > +               node->vdev_fmt.fmt.meta = f->fmt.meta;
> > +               dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
> > +       } else {
> > +               dev_warn(&isp_dev->pdev->dev,
> > +                        "s_meta_fm failed, format not support\n");
> 
> No need for this warning.
> 

Ok, fix in next patch.

> > +       }
> > +
> > +       return ret;
> > +}
> 
> Actually, why do we even need to do all the things? Do we support
> multiple different meta formats on the same video node? If not, we can
> just have all the TRY_FMT/S_FMT/G_FMT return the hardcoded format.
> 

Ok, it is a good idea. We will return the hardcode format for meta video
devices.
Below is the revision version.

int mtk_cam_meta_enum_format(struct file *file,
			     void *fh, struct v4l2_fmtdesc *f)
{
	struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);

	f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;

	return 0;
}

const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_cap_ioctl_ops = {
	.vidioc_querycap = mtk_cam_videoc_querycap,
	.vidioc_enum_fmt_meta_cap = mtk_cam_meta_enum_format,
	.vidioc_g_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
	.vidioc_s_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
	.vidioc_try_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
...

> > +
> > +static int mtk_cam_videoc_g_meta_fmt(struct file *file,
> > +                                    void *fh, struct v4l2_format *f)
> > +{
> > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > +
> > +       if (f->type != node->vbq.type)
> > +               return -EINVAL;
> 
> Not needed.
> 

Ok, remove it in next patch.

> > +
> > +       f->fmt = node->vdev_fmt.fmt;
> > +
> > +       return 0;
> > +}
> > +
> > +int mtk_cam_videoc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> > +{
> > +       struct video_device *vdev = video_devdata(file);
> > +       struct vb2_buffer *vb;
> > +       struct mtk_cam_dev_buffer *db;
> > +       int r = 0;
> > +
> > +       /* check if vb2 queue is busy */
> > +       if (vdev->queue->owner &&
> > +           vdev->queue->owner != file->private_data)
> > +               return -EBUSY;
> 
> This should be already handled by the core.
> 

Ok, remove it in next patch.

> > +
> > +       /* Keep the value of sequence in v4l2_buffer */
> > +       /* in ctx buf since vb2_qbuf will set it to 0 */
> > +       vb = vdev->queue->bufs[p->index];
> 
> Why do you need a sequence number for buffers on queue time? The field
> is not specified to be set by the userspace and should be ignored by
> the driver. The driver should rely on the Request API to match any
> buffers together anyway.
> 

It is our old design for frame-sync mechanism.
However, we change to use "Request API" design and this function
is removed in new version.

> > +
> > +       if (vb) {
> > +               db = mtk_cam_vb2_buf_to_dev_buf(vb);
> > +               pr_debug("qbuf: p:%llx,vb:%llx, db:%llx\n",
> > +                        (unsigned long long)p,
> > +                       (unsigned long long)vb,
> > +                       (unsigned long long)db);
> > +               db->ctx_buf.user_sequence = p->sequence;
> > +       }
> > +
> 
> Generally this driver shouldn't need to implement this callback
> itself. Instead it can just use the vb2_ioctl_qbuf() helper.
> 

Same as above. This function is removed in new version.

> > +       r = vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
> > +
> > +       if (r)
> > +               pr_err("vb2_qbuf failed(err=%d): buf idx(%d)\n",
> > +                      r, p->index);
> > +
> > +       return r;
> > +}
> > +EXPORT_SYMBOL_GPL(mtk_cam_videoc_qbuf);
> > +
> > +/******************** function pointers ********************/
> > +
> > +/* subdev internal operations */
> > +static const struct v4l2_subdev_internal_ops mtk_cam_subdev_internal_ops = {
> > +       .open = mtk_cam_subdev_open,
> > +       .close = mtk_cam_subdev_close,
> > +};
> > +
> > +static const struct v4l2_subdev_core_ops mtk_cam_subdev_core_ops = {
> > +       .subscribe_event = mtk_cam_subdev_subscribe_event,
> > +       .unsubscribe_event = mtk_cam_subdev_unsubscribe_event,
> > +};
> > +
> > +static const struct v4l2_subdev_video_ops mtk_cam_subdev_video_ops = {
> > +       .s_stream = mtk_cam_subdev_s_stream,
> > +};
> > +
> > +static const struct v4l2_subdev_ops mtk_cam_subdev_ops = {
> > +       .core = &mtk_cam_subdev_core_ops,
> > +       .video = &mtk_cam_subdev_video_ops,
> > +};
> > +
> > +static const struct media_entity_operations mtk_cam_media_ops = {
> > +       .link_setup = mtk_cam_link_setup,
> > +       .link_validate = v4l2_subdev_link_validate,
> > +};
> > +
> > +#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
> > +static void mtk_cam_vb2_buf_request_complete(struct vb2_buffer *vb)
> > +{
> > +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +       v4l2_ctrl_request_complete(vb->req_obj.req,
> > +                                  m2m2->v4l2_dev->ctrl_handler);
> > +}
> > +#endif
> > +
> > +static const struct vb2_ops mtk_cam_vb2_ops = {
> > +       .buf_queue = mtk_cam_vb2_buf_queue,
> > +       .queue_setup = mtk_cam_vb2_queue_setup,
> > +       .start_streaming = mtk_cam_vb2_start_streaming,
> > +       .stop_streaming = mtk_cam_vb2_stop_streaming,
> > +       .wait_prepare = vb2_ops_wait_prepare,
> > +       .wait_finish = vb2_ops_wait_finish,
> > +#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
> > +       .buf_request_complete = mtk_cam_vb2_buf_request_complete,
> > +#endif
> > +};
> > +
> > +static const struct v4l2_file_operations mtk_cam_v4l2_fops = {
> > +       .unlocked_ioctl = video_ioctl2,
> > +       .open = v4l2_fh_open,
> > +       .release = vb2_fop_release,
> > +       .poll = vb2_fop_poll,
> > +       .mmap = vb2_fop_mmap,
> > +#ifdef CONFIG_COMPAT
> > +       .compat_ioctl32 = v4l2_compat_ioctl32,
> > +#endif
> > +};
> > +
> > +static const struct v4l2_ioctl_ops mtk_cam_v4l2_ioctl_ops = {
> > +       .vidioc_querycap = mtk_cam_videoc_querycap,
> > +       .vidioc_enum_framesizes = mtk_cam_enum_framesizes,
> > +
> > +       .vidioc_g_fmt_vid_cap_mplane = mtk_cam_videoc_g_fmt,
> > +       .vidioc_s_fmt_vid_cap_mplane = mtk_cam_videoc_s_fmt,
> > +       .vidioc_try_fmt_vid_cap_mplane = mtk_cam_videoc_try_fmt,
> > +
> > +       .vidioc_g_fmt_vid_out_mplane = mtk_cam_videoc_g_fmt,
> > +       .vidioc_s_fmt_vid_out_mplane = mtk_cam_videoc_s_fmt,
> > +       .vidioc_try_fmt_vid_out_mplane = mtk_cam_videoc_try_fmt,
> > +
> > +       /* buffer queue management */
> > +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> > +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> > +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> > +       .vidioc_querybuf = vb2_ioctl_querybuf,
> > +       .vidioc_qbuf = mtk_cam_videoc_qbuf,
> > +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> > +       .vidioc_streamon = vb2_ioctl_streamon,
> > +       .vidioc_streamoff = vb2_ioctl_streamoff,
> > +       .vidioc_expbuf = vb2_ioctl_expbuf,
> > +};
> > +
> > +static const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_ioctl_ops = {
> > +       .vidioc_querycap = mtk_cam_videoc_querycap,
> > +
> > +       .vidioc_enum_fmt_meta_cap = mtk_cam_meta_enum_format,
> > +       .vidioc_g_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
> > +       .vidioc_s_fmt_meta_cap = mtk_cam_videoc_s_meta_fmt,
> > +       .vidioc_try_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
> > +
> > +       .vidioc_enum_fmt_meta_out = mtk_cam_meta_enum_format,
> > +       .vidioc_g_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
> > +       .vidioc_s_fmt_meta_out = mtk_cam_videoc_s_meta_fmt,
> > +       .vidioc_try_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
> > +
> > +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> > +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> > +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> > +       .vidioc_querybuf = vb2_ioctl_querybuf,
> > +       .vidioc_qbuf = mtk_cam_videoc_qbuf,
> > +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> > +       .vidioc_streamon = vb2_ioctl_streamon,
> > +       .vidioc_streamoff = vb2_ioctl_streamoff,
> > +       .vidioc_expbuf = vb2_ioctl_expbuf,
> > +};
> 
> The ops should be split for each node type, {VIDEO, META} x {OUTPUT,
> CAPTURE}. Then the core would validate the type given to all the
> ioctls automatically.
> 

Ok, below is new implementation.

static const struct v4l2_ioctl_ops mtk_cam_v4l2_vcap_ioctl_ops
static const struct v4l2_ioctl_ops mtk_cam_v4l2_vout_ioctl_ops
static  const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_cap_ioctl_ops
static  const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_out_ioctl_ops

> > +
> > +static u32 mtk_cam_node_get_v4l2_cap(struct mtk_cam_ctx_queue *node_ctx)
> > +{
> > +       u32 cap = 0;
> > +
> > +       if (node_ctx->desc.capture)
> > +               if (node_ctx->desc.image)
> > +                       cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> > +               else
> > +                       cap = V4L2_CAP_META_CAPTURE;
> > +       else
> > +               if (node_ctx->desc.image)
> > +                       cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> > +               else
> > +                       cap = V4L2_CAP_META_OUTPUT;
> > +
> > +       return cap;
> > +}
> 
> Why not just have this defined statically as node_ctx->desc.cap?
> 

Ok, it is refactoring done.

> > +
> > +static u32 mtk_cam_node_get_format_type(struct mtk_cam_ctx_queue *node_ctx)
> > +{
> > +       u32 type;
> > +
> > +       if (node_ctx->desc.capture)
> > +               if (node_ctx->desc.image)
> > +                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > +               else
> > +                       type = V4L2_BUF_TYPE_META_CAPTURE;
> > +       else
> > +               if (node_ctx->desc.image)
> > +                       type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > +               else
> > +                       type = V4L2_BUF_TYPE_META_OUTPUT;
> > +
> > +       return type;
> > +}
> 
> Why not just have this defined statically as node_ctx->desc.buf_type?
> 

Same as above.

> > +
> > +static const struct v4l2_ioctl_ops *mtk_cam_node_get_ioctl_ops
> > +       (struct mtk_cam_ctx_queue *node_ctx)
> > +{
> > +       const struct v4l2_ioctl_ops *ops = NULL;
> > +
> > +       if (node_ctx->desc.image)
> > +               ops = &mtk_cam_v4l2_ioctl_ops;
> > +       else
> > +               ops = &mtk_cam_v4l2_meta_ioctl_ops;
> > +       return ops;
> > +}
> 
> It's also preferable to just put this inside some structure rather
> than have getter functions. (node_ctx->desc.ioctl_ops?)
> 

Same as above.
Below is the new version for struct mtk_cam_ctx_queue_desc

/*
 * struct mtk_cam_ctx_queue_desc - queue attributes
 *				setup by device context owner
 * @id:		id of the context queue
 * @name:		media entity name
 * @cap:		mapped to V4L2 capabilities
 * @buf_type:	mapped to V4L2 buffer type
 * @capture:	true for capture queue (device to user)
 *				false for output queue (from user to device)
 * @image:		true for image, false for meta data
 * @smem_alloc:	Using the cam_smem_drv as alloc ctx or not
 * @dma_port:	the dma port associated to the buffer
 * @fmts:	supported format
 * @num_fmts:	the number of supported formats
 * @default_fmt_idx: default format of this queue
 * @max_buf_count: maximum V4L2 buffer count
 * @max_buf_count: mapped to v4l2_ioctl_ops
 */
struct mtk_cam_ctx_queue_desc {
	u8 id;
	char *name;
	u32 cap;
	u32 buf_type;
	u32 dma_port;
	u32 smem_alloc:1;
	u8 capture:1;
	u8 image:1;
	u8 num_fmts;
	u8 default_fmt_idx;
	u8 max_buf_count;
	const struct v4l2_ioctl_ops *ioctl_ops;
	struct v4l2_format *fmts;
};

> > +
> > +/* Config node's video properties */
> > +/* according to the device context requirement */
> > +static void mtk_cam_node_to_v4l2(struct mtk_cam_dev *isp_dev, u32 node,
> > +                                struct video_device *vdev,
> > +                                struct v4l2_format *f)
> > +{
> > +       u32 cap;
> > +       struct mtk_cam_ctx *device_ctx = &isp_dev->ctx;
> > +       struct mtk_cam_ctx_queue *node_ctx = &device_ctx->queue[node];
> > +
> > +       WARN_ON(node >= mtk_cam_dev_get_total_node(isp_dev));
> > +       WARN_ON(!node_ctx);
> 
> How is this possible?
> 

Ok, we will remove this in next version.

> > +
> > +       /* set cap of the node */
> > +       cap = mtk_cam_node_get_v4l2_cap(node_ctx);
> > +       f->type = mtk_cam_node_get_format_type(node_ctx);
> > +       vdev->ioctl_ops = mtk_cam_node_get_ioctl_ops(node_ctx);
> > +
> > +       if (mtk_cam_ctx_format_load_default_fmt(&device_ctx->queue[node], f)) {
> > +               dev_err(&isp_dev->pdev->dev,
> > +                       "Can't load default for node (%d): (%s)",
> > +               node, device_ctx->queue[node].desc.name);
> 
> mtk_cam_ctx_format_load_default_fmt() doesn't fail (and that's right).
> It should be actually made void.
> 

Ok, we will revise this in next version.

> > +       }       else {
> > +               if (device_ctx->queue[node].desc.image) {
> > +                       dev_dbg(&isp_dev->pdev->dev,
> > +                               "Node (%d): (%s), dfmt (f:0x%x w:%d: h:%d s:%d)\n",
> > +                       node, device_ctx->queue[node].desc.name,
> > +                       f->fmt.pix_mp.pixelformat,
> > +                       f->fmt.pix_mp.width,
> > +                       f->fmt.pix_mp.height,
> > +                       f->fmt.pix_mp.plane_fmt[0].sizeimage
> > +                       );
> > +                       node_ctx->fmt.pix_mp = f->fmt.pix_mp;
> > +               } else {
> > +                       dev_dbg(&isp_dev->pdev->dev,
> > +                               "Node (%d): (%s), dfmt (f:0x%x s:%u)\n",
> > +                       node, device_ctx->queue[node].desc.name,
> > +                       f->fmt.meta.dataformat,
> > +                       f->fmt.meta.buffersize
> > +                       );
> > +                       node_ctx->fmt.meta = f->fmt.meta;
> > +               }
> 
> Drop the debugging messages and just replace the whole if/else block with:
> 
> node_ctx->fmt = f->fmt;
> 

Same as above.

> Sorry, ran out of time for today. Fourth part will come. :)
> 
> Best regards,
> Tomasz
> 

Appreciate your support and hard working on this review.
We will look forward your part 4 review.
 

Best regards,

Jungo

> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek


