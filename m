Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95E9C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 07:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6987220830
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 07:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zh2c//RH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbfCYHMR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 03:12:17 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46966 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbfCYHMR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 03:12:17 -0400
Received: by mail-ot1-f66.google.com with SMTP id c18so7038017otl.13
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 00:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IDvbNq+v166+7lTj+ev0mlGTruKVauY7qaTvlkrLUfc=;
        b=Zh2c//RHzqo5fYOIfVnSDgIxaJlVXLEgJm1VngSYmEEFRQwrSxDIo2Jwgabh5ez2/9
         N+B2i948ji/k1dqz/j3dXyN8mLDbNe0BWclNcHje9OUoOayKY68ZmMNC4jQZ5nADivyT
         nXtfGzfWWdGPil7snioVGfaJVjlyLGOC4Gw6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IDvbNq+v166+7lTj+ev0mlGTruKVauY7qaTvlkrLUfc=;
        b=sMqVtEDlkfv/iQM5cjjetEbtR6KPxLlLjGDYCDouowkwdiKIGILvFDjVKqaXvR5xSe
         D/zCzkUa8vva7bJmiO+Kgdo2RwWSFOtBn9dwzrXmbq4ExXUHUNDv8eWibwRW8BNV8u6D
         ULntvRWW+0RMdOjk11B5azw8Gq9K9tbmumnufrlvsXbTNMx5iB6cEXJkIxHijvz9sHml
         bMbvGuAOOBHfZ774T2MlL3+6ZvHnSD8CEE6ZjByfP8ppyTK61sGph1JX5CdyyUpmn4zo
         2xwDrvKNNt/054Bxs1vYOZJkrVOpYbJdQAHK18mRBQqqL0444fEp9qzlC+OTBGccN4qB
         AM+w==
X-Gm-Message-State: APjAAAUNwkg66gli1nxLSmAM2fRfNmlroeoGSswIrBkK2vGs9jkGlfe4
        9vn0RIV8QwYp50qTIEtwiaiHtj/tNOqOYQ==
X-Google-Smtp-Source: APXvYqyKPGV5PGNsuu6sj+OAJtGU3NIFmCAXNwBo729LrkLRxoj/OIJXURh0tL10R3d3d9BA5zB5Ww==
X-Received: by 2002:a9d:6187:: with SMTP id g7mr17320327otk.2.1553497935573;
        Mon, 25 Mar 2019 00:12:15 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id o18sm1663180otp.65.2019.03.25.00.12.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 00:12:14 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id w139so6118340oie.9
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 00:12:13 -0700 (PDT)
X-Received: by 2002:aca:4b03:: with SMTP id y3mr10732030oia.21.1553497933444;
 Mon, 25 Mar 2019 00:12:13 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com>
 <1552460044.13953.114.camel@mtksdccf07> <CAAFQd5CAY73b4jR=BFaJnhnHL-4QfEV7kQsiQusf=k-KghO0=g@mail.gmail.com>
 <1553221253.7066.32.camel@mtksdccf07>
In-Reply-To: <1553221253.7066.32.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 25 Mar 2019 16:12:02 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CU2nTrxaYKW-NOxvc75_D+j+EhLhS9JSnUbqk=1aAW9g@mail.gmail.com>
Message-ID: <CAAFQd5CU2nTrxaYKW-NOxvc75_D+j+EhLhS9JSnUbqk=1aAW9g@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
To:     Jungo Lin <jungo.lin@mediatek.com>
Cc:     Frederic Chen <frederic.chen@mediatek.com>,
        =?UTF-8?B?U2VhbiBDaGVuZyAo6YSt5piH5byYKQ==?= 
        <Sean.Cheng@mediatek.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        =?UTF-8?B?UnlubiBXdSAo5ZCz6IKy5oGpKQ==?= <Rynn.Wu@mediatek.com>,
        =?UTF-8?B?Q2hyaXN0aWUgWXUgKOa4uOmbheaDoCk=?= 
        <christie.yu@mediatek.com>, srv_heupstream@mediatek.com,
        =?UTF-8?B?SG9sbWVzIENoaW91ICjpgrHmjLop?= 
        <holmes.chiou@mediatek.com>,
        Jerry-ch Chen <Jerry-ch.Chen@mediatek.com>,
        Sj Huang <sj.huang@mediatek.com>, yuzhao@chromium.org,
        linux-mediatek@lists.infradead.org, zwisler@chromium.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 11:21 AM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Thu, 2019-03-21 at 12:59 +0900, Tomasz Figa wrote:
