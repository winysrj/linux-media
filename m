Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB701C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 10:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649B12171F
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 10:04:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FBG/jVMz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCLKEk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 06:04:40 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33724 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbfCLKEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 06:04:39 -0400
Received: by mail-oi1-f196.google.com with SMTP id z14so1604836oid.0
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 03:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wQe0v3e3Y7QaQlMutca+FwK52EN/3Za4U1s8iTTbqOI=;
        b=FBG/jVMzzMgAoDiIg7aFvYOLksQD7RfcfsehOYIs9WrvpViF0v57o/OdLXx4zwRHlQ
         4aCiDjQ9vpSifD/1X8FkwuaoVoClN1ATxyv3FIr6/Ebo0WGmYAnXAoTYtyhdXK9orZ6B
         kQC2l6lxBWsCek6xnRAmepIT5AdL5NsLoUJ7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wQe0v3e3Y7QaQlMutca+FwK52EN/3Za4U1s8iTTbqOI=;
        b=k0wcRLYqzDuqiarAnB5FLQIhxUT0soUqGWs8B1xaJ8xCKgWwfIesHwKU5ubamst4u4
         GCBgiE5dQGu7oTaE6MNVpOrZULfKZVqV7+sQQRgbhAaAPiLC4UaJcHy3o5dUmSKeImFa
         kXVFbIXzPmOoxQw9siWupeM651Q0xJHOq4fHehiDNcvxGy9zgkbuNMeE0dHGeGXwxAeS
         n0HVFDqEuDCRULbdQSqWXkU24HI8cAZRmUHisLzeoTlhrDthhx/cRaenoZrDcb3u64Gh
         XLI5gxZpfm3ixeqa1h34eRYIv6VRaUJOXqEMeBix/V7GOJTmW6tDQC2eHGjT6FauVJ76
         wEug==
X-Gm-Message-State: APjAAAWg5s02ldmKae6Vq4IdYD13MxpBz5MfqUGq8JkxmGhZY8nss/mT
        a2VqW4Sh7AEgMpcbAr3R8/USVB7Ds5I=
X-Google-Smtp-Source: APXvYqwBupQqa4cIC+feDtSyyHj1Hp8ZeJ0303cLpxxIUrFU7eAJPfNiP6CPFyBAfCjEmgxBluT8HQ==
X-Received: by 2002:aca:c745:: with SMTP id x66mr1129912oif.44.1552385076779;
        Tue, 12 Mar 2019 03:04:36 -0700 (PDT)
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com. [209.85.167.179])
        by smtp.gmail.com with ESMTPSA id w22sm3434062oth.45.2019.03.12.03.04.35
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Mar 2019 03:04:35 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id e7so1555207oia.8
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2019 03:04:35 -0700 (PDT)
X-Received: by 2002:aca:59d7:: with SMTP id n206mr1191406oib.26.1552385074401;
 Tue, 12 Mar 2019 03:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com> <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
In-Reply-To: <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 12 Mar 2019 19:04:22 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com>
Message-ID: <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
To:     Frederic Chen <frederic.chen@mediatek.com>,
        =?UTF-8?B?SnVuZ28gTGluICjmnpfmmI7kv4op?= <jungo.lin@mediatek.com>
Cc:     Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-mediatek@lists.infradead.org,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>, Sj Huang <sj.huang@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        srv_heupstream@mediatek.com, yuzhao@chromium.org,
        zwisler@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Frederic, Jungo,

Please see more comments inline.

> +static int mtk_cam_vb2_queue_setup(struct vb2_queue *vq,
> +                                  unsigned int *num_buffers,
> +                               unsigned int *num_planes,
> +                               unsigned int sizes[],
> +                               struct device *alloc_devs[])
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_cam_dev_video_device *node =
> +               mtk_cam_vbq_to_isp_node(vq);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       struct device *dev = &isp_dev->pdev->dev;
> +       void *buf_alloc_ctx = NULL;

Don't initialize by default, if not strictly necessary.

