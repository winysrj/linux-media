Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:33970 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbeGYOr3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:47:29 -0400
Received: by mail-yw0-f195.google.com with SMTP id j68-v6so2859390ywg.1
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 06:35:46 -0700 (PDT)
Received: from mail-yb0-f180.google.com (mail-yb0-f180.google.com. [209.85.213.180])
        by smtp.gmail.com with ESMTPSA id o2-v6sm477664ywb.18.2018.07.25.06.35.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Jul 2018 06:35:46 -0700 (PDT)
Received: by mail-yb0-f180.google.com with SMTP id i9-v6so2985397ybo.5
        for <linux-media@vger.kernel.org>; Wed, 25 Jul 2018 06:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <1532525286.4879.5.camel@pengutronix.de>
In-Reply-To: <1532525286.4879.5.camel@pengutronix.de>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 25 Jul 2018 22:35:34 +0900
Message-ID: <CAAFQd5DJXucCFGUadNUiEboWLGrFF330KX9a4xJPONv6J4yidg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Document memory-to-memory video codec interfaces
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Jul 25, 2018 at 10:28 PM Philipp Zabel <p.zabel@pengutronix.de> wro=
te:
>
> Hi Tomasz,
>
> On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
> > This series attempts to add the documentation of what was discussed
> > during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
> > later Embedded Linux Conference Europe 2014 in D=C3=BCsseldorf and then
> > eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
> > video team (but mostly in a cosmetic way or making the document more
> > precise), during the several years of Chrome OS using the APIs in
> > production.
> >
> > Note that most, if not all, of the API is already implemented in
> > existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
> > this series is just to formalize what we already have.
> >
> > It is an initial conversion from Google Docs to RST, so formatting is
> > likely to need some further polishing. It is also the first time for me
> > to create such long RST documention. I could not find any other instanc=
e
> > of similar userspace sequence specifications among our Media documents,
> > so I mostly followed what was there in the source. Feel free to suggest
> > a better format.
> >
> > Much of credits should go to Pawel Osciak, for writing most of the
> > original text of the initial RFC.
> >
> > Changes since RFC:
> > (https://lore.kernel.org/patchwork/project/lkml/list/?series=3D348588)
> >  - The number of changes is too big to list them all here. Thanks to
> >    a huge number of very useful comments from everyone (Philipp, Hans,
> >    Nicolas, Dave, Stanimir, Alexandre) we should have the interfaces mu=
ch
> >    more specified now. The issues collected since previous revisions an=
d
> >    answers leading to this revision are listed below.
>
> Thanks a lot for the update, and especially for the nice Q&A summary of
> the discussions so far.
>
> [...]
> > Decoder issues
> >
> [...]
> >   How should ENUM_FRAMESIZES be affected by profiles and levels?
> >
> >   Answer: Not in current specification - the logic is too complicated a=
nd
> >   it might make more sense to actually handle this in user space.  (In
> >   theory, level implies supported frame sizes + other factors.)
>
> For decoding I think it makes more sense to let the hardware decode them
> from the stream and present them as read-only controls, such as:
>
> 42a68012e67c ("media: coda: add read-only h.264 decoder profile/level
> controls")

To clarify, this point is only about the effect on ENUM_FRAMESIZES.
Profile and level controls are mentioned in capabilities enumeration,
but it may make sense to add optional steps of querying them in
Initialization sequence.

>
> if possible. For encoding, the coda firmware determines level from
> bitrate and coded resolution, itself, so I agree not making this part of
> the spec is a good idea for now.

Encoder controls are driver-specific in general, since the encoding
capabilities vary a lot, so I decided to just briefly mention the
general idea of encoding parameters in "Encoding parameter changes"
section. It could be a good idea to add a reference to the MPEG
control documentation there, though.

Best regards,
Tomasz
