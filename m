Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42413 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbeJDV5o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 17:57:44 -0400
Date: Thu, 4 Oct 2018 17:04:02 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Samuel Bobrowicz <sam@elite-embedded.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v3 00/12] media: ov5640: Misc cleanup and improvements
Message-ID: <20181004150402.uqqmkwbzvmotaq6r@flea>
References: <20180517085405.10104-1-maxime.ripard@bootlin.com>
 <b3bac06f-f4d6-7620-2c3d-f8a852920f56@st.com>
 <20180928160507.4jerbp4dqgz6l4qu@flea>
 <56139505-6e5c-6d7f-027d-54b51c70b179@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gaskgnzet4jza5gm"
Content-Disposition: inline
In-Reply-To: <56139505-6e5c-6d7f-027d-54b51c70b179@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--gaskgnzet4jza5gm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

On Mon, Oct 01, 2018 at 02:12:31PM +0000, Hugues FRUCHET wrote:
> >> This is working perfectly fine on my parallel setup and allows me to
> >> well support VGA@30fps (instead 27) and also support XGA(1024x768)@15f=
ps
> >> that I never seen working before.
> >> So at least for the parallel setup, this serie is working fine for all
> >> the discrete resolutions and framerate exposed by the driver for the m=
oment:
> >> * QCIF 176x144 15/30fps
> >> * QVGA 320x240 15/30fps
> >> * VGA 640x480 15/30fps
> >> * 480p 720x480 15/30fps
> >> * XGA 1024x768 15/30fps
> >> * 720p 1280x720 15/30fps
> >> * 1080p 1920x1080 15/30fps
> >> * 5Mp 2592x1944 15fps
> >=20
> > I'm glad this is working for you as well. I guess I'll resubmit these
> > patches, but this time making sure someone with a CSI setup tests
> > before merging. I crtainly don't want to repeat the previous disaster.
> >=20
> > Do you have those patches rebased somewhere? I'm not quite sure how to
> > fix the conflict with the v4l2_find_nearest_size addition.
> >=20
> >> Moreover I'm not clear on relationship between rate and pixel clock
> >> frequency.
> >> I've understood that to DVP_PCLK_DIVIDER (0x3824) register
> >> and VFIFO_CTRL0C (0x460c) affects the effective pixel clock frequency.
> >> All the resolutions up to 720x576 are forcing a manual value of 2 for
> >> divider (0x460c=3D0x22), but including 720p and more, the divider valu=
e is
> >> controlled by "auto-mode" (0x460c=3D0x20)... from what I measured and
> >> understood, for those resolutions, the divider must be set to 1 in ord=
er
> >> that your rate computation match the effective pixel clock on output,
> >> see [2].
> >>
> >> So I wonder if this PCLK divider register should be included
> >> or not into your rate computation, what do you think ?
> >=20
> > Have you tried change the PCLK divider while in auto-mode? IIRC, I did
> > that and it was affecting the PCLK rate on my scope, but I wouldn't be
> > definitive about it.
>=20
> I have tested to change PCLK divider while in auto mode but no effect.
>=20
> > Can we always set the mode to auto and divider to 1, even for the
> > lower resolutions?
>
> This is breaking 176x144@30fps on my side, because of pixel clock too=20
> high (112MHz vs 70 MHz max).

Ok.

> Instead of using auto mode, my proposal was the inverse: use manual mode=
=20
> with the proper divider to fit the max pixel clock constraint.

Oh. That would work for me too yeah. How do you want to deal with it?
Should I send your rebased patches, and you add that change as a
subsequent patch?

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--gaskgnzet4jza5gm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlu2K+EACgkQ0rTAlCFN
r3TxJQ//d+he84BGCsCPK/a98Kx9LPyqqYqNQpdGr3m5OE/X+v1qZof50ImfJiY+
eEdM8s3xAQ8W2HIw9mKQ5tnMYD7QD8odfXM3CVzRLthznMeFre6XZT3pVfX7EIUz
GfO3iktngOuBZF82Gl9gRhgCACDPYDSKPtBVlkWUJ9q5eulAGv3PvtBOeQq2pEsT
1a38pwYc5w+FBybkLvhyExNlN7+zDua6TPvYhKIHM27BZBbvv5UczF4SzOz19Hxo
cfvgnYBW4auzEtwwx8fV+jRUtPVs2tG5bAV8UWzG/4N+tDb0FNFWQQZW4GLxuewJ
RnRHVCDapw3Ni8KZl+b3cWVLo7ufhb8aBp+FfmcVYKP9yaltsNmVWOnz9OpR4zr5
MJnUup8p2NQgb4U3TV8Y4PfF1ScnfIopTLudre28I/nk82mgjyE3ZCRuskRcWqn5
T1ay0zvSelN63uxce6TpCB5PvgGTAX1NX89U1c3b1kxY63P9pQmhyeRIUfRKwJFp
ug95i/Na1pCPPxA3llqT+Uyb1QLIiQtAvNlGmxZ0iexdyFiPTVXX3StgRON/a6BD
36YeN2UbTxLscatgsX6vOR37dF3tRXhZQu32OvX5/pgeE5l1UMUJy5ZeNlRSNv6O
btDNYhVUQqHJG8w0SA3i4eej7YYAse3QuwFJ5e6N1cMLNrQJJ78=
=iktS
-----END PGP SIGNATURE-----

--gaskgnzet4jza5gm--
