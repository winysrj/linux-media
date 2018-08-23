Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:38101 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeHWVE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 17:04:28 -0400
Received: by mail-qt0-f170.google.com with SMTP id x7-v6so7193481qtk.5
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 10:33:42 -0700 (PDT)
Message-ID: <83966321e1be92e0802dfed27b76cbbadefa9e93.camel@ndufresne.ca>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Thu, 23 Aug 2018 13:33:38 -0400
In-Reply-To: <0f947768d8e982fcc591112c43cf40d618df2233.camel@bootlin.com>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <43c3d4b79377e9481ca29308cf1c160d57902d8c.camel@bootlin.com>
         <5f1a88aa-9ad9-9669-b8b9-78c921282279@xs4all.nl>
         <ee7e5b404c895d01682700d815a6cec89c2221a1.camel@bootlin.com>
         <186fd3ca-7759-7648-6870-4e5274a9680d@xs4all.nl>
         <05d52a4a3ed33a057e050d1f79dc0d873f31f21e.camel@bootlin.com>
         <CAAFQd5C0bwbZ74rpCTmXVNGPdp2TDJcb+YzRfevwuxvvK7Lbzg@mail.gmail.com>
         <8b603c5a27c55e30e4ac3f1b9bb6b6d8515e2331.camel@bootlin.com>
         <8a4dba99d73e46eb6885b852110d9eac2b041db7.camel@collabora.com>
         <0f947768d8e982fcc591112c43cf40d618df2233.camel@bootlin.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-M0iYUR3Eq8qmykd1rKsP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-M0iYUR3Eq8qmykd1rKsP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 23 ao=C3=BBt 2018 =C3=A0 10:05 +0200, Paul Kocialkowski a =C3=A9cr=
