Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A584EC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 04:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56834218A5
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 04:07:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WlVj06WL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfCUEHK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 00:07:10 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34964 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfCUEHK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 00:07:10 -0400
Received: by mail-ot1-f67.google.com with SMTP id h7so4305031otm.2
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 21:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kB7bECJuohRjhZCdmLp9SMfR5l8Aw2pJfOx9kmofFPw=;
        b=WlVj06WLMsppNRSoOjg3qZTXg0sJX/EwpaXZ6fHRjp06ks6wHZ2RwhnCnWDUBCizPW
         HclVyM92KReeY/Dl1vubN6w1LGUOi6JlcF2MDpzJkbPS4hN97nJ1bIZCD9QrSNBUuaC9
         Ap89ZKUoP9v/craH3BCzOT9JWsYiy5cB/ENzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kB7bECJuohRjhZCdmLp9SMfR5l8Aw2pJfOx9kmofFPw=;
        b=uHknrK077YlnP1tDDJkWe7GqfbJY+NNRjkLPwPUw9DK0lmB6D7Z7BVPSxdoZ3C9rsv
         b91mu7RF0MfCdNjVLC512CeHrdthZNbLmVWsZ1ZuQfNBRuARivrqlsLfBGBBI+E5vCk+
         xnNXdNj0ZigStWcTIe6YnrPB548jZB4HsdbPGo2JQtJKJe8XJp8dbKsvoYLHCmNTx4EQ
         E4gQUmIr6EyaIAdN17lV3VfWia/5dSDI33/v+jPXogLiTTY9/pI4ATAGzI5d7MLlthlr
         7KMfQbDJXANIOcMmYeKhxdo+BxkfTZx6O+uVS725j3NmwxEAeuoFfTpzXCvTyoaql6TA
         ErdQ==
X-Gm-Message-State: APjAAAUh0giEen2xUG7EjOhXQE9ckvHLXqid5TStsnbzDxdREKcLL51z
        R3+d1mQC0huwwAyv5ykVQmXpWxcXTAA=
X-Google-Smtp-Source: APXvYqwPBYOBoIPLmIXfmo8X6nrk9OkGQCvhOG9NycZcYKXMg761SVRrhqvfDMEQ8L80FCLm7En8SQ==
X-Received: by 2002:a9d:6505:: with SMTP id i5mr1140390otl.263.1553141228768;
        Wed, 20 Mar 2019 21:07:08 -0700 (PDT)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id h26sm1535010otm.48.2019.03.20.21.07.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 21:07:08 -0700 (PDT)
Received: by mail-oi1-f177.google.com with SMTP id w137so3679876oiw.5
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 21:07:08 -0700 (PDT)
X-Received: by 2002:aca:4b03:: with SMTP id y3mr884884oia.21.1553140792562;
 Wed, 20 Mar 2019 20:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5CUi9MqZ+j+DhRZtgByvfVH-FBFJHiaxb_JOqsLGNoK2Q@mail.gmail.com> <1552460044.13953.114.camel@mtksdccf07>
In-Reply-To: <1552460044.13953.114.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 21 Mar 2019 12:59:41 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CAY73b4jR=BFaJnhnHL-4QfEV7kQsiQusf=k-KghO0=g@mail.gmail.com>
Message-ID: <CAAFQd5CAY73b4jR=BFaJnhnHL-4QfEV7kQsiQusf=k-KghO0=g@mail.gmail.com>
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

