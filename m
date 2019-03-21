Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463A2C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F753218B0
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 03:54:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DjcOo8cM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfCUDyu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 23:54:50 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42590 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbfCUDyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 23:54:50 -0400
Received: by mail-oi1-f194.google.com with SMTP id w139so3651129oie.9
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FM7HxXDxarqniVmvj6OwLkwKYk9E/QUQmCKO+zkKi4w=;
        b=DjcOo8cM6TmRqKfNiY5oJWRj9dUDXvohq3z8QY7BIVWVIcYkF17hSD65dDOGq2eIVa
         fwjNK4+BwsLQ6zr4cq0RhugqrZbncwuTp3SqdpTDmm0sqJyzM2m1T5NsdFEnLaPCGE5y
         BpTNpajjXqECXholDAwKF2HnWjeUCB7pRCe1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FM7HxXDxarqniVmvj6OwLkwKYk9E/QUQmCKO+zkKi4w=;
        b=FfOCsLAXjYM0sw7UP+vtMF7VKqdurRF72J7MYXIF5tH8n+qb0E6QPulwwAMw+6Djyd
         XCUEHNLSTcPGuJ8ynk/O7NUc7lUZnIsBzNw+WaSdQmg3sbmORI9w4f3t4Doy4xMRDog4
         oGL/xuAtMzcZ1eAXGGQOOJYMWkBJwdLReq27dlMM58Brgnl4Wu9xXkCyJ1UJPGEJUgMQ
         ZIBOUDzAruUtAJaGIXPBFsN5pb8UEAIw1DElL/Da4eUKLQD5USJB6nxd2KhCeKlXMfF7
         lCrivlpWSVPLpZnemCAvEpn9p37/H+bDYyAX4vZSjHmvQkGmdOfJhGWbvpzRiEF2G5JY
         CCXQ==
X-Gm-Message-State: APjAAAWI2ppX/UlR4B6nfZJEg4T6x6axPKcNvrQgBsElzLdp5j4qlXiJ
        3SPeuWPl9Ob9+E5/FOwoqjsbPOelec4=
X-Google-Smtp-Source: APXvYqx6A5af0RZMm0Zx/n+4Zb2/ueGE7gDkoxchZnJrC/BaHjp0kY2qypfaEJ4SprApdK2eaM2OIw==
X-Received: by 2002:aca:4908:: with SMTP id w8mr873787oia.157.1553140488698;
        Wed, 20 Mar 2019 20:54:48 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id i17sm511372otr.36.2019.03.20.20.54.48
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Mar 2019 20:54:48 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id i21so3635614oib.11
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 20:54:48 -0700 (PDT)
X-Received: by 2002:aca:edc7:: with SMTP id l190mr924564oih.92.1553140125912;
 Wed, 20 Mar 2019 20:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
 <1549348966-14451-8-git-send-email-frederic.chen@mediatek.com>
 <CAAFQd5BGFmTbRF+LdRvXs0MBZifRd9zB_+OT6Xwo=dzwqajgGA@mail.gmail.com> <1552378607.13953.71.camel@mtksdccf07>
In-Reply-To: <1552378607.13953.71.camel@mtksdccf07>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 21 Mar 2019 12:48:34 +0900
X-Gmail-Original-Message-ID: <CAAFQd5C=dmoUU9=FdkaeErSFVpA--uFZJ0P1jrb3DTXFZ_tdpg@mail.gmail.com>
Message-ID: <CAAFQd5C=dmoUU9=FdkaeErSFVpA--uFZJ0P1jrb3DTXFZ_tdpg@mail.gmail.com>
Subject: Re: [RFC PATCH V0 7/7] [media] platform: mtk-isp: Add Mediatek ISP
 Pass 1 driver
To:     Jungo Lin <jungo.lin@mediatek.com>
Cc:     Frederic Chen <frederic.chen@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
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

On Tue, Mar 12, 2019 at 5:16 PM Jungo Lin <jungo.lin@mediatek.com> wrote:
>
> On Thu, 2019-03-07 at 19:04 +0900, Tomasz Figa wrote:
[snip]
> > > +struct mtk_cam_mem2mem2_device {
> > > +       const char *name;
> > > +       const char *model;
> >
> > For both of the fields above, they seem to be always
> > MTK_CAM_DEV_P1_NAME, so we can just use the macro directly whenever
> > needed. No need for this indirection.
> >
>
> OK. These two fields will be removed in next patch.
>
> > > +       struct device *dev;
> > > +       int num_nodes;
> > > +       struct mtk_cam_dev_video_device *nodes;
> > > +       const struct vb2_mem_ops *vb2_mem_ops;
> >
> > This is always "vb2_dma_contig_memops", so it can be used directly.
> >
>
> Ditto.
>
> > > +       unsigned int buf_struct_size;
> >
> > This is always sizeof(struct mtk_cam_dev_buffer), so no need to save
> > it in the struct.
> >
>
> Ditto.
>
> > > +       int streaming;
> > > +       struct v4l2_device *v4l2_dev;
> > > +       struct media_device *media_dev;
> >
> > These 2 fields are already in mtk_cam_dev which is a superclass of
> > this struct. One can just access them from there directly.
> >
>
> Ditto.
>
> > > +       struct media_pipeline pipeline;
> > > +       struct v4l2_subdev subdev;
> >
> > Could you remind me what was the media topology exposed by this
> > driver? This is already the second subdev I spotted in this patch,
> > which looks strange.
> >
>
>
> For sub-device design, we will remove the sub-device for CIO and keep
> only one sub-device for ISP driver in next patch. We will also provide
> the media topology in RFC v1 patch to clarify.
>
> > > +       struct media_pad *subdev_pads;
> > > +       struct v4l2_file_operations v4l2_file_ops;
> > > +       const struct file_operations fops;
> > > +};
> >
> > Given most of the comments above, it looks like the remaining useful
> > fields in this struct could be just moved to mtk_cam_dev, without the
> > need for this separate struct.
> >
>
> This is the final revision for these two structures.
> Do you suggest to merge it to simplify?
>
> struct mtk_cam_mem2mem2_device {
>         struct mtk_cam_video_device *nodes;
>         struct media_pipeline pipeline;
>         struct v4l2_subdev subdev;
>         struct media_pad *subdev_pads;
> };
>
> struct mtk_cam_dev {
>         struct platform_device *pdev;
>         struct mtk_cam_video_device     mem2mem2_nodes[MTK_CAM_DEV_NODE_MAX];
>         struct mtk_cam_mem2mem2_device mem2mem2;
>         struct mtk_cam_io_connection cio;
>         struct v4l2_device v4l2_dev;
>         struct media_device media_dev;
>         struct mtk_cam_ctx ctx;
>         struct v4l2_async_notifier notifier;
> };
>

I feel like there is not much benefit in having this split. Similarly,
I'm not sure if there is a reason to have separate structs for
mtk_cam_io_connection and mtk_cam_ctx.

(Sorry, missed this one in previous reply.)

Best regards,
Tomasz
