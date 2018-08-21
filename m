Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:34785 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbeHUMMW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Aug 2018 08:12:22 -0400
Received: by mail-yb0-f195.google.com with SMTP id t10-v6so2122294ybb.1
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 01:53:05 -0700 (PDT)
Received: from mail-yw1-f51.google.com (mail-yw1-f51.google.com. [209.85.161.51])
        by smtp.gmail.com with ESMTPSA id z125-v6sm12552321ywg.57.2018.08.21.01.53.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Aug 2018 01:53:03 -0700 (PDT)
Received: by mail-yw1-f51.google.com with SMTP id r184-v6so7859890ywg.6
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2018 01:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
 <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl> <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
 <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl> <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
In-Reply-To: <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 21 Aug 2018 17:52:51 +0900
Message-ID: <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Paul,

On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > Hi,
> > >
> > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > Regarding point 3: I think this should be documented next to th=
e pixel format. I.e.
> > > > > > the MPEG-2 Slice format used by the stateless cedrus codec requ=
ires the request API
> > > > > > and that two MPEG-2 controls (slice params and quantization mat=
rices) must be present
> > > > > > in each request.
> > > > > >
> > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_IN_R=
EQ) is needed here.
> > > > > > It's really implied by the fact that you use a stateless codec.=
 It doesn't help
> > > > > > generic applications like v4l2-ctl or qv4l2 either since in ord=
er to support
> > > > > > stateless codecs they will have to know about the details of th=
ese controls anyway.
> > > > > >
> > > > > > So I am inclined to say that it is not necessary to expose this=
 information in
> > > > > > the API, but it has to be documented together with the pixel fo=
rmat documentation.
> > > > >
> > > > > I think this is affected by considerations about codec profile/le=
vel
> > > > > support. More specifically, some controls will only be required f=
or
> > > > > supporting advanced codec profiles/levels, so they can only be
> > > > > explicitly marked with appropriate flags by the driver when the t=
arget
> > > > > profile/level is known. And I don't think it would be sane for us=
erspace
> > > > > to explicitly set what profile/level it's aiming at. As a result,=
 I
> > > > > don't think we can explicitly mark controls as required or option=
al.

I'm not sure this is entirely true. The hardware may need to be
explicitly told what profile the video is. It may even not be the
hardware, but the driver itself too, given that the profile may imply
the CAPTURE pixel format, e.g. for VP9 profiles:

profile 0
color depth: 8 bit/sample, chroma subsampling: 4:2:0
profile 1
color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
profile 2
color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
profile 3
color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4

(reference: https://en.wikipedia.org/wiki/VP9#Profiles)

> > > > >
> > > > > I also like the idea that it should instead be implicit and that =
the
> > > > > documentation should detail which specific stateless metadata con=
trols
> > > > > are required for a given profile/level.
> > > > >
> > > > > As for controls validation, the approach followed in the Cedrus d=
river
> > > > > is to check that the most basic controls are filled and allow hav=
ing
> > > > > missing controls for those that match advanced profiles.
> > > > >
> > > > > Since this approach feels somewhat generic enough to be applied t=
o all
> > > > > stateless VPU drivers, maybe this should be made a helper in the
> > > > > framework?
> > > >
> > > > Sounds reasonable. Not sure if it will be in the first version, but=
 it is
> > > > easy to add later.
> > >
> > > Definitely, I don't think this is such a high priority for now either=
.
> > >

We may want to put strict requirements on what controls are provided
for given codec+profile/level. Otherwise we might get some user space
that doesn't provide some of them and works only by luck, e.g. because
some hardware defaults on initial drivers luckily match the needed
values. Even if we don't validate it in the code yet, we should put a
big warning saying that not providing the required controls would
result in undefined behavior.

> > > > > In addition, I see a need for exposing the maximum profile/level =
that
> > > > > the driver supports for decoding. I would suggest reusing the alr=
eady-
> > > > > existing dedicated controls used for encoding for this purpose. F=
or
> > > > > decoders, they would be used to expose the (read-only) maximum
> > > > > profile/level that is supported by the hardware and keep using th=
em as a
> > > > > settable value in a range (matching the level of support) for enc=
oders.
> > > > >
> > > > > This is necessary for userspace to determine whether a given vide=
o can
> > > > > be decoded in hardware or not. Instead of half-way decoding the v=
ideo
> > > > > (ending up in funky results), this would easily allow skipping ha=
rdware
> > > > > decoding and e.g. falling back on software decoding.
> > > >
> > > > I think it might be better to expose this through new read-only bit=
mask
> > > > controls: i.e. a bitmask containing the supported profiles and leve=
ls.
> > >
> > > It seems that this is more or less what the coda driver is doing for
> > > decoding actually, although it uses a menu control between min/max
> > > supported profile/levels, with a mask to "blacklist" the unsupported
> > > values. Then, the V4L2_CTRL_FLAG_READ_ONLY flag is set to keep the
> > > control read-only.
> > >
> > > > Reusing the existing controls for a decoder is odd since there is n=
ot
> > > > really a concept of a 'current' value since you just want to report=
 what
> > > > is supported. And I am not sure if all decoders can report the prof=
ile
> > > > or level that they detect.
> > >
> > > Is that really a problem when the READ_ONLY flag is set? I thought it
> > > was designed to fit this specific case, when the driver reports a val=
ue
> > > that userspace cannot affect.
> >
> > Well, for read-only menu controls the current value of the control woul=
d
> > have to indicate what the current profile/level is that is being decode=
d.
> >
> > That's not really relevant since what you want is just to query the
> > supported profiles/levels. A read-only bitmask control is the fastest
> > method (if only because using a menu control requires the application t=
o
> > enumerate all possibilities with QUERYMENU).

Besides querying for supported profiles,
 - For stateless codecs we also need to set the profile, since the
codec itself does only the number crunching.
 - For stateful codecs, the decoder would also report the detected
profile after parsing the bitstream (although this is possibly not of
a big importance to the user space).

As for querying itself, there is still more to it than could be
handled with just a read only control. To detect what CAPTURE formats
are supported for given profile, one would have to set the profile
control first and then use ENUM_FMT.

>
> Ah yes, I finally understand the issue with what the current control
> value represents here. Since I don't think the driver should have to
> bother with figuring out the profile in use (as expressed earlier, I
> think it should be implicit, through the codec metadata controls and
> features used), I no longer believe it's best to have the same control
> for both encoding and decoding.
>
> > > Otherwise, I agree that having a bitmask type would be a better fit, =
but
> > > I think it would be beneficial to keep the already-defined control an=
d
> > > associated values, which implies using the menu control type for both
> > > encoders and decoders.
> > >
> > > If this is not an option, I would be in favour of adding per-codec re=
ad-
> > > only bitmask controls (e.g. for H264 something like
> > > V4L2_CID_MPEG_VIDEO_H264_PROFILE_SUPPORT) that expose the already-
> > > existing profile/level definitions as bit identifiers (a bit like cod=
a
> > > is using them to craft a mask for the menu items to blacklist) for
> > > decoding only.
> >
> > That's what I have in mind, yes. I'd like Tomasz' input as well, though=
.

Thanks for valuing my input! Hopefully the comments don't turn that
into overestimation. ;) Sorry for being terribly late to the party,
last 2 weeks have been extremely busy.

Best regards,
Tomasz