> +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +
> +       /* Get V4L2 format with the following method */
> +       const struct v4l2_format *fmt = &node->vdev_fmt;
> +
> +       *num_planes = 1;

This doesn't handle VIDIOC_CREATE_BUFS, which triggers a
.queue_setup() call with *num_planes > 0 and sizes[] already
initialized. The driver needs to validate that the sizes and number of
planes are valid in that case and return -EINVAL otherwise. Perhaps
you should try running v4l2-compliance
(https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance) on
this driver, which should catch issues like this.

> +       *num_buffers = clamp_val(*num_buffers, 1, VB2_MAX_FRAME);
> +
> +       if (isp_dev->ctx.queue[queue_id].desc.smem_alloc) {
> +               buf_alloc_ctx = isp_dev->ctx.smem_vb2_alloc_ctx;
> +               dev_dbg(dev, "Select smem_vb2_alloc_ctx(%llx)\n",
> +                       (unsigned long long)buf_alloc_ctx);

Use %p for printing pointers.

> +       } else {
> +               buf_alloc_ctx = isp_dev->ctx.default_vb2_alloc_ctx;
> +               dev_dbg(dev, "Select default_vb2_alloc_ctx(%llx)\n",
> +                       (unsigned long long)buf_alloc_ctx);
> +       }
> +
> +       vq->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
> +       dev_dbg(dev, "queue(%d): cached mmap enabled\n", queue_id);

This isn't supported in upstream. (By the way, neither it is in Chrome
OS 4.19 kernel. If we really need cached mmap for some reason, we
should propose a proper solution upstream. I'd still first investigate
why write-combine mmap is slow for operations that should be simple
one-time writes or reads.)

> +
> +       if (vq->type == V4L2_BUF_TYPE_META_CAPTURE ||
> +           vq->type == V4L2_BUF_TYPE_META_OUTPUT)
> +               sizes[0] = fmt->fmt.meta.buffersize;
> +       else
> +               sizes[0] = fmt->fmt.pix_mp.plane_fmt[0].sizeimage;
> +
> +       alloc_devs[0] = (struct device *)buf_alloc_ctx;

Please don't add random type casts. If the compiler gives a type
error, that normally means that there is something wrong elsewhere in
the code (i.e. the type of buf_alloc_ctx variable is wrong here - it
should be struct device *) and casting just masks the original
problem.

> +
> +       dev_dbg(dev, "queue(%d):type(%d),size(%d),alloc_ctx(%llx)\n",
> +               queue_id, vq->type, sizes[0],
> +               (unsigned long long)buf_alloc_ctx);
> +
> +       /* Initialize buffer queue */
> +       INIT_LIST_HEAD(&node->buffers);

This is incorrect. .queue_setup() can be also called on
VIDIOC_CREATE_BUFS, which must preserve the other buffers in the
queue.

> +
> +       return 0;
> +}
[snip]
> +static int mtk_cam_vb2_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_cam_dev_video_device *node =
> +               mtk_cam_vbq_to_isp_node(vq);
> +       int r;

nit: "ret" is more common and already used by some other functions in
this patch.

> +
> +       if (m2m2->streaming) {
> +               r = -EBUSY;
> +               goto fail_return_bufs;
> +       }

We shouldn't need to check this ourselves. It's not possible to have
this call on an already streaming vb2 queue. Since we start streaming
the m2m2 subdev only when all video nodes start streaming, this should
never happen.

