Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:34753 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbeH2IQO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 04:16:14 -0400
Received: by mail-yw1-f66.google.com with SMTP id y134-v6so1513357ywg.1
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:21:18 -0700 (PDT)
Received: from mail-yb0-f178.google.com (mail-yb0-f178.google.com. [209.85.213.178])
        by smtp.gmail.com with ESMTPSA id t4-v6sm1158735ywa.51.2018.08.28.21.21.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Aug 2018 21:21:16 -0700 (PDT)
Received: by mail-yb0-f178.google.com with SMTP id c1-v6so1515448ybq.5
        for <linux-media@vger.kernel.org>; Tue, 28 Aug 2018 21:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
 <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
 <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl> <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
 <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl> <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
 <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com> <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
In-Reply-To: <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 29 Aug 2018 13:21:04 +0900
Message-ID: <CAAFQd5Dz74BZvDT74iBXMKkBygqgvfW1jtw9dHcwFg6jq5fzWA@mail.gmail.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 22, 2018 at 11:10 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> > Hi Hans, Paul,
> >
> > On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > >
> > > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > > Hi,
> > > > >
> > > > > On Mon, 2018-08-06 at 10:32 +0200, Hans Verkuil wrote:
> > > > > > On 08/06/2018 10:16 AM, Paul Kocialkowski wrote:
> > > > > > > On Sat, 2018-08-04 at 15:50 +0200, Hans Verkuil wrote:
> > > > > > > > Regarding point 3: I think this should be documented next t=
o the pixel format. I.e.
> > > > > > > > the MPEG-2 Slice format used by the stateless cedrus codec =
requires the request API
> > > > > > > > and that two MPEG-2 controls (slice params and quantization=
 matrices) must be present
> > > > > > > > in each request.
> > > > > > > >
> > > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUIRED_=
IN_REQ) is needed here.
> > > > > > > > It's really implied by the fact that you use a stateless co=
dec. It doesn't help
> > > > > > > > generic applications like v4l2-ctl or qv4l2 either since in=
 order to support
