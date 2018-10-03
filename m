Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37629 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbeJCPMN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2018 11:12:13 -0400
Received: by mail-yb1-f196.google.com with SMTP id h1-v6so2015107ybm.4
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 01:24:52 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id k2-v6sm333495ywh.52.2018.10.03.01.24.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 01:24:50 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id l79-v6so1936119ywc.7
        for <linux-media@vger.kernel.org>; Wed, 03 Oct 2018 01:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl> <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
In-Reply-To: <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 3 Oct 2018 17:24:39 +0900
Message-ID: <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
To: nicolas@ndufresne.ca
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 3:14 AM Nicolas Dufresne <nicolas@ndufresne.ca> wro=
te:
>
> Le jeudi 20 septembre 2018 =C3=A0 16:42 +0200, Hans Verkuil a =C3=A9crit =
:
> > Some parts of the V4L2 API are awkward to use and I think it would be
> > a good idea to look at possible candidates for that.
> >
> > Examples are the ioctls that use struct v4l2_buffer: the multiplanar su=
pport is
> > really horrible, and writing code to support both single and multiplana=
r is hard.
> > We are also running out of fields and the timeval isn't y2038 compliant=
.
> >
> > A proof-of-concept is here:
> >
> > https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=3Dv4l2-buffer=
&id=3Da95549df06d9900f3559afdbb9da06bd4b22d1f3
> >
> > It's a bit old, but it gives a good impression of what I have in mind.
> >
> > Another candidate is VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAM=
EINTERVALS:
> > expressing frame intervals as a fraction is really awkward and so is th=
e fact
> > that the subdev and 'normal' ioctls are not the same.
> >
> > Would using nanoseconds or something along those lines for intervals be=
 better?
>
> This one is not a good idea, because you cannot represent well known
> rates used a lot in the field. Like 60000/1001 also known as 59.94 Hz.
> You could endup with drift issues.
>
> For me, what is the most difficult with this API is the fact that it
> uses frame internal (duration) instead of frame rate.
>
> >
> > I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there =
is no
> > stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But i=
t should
> > be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with stepwise suppo=
rt, I
> > think.
>
> One of the thing to fix, maybe it's doable now, is the differentiation
> between allocation size and display size. Pretty much all video capture
> code assumes this is display size and ignores the selection API. This
> should be documented explicitly.

Technically, there is already a distinction between allocation and
display size at format level - width and height could be interpreted
as the rectangle containing the captured video, while bytesperline and
sizeimage would match to the allocation size. The behavior between
drivers seems to be extremely variable - some would just enforce
bytesperline =3D bpp*width and sizeimage =3D bytesperline*height, while
others would actually give control over them to the user space.

It's a bit more complicated with video decoders, because the stream,
in addition to the 2 sizes mentioned before, is also characterized by
coded size, which corresponds to the actual number of pixels encoded
in the stream, even if not all contain pixels to be displayed. This is
something that needs to be specified explicitly (and is, in my
documentation patches) in the Codec Interface.

>
> In fact, the display/allocation dimension isn't very nice, as both
> information overlaps in structures. As an example, you call S_FMT with
> a display size you want, and it will return you an allocation size
> (which yes, can be smaller, because we always round to the middle).
>
> >
> > Do we have more ioctls that could use a refresh? S/G/TRY_FMT perhaps, a=
gain in
> > order to improve single vs multiplanar handling.
>
> Yes, but that would fall in a complete redesign I guess. The buffer
> allocation scheme is very inflexible. You can't have buffers of two
> dimensions allocated at the same time for the same queue. Worst, you
> cannot leave even 1 buffer as your scannout buffer while reallocating
> new buffers, this is not permitted by the framework (in software). As a
> side effect, there is no way to optimize the resolution changes, you
> even have to copy your scannout buffer on the CPU, to free it in order
> to proceed. Resolution changes are thus painfully slow, by design.

Hmm? There is VIDIOC_CREATEBUFS, which can allows you to allocate
buffers for explicitly specified format, with other buffers already
existing in the queue.

Also, I fail to understand the scanout issue. If one exports a vb2
buffer to a DMA-buf and import it to the scanout engine, it can keep
scanning out from it as long as it want, because the DMA-buf will hold
a reference on the buffer, even if it's removed from the vb2 queue.

>
> You also cannot switch from internal buffers to importing buffers
> easily (in some case you, like encoder, you cannot do that without
> flushing the encoder state).

Hmm, technically VIDIOC_CREATEBUFS accepts the "memory" type value,
but I'm not sure what happens if the queue already has buffers
requested with different one.

Best regards,
Tomasz
