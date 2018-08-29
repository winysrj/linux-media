Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:39605 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH2IUk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 04:20:40 -0400
Received: by mail-yb0-f195.google.com with SMTP id c4-v6so1519082ybl.6
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:25:43 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id t2-v6sm4069800ywd.99.2018.08.28.21.25.41
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Aug 2018 21:25:41 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id y134-v6so1515962ywg.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:25:41 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
 <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl> <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
 <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl> <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
 <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
 <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
 <8a4dba99d73e46eb6885b852110d9eac2b041db7.camel@collabora.com> <0f947768d8e982fcc591112c43cf40d618df2233.camel@bootlin.com>
In-Reply-To: <0f947768d8e982fcc591112c43cf40d618df2233.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 29 Aug 2018 13:25:28 +0900
Message-ID: <CAAFQd5AU0dEJSdj741qDR4pQf6d56t8R=tCYScrvG0+AcLK67g@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2018 at 5:05 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Wed, 2018-08-22 at 14:33 -0300, Ezequiel Garcia wrote:
> > On Wed, 2018-08-22 at 16:10 +0200, Paul Kocialkowski wrote:
> > > Hi,
> > >
> > > On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> > > > Hi Hans, Paul,
> > > >
> > > > On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> > > > <paul.kocialkowski@bootlin.com> wrote:
> > > > >
> > > > > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > > > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > > > > Hi,
> > > > > > >
> > > > > > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > > > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > > > > > Regarding point 3: I think this should be documented ne=
xt to the pixel format. I.e.
> > > > > > > > > > the MPEG-2 Slice format used by the stateless cedrus co=
dec requires the request API
> > > > > > > > > > and that two MPEG-2 controls (slice params and quantiza=
tion matrices) must be present
> > > > > > > > > > in each request.
> > > > > > > > > >
> > > > > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUI=
RED_IN_REQ) is needed here.
> > > > > > > > > > It's really implied by the fact that you use a stateles=
s codec. It doesn't help
> > > > > > > > > > generic applications like v4l2-ctl or qv4l2 either sinc=
e in order to support
> > > > > > > > > > stateless codecs they will have to know about the detai=
ls of these controls anyway.
> > > > > > > > > >
> > > > > > > > > > So I am inclined to say that it is not necessary to exp=
ose this information in
> > > > > > > > > > the API, but it has to be documented together with the =
pixel format documentation.
> > > > > > > > >
> > > > > > > > > I think this is affected by considerations about codec pr=
ofile/level
> > > > > > > > > support. More specifically, some controls will only be re=
quired for
> > > > > > > > > supporting advanced codec profiles/levels, so they can on=
ly be
> > > > > > > > > explicitly marked with appropriate flags by the driver wh=
en the target
> > > > > > > > > profile/level is known. And I don't think it would be san=
e for userspace
> > > > > > > > > to explicitly set what profile/level it's aiming at. As a=
 result, I
> > > > > > > > > don't think we can explicitly mark controls as required o=
r optional.
> > > >
> > > > I'm not sure this is entirely true. The hardware may need to be
> > > > explicitly told what profile the video is. It may even not be the
> > > > hardware, but the driver itself too, given that the profile may imp=
ly
> > > > the CAPTURE pixel format, e.g. for VP9 profiles:
> > > >
> > > > profile 0
> > > > color depth: 8 bit/sample, chroma subsampling: 4:2:0
> > > > profile 1
> > > > color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > > > profile 2
> > > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
> > > > profile 3
> > > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4=
:4:4
> > > >
> > > > (reference: https://en.wikipedia.org/wiki/VP9#Profiles)
> > >
> > > I think it would be fair to expect userspace to select the right
> > > destination format (and maybe have the driver error if there's a
> > > mismatch with the meta-data) instead of having the driver somewhat
> > > expose what format should be used.
> > >
> > > But maybe this would be an API violation, since all the enumerated
> > > formats are probably supposed to be selectable?
> > >
> > > We could also look at it the other way round and consider that select=
ing
> > > an exposed format is always legit, but that it implies passing a
> > > bitstream that matches it or the driver will error (because of an
> > > invalid bitstream passed, not because of a "wrong" selected format).
> > >
> >
> > The API requires the user to negotiate via TRY_FMT/S_FMT. The driver
> > usually does not return error on invalid formats, and simply return
> > a format it can work with. I think the kernel-user contract has to
> > guarantee if the driver accepted a given format, it won't fail to
> > encoder or decode.
>
> Well, the issue here is that in order to correctly enumerate the
> formats, the driver needs to be aware of:
> 1. in what destination format the bitstream data is decoded to;
> 2. what format convesions the VPU can do.
>
> Step 1 is known by userspace but is only passed to the driver with the
> bitstream metadata from controls. This is much too late for trimming the
> list of supported formats.

That's not true. See my previous reply. The user space only knows the
physical representation of samples in the stream, i.e. YUV 4:2:0 or
4:2:2. It doesn't know anything about hardware constraints on the
memory representation.

>
> I'm not sure that passing an extra information to the driver early to
> trim the list would make sense, because it comes to down to telling the
> driver what format to target and then asking the driver was format it
> supports, which is rather redundant.
>
> I think the information we need to expose to userspace is whether the
> driver supports a destination format that does not match the bitstream
> format. We could make it part of the spec that, by lack of this
> indication, the provided bitstream is expected to match the format that
> was selected.
>
> > I think that's why it makes sense for stateless drivers to set the
> > profile/levels for a given job, in order to properly negotiate
> > the input and output formats (for both encoders and decoders).
>
> I still fail to follow this logic. As far as I understood, profile/level
> are indications of hardware capabilities required to decode the video,
> not an indication of the precise features selected for decoding,
> especially when it comes the format. As Tomasz mentionned in the
> previous email, various formats may be supported by the same profile, so
> setting the profile/level does not indicate which format is appropriate
> for decoding the bitstream.

Indeed, after thinking a bit more about this, profile/levels alone are
not a good indicator for this. I'm afraid we may need an
initialization sequence that involves user space providing to the
driver any necessary state needed for it to determine the exact set of
supported memory representations (pixel formats).

Best regards,
Tomasz
