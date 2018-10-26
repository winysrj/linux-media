Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:38248 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbeJZQAa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Oct 2018 12:00:30 -0400
Received: by mail-yw1-f66.google.com with SMTP id d126-v6so74371ywa.5
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 00:24:39 -0700 (PDT)
Received: from mail-yw1-f52.google.com (mail-yw1-f52.google.com. [209.85.161.52])
        by smtp.gmail.com with ESMTPSA id y126-v6sm2593950ywe.26.2018.10.26.00.24.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Oct 2018 00:24:36 -0700 (PDT)
Received: by mail-yw1-f52.google.com with SMTP id z206-v6so77027ywb.3
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2018 00:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20181018160841.17674-1-ezequiel@collabora.com>
 <20181018160841.17674-2-ezequiel@collabora.com> <a81e37eb-9d85-7a52-1098-d067c719f1e1@xs4all.nl>
 <457d3a25453d27135270ee4318a3afc1c5da51fb.camel@collabora.com>
In-Reply-To: <457d3a25453d27135270ee4318a3afc1c5da51fb.camel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 26 Oct 2018 16:24:24 +0900
Message-ID: <CAAFQd5ATt3xDR7=vfp2CCp5FJDBwDZvv5pgFYE_76mCjgMvajw@mail.gmail.com>
Subject: Re: [PATCH 1/2] vicodec: Have decoder propagate changes to the
 CAPTURE queue
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 19, 2018 at 10:00 PM Ezequiel Garcia <ezequiel@collabora.com> w=
rote:
>
> On Fri, 2018-10-19 at 09:14 +0200, Hans Verkuil wrote:
> > On 10/18/2018 06:08 PM, Ezequiel Garcia wrote:
> > > The decoder interface (not yet merged) specifies that
> > > width and height values set on the OUTPUT queue, must
> > > be propagated to the CAPTURE queue.
> > >
> > > This is not enough to comply with the specification,
> > > which would require to properly support stream resolution
> > > changes detection and notification.
> > >
> > > However, it's a relatively small change, which fixes behavior
> > > required by some applications such as gstreamer.
> > >
> > > With this change, it's possible to run a simple T(T=E2=81=BB=C2=B9) p=
ipeline:
> > >
> > > gst-launch-1.0 videotestsrc ! v4l2fwhtenc ! v4l2fwhtdec ! fakevideosi=
nk
> > >
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  drivers/media/platform/vicodec/vicodec-core.c | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > >
> > > diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/=
media/platform/vicodec/vicodec-core.c
> > > index 1eb9132bfc85..a2c487b4b80d 100644
> > > --- a/drivers/media/platform/vicodec/vicodec-core.c
> > > +++ b/drivers/media/platform/vicodec/vicodec-core.c
> > > @@ -673,6 +673,13 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx,=
 struct v4l2_format *f)
> > >             q_data->width =3D pix->width;
> > >             q_data->height =3D pix->height;
> > >             q_data->sizeimage =3D pix->sizeimage;
> > > +
> > > +           /* Propagate changes to CAPTURE queue */
> > > +           if (!ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type)) {
> >
> > Do we need !ctx->is_enc? Isn't this the same for both decoder and encod=
er?
> >
>
> Well, I wasn't really sure about this. The decoder document clearly
> says that changes has to be propagated to the capture queue, but that sta=
tement
> is not in the encoder spec.
>
> Since gstreamer didn't needs this, I decided not to add it.
>
> Perhaps it's something to correct in the encoder spec?

Hmm, in the v2 of the documentation I sent recently, the CAPTURE queue
of an encoder doesn't have width and height specified. For formats
that have the resolution embedded in bitstream metadata, this isn't
anything that the userspace should be concerned with. I forgot about
the formats that don't have the resolution in the metadata, so we
might need to bring them back. Then the propagation would have to be
there indeed.

> > > +                   ctx->q_data[V4L2_M2M_DST].width =3D pix->width;
> > > +                   ctx->q_data[V4L2_M2M_DST].height =3D pix->height;
> > > +                   ctx->q_data[V4L2_M2M_DST].sizeimage =3D pix->size=
image;
> >
> > This is wrong: you are copying the sizeimage for the compressed format =
as the
> > sizeimage for the raw format, which is quite different.
> >
>
> Doh, you are right.
>
> > I think you need to make a little helper function that can update the w=
idth/height
> > of a particular queue and that can calculate the sizeimage correctly.
> >

I wish we had generic helpers to manage all the formats in one place,
rather than duplicating the handling in each driver. I found many
cases of drivers not reporting bytesperline correctly or not handling
some formats (other than default and so often not tested) correctly.
If we could just have the driver call
v4l2_fill_pixfmt_mp_for_format(&pixfmt_mp, pixelformat, width, height,
...), a lot of boilerplate and potential source of errors could be
removed. (Bonus points for helpers that can convert pixfmt_mp for a
non-M format, e.g. NV12, into a pixfmt_mp for the corresponding M
format, e.g. NV12M, so that all the drivers that can support M formats
can also handle non-M formats automatically.)

One thing to note, though, is that there might be driver specific
alignment constraints in the play, so care must be taken.

Best regards,
Tomasz