On Wed, Mar 13, 2019 at 3:54 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Tue, 2019-03-12 at 19:04 +0900, Tomasz Figa wrote:
[snip]
> > Instead of opencoding most of this function, one would normally call
> > mtk_cam_videoc_try_fmt() first to adjust the format struct and then
> > just update the driver state with the adjusted format.
> >
> > Also, similarly to VIDIOC_TRY_FMT, VIDIOC_SET_FMT doesn't fail unless
> > in the very specific cases, as described in
> > https://www.kernel.org/doc/html/latest/media/uapi/v4l/vidioc-g-fmt.html#return-value
> > .
> >
>
> Ok, below is our revised version of this function.
>
> int mtk_cam_videoc_s_fmt(struct file *file, void *fh,
>                          struct v4l2_format *f)
> {
>         struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
>         struct mtk_cam_dev *cam_dev = mtk_cam_m2m_to_dev(m2m2);
>         struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);
>
>         /* Get the valid format*/
>         mtk_cam_videoc_try_fmt(file, fh, f);
>         /* Configure to video device */
>         mtk_cam_ctx_fmt_set_img(&cam_dev->pdev->dev,
>                                 &node->vdev_fmt.fmt.pix_mp,
>                                 &f->fmt.pix_mp,
>                                 node->queue_id);
>
>         return 0;
> }
>

Looks almost good. We still need to signal the -EBUSY error condition
if an attempt to change the format is made while streaming is active.

[snip]
> > > +static int mtk_cam_videoc_s_meta_fmt(struct file *file,
> > > +                                    void *fh, struct v4l2_format *f)
> > > +{
> > > +       struct mtk_cam_mem2mem2_device *m2m2 = video_drvdata(file);
> > > +       struct mtk_cam_dev *isp_dev = mtk_cam_m2m_to_dev(m2m2);
> > > +       struct mtk_cam_ctx *dev_ctx = &isp_dev->ctx;
> > > +       struct mtk_cam_dev_video_device *node = file_to_mtk_cam_node(file);
> > > +       int queue_id = mtk_cam_dev_get_queue_id_of_dev_node(isp_dev, node);
> > > +
> >
> > No need for this blank line.
> >
>
> We will fix this coding style in next patch.
>
> > > +       int ret = 0;
> >
> > Please don't default-initialize without a good reason.
> >
>
> Ok, fix in next patch.
>
> > > +
> > > +       if (f->type != node->vbq.type)
> > > +               return -EINVAL;
> >
> > Ditto.
> >
>
> Ok, fix in next patch.
>
> > > +
> > > +       ret = mtk_cam_ctx_format_load_default_fmt(&dev_ctx->queue[queue_id], f);
> > > +
> >
> > No need for this blank line.
> >
>
> Ok, fix in next patch.
>
> > > +       if (!ret) {
> > > +               node->vdev_fmt.fmt.meta = f->fmt.meta;
> > > +               dev_ctx->queue[queue_id].fmt.meta = node->vdev_fmt.fmt.meta;
> > > +       } else {
> > > +               dev_warn(&isp_dev->pdev->dev,
> > > +                        "s_meta_fm failed, format not support\n");
> >
> > No need for this warning.
> >
>
> Ok, fix in next patch.
>
> > > +       }
> > > +
> > > +       return ret;
> > > +}
> >
> > Actually, why do we even need to do all the things? Do we support
> > multiple different meta formats on the same video node? If not, we can
> > just have all the TRY_FMT/S_FMT/G_FMT return the hardcoded format.
> >
>
> Ok, it is a good idea. We will return the hardcode format for meta video
> devices.
> Below is the revision version.
>
> int mtk_cam_meta_enum_format(struct file *file,
>                              void *fh, struct v4l2_fmtdesc *f)
> {
>         struct mtk_cam_video_device *node = file_to_mtk_cam_node(file);
>
>         f->pixelformat = node->vdev_fmt.fmt.meta.dataformat;
>
>         return 0;
> }

Need to error out if f->index > 0. Also need to initialize the other
output fields - flags and description.