> > On Wed, Mar 13, 2019 at 3:54 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
> > >
> > > On Tue, 2019-03-12 at 19:04 +0900, Tomasz Figa wrote:
> > [snip]
> > > > Instead of opencoding most of this function, one would normally call
> > > > mtk_cam_videoc_try_fmt() first to adjust the format struct and then
> > > > just update the driver state with the adjusted format.
> > > >
> > > > Also, similarly to VIDIOC_TRY_FMT, VIDIOC_SET_FMT doesn't fail unless
> > > > in the very specific cases, as described in
> > > > https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
> > > > .
> > > >
> > >
> > > Ok, below is our revised version of this function.
> > >
> > > int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
> > >                          struct v4l2_format *f)
> > > {
> > >         struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > >         struct mtk_cam_dev *cam_dev = mtk_cam_m2m_to_dev(m2m2);
> > >         struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);
> > >
> > >         /* Get the valid format*/
> > >         mtk_cam_videoc_try_fmt(file, fh, f);
> > >         /* Configure to video device */
> > >         mtk_cam_ctx_fmt_set_img(&cam_dev->pdev->dev,
> > >                                 &node->vdev_fmt.fmt.pix_mp,
> > >                                 &f->fmt.pix_mp,
> > >                                 node->queue_id);
> > >
> > >         return 0;
> > > }
> > >
> >
> > Looks almost good. We still need to signal the -EBUSY error condition
> > if an attempt to change the format is made while streaming is active.
> >
> > [snip]
>
> Ok, we will add streaming status checking in this function.
>
> > > > > +static int mtk_cam_videoc_s_meta_fmt(struct file *file,
> > > > > +                                    void *fh, struct v4l2_format *f)
> > > > > +{
> > > > > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > > > > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > > > > +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> > > > > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > > > > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > > > > +
> > > >
> > > > No need for this blank line.
> > > >
> > >
> > > We will fix this coding style in next patch.
> > >
> > > > > +       int ret = 0;
> > > >
> > > > Please don't default-initialize without a good reason.
> > > >
> > >
> > > Ok, fix in next patch.
> > >
> > > > > +
> > > > > +       if (f->type != node->vbq.type)
> > > > > +               return -EINVAL;
> > > >
> > > > Ditto.
> > > >
> > >
> > > Ok, fix in next patch.
> > >
> > > > > +
> > > > > +       ret = mtk_cam_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
> > > > > +
> > > >
> > > > No need for this blank line.
> > > >
> > >
> > > Ok, fix in next patch.
> > >
> > > > > +       if (!ret) {
> > > > > +               node->vdev_fmt.fmt.meta = f->fmt.meta;
> > > > > +               dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
> > > > > +       } else {
> > > > > +               dev_warn(&isp_dev->pdev->dev,
> > > > > +                        "s_meta_fm failed, format not support\n");
> > > >
> > > > No need for this warning.
> > > >
> > >
> > > Ok, fix in next patch.
> > >
> > > > > +       }
> > > > > +
> > > > > +       return ret;
> > > > > +}
> > > >
> > > > Actually, why do we even need to do all the things? Do we support
> > > > multiple different meta formats on the same video node? If not, we can
> > > > just have all the TRY_FMT/S_FMT/G_FMT return the hardcoded format.
> > > >
> > >
> > > Ok, it is a good idea. We will return the hardcode format for meta video
> > > devices.
> > > Below is the revision version.
> > >
> > > int mtk_cam_meta_enum_format(struct file *file,
> > >                              void *fh, struct v4l2_fmtdesc *f)
> > > {
> > >         struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);
> > >
> > >         f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
> > >
> > >         return 0;
> > > }
> >
> > Need to error out if f->index > 0. Also need to initialize the other
> > output fields - flags and description.
> >
> > [snip]
>
> Ok, we will add format index & type checking in the beginning of this
> function. Moreover, we will initialize flags & description based on
> current meta format value.
>
> > > > > +static u32 mtk_cam_node_get_v4l2_cap(struct mtk_cam_ctx_queue *node_ctx)
> > > > > +{
> > > > > +       u32 cap = 0;
> > > > > +
> > > > > +       if (node_ctx->desc.capture)
> > > > > +               if (node_ctx->desc.image)
> > > > > +                       cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> > > > > +               else
> > > > > +                       cap = V4L2_CAP_META_CAPTURE;
> > > > > +       else
> > > > > +               if (node_ctx->desc.image)
> > > > > +                       cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> > > > > +               else
> > > > > +                       cap = V4L2_CAP_META_OUTPUT;
> > > > > +
> > > > > +       return cap;
> > > > > +}
> > > >
> > > > Why not just have this defined statically as node_ctx->desc.cap?
> > > >
> > >
> > > Ok, it is refactoring done.
> > >
> > > > > +
> > > > > +static u32 mtk_cam_node_get_format_type(struct mtk_cam_ctx_queue *node_ctx)
> > > > > +{
> > > > > +       u32 type;
> > > > > +
> > > > > +       if (node_ctx->desc.capture)
> > > > > +               if (node_ctx->desc.image)
> > > > > +                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > > > > +               else
> > > > > +                       type = V4L2_BUF_TYPE_META_CAPTURE;
> > > > > +       else
> > > > > +               if (node_ctx->desc.image)
> > > > > +                       type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > > > > +               else
> > > > > +                       type = V4L2_BUF_TYPE_META_OUTPUT;
> > > > > +
> > > > > +       return type;
> > > > > +}
> > > >
> > > > Why not just have this defined statically as node_ctx->desc.buf_type?
> > > >
> > >
> > > Same as above.
> > >
> > > > > +
> > > > > +static const struct v4l2_ioctl_ops *mtk_cam_node_get_ioctl_ops
> > > > > +       (struct mtk_cam_ctx_queue *node_ctx)
> > > > > +{
> > > > > +       const struct v4l2_ioctl_ops *ops = NULL;
> > > > > +
> > > > > +       if (node_ctx->desc.image)
> > > > > +               ops = &mtk_cam_v4l2_ioctl_ops;
> > > > > +       else
> > > > > +               ops = &mtk_cam_v4l2_meta_ioctl_ops;
> > > > > +       return ops;
> > > > > +}
> > > >
> > > > It's also preferable to just put this inside some structure rather
> > > > than have getter functions. (node_ctx->desc.ioctl_ops?)
> > > >
> > >
> > > Same as above.
> > > Below is the new version for struct mtk_cam_ctx_queue_desc
> > >
> > > /*
> > >  * struct mtk_cam_ctx_queue_desc - queue attributes
> > >  *                              setup by device context owner
> > >  * @id:         id of the context queue
> > >  * @name:               media entity name
> > >  * @cap:                mapped to V4L2 capabilities
> > >  * @buf_type:   mapped to V4L2 buffer type
> > >  * @capture:    true for capture queue (device to user)
> > >  *                              false for output queue (from user to device)
> > >  * @image:              true for image, false for meta data
> > >  * @smem_alloc: Using the cam_smem_drv as alloc ctx or not
> > >  * @dma_port:   the dma port associated to the buffer
> > >  * @fmts:       supported format
> > >  * @num_fmts:   the number of supported formats
> > >  * @default_fmt_idx: default format of this queue
> > >  * @max_buf_count: maximum V4L2 buffer count
> > >  * @max_buf_count: mapped to v4l2_ioctl_ops
> > >  */
> > > struct mtk_cam_ctx_queue_desc {
> > >         u8 id;
> > >         char *name;
> > >         u32 cap;
> > >         u32 buf_type;
> > >         u32 dma_port;
> > >         u32 smem_alloc:1;
> > >         u8 capture:1;
> > >         u8 image:1;
> > >         u8 num_fmts;
> > >         u8 default_fmt_idx;
> > >         u8 max_buf_count;
> > >         const struct v4l2_ioctl_ops *ioctl_ops;
> > >         struct v4l2_format *fmts;
> > > };
> >
> > SGTM +/- the missing kerneldoc for the new fields.
> >
> > [snip]
>
> Ok, we will fix the missing part.
>
> > > > Sorry, ran out of time for today. Fourth part will come. :)
> > > >
> > > > Best regards,
> > > > Tomasz
> > > >
> > >
> > > Appreciate your support and hard working on this review.
> > > We will look forward your part 4 review.
> >
> > Thanks for replying to all the comments, it's very helpful.
> >
> > As I mentioned in another reply, I'm going to be busy for the next few
> > days, so I'd suggest addressing the existing comments, fixing any
> > v4l2-compliance issues and also checking if any changes could be
> > applied to the other drivers (DIP, FD, Seninf, MDP) too and then
> > sending RFC V1.
> >
> > Best regards,
> > Tomasz
>
> Ok, we will deliver the RFC V1 next week.
> Btw, for v4l2-compliance testing, we have some questions about this.
> We list these two issues below.
> If you have time, please kindly provide your comments.
> Or we could discuss these two issues in RFC V1.
>
>
> 1. Kernel minor issue for 32 bit test program.
> => fail: v4l2-test-media.cpp(368): check_0(links.reserved,
> sizeof(links.reserved))
> This issue is similar to below patch.
> https://patchwork.kernel.org/patch/8578421/
> The reserved fields of media_links_enum is missing copy from kernel
> space to user space in media_device_enum_links32 function.
> So it makes the above failed.
> Do we provide our patch to fix it?

Yes, it would be nice if you could send a patch fixing it.

>
> 2. Some v4l2-compliance testing results are failed in the sensor
> drivers's sub devices nodes. which are implemented in ov5695 & ov2685
> driver. Do you suggest us to fix them?

Let's look at this off the list and figure out. Please send me an
email with the results.

Other than that, just to make sure we're all on the same page, please
try to fix any remaining v4l2-compliance issues of Mediatek drivers
for RFC V1.

Best regards,
Tomasz
