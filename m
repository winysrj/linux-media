Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46414 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbeJVNHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 09:07:39 -0400
Received: by mail-yw1-f66.google.com with SMTP id j202-v6so15482548ywa.13
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 21:50:46 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id m125-v6sm8078872ywd.23.2018.10.21.21.50.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 21:50:44 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id z206-v6so4246835ywb.3
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 21:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-3-tfiga@chromium.org>
 <4168da98-fa01-ea2f-8162-385501e666be@xs4all.nl> <CAAFQd5BqtKFeJniNaqahi9h_zKR+rPrWUiyx004Z=MWDj7q++w@mail.gmail.com>
 <CAAFQd5Djur9y+=UHTx9ZSx310p2ShCsBTqsEA1UHCMoawuDscA@mail.gmail.com> <7b8b56e7-1617-5de6-9fa9-a10897a8f2f1@xs4all.nl>
In-Reply-To: <7b8b56e7-1617-5de6-9fa9-a10897a8f2f1@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 22 Oct 2018 13:50:32 +0900
Message-ID: <CAAFQd5BRxmMpH9J0tZLD7=9Be+dUggym9-5ctV4536YbHedESQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] media: docs-rst: Document memory-to-memory video
 encoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 16, 2018 at 10:50 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 10/16/18 09:36, Tomasz Figa wrote:
> > On Tue, Aug 7, 2018 at 3:54 PM Tomasz Figa <tfiga@chromium.org> wrote:
> >>>> +   * The driver must expose following selection targets on ``OUTPUT``:
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_CROP_BOUNDS``
> >>>> +         maximum crop bounds within the source buffer supported by the
> >>>> +         encoder
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_CROP_DEFAULT``
> >>>> +         suggested cropping rectangle that covers the whole source picture
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_CROP``
> >>>> +         rectangle within the source buffer to be encoded into the
> >>>> +         ``CAPTURE`` stream; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> >>>> +         maximum rectangle within the coded resolution, which the cropped
> >>>> +         source frame can be output into; always equal to (0, 0)x(width of
> >>>> +         ``V4L2_SEL_TGT_CROP``, height of ``V4L2_SEL_TGT_CROP``), if the
> >>>> +         hardware does not support compose/scaling
>
> Re-reading this I would rewrite this a bit:
>
> if the hardware does not support composition or scaling, then this is always
> equal to (0, 0)x(width of ``V4L2_SEL_TGT_CROP``, height of ``V4L2_SEL_TGT_CROP``).
>

Ack.

> >>>> +
> >>>> +     ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> >>>> +         equal to ``V4L2_SEL_TGT_CROP``
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_COMPOSE``
> >>>> +         rectangle within the coded frame, which the cropped source frame
> >>>> +         is to be output into; defaults to
> >>>> +         ``V4L2_SEL_TGT_COMPOSE_DEFAULT``; read-only on hardware without
> >>>> +         additional compose/scaling capabilities; resulting stream will
> >>>> +         have this rectangle encoded as the visible rectangle in its
> >>>> +         metadata
> >>>> +
> >>>> +     ``V4L2_SEL_TGT_COMPOSE_PADDED``
> >>>> +         always equal to coded resolution of the stream, as selected by the
> >>>> +         encoder based on source resolution and crop/compose rectangles
> >>>
> >>> Are there codec drivers that support composition? I can't remember seeing any.
> >>>
> >>
> >> Hmm, I was convinced that MFC could scale and we just lacked support
> >> in the driver, but I checked the documentation and it doesn't seem to
> >> be able to do so. I guess we could drop the COMPOSE rectangles for
> >> now, until we find any hardware that can do scaling or composing on
> >> the fly.
> >>
> >
> > On the other hand, having them defined already wouldn't complicate
> > existing drivers too much either, because they would just handle all
> > of them in the same switch case, i.e.
> >
> > case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> > case V4L2_SEL_TGT_COMPOSE_DEFAULT:
> > case V4L2_SEL_TGT_COMPOSE:
> > case V4L2_SEL_TGT_COMPOSE_PADDED:
> >      return visible_rectangle;
> >
> > That would need one change, though. We would define
> > V4L2_SEL_TGT_COMPOSE_DEFAULT to be equal to (0, 0)x(width of
> > V4L2_SEL_TGT_CROP - 1, height of ``V4L2_SEL_TGT_CROP - 1), which
>
> " - 1"? Where does that come from?
>
> Usually rectangles are specified as widthxheight@left,top.
>

Yeah, the notation I used was quite unfortunate. How about just making
it fully verbose?

         if the hardware does not support
         composition or scaling, then this is always equal to the rectangle of
         width and height matching ``V4L2_SEL_TGT_CROP`` and located at (0, 0)

> > makes more sense than current definition, since it would bypass any
> > compose/scaling by default.
>
> I have no problem with drivers optionally implementing these rectangles,
> even if they don't do scaling or composition. The question is, should it
> be required for decoders? If there is a good reason, then I'm OK with it.

There is no particular reason to do it for existing drivers. I'm
personally not a big fan of making things optional, since you never
know when something becomes required and then you run into problems
with user space compatibility. In this case the cost of having those
rectangles defined is really low and they will be useful to handle
encoders and decoders with scaling/compose ability in the future.

I have no strong opinion though.

Best regards,
Tomasz
