Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44855 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbeJTXuu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 19:50:50 -0400
Received: by mail-yb1-f194.google.com with SMTP id x5-v6so14453252ybl.11
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 08:39:58 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id x130-v6sm6755804ywb.27.2018.10.20.08.39.54
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 08:39:55 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id v92-v6so1710975ybi.5
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 08:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <9696282.0ldyWdpzWo@avalon> <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
In-Reply-To: <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sun, 21 Oct 2018 00:39:42 +0900
Message-ID: <CAAFQd5CdjZKEeZmowMKVLVKhiWPxEK2f7H+xNhhXAPn7O-S33g@mail.gmail.com>
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
> > > The driver must also set
> > > +     ``V4L2_BUF_FLAG_LAST`` in :c:type:`v4l2_buffer` ``flags`` field on the
> > > +     buffer on the ``CAPTURE`` queue containing the last frame (if any)
> > > +     produced as a result of processing the ``OUTPUT`` buffers queued
> > > +     before ``V4L2_DEC_CMD_STOP``. If no more frames are left to be
> > > +     returned at the point of handling ``V4L2_DEC_CMD_STOP``, the driver
> > > +     must return an empty buffer (with :c:type:`v4l2_buffer`
> > > +     ``bytesused`` = 0) as the last buffer with ``V4L2_BUF_FLAG_LAST`` set
> > > +     instead. Any attempts to dequeue more buffers beyond the buffer marked
> > > +     with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > > +     :c:func:`VIDIOC_DQBUF`.
> > > +
> > > +   * If the ``CAPTURE`` queue is NOT streaming, no action is necessary for
> > > +     ``CAPTURE`` queue and the driver must send a ``V4L2_EVENT_EOS``
> > > +     immediately after all ``OUTPUT`` buffers in question have been
> > > +     processed.
> >
> > What is the use case for this ? Can't we just return an error if decoder isn't
> > streaming ?
> >
>
> Actually this is wrong. We want the queued OUTPUT buffers to be
> processed and decoded, so if the CAPTURE queue is not yet set up
> (initialization sequence not completed yet), handling the
> initialization sequence first will be needed as a part of the drain
> sequence. I've updated the document with that.

I might want to take this back. The client could just drive the
initialization to completion on its own and start the drain sequence
after that. Let me think if it makes anything easier. For reference, I
don't see any compatibility constraint here, since the existing user
space already works like that.

Best regards,
Tomasz