> +
> +       if (!node->enabled) {
> +               pr_err("Node (%ld) is not enable\n", node - m2m2->nodes);
> +               r = -EINVAL;
> +               goto fail_return_bufs;
> +       }
> +
> +       r = media_pipeline_start(&node->vdev.entity, &m2m2->pipeline);
> +       if (r < 0) {
> +               pr_err("Node (%ld) media_pipeline_start failed\n",
> +                      node - m2m2->nodes);
> +               goto fail_return_bufs;
> +       }
> +
> +       if (!mtk_cam_all_nodes_streaming(m2m2, node))
> +               return 0;
> +
> +       /* Start streaming of the whole pipeline now */
> +
> +       r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 1);
> +       if (r < 0) {
> +               pr_err("Node (%ld) v4l2_subdev_call s_stream failed\n",
> +                      node - m2m2->nodes);
> +               goto fail_stop_pipeline;
> +       }
> +       return 0;
> +
> +fail_stop_pipeline:
> +       media_pipeline_stop(&node->vdev.entity);
> +fail_return_bufs:
> +       mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_QUEUED);
> +
> +       return r;
> +}
> +
> +static void mtk_cam_vb2_stop_streaming(struct vb2_queue *vq)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vq);
> +       struct mtk_cam_dev_video_device *node =
> +               mtk_cam_vbq_to_isp_node(vq);
> +       int r;
> +
> +       WARN_ON(!node->enabled);
> +
> +       /* Was this the first node with streaming disabled? */
> +       if (mtk_cam_all_nodes_streaming(m2m2, node)) {
> +               /* Yes, really stop streaming now */
> +               r = v4l2_subdev_call(&m2m2->subdev, video, s_stream, 0);
> +               if (r)
> +                       dev_err(m2m2->dev, "failed to stop streaming\n");
> +       }
> +
> +       mtk_cam_return_all_buffers(m2m2, node, VB2_BUF_STATE_ERROR);
> +       media_pipeline_stop(&node->vdev.entity);
> +}
> +
> +static int mtk_cam_videoc_querycap(struct file *file, void *fh,
> +                                  struct v4l2_capability *cap)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       int queue_id =
> +               mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +       struct mtk_cam_ctx_queue *node_ctx = &isp_dev->ctx.queue[queue_id];

It feels like this could be just stored as node->ctx.

> +
> +       strlcpy(cap->driver, m2m2->name, sizeof(cap->driver));
> +       strlcpy(cap->card, m2m2->model, sizeof(cap->card));
> +       snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> +                node->name);
> +
> +       cap->device_caps =
> +               mtk_cam_node_get_v4l2_cap(node_ctx) | V4L2_CAP_STREAMING;
> +       cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

No need to set these 2 fields manually. They are filled in
automatically from struct video_device::device_caps.

> +
> +       return 0;
> +}
> +
> +/* Propagate forward always the format from the mtk_cam_dev subdev */

It doesn't seem to match what the function is doing, i.e. returning
the format structure of the node itself. I'd just drop this comment.
The code should be written in a self-explaining way anyway.

> +static int mtk_cam_videoc_g_fmt(struct file *file, void *fh,
> +                               struct v4l2_format *f)
> +{
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +
> +       f->fmt = node->vdev_fmt.fmt;
> +
> +       return 0;
> +}
> +
> +static int mtk_cam_videoc_try_fmt(struct file *file,
> +                                 void *fh,
> +        struct v4l2_format *f)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +       int queue_id =
> +               mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +       int ret = 0;
> +
> +       ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
> +                                     &f->fmt.pix_mp,
> +               &node->vdev_fmt.fmt.pix_mp);

Doesn't this actually change the current node format? VIDIOC_TRY_FMT
must not have any side effects on current driver state.

> +
> +       /* Simply set the format to the node context in the initial version */
> +       if (ret) {
> +               pr_warn("Fmt(%d) not support for queue(%d), will load default fmt\n",
> +                       f->fmt.pix_mp.pixelformat, queue_id);

No need for this warning.

> +
> +               ret =   mtk_cam_ctx_format_load_default_fmt
> +                       (&dev_ctx->queue[queue_id], f);

Wouldn't this also change the current node state?

Also, something wrong with the number of spaces after "ret =".

> +       }
> +
> +       if (!ret) {
> +               node->vdev_fmt.fmt.pix_mp = f->fmt.pix_mp;
> +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;

Ditto.

> +       }
> +
> +       return ret;

VIDIOC_TRY_FMT must not return an error unless for the cases described
in https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
.