> > > > > > > > stateless codecs they will have to know about the details o=
f these controls anyway.
> > > > > > > >
> > > > > > > > So I am inclined to say that it is not necessary to expose =
this information in
> > > > > > > > the API, but it has to be documented together with the pixe=
l format documentation.
> > > > > > >
> > > > > > > I think this is affected by considerations about codec profil=
e/level
> > > > > > > support. More specifically, some controls will only be requir=
ed for
> > > > > > > supporting advanced codec profiles/levels, so they can only b=
e
> > > > > > > explicitly marked with appropriate flags by the driver when t=
he target
> > > > > > > profile/level is known. And I don't think it would be sane fo=
r userspace
> > > > > > > to explicitly set what profile/level it's aiming at. As a res=
ult, I
> > > > > > > don't think we can explicitly mark controls as required or op=
tional.
> >
> > I'm not sure this is entirely true. The hardware may need to be
> > explicitly told what profile the video is. It may even not be the
> > hardware, but the driver itself too, given that the profile may imply
> > the CAPTURE pixel format, e.g. for VP9 profiles:
> >
> > profile 0
> > color depth: 8 bit/sample, chroma subsampling: 4:2:0
> > profile 1
> > color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > profile 2
> > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
> > profile 3
> > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> >
> > (reference: https://en.wikipedia.org/wiki/VP9#Profiles)
>
> I think it would be fair to expect userspace to select the right
> destination format (and maybe have the driver error if there's a
> mismatch with the meta-data) instead of having the driver somewhat
> expose what format should be used.

There are many different memory representations of the same physical
YUV format, just for YUV 4:2:0: NV12, NV12M, NV21, NV21M, YUV420,
YUV420M, YVU420, YVU420M. It depends on hardware and driver which one
would be available for given stream to decode. How is the user space
expected to know which one is, without querying the driver first?

>
> But maybe this would be an API violation, since all the enumerated
> formats are probably supposed to be selectable?

Correct.

>
> We could also look at it the other way round and consider that selecting
> an exposed format is always legit, but that it implies passing a
> bitstream that matches it or the driver will error (because of an
> invalid bitstream passed, not because of a "wrong" selected format).

As per above, it's unlikely that a generic user space can set the
right format. It may be able to narrow down the list of exposed
formats to those which make sense for the generic information about
the stream it has, e.g. VP9 profile 0 -> YUV 4:2:0, but there may
still be a constraint on which representation is allowed depending on
stream features.

>
> As far as I understood, the profile/level information is there to
> indicate a set of supported features by the decoder, not as an
> information used for the decoding process. Each corresponding feature is
> enabled or not in the bitstream meta-data and that's all the information
> the decoder really needs.
>
> This is why I think that setting the profile/level explicitly is not
> justified by the nature of the process and adding it only for
> convenience or marking whether controls are optional doesn't seem
> justified at this point, in my opinion.

Okay, it's actually a good point. Whether given format can be
supported is not entirely dictated by profile/level. There may be some
initial negotiation needed, involving the user space setting the
parsed stream parameters through respective controls.

>
> > > > > > > I also like the idea that it should instead be implicit and t=
hat the
> > > > > > > documentation should detail which specific stateless metadata=
 controls
> > > > > > > are required for a given profile/level.
> > > > > > >
> > > > > > > As for controls validation, the approach followed in the Cedr=
us driver
> > > > > > > is to check that the most basic controls are filled and allow=
 having
> > > > > > > missing controls for those that match advanced profiles.
> > > > > > >
> > > > > > > Since this approach feels somewhat generic enough to be appli=
ed to all
> > > > > > > stateless VPU drivers, maybe this should be made a helper in =
the
> > > > > > > framework?
> > > > > >
> > > > > > Sounds reasonable. Not sure if it will be in the first version,=
 but it is
> > > > > > easy to add later.
> > > > >
> > > > > Definitely, I don't think this is such a high priority for now ei=
ther.
> > > > >
> >
> > We may want to put strict requirements on what controls are provided
> > for given codec+profile/level. Otherwise we might get some user space
> > that doesn't provide some of them and works only by luck, e.g. because
> > some hardware defaults on initial drivers luckily match the needed
> > values. Even if we don't validate it in the code yet, we should put a
> > big warning saying that not providing the required controls would
> > result in undefined behavior.
>
> I don't think having such strict requirements are a good thing. Even
> with the level/profile made explicit, what if the video under-uses its
> features and thus legitimately doesn't need to have all the controls
> that could be supported with the level/profile? This can probably also
> be frame-specific, so some frames could require more controls than
> others.

That's exactly the best first step towards an user space that relies
on unspecified behavior. Even if the video doesn't use all the
features as per given profile/level, user space should be expected to
initialize the state with reasonable defaults, since it's essentially
for the driver/hardware to decide which state it needs to do the
decoding.

Whether profile/level is the right indicator to judge what's required
and what's not is a different question. It indeed may not be. However,
we need to clearly state what controls and when the application needs
to set in the specification. I'm not talking about requirements as for
bailing out with an error code, but exactly as for having that
included in the specification and correct behavior only guaranteed if
followed correctly.

>
> This also leads me to believe that the profile/level indication should
> be used as a support indication to userspace, not as a way to expose the
> required features for decoding to the kernel
>
> We could still enforce checks for the most basic controls (that are used
> for all types of slices to decode) and error if they are missing. We
> could also check the bits that indicate more advanced features in these
> basic controls and decide what other controls are required from that.
>
> > > > > > > In addition, I see a need for exposing the maximum profile/le=
vel that
> > > > > > > the driver supports for decoding. I would suggest reusing the=
 already-
> > > > > > > existing dedicated controls used for encoding for this purpos=
e. For
> > > > > > > decoders, they would be used to expose the (read-only) maximu=
m
> > > > > > > profile/level that is supported by the hardware and keep usin=
g them as a
> > > > > > > settable value in a range (matching the level of support) for=
 encoders.
> > > > > > >
> > > > > > > This is necessary for userspace to determine whether a given =
video can
> > > > > > > be decoded in hardware or not. Instead of half-way decoding t=
he video
> > > > > > > (ending up in funky results), this would easily allow skippin=
g hardware
> > > > > > > decoding and e.g. falling back on software decoding.
> > > > > >
> > > > > > I think it might be better to expose this through new read-only=
 bitmask
> > > > > > controls: i.e. a bitmask containing the supported profiles and =
levels.
> > > > >
> > > > > It seems that this is more or less what the coda driver is doing =
for
> > > > > decoding actually, although it uses a menu control between min/ma=
x
> > > > > supported profile/levels, with a mask to "blacklist" the unsuppor=
ted
> > > > > values. Then, the V4L2_CTRL_FLAG_READ_ONLY flag is set to keep th=
e
> > > > > control read-only.
> > > > >
> > > > > > Reusing the existing controls for a decoder is odd since there =
is not
> > > > > > really a concept of a 'current' value since you just want to re=
port what
> > > > > > is supported. And I am not sure if all decoders can report the =
profile
> > > > > > or level that they detect.
> > > > >
> > > > > Is that really a problem when the READ_ONLY flag is set? I though=
t it
> > > > > was designed to fit this specific case, when the driver reports a=
 value
> > > > > that userspace cannot affect.
> > > >
> > > > Well, for read-only menu controls the current value of the control =
would
> > > > have to indicate what the current profile/level is that is being de=
coded.
> > > >
> > > > That's not really relevant since what you want is just to query the
> > > > supported profiles/levels. A read-only bitmask control is the faste=
st
> > > > method (if only because using a menu control requires the applicati=
on to
> > > > enumerate all possibilities with QUERYMENU).
> >
> > Besides querying for supported profiles,
> >  - For stateless codecs we also need to set the profile, since the
> > codec itself does only the number crunching.
>
> I disagree here, see above.
>

Indeed, profile is normally a function of various parameters included
in the more general decoder state (e.g. bitstream headers).

> >  - For stateful codecs, the decoder would also report the detected
> > profile after parsing the bitstream (although this is possibly not of
> > a big importance to the user space).
>
> I don't follow the logic behind this. This means informing userspace of
> the capabilities required to decode the video that the VPU is currently
> decoding... so that it can decided whether to decode it?

That's what some of current drivers do, but I also fail to see it
being useful. We should make sure that there is no user space relying
on this behavior, if we intend to change it.

>
> > As for querying itself, there is still more to it than could be
> > handled with just a read only control. To detect what CAPTURE formats
> > are supported for given profile, one would have to set the profile
> > control first and then use ENUM_FMT.
>
> Or consider that the bitstream is invalid if it doesn't match the
> selected format and let userspace pick the appropriate format.

See above. The appropriate format is only known to the driver.

Best regards,
Tomasz
