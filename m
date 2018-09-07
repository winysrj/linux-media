Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43192 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727847AbeIGMo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2018 08:44:59 -0400
Received: by mail-yw1-f68.google.com with SMTP id l189-v6so5088206ywb.10
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:05:14 -0700 (PDT)
Received: from mail-yw1-f47.google.com (mail-yw1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id n2-v6sm2834747ywd.64.2018.09.07.01.05.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Sep 2018 01:05:13 -0700 (PDT)
Received: by mail-yw1-f47.google.com with SMTP id n21-v6so5096565ywh.5
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2018 01:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <20180828073424.30247-1-paul.kocialkowski@bootlin.com>
 <20180828073424.30247-5-paul.kocialkowski@bootlin.com> <5faf5eed-eb2c-f804-93e3-5a42f6204d99@xs4all.nl>
 <b7b3cb2320978d45acb34475d15abd7bf03da367.camel@paulk.fr> <461c6a0d-a346-b9da-b75e-4aab907054df@xs4all.nl>
 <CAAFQd5Cmc7uFhprsoTU6Gq19n3z2eiUfZZ2ZjDW4QWVWMDN6tg@mail.gmail.com> <7a2167a3-5b61-0937-7f06-8b36fa12e7a0@xs4all.nl>
In-Reply-To: <7a2167a3-5b61-0937-7f06-8b36fa12e7a0@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 7 Sep 2018 17:05:01 +0900
Message-ID: <CAAFQd5A1NFBE8x8h-CYrusmqR5sJzhQdgyrhU5oVbPR22vu6wg@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] media: platform: Add Cedrus VPU decoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: contact@paulk.fr,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <joro@8bytes.org>,
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

On Thu, Sep 6, 2018 at 4:39 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 09/06/2018 09:25 AM, Tomasz Figa wrote:
> > On Thu, Sep 6, 2018 at 4:01 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> On 09/05/2018 06:29 PM, Paul Kocialkowski wrote:
> >>> Hi and thanks for the review!
> >>>
> >>> Le lundi 03 septembre 2018 =C3=A0 11:11 +0200, Hans Verkuil a =C3=A9c=
rit :
> >>>> On 08/28/2018 09:34 AM, Paul Kocialkowski wrote:
> >>>>> +static int cedrus_request_validate(struct media_request *req)
> >>>>> +{
> >>>>> +   struct media_request_object *obj, *obj_safe;
> >>>>> +   struct v4l2_ctrl_handler *parent_hdl, *hdl;
> >>>>> +   struct cedrus_ctx *ctx =3D NULL;
> >>>>> +   struct v4l2_ctrl *ctrl_test;
> >>>>> +   unsigned int i;
> >>>>> +
> >>>>> +   list_for_each_entry_safe(obj, obj_safe, &req->objects, list) {
> >>>>
> >>>> You don't need to use the _safe variant during validation.
> >>>
> >>> Okay, I'll use the regular one then.
> >>>
> >>>>> +           struct vb2_buffer *vb;
> >>>>> +
> >>>>> +           if (vb2_request_object_is_buffer(obj)) {
> >>>>> +                   vb =3D container_of(obj, struct vb2_buffer, req=
_obj);
> >>>>> +                   ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> >>>>> +
> >>>>> +                   break;
> >>>>> +           }
> >>>>> +   }
> >>>>
> >>>> Interesting question: what happens if more than one buffer is queued=
 in the
> >>>> request? This is allowed by the request API and in that case the ass=
ociated
> >>>> controls in the request apply to all queued buffers.
> >>>>
> >>>> Would this make sense at all for this driver? If not, then you need =
to
> >>>> check here if there is more than one buffer in the request and docum=
ent in
> >>>> the spec that this is not allowed.
> >>>
> >>> Well, our driver was written with the (unformal) assumption that we
> >>> only deal with a pair of one output and one capture buffer. So I will
> >>> add a check for this at request validation time and document it in th=
e
> >>> spec. Should that be part of the MPEG-2 PIXFMT documentation (and
> >>> duplicated for future formats we add support for)?
> >>
> >> Can you make a patch for vb2_request_has_buffers() in videobuf2-core.c
> >> renaming it to vb2_request_buffer_cnt() and returning the number of bu=
ffers
> >> in the request?
> >>
> >> Then you can call it here to check that you have only one buffer.
> >>
> >> And this has to be documented with the PIXFMT.
> >>
> >> Multiple buffers are certainly possible in non-codec scenarios (vim2m =
and
> >> vivid happily accept that), so this is an exception that should be
> >> documented and checked in the codec driver.
> >
> > Hmm, isn't it still 1 buffer per 1 queue and just multiple queues
> > included in the request?
>
> No. The request API allows multiple buffers for the same vb2_queue to be
> queued for the same request (obviously when the request is committed, the
> buffers are queued to the driver in the same order).
>
> >
> > If we indeed allow multiple buffers for the same queue in a request,
> > we shouldn't restrict this on a per-driver basis. It's definitely not
> > a hardware limitation, since the driver could just do the same as if 2
> > requests with the same controls were given.
>
> That's how it operates: for all buffers in the request the same controls
> apply. But does this make sense for codecs? If the control(s) with the
> codec metadata always change for every buffer, then having more than one
> buffer in the request is senseless and the driver should check for this
> in the validation step.
>
> If it *does* make sense in some circumstances to have the same metadata
> for multiple buffers, then it should be checked if the cedrus driver
> handles this correctly.

Just FYI, we may want to move this discussion to Alex's RFC with
documentation of stateless interface:
https://patchwork.kernel.org/patch/10583233/

Best regards,
Tomasz
