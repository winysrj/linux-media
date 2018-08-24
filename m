Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44909 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbeHXMev (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 08:34:51 -0400
Message-ID: <3774b8efd8818b7aef64211f0d7424e296806636.camel@bootlin.com>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Fri, 24 Aug 2018 11:00:28 +0200
In-Reply-To: <26ae963d-3326-2506-b116-0a5f64b34c3d@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl>
         <f4d1e18a6552446b092cffaa3028e0dfe5432b9a.camel@ndufresne.ca>
         <26ae963d-3326-2506-b116-0a5f64b34c3d@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-TECyqF2VRcCKcma0fsIs"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-TECyqF2VRcCKcma0fsIs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2018-08-24 at 09:29 +0200, Hans Verkuil wrote:
> On 08/23/2018 07:37 PM, Nicolas Dufresne wrote:
> > Le jeudi 23 ao=C3=BBt 2018 =C3=A0 16:31 +0200, Hans Verkuil a =C3=A9cri=
t :
> > > > I propose adding these capabilities:
> > > >=20
> > > > #define V4L2_BUF_CAP_HAS_REQUESTS     0x00000001
> > > > #define V4L2_BUF_CAP_REQUIRES_REQUESTS        0x00000002
> > > > #define V4L2_BUF_CAP_HAS_MMAP         0x00000100
> > > > #define V4L2_BUF_CAP_HAS_USERPTR      0x00000200
> > > > #define V4L2_BUF_CAP_HAS_DMABUF               0x00000400
> > >=20
> > > I substituted SUPPORTS for HAS and dropped the REQUIRES_REQUESTS capa=
bility.
> > > As Tomasz mentioned, technically (at least for stateless codecs) you =
could
> > > handle just one frame at a time without using requests. It's very ine=
fficient,
> > > but it would work.
> >=20
> > I thought the request was providing a data structure to refer back to
> > the frames, so each codec don't have to implement one. Do you mean that
> > the framework will implicitly request requests in that mode ? or simply
> > that there is no such helper ?
>=20
> Yes, that's done through controls as well.
>=20
> The idea would be that you set the necessary controls, queue a buffer to
> the output queue, dequeue a buffer from the output queue, read back any
> new state information and repeat the process.
>=20
> That said, I'm not sure if the cedrus driver for example can handle this
> at the moment. It is also inefficient and it won't work if codecs require
> more than one buffer in the queue for whatever reason.
>=20
> Tomasz, Paul, please correct me if I am wrong.

I haven't tested decoding without requests, but I suppose it should work
when submitting only one source buffer at a time.

By the way, note that our VAAPI backend for the request API gets the
slice data and metadata for each frame sequentially and we are not yet
starting to fill the next request before the current one was completed
(fences would probably help implement that).

> In any case, I think we can do without this proposed capability since it =
is
> simply a requirement when implementing the pixelformat for the stateless
> codec that the Request API will be available and it should be documented
> as such in the spec.

Agreed.

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com

--=-TECyqF2VRcCKcma0fsIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlt/ySwACgkQ3cLmz3+f
v9FPUwf/SxS2XbDbfXFQ6T4AH6cNb1Z20R9DwdkGp3F9e3tGX4srNIdM07Eg+VWN
lxSPArGEEBbDtrxIi+4y1qCKxw+h7qCK0MImq1LMp9ysDbddY5nhEBtKxE/H7a0S
12N78E9tVwe/7snn2drWFJT8UuzZa9pkj99QxW/+sdrwA9RKLFz7aZqxqy8FSr9n
vDHCiop0f0P9F6LnMiPWxwVmrcAiMoZ0YXjLBTymgD2mIV3sUwOFUD/I56Ehnosx
cBr6iRtG+nRKlNnwymgy6i+5JZeR/u7brDWMZQ595X8n/3DMi2kvT7rAe74/QtSW
1+jSosXxiiITvJScYUyaGo6H3i7++w==
=yxBk
-----END PGP SIGNATURE-----

--=-TECyqF2VRcCKcma0fsIs--
