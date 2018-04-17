Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:38992 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751238AbeDQIo2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 04:44:28 -0400
Received: by mail-ua0-f195.google.com with SMTP id g10so11938970ual.6
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 01:44:27 -0700 (PDT)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com. [209.85.217.170])
        by smtp.gmail.com with ESMTPSA id c187sm6060774vkf.46.2018.04.17.01.44.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Apr 2018 01:44:25 -0700 (PDT)
Received: by mail-ua0-f170.google.com with SMTP id d3so11614962uae.4
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 01:44:25 -0700 (PDT)
MIME-Version: 1.0
References: <20180308094807.9443-1-jacob-chen@iotwrt.com> <20180308094807.9443-9-jacob-chen@iotwrt.com>
In-Reply-To: <20180308094807.9443-9-jacob-chen@iotwrt.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 17 Apr 2018 08:44:14 +0000
Message-ID: <CAAFQd5CF9-T24sw9fPw050G=fPha46DnCb8g6m7V2wtNVx_=1A@mail.gmail.com>
Subject: Re: [PATCH v6 08/17] media: rkisp1: add capture device driver
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy <jeffy.chen@rock-chips.com>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Chen Jacob <jacob2.chen@rock-chips.com>,
        =?UTF-8?B?6ZmI5Z+O?= <cc@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

On Thu, Mar 8, 2018 at 6:49 PM Jacob Chen <jacob-chen@iotwrt.com> wrote:

> From: Jacob Chen <jacob2.chen@rock-chips.com>

> This is the capture device interface driver that provides the v4l2
> user interface. Frames can be received from ISP1.

Thanks for the patch. Please find my comment inline.

[snip]
> +static int
> +rkisp1_start_streaming(struct vb2_queue *queue, unsigned int count)
> +{
> +       struct rkisp1_stream *stream = queue->drv_priv;
> +       struct rkisp1_vdev_node *node = &stream->vnode;
> +       struct rkisp1_device *dev = stream->ispdev;
> +       struct v4l2_device *v4l2_dev = &dev->v4l2_dev;
> +       int ret;
> +
> +       if (WARN_ON(stream->state != RKISP1_STATE_READY))
> +               goto return_queued_buf;

We jump out with ret unitialized here. For reference, it triggers a
compiler warning for me.

Note that rather than initializing ret at its definition, I'd recommend
adding an assignment before the goto statement. This will still let the
compiler issue warnings, without assuming that the default value is correct.

Best regards,
Tomasz
