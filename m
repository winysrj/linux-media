Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42376 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbeJTSef (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 14:34:35 -0400
Received: by mail-yw1-f67.google.com with SMTP id a197-v6so14155395ywh.9
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 03:24:38 -0700 (PDT)
Received: from mail-yw1-f53.google.com (mail-yw1-f53.google.com. [209.85.161.53])
        by smtp.gmail.com with ESMTPSA id s200-v6sm6783782ywg.61.2018.10.20.03.24.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:24:35 -0700 (PDT)
Received: by mail-yw1-f53.google.com with SMTP id 130-v6so2808397ywl.4
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 03:24:34 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <9696282.0ldyWdpzWo@avalon> <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
In-Reply-To: <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 20 Oct 2018 19:24:20 +0900
Message-ID: <CAAFQd5D=Lj2XzUMK1LpOXbK3nTdNCFKRkfj3yfpV9mguDkcvdw@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 18, 2018 at 7:03 PM Tomasz Figa <tfiga@chromium.org> wrote:
>
> Hi Laurent,
>
> On Wed, Oct 17, 2018 at 10:34 PM Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Hi Tomasz,
> >
> > Thank you for the patch.
>
> Thanks for your comments! Please see my replies inline.
>
> >
> > On Tuesday, 24 July 2018 17:06:20 EEST Tomasz Figa wrote:
[snip]
> > > +4. At this point, decoding is paused and the driver will accept, but not
> > > +   process any newly queued ``OUTPUT`` buffers until the client issues
> > > +   ``V4L2_DEC_CMD_START`` or restarts streaming on any queue.
> > > +
> > > +* Once the drain sequence is initiated, the client needs to drive it to
> > > +  completion, as described by the above steps, unless it aborts the process
> > > +  by issuing :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue.  The client
> > > +  is not allowed to issue ``V4L2_DEC_CMD_START`` or ``V4L2_DEC_CMD_STOP``
> > > +  again while the drain sequence is in progress and they will fail with
> > > +  -EBUSY error code if attempted.
> >
> > While this seems OK to me, I think drivers will need help to implement all the
> > corner cases correctly without race conditions.
>
> We went through the possible list of corner cases and concluded that
> there is no use in handling them, especially considering how much they
> would complicate both the userspace and the drivers. Not even
> mentioning some hardware, like s5p-mfc, which actually has a dedicated
> flush operation, that needs to complete before the decoder can switch
> back to normal mode.

Actually I misread your comment.

Agreed that the decoder commands are a bit tricky to implement
properly. That's one of the reasons I decided to make the return
-EBUSY while an existing drain is in progress.

Do you have any particular simplification in mind that could avoid
some corner cases?

Best regards,
Tomasz