> +}
> +
> +static int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
> +                               struct v4l2_format *f)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +       int ret = 0;
> +
> +       ret = mtk_cam_ctx_fmt_set_img(dev_ctx, queue_id,
> +                                     &f->fmt.pix_mp,
> +               &node->vdev_fmt.fmt.pix_mp);
> +
> +       /* Simply set the format to the node context in the initial version */
> +       if (!ret)
> +               dev_ctx->queue[queue_id].fmt.pix_mp = node->vdev_fmt.fmt.pix_mp;
> +       else
> +               dev_warn(&isp_dev->pdev->dev,
> +                        "s_fmt, format not support\n");

No need for error messages for userspace errors.

> +
> +       return ret;

Instead of opencoding most of this function, one would normally call
mtk_cam_videoc_try_fmt() first to adjust the format struct and then
just update the driver state with the adjusted format.

Also, similarly to VIDIOC_TRY_FMT, VIDIOC_SET_FMT doesn't fail unless
in the very specific cases, as described in
https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
.

> +}
> +
> +static int mtk_cam_enum_framesizes(struct file *filp, void *priv,
> +                                  struct v4l2_frmsizeenum *sizes)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(filp);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       struct mtk_cam_dev_video_device *node =
> +               file_to_mtk_cam_node(filp);
> +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +
> +       if (sizes->index != 0)
> +               return -EINVAL;
> +
> +       if (queue_id == MTK_CAM_CTX_P1_MAIN_STREAM_OUT) {
> +               sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +               sizes->stepwise.max_width = CAM_B_MAX_WIDTH;
> +               sizes->stepwise.min_width = CAM_MIN_WIDTH;
> +               sizes->stepwise.max_height = CAM_B_MAX_HEIGHT;
> +               sizes->stepwise.min_height = CAM_MIN_HEIGHT;
> +               sizes->stepwise.step_height = 1;
> +               sizes->stepwise.step_width = 1;
> +       } else if (queue_id == MTK_CAM_CTX_P1_PACKED_BIN_OUT) {
> +               sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +               sizes->stepwise.max_width = RRZ_MAX_WIDTH;
> +               sizes->stepwise.min_width = RRZ_MIN_WIDTH;
> +               sizes->stepwise.max_height = RRZ_MAX_HEIGHT;
> +               sizes->stepwise.min_height = RRZ_MIN_HEIGHT;
> +               sizes->stepwise.step_height = 1;
> +               sizes->stepwise.step_width = 1;
> +       }
> +
> +       return 0;
> +}
> +
> +static int mtk_cam_meta_enum_format(struct file *file,
> +                                   void *fh, struct v4l2_fmtdesc *f)
> +{
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +
> +       if (f->index > 0 || f->type != node->vbq.type)
> +               return -EINVAL;

f->type is already checked by the V4L2 core. See v4l_enum_fmt().

> +
> +       f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
> +
> +       return 0;
> +}
> +
> +static int mtk_cam_videoc_s_meta_fmt(struct file *file,
> +                                    void *fh, struct v4l2_format *f)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> +

No need for this blank line.

> +       int ret = 0;

Please don't default-initialize without a good reason.

> +
> +       if (f->type != node->vbq.type)
> +               return -EINVAL;

Ditto.

> +
> +       ret = mtk_cam_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
> +

No need for this blank line.

> +       if (!ret) {
> +               node->vdev_fmt.fmt.meta = f->fmt.meta;
> +               dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
> +       } else {
> +               dev_warn(&isp_dev->pdev->dev,
> +                        "s_meta_fm failed, format not support\n");

No need for this warning.

> +       }
> +
> +       return ret;
> +}

Actually, why do we even need to do all the things? Do we support
multiple different meta formats on the same video node? If not, we can
just have all the TRY_FMT/S_FMT/G_FMT return the hardcoded format.

