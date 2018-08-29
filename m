Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f181.google.com ([209.85.213.181]:41701 "EHLO
        mail-yb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbeH2I1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 04:27:06 -0400
Received: by mail-yb0-f181.google.com with SMTP id q18-v6so64980ybg.8
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:32:08 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id k2-v6sm1158275ywa.93.2018.08.28.21.32.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Aug 2018 21:32:06 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id n207-v6so1505865ywn.9
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl> <f4d1e18a6552446b092cffaa3028e0dfe5432b9a.camel@ndufresne.ca>
 <26ae963d-3326-2506-b116-0a5f64b34c3d@xs4all.nl>
In-Reply-To: <26ae963d-3326-2506-b116-0a5f64b34c3d@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 29 Aug 2018 13:31:54 +0900
Message-ID: <CAAFQd5Bm55KL2arNGoPevKZV7Fc99GH4FU+ZDRgcOqD9jUoRaw@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: nicolas@ndufresne.ca,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 24, 2018 at 4:30 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 08/23/2018 07:37 PM, Nicolas Dufresne wrote:
> > Le jeudi 23 ao=C3=BBt 2018 =C3=A0 16:31 +0200, Hans Verkuil a =C3=A9cri=
t :
> >>> I propose adding these capabilities:
> >>>
> >>> #define V4L2_BUF_CAP_HAS_REQUESTS     0x00000001
> >>> #define V4L2_BUF_CAP_REQUIRES_REQUESTS        0x00000002
> >>> #define V4L2_BUF_CAP_HAS_MMAP         0x00000100
> >>> #define V4L2_BUF_CAP_HAS_USERPTR      0x00000200
> >>> #define V4L2_BUF_CAP_HAS_DMABUF               0x00000400
> >>
> >> I substituted SUPPORTS for HAS and dropped the REQUIRES_REQUESTS capab=
ility.
> >> As Tomasz mentioned, technically (at least for stateless codecs) you c=
ould
> >> handle just one frame at a time without using requests. It's very inef=
ficient,
> >> but it would work.
> >
> > I thought the request was providing a data structure to refer back to
> > the frames, so each codec don't have to implement one. Do you mean that
> > the framework will implicitly request requests in that mode ? or simply
> > that there is no such helper ?
>
> Yes, that's done through controls as well.
>
> The idea would be that you set the necessary controls, queue a buffer to
> the output queue, dequeue a buffer from the output queue, read back any
> new state information and repeat the process.
>
> That said, I'm not sure if the cedrus driver for example can handle this
> at the moment. It is also inefficient and it won't work if codecs require
> more than one buffer in the queue for whatever reason.
>
> Tomasz, Paul, please correct me if I am wrong.
>
> In any case, I think we can do without this proposed capability since it =
is
> simply a requirement when implementing the pixelformat for the stateless
> codec that the Request API will be available and it should be documented
> as such in the spec.

No correction needed. :)

Best regards,
Tomasz