[snip]
> > > +static u32 mtk_cam_node_get_v4l2_cap(struct mtk_cam_ctx_queue *node_ctx)
> > > +{
> > > +       u32 cap = 0;
> > > +
> > > +       if (node_ctx->desc.capture)
> > > +               if (node_ctx->desc.image)
> > > +                       cap = V4L2_CAP_VIDEO_CAPTURE_MPLANE;
> > > +               else
> > > +                       cap = V4L2_CAP_META_CAPTURE;
> > > +       else
> > > +               if (node_ctx->desc.image)
> > > +                       cap = V4L2_CAP_VIDEO_OUTPUT_MPLANE;
> > > +               else
> > > +                       cap = V4L2_CAP_META_OUTPUT;
> > > +
> > > +       return cap;
> > > +}
> >
> > Why not just have this defined statically as node_ctx->desc.cap?
> >
>
> Ok, it is refactoring done.
>
> > > +
> > > +static u32 mtk_cam_node_get_format_type(struct mtk_cam_ctx_queue *node_ctx)
> > > +{
> > > +       u32 type;
> > > +
> > > +       if (node_ctx->desc.capture)
> > > +               if (node_ctx->desc.image)
> > > +                       type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> > > +               else
> > > +                       type = V4L2_BUF_TYPE_META_CAPTURE;
> > > +       else
> > > +               if (node_ctx->desc.image)
> > > +                       type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> > > +               else
> > > +                       type = V4L2_BUF_TYPE_META_OUTPUT;
> > > +
> > > +       return type;
> > > +}
> >
> > Why not just have this defined statically as node_ctx->desc.buf_type?
> >
>
> Same as above.
>
> > > +
> > > +static const struct v4l2_ioctl_ops *mtk_cam_node_get_ioctl_ops
> > > +       (struct mtk_cam_ctx_queue *node_ctx)
> > > +{
> > > +       const struct v4l2_ioctl_ops *ops = NULL;
> > > +
> > > +       if (node_ctx->desc.image)
> > > +               ops = &mtk_cam_v4l2_ioctl_ops;
> > > +       else
> > > +               ops = &mtk_cam_v4l2_meta_ioctl_ops;
> > > +       return ops;
> > > +}
> >
> > It's also preferable to just put this inside some structure rather
> > than have getter functions. (node_ctx->desc.ioctl_ops?)
> >
>
> Same as above.
> Below is the new version for struct mtk_cam_ctx_queue_desc
>
> /*
>  * struct mtk_cam_ctx_queue_desc - queue attributes
>  *                              setup by device context owner
>  * @id:         id of the context queue
>  * @name:               media entity name
>  * @cap:                mapped to V4L2 capabilities
>  * @buf_type:   mapped to V4L2 buffer type
>  * @capture:    true for capture queue (device to user)
>  *                              false for output queue (from user to device)
>  * @image:              true for image, false for meta data
>  * @smem_alloc: Using the cam_smem_drv as alloc ctx or not
>  * @dma_port:   the dma port associated to the buffer
>  * @fmts:       supported format
>  * @num_fmts:   the number of supported formats
>  * @default_fmt_idx: default format of this queue
>  * @max_buf_count: maximum V4L2 buffer count
>  * @max_buf_count: mapped to v4l2_ioctl_ops
>  */
> struct mtk_cam_ctx_queue_desc {
>         u8 id;
>         char *name;
>         u32 cap;
>         u32 buf_type;
>         u32 dma_port;
>         u32 smem_alloc:1;
>         u8 capture:1;
>         u8 image:1;
>         u8 num_fmts;
>         u8 default_fmt_idx;
>         u8 max_buf_count;
>         const struct v4l2_ioctl_ops *ioctl_ops;
>         struct v4l2_format *fmts;
> };

SGTM +/- the missing kerneldoc for the new fields.

[snip]
> > Sorry, ran out of time for today. Fourth part will come. :)
> >
> > Best regards,
> > Tomasz
> >
>
> Appreciate your support and hard working on this review.
> We will look forward your part 4 review.

Thanks for replying to all the comments, it's very helpful.

As I mentioned in another reply, I'm going to be busy for the next few
days, so I'd suggest addressing the existing comments, fixing any
v4l2-compliance issues and also checking if any changes could be
applied to the other drivers (DIP, FD, Seninf, MDP) too and then
sending RFC V1.

Best regards,
Tomasz