> +
> +static int mtk_cam_videoc_g_meta_fmt(struct file *file,
> +                                    void *fh, struct v4l2_format *f)
> +{
> +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> +
> +       if (f->type != node->vbq.type)
> +               return -EINVAL;

Not needed.

> +
> +       f->fmt = node->vdev_fmt.fmt;
> +
> +       return 0;
> +}
> +
> +int mtk_cam_videoc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct vb2_buffer *vb;
> +       struct mtk_cam_dev_buffer *db;
> +       int r = 0;
> +
> +       /* check if vb2 queue is busy */
> +       if (vdev->queue->owner &&
> +           vdev->queue->owner != file->private_data)
> +               return -EBUSY;

This should be already handled by the core.

> +
> +       /* Keep the value of sequence in v4l2_buffer */
> +       /* in ctx buf since vb2_qbuf will set it to 0 */
> +       vb = vdev->queue->bufs[p->index];

Why do you need a sequence number for buffers on queue time? The field
is not specified to be set by the userspace and should be ignored by
the driver. The driver should rely on the Request API to match any
buffers together anyway.

> +
> +       if (vb) {
> +               db = mtk_cam_vb2_buf_to_dev_buf(vb);
> +               pr_debug("qbuf: p:%llx,vb:%llx, db:%llx\n",
> +                        (unsigned long long)p,
> +                       (unsigned long long)vb,
> +                       (unsigned long long)db);
> +               db->ctx_buf.user_sequence = p->sequence;
> +       }
> +

Generally this driver shouldn't need to implement this callback
itself. Instead it can just use the vb2_ioctl_qbuf() helper.

