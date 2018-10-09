Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38365 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbeJINOD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 09:14:03 -0400
Received: by mail-yw1-f68.google.com with SMTP id d126-v6so165232ywa.5
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 22:58:47 -0700 (PDT)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id i62-v6sm10058400ywb.32.2018.10.08.22.58.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Oct 2018 22:58:45 -0700 (PDT)
Received: by mail-yb1-f169.google.com with SMTP id g15-v6so161972ybf.6
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 22:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20181004081119.102575-1-acourbot@chromium.org> <7bd6883f43f3ffa1803975236eb18b5e63d3455a.camel@paulk.fr>
In-Reply-To: <7bd6883f43f3ffa1803975236eb18b5e63d3455a.camel@paulk.fr>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 Oct 2018 14:58:33 +0900
Message-ID: <CAAFQd5DvkvjMrdSVd-Ba5RiGUjM6Jp8hruk23A87sd4htoFovw@mail.gmail.com>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
To: contact@paulk.fr
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paul,

On Thu, Oct 4, 2018 at 9:40 PM Paul Kocialkowski <contact@paulk.fr> wrote:
>
> Hi Alexandre,
>
> Thanks for submitting this second version of the RFC, it is very
> appreciated! I will try to provide useful feedback here and hopefully
> be more reactive than during v1 review!
>
> Most of it looks good to me, but there is a specific point I'd like to
> keep discussing.
>
> Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9cr=
it :
> > This patch documents the protocol that user-space should follow when
> > communicating with stateless video decoders. It is based on the
> > following references:
> >
> > * The current protocol used by Chromium (converted from config store to
> >   request API)
> >
> > * The submitted Cedrus VPU driver
> >
> > As such, some things may not be entirely consistent with the current
> > state of drivers, so it would be great if all stakeholders could point
> > out these inconsistencies. :)
> >
> > This patch is supposed to be applied on top of the Request API V18 as
> > well as the memory-to-memory video decoder interface series by Tomasz
> > Figa.
> >
> > Changes since V1:
> >
> > * Applied fixes received as feedback,
> > * Moved controls descriptions to the extended controls file,
> > * Document reference frame management and referencing (need Hans' feedb=
ack on
> >   that).
> >
> > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 348 ++++++++++++++++++
> >  Documentation/media/uapi/v4l/devices.rst      |   1 +
> >  .../media/uapi/v4l/extended-controls.rst      |  25 ++
> >  .../media/uapi/v4l/pixfmt-compressed.rst      |  54 ++-
> >  4 files changed, 424 insertions(+), 4 deletions(-)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.=
rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/D=
ocumentation/media/uapi/v4l/dev-stateless-decoder.rst
> > new file mode 100644
> > index 000000000000..e54246df18d0
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > @@ -0,0 +1,348 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _stateless_decoder:
> > +
> > +**************************************************
> > +Memory-to-memory Stateless Video Decoder Interface
> > +**************************************************
> > +
> > +A stateless decoder is a decoder that works without retaining any kind=
 of state
> > +between processing frames. This means that each frame is decoded indep=
endently
> > +of any previous and future frames, and that the client is responsible =
for
> > +maintaining the decoding state and providing it to the driver. This is=
 in
> > +contrast to the stateful video decoder interface, where the hardware m=
aintains
> > +the decoding state and all the client has to do is to provide the raw =
encoded
> > +stream.
> > +
> > +This section describes how user-space ("the client") is expected to co=
mmunicate
> > +with such decoders in order to successfully decode an encoded stream. =
Compared
> > +to stateful codecs, the driver/client sequence is simpler, but the cos=
t of this
> > +simplicity is extra complexity in the client which must maintain a con=
sistent
> > +decoding state.
> > +
> > +Querying capabilities
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. To enumerate the set of coded formats supported by the driver, the =
client
> > +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> > +
> > +   * The driver must always return the full set of supported ``OUTPUT`=
` formats,
> > +     irrespective of the format currently set on the ``CAPTURE`` queue=
.
> > +
> > +2. To enumerate the set of supported raw formats, the client calls
> > +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> > +
> > +   * The driver must return only the formats supported for the format =
currently
> > +     active on the ``OUTPUT`` queue.
> > +
> > +   * Depending on the currently set ``OUTPUT`` format, the set of supp=
orted raw
> > +     formats may depend on the value of some controls (e.g. H264 or VP=
9
> > +     profile). The client is responsible for making sure that these co=
ntrols
> > +     are set to the desired value before querying the ``CAPTURE`` queu=
e.
>
> I still think we have a problem when enumerating CAPTURE formats, that
> providing the profile/level information does not help solving.
>
> From previous emails on v1 (to which I failed to react to), it seems
> that the consensus was to set the profile/level indication beforehand
> to reduce the subset of possible formats and return that as enumerated
> possible formats.

I think the consensus was to set all the the parsed header controls
and actually Alex seems to have mentioned it slightly further in his
patch:

+   * In order to enumerate raw formats supported by a given coded format, =
the
+     client must thus set that coded format on the ``OUTPUT`` queue first,=
 then
+     set any control listed on the format's description, and finally enume=
rate
+     the ``CAPTURE`` queue.

>
> However, it does not really solve the issue here, given the following
> distinct cases:
>
> 1. The VPU can only output the format for the decoded frame and that
> format is not known until the first buffer metadata is passed.

That's why I later suggested metadata (parsed header controls) and not
just some selective controls, such as profiles.

> Everything that is reported as supported at this point should be
> understood as supported formats for the decoded bitstreams, but
> userspace would have to pick the one matching the decoded format of the
> bitstream to decode. I don't really see the point of trying to reduce
> that list by providing the profile/level.
>
> 2. The VPU has some format conversion block in its pipeline and can
> actually provide a range of different formats for CAPTURE buffers,
> independently from the format of the decoded bitstream.
>
> Either way, I think (correct me if I'm wrong) that players do know the
> format from the decoded bitstream here, so enumeration only makes sense
> for case 2.

Players don't know the format for the decoded bitstream, as I already
explained before. From stream metadata they would only know whether
the stream is YUV 4:2:0 vs 4:2:2, but wouldn't know the exact hardware
constraints, e.g. whether NV12 or YUV420 is supported for given YUV
4:2:0 stream.

>
> Something we could do is to not enumerate any format for case 1., which
> we would specify as an indication that only the decoded bitstream
> format must be set. Then in case 2., we would enumerate the possible
> formats.
>
> For case 1., having the driver expose the supported profiles ensures
> that any format in a supported profile is valid although not
> enumerated.

Profile doesn't fully determine a specific pixel format, only the
abstract format (see above).

>
> Alternatively, we could go with a control that indicates whether the
> driver supports a format decorrelated from the decoded bitstream format
> and still enumerate all formats in case 1., with the implication that
> only the right one must be picked by userspace. Here again, I don't see
> the point of reducing the list by setting the profile/level.
>
> So my goal here is to clearly enable userspace to distinguish between
> the two situations.
>
> What do you think?

Why would we need to create a control, if we already have the ENUM_FMT
API existing exactly to achieve this? We already have this problem
solved for stateful decoders and if we request the userspace to
actually set all the necessary metadata beforehand, the resulting
behavior (initialization sequence) would be much more consistent
between these 2 APIs.

Best regards,
Tomasz
