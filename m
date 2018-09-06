Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:38543 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeIFL7w (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Sep 2018 07:59:52 -0400
Received: by mail-yb1-f196.google.com with SMTP id e18-v6so3747200ybq.5
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2018 00:25:48 -0700 (PDT)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id v18-v6sm1534515ywv.9.2018.09.06.00.25.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Sep 2018 00:25:46 -0700 (PDT)
Received: by mail-yw1-f50.google.com with SMTP id x83-v6so3700340ywd.4
        for <linux-media@vger.kernel.org>; Thu, 06 Sep 2018 00:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-5-paul.kocialkowski@bootlin.com> <5faf5eed-eb2c-f804-93e3-5a42f6204d99@xs4all.nl>
 <b7b3cb2320978d45acb34475d15abd7bf03da367.camel@paulk.fr> <461c6a0d-a346-b9da-b75e-4aab907054df@xs4all.nl>
In-Reply-To: <461c6a0d-a346-b9da-b75e-4aab907054df@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 6 Sep 2018 16:25:34 +0900
Message-ID: <CAAFQd5Cmc7uFhprsoTU6Gq19n3z2eiUfZZ2ZjDW4QWVWMDN6tg@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: contact@paulk.fr,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        thomas.petazzoni@bootlin.com, ayaka <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-sunxi@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 6, 2018 at 4:01 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/05/2018 06:29 PM, Paul Kocialkowski wrote:
> > Hi and thanks for the review!
> >
> > Le lundi 03 septembre 2018 =C3=A0 11:11 +0200, Hans Verkuil a =C3=A9cri=
t :
> >> On 08/28/2018 09:34 AM, Paul Kocialkowski wrote:
> >>> +static int cedrus_request_validate(struct media_request *req)
> >>> +{
> >>> +   struct media_request_object *obj, *obj_safe;
> >>> +   struct v4l2_ctrl_handler *parent_hdl, *hdl;
> >>> +   struct cedrus_ctx *ctx =3D NULL;
> >>> +   struct v4l2_ctrl *ctrl_test;
> >>> +   unsigned int i;
> >>> +
> >>> +   list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> >>
> >> You don't need to use the _safe variant during validation.
> >
> > Okay, I'll use the regular one then.
> >
> >>> +           struct vb2_buffer *vb;
> >>> +
> >>> +           if (vb2_request_object_is_buffer(obj)) {
> >>> +                   vb =3D container_of(obj, struct vb2_buffer, req_o=
bj);
> >>> +                   ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> >>> +
> >>> +                   break;
> >>> +           }
> >>> +   }
> >>
> >> Interesting question: what happens if more than one buffer is queued i=
n the
> >> request? This is allowed by the request API and in that case the assoc=
iated
> >> controls in the request apply to all queued buffers.
> >>
> >> Would this make sense at all for this driver? If not, then you need to
> >> check here if there is more than one buffer in the request and documen=
t in
> >> the spec that this is not allowed.
> >
> > Well, our driver was written with the (unformal) assumption that we
> > only deal with a pair of one output and one capture buffer. So I will
> > add a check for this at request validation time and document it in the
> > spec. Should that be part of the MPEG-2 PIXFMT documentation (and
> > duplicated for future formats we add support for)?
>
> Can you make a patch for vb2_request_has_buffers() in videobuf2-core.c
> renaming it to vb2_request_buffer_cnt() and returning the number of buffe=
rs
> in the request?
>
> Then you can call it here to check that you have only one buffer.
>
> And this has to be documented with the PIXFMT.
>
> Multiple buffers are certainly possible in non-codec scenarios (vim2m and
> vivid happily accept that), so this is an exception that should be
> documented and checked in the codec driver.

Hmm, isn't it still 1 buffer per 1 queue and just multiple queues
included in the request?

If we indeed allow multiple buffers for the same queue in a request,
we shouldn't restrict this on a per-driver basis. It's definitely not
a hardware limitation, since the driver could just do the same as if 2
requests with the same controls were given.

Best regards,
Tomasz