it :
> Hi,
>=20
> On Wed, 2018-08-22 at 14:33 -0300, Ezequiel Garcia wrote:
> > On Wed, 2018-08-22 at 16:10 +0200, Paul Kocialkowski wrote:
> > > Hi,
> > >=20
> > > On Tue, 2018-08-21 at 17:52 +0900, Tomasz Figa wrote:
> > > > Hi Hans, Paul,
> > > >=20
> > > > On Mon, Aug 6, 2018 at 6:29 PM Paul Kocialkowski
> > > > <paul.kocialkowski@bootlin.com> wrote:
> > > > >=20
> > > > > On Mon, 2018-08-06 at 11:23 +0200, Hans Verkuil wrote:
> > > > > > On 08/06/2018 11:13 AM, Paul Kocialkowski wrote:
> > > > > > > Hi,
> > > > > > >=20
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
> > > > > > > > > >=20
> > > > > > > > > > I am not sure a control flag (e.g. V4L2_CTRL_FLAG_REQUI=
RED_IN_REQ) is needed here.
> > > > > > > > > > It's really implied by the fact that you use a stateles=
s codec. It doesn't help
> > > > > > > > > > generic applications like v4l2-ctl or qv4l2 either sinc=
e in order to support
> > > > > > > > > > stateless codecs they will have to know about the detai=
ls of these controls anyway.
> > > > > > > > > >=20
> > > > > > > > > > So I am inclined to say that it is not necessary to exp=
ose this information in
> > > > > > > > > > the API, but it has to be documented together with the =
pixel format documentation.
> > > > > > > > >=20
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
> > > >=20
> > > > I'm not sure this is entirely true. The hardware may need to be
> > > > explicitly told what profile the video is. It may even not be the
> > > > hardware, but the driver itself too, given that the profile may imp=
ly
> > > > the CAPTURE pixel format, e.g. for VP9 profiles:
> > > >=20
> > > > profile 0
> > > > color depth: 8 bit/sample, chroma subsampling: 4:2:0
> > > > profile 1
> > > > color depth: 8 bit, chroma subsampling: 4:2:0, 4:2:2, 4:4:4
> > > > profile 2
> > > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0
> > > > profile 3
> > > > color depth: 10=E2=80=9312 bit, chroma subsampling: 4:2:0, 4:2:2, 4=
:4:4
> > > >=20
> > > > (reference: https://en.wikipedia.org/wiki/VP9#Profiles)
> > >=20
> > > I think it would be fair to expect userspace to select the right
> > > destination format (and maybe have the driver error if there's a
> > > mismatch with the meta-data) instead of having the driver somewhat
> > > expose what format should be used.
> > >=20
> > > But maybe this would be an API violation, since all the enumerated
> > > formats are probably supposed to be selectable?
> > >=20
> > > We could also look at it the other way round and consider that select=
ing
> > > an exposed format is always legit, but that it implies passing a
> > > bitstream that matches it or the driver will error (because of an
> > > invalid bitstream passed, not because of a "wrong" selected format).
> > >=20
> >=20
> > The API requires the user to negotiate via TRY_FMT/S_FMT. The driver
> > usually does not return error on invalid formats, and simply return
> > a format it can work with. I think the kernel-user contract has to
> > guarantee if the driver accepted a given format, it won't fail to
> > encoder or decode.
>=20
> Well, the issue here is that in order to correctly enumerate the
> formats, the driver needs to be aware of:
> 1. in what destination format the bitstream data is decoded to;

This is covered by the state-full specification patch if I remember
correctly. So the driver, if it's a multi-format, will first return all
possible formats, and later on, will return the proper subset. So let's
take an encoder, after setting the capture format, the enumeration of
the raw formats could then be limited to what is supported for this
output. For an H264 encoder, what could also affect this list is the
profile that being set. For decoder, this list is reduced after
sufficient headers information has been given. Though for decoder it's
also limited case, since it only apply to decoder that do a conversion
before releasing the output buffer (like CODA does).

What isn't so nice with this approach, is that it adds an implicit
uninitialized state after open() which isn't usual to the V4L2 API and
might not be that trivial or nice to handle in drivers.

> 2. what format convesions the VPU can do.

whenever possible, exposing the color conversion as a seperate m2m
driver is better approach. Makes the driver simpler and avoids having
to add this double enumeration support.

>=20
> Step 1 is known by userspace but is only passed to the driver with the
> bitstream metadata from controls. This is much too late for trimming the
> list of supported formats.
>=20
> I'm not sure that passing an extra information to the driver early to
> trim the list would make sense, because it comes to down to telling the
> driver what format to target and then asking the driver was format it
> supports, which is rather redundant.
>=20
> I think the information we need to expose to userspace is whether the
> driver supports a destination format that does not match the bitstream
> format. We could make it part of the spec that, by lack of this
> indication, the provided bitstream is expected to match the format that
> was selected.

I'm not sure why you consider this too late. With decoder, the OUTPUT
and CAPTURE stream is asynchronous. So we start streaming on the OUTPUT
until the driver notify (V4L2_EVENT_SOURCE_CHANGE). We then enumerate
the formats again at that moment, and then configure and start the
CAPTURE.

>=20
> > I think that's why it makes sense for stateless drivers to set the
> > profile/levels for a given job, in order to properly negotiate
> > the input and output formats (for both encoders and decoders). =20
>=20
> I still fail to follow this logic. As far as I understood, profile/level
> are indications of hardware capabilities required to decode the video,
> not an indication of the precise features selected for decoding,
> especially when it comes the format. As Tomasz mentionned in the
> previous email, various formats may be supported by the same profile, so
> setting the profile/level does not indicate which format is appropriate
> for decoding the bitstream.

For decoder, the only purpose I have ever seen of setting the
profile/level is for pre-allocation purpose. This information gives an
upper bound to the largest required buffer needed to hold a frame,
though as you said, it's not a fixed indication. For stateless codec,
this information is describe in the PPS table, with much more details
then just the profile/level. So for stateless *decoder*, the
profile/level controls would be a bit redundant. Though the control
enumerate list if profile/level is important to userspace in order to
change some generic error into "Sorry, your hardware does not support
profile X" or to be able to fallback to another decoder if any.

>=20
> > [1] https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/vidioc-g-fmt.ht=
ml

--=-M0iYUR3Eq8qmykd1rKsP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW37v8gAKCRBxUwItrAao
HNL3AJ923eeXn6EgAC6KjqoYK9shrvjWlgCfbHHzqa9CLzJIlS6l9/GLBLFI9IY=
=Shk6
-----END PGP SIGNATURE-----

--=-M0iYUR3Eq8qmykd1rKsP--