> +       r = vb2_qbuf(vdev->queue, vdev->v4l2_dev->mdev, p);
> +
> +       if (r)
> +               pr_err("vb2_qbuf failed(err=%d): buf idx(%d)\n",
> +                      r, p->index);
> +
> +       return r;
> +}
> +EXPORT_SYMBOL_GPL(mtk_cam_videoc_qbuf);
> +
> +/******************** function pointers ********************/
> +
> +/* subdev internal operations */
> +static const struct v4l2_subdev_internal_ops mtk_cam_subdev_internal_ops = {
> +       .open = mtk_cam_subdev_open,
> +       .close = mtk_cam_subdev_close,
> +};
> +
> +static const struct v4l2_subdev_core_ops mtk_cam_subdev_core_ops = {
> +       .subscribe_event = mtk_cam_subdev_subscribe_event,
> +       .unsubscribe_event = mtk_cam_subdev_unsubscribe_event,
> +};
> +
> +static const struct v4l2_subdev_video_ops mtk_cam_subdev_video_ops = {
> +       .s_stream = mtk_cam_subdev_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops mtk_cam_subdev_ops = {
> +       .core = &mtk_cam_subdev_core_ops,
> +       .video = &mtk_cam_subdev_video_ops,
> +};
> +
> +static const struct media_entity_operations mtk_cam_media_ops = {
> +       .link_setup = mtk_cam_link_setup,
> +       .link_validate = v4l2_subdev_link_validate,
> +};
> +
> +#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
> +static void mtk_cam_vb2_buf_request_complete(struct vb2_buffer *vb)
> +{
> +       struct mtk_cam_mem2mem2_device *m2m2 = vb2_get_drv_priv(vb->vb2_queue);
> +
> +       v4l2_ctrl_request_complete(vb->req_obj.req,
> +                                  m2m2->v4l2_dev->ctrl_handler);
> +}
> +#endif
> +
> +static const struct vb2_ops mtk_cam_vb2_ops = {
> +       .buf_queue = mtk_cam_vb2_buf_queue,
> +       .queue_setup = mtk_cam_vb2_queue_setup,
> +       .start_streaming = mtk_cam_vb2_start_streaming,
> +       .stop_streaming = mtk_cam_vb2_stop_streaming,
> +       .wait_prepare = vb2_ops_wait_prepare,
> +       .wait_finish = vb2_ops_wait_finish,
> +#ifdef CONFIG_MEDIATEK_MEDIA_REQUEST
> +       .buf_request_complete = mtk_cam_vb2_buf_request_complete,
> +#endif
> +};
> +
> +static const struct v4l2_file_operations mtk_cam_v4l2_fops = {
> +       .unlocked_ioctl = video_ioctl2,
> +       .open = v4l2_fh_open,
> +       .release = vb2_fop_release,
> +       .poll = vb2_fop_poll,
> +       .mmap = vb2_fop_mmap,
> +#ifdef CONFIG_COMPAT
> +       .compat_ioctl32 = v4l2_compat_ioctl32,
> +#endif
> +};
> +
> +static const struct v4l2_ioctl_ops mtk_cam_v4l2_ioctl_ops = {
> +       .vidioc_querycap = mtk_cam_videoc_querycap,
> +       .vidioc_enum_framesizes = mtk_cam_enum_framesizes,
> +
> +       .vidioc_g_fmt_vid_cap_mplane = mtk_cam_videoc_g_fmt,
> +       .vidioc_s_fmt_vid_cap_mplane = mtk_cam_videoc_s_fmt,
> +       .vidioc_try_fmt_vid_cap_mplane = mtk_cam_videoc_try_fmt,
> +
> +       .vidioc_g_fmt_vid_out_mplane = mtk_cam_videoc_g_fmt,
> +       .vidioc_s_fmt_vid_out_mplane = mtk_cam_videoc_s_fmt,
> +       .vidioc_try_fmt_vid_out_mplane = mtk_cam_videoc_try_fmt,
> +
> +       /* buffer queue management */
> +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +       .vidioc_querybuf = vb2_ioctl_querybuf,
> +       .vidioc_qbuf = mtk_cam_videoc_qbuf,
> +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> +       .vidioc_streamon = vb2_ioctl_streamon,
> +       .vidioc_streamoff = vb2_ioctl_streamoff,
> +       .vidioc_expbuf = vb2_ioctl_expbuf,
> +};
> +
> +static const struct v4l2_ioctl_ops mtk_cam_v4l2_meta_ioctl_ops = {
> +       .vidioc_querycap = mtk_cam_videoc_querycap,
> +
> +       .vidioc_enum_fmt_meta_cap = mtk_cam_meta_enum_format,
> +       .vidioc_g_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
> +       .vidioc_s_fmt_meta_cap = mtk_cam_videoc_s_meta_fmt,
> +       .vidioc_try_fmt_meta_cap = mtk_cam_videoc_g_meta_fmt,
> +
> +       .vidioc_enum_fmt_meta_out = mtk_cam_meta_enum_format,
> +       .vidioc_g_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
> +       .vidioc_s_fmt_meta_out = mtk_cam_videoc_s_meta_fmt,
> +       .vidioc_try_fmt_meta_out = mtk_cam_videoc_g_meta_fmt,
> +
> +       .vidioc_reqbufs = vb2_ioctl_reqbufs,
> +       .vidioc_create_bufs = vb2_ioctl_create_bufs,
> +       .vidioc_prepare_buf = vb2_ioctl_prepare_buf,
> +       .vidioc_querybuf = vb2_ioctl_querybuf,
> +       .vidioc_qbuf = mtk_cam_videoc_qbuf,
> +       .vidioc_dqbuf = vb2_ioctl_dqbuf,
> +       .vidioc_streamon = vb2_ioctl_streamon,
> +       .vidioc_streamoff = vb2_ioctl_streamoff,
> +       .vidioc_expbuf = vb2_ioctl_expbuf,
> +};

The ops should be split for each node type, {VIDEO, META} x {OUTPUT,
CAPTURE}. Then the core would validate the type given to all the
ioctls automatically.

> +
> +static u32 mtk_cam_node_get_v4l2_cap(struct mtk_cam_ctx_queue *node_ctx)
> +{
> +       u32 cap = 0;
> +
> +       if (node_ctx->desc.capture)
> +               if (node_ctx->desc.image)
> +                       cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> +               else
> +                       cap = V4L2_CAP_META_CAPTURE;
> +       else
> +               if (node_ctx->desc.image)
> +                       cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> +               else
> +                       cap = V4L2_CAP_META_OUTPUT;
> +
> +       return cap;
> +}

Why not just have this defined statically as node_ctx->desc.cap?

> +
> +static u32 mtk_cam_node_get_format_type(struct mtk_cam_ctx_queue *node_ctx)
> +{
> +       u32 type;
> +
> +       if (node_ctx->desc.capture)
> +               if (node_ctx->desc.image)
> +                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +               else
> +                       type = V4L2_BUF_TYPE_META_CAPTURE;
> +       else
> +               if (node_ctx->desc.image)
> +                       type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +               else
> +                       type = V4L2_BUF_TYPE_META_OUTPUT;
> +
> +       return type;
> +}

Why not just have this defined statically as node_ctx->desc.buf_type?

> +
> +static const struct v4l2_ioctl_ops *mtk_cam_node_get_ioctl_ops
> +       (struct mtk_cam_ctx_queue *node_ctx)
> +{
> +       const struct v4l2_ioctl_ops *ops = NULL;
> +
> +       if (node_ctx->desc.image)
> +               ops = &mtk_cam_v4l2_ioctl_ops;
> +       else
> +               ops = &mtk_cam_v4l2_meta_ioctl_ops;
> +       return ops;
> +}

It's also preferable to just put this inside some structure rather
than have getter functions. (node_ctx->desc.ioctl_ops?)

> +
> +/* Config node's video properties */
> +/* according to the device context requirement */
> +static void mtk_cam_node_to_v4l2(struct mtk_cam_dev *isp_dev, u32 node,
> +                                struct video_device *vdev,
> +                                struct v4l2_format *f)
> +{
> +       u32 cap;
> +       struct mtk_cam_ctx *device_ctx = &isp_dev->ctx;
> +       struct mtk_cam_ctx_queue *node_ctx = &device_ctx->queue[node];
> +
> +       WARN_ON(node >= mtk_cam_dev_get_total_node(isp_dev));
> +       WARN_ON(!node_ctx);

How is this possible?

> +
> +       /* set cap of the node */
> +       cap = mtk_cam_node_get_v4l2_cap(node_ctx);
> +       f->type = mtk_cam_node_get_format_type(node_ctx);
> +       vdev->ioctl_ops = mtk_cam_node_get_ioctl_ops(node_ctx);
> +
> +       if (mtk_cam_ctx_format_load_default_fmt(&device_ctx->queue[node], f)) {
> +               dev_err(&isp_dev->pdev->dev,
> +                       "Can't load default for node (%d): (%s)",
> +               node, device_ctx->queue[node].desc.name);

mtk_cam_ctx_format_load_default_fmt() doesn't fail (and that's right).
It should be actually made void.

> +       }       else {
> +               if (device_ctx->queue[node].desc.image) {
> +                       dev_dbg(&isp_dev->pdev->dev,
> +                               "Node (%d): (%s), dfmt (f:0x%x w:%d: h:%d s:%d)\n",
> +                       node, device_ctx->queue[node].desc.name,
> +                       f->fmt.pix_mp.pixelformat,
> +                       f->fmt.pix_mp.width,
> +                       f->fmt.pix_mp.height,
> +                       f->fmt.pix_mp.plane_fmt[0].sizeimage
> +                       );
> +                       node_ctx->fmt.pix_mp = f->fmt.pix_mp;
> +               } else {
> +                       dev_dbg(&isp_dev->pdev->dev,
> +                               "Node (%d): (%s), dfmt (f:0x%x s:%u)\n",
> +                       node, device_ctx->queue[node].desc.name,
> +                       f->fmt.meta.dataformat,
> +                       f->fmt.meta.buffersize
> +                       );
> +                       node_ctx->fmt.meta = f->fmt.meta;
> +               }

Drop the debugging messages and just replace the whole if/else block with:

node_ctx->fmt = f->fmt;

Sorry, ran out of time for today. Fourth part will come. :)

Best regards,
Tomasz
