Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43758 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750826AbeEQIwJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:52:09 -0400
Date: Thu, 17 May 2018 10:52:07 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 11/12] media: ov5640: Add 60 fps support
Message-ID: <20180517085207.wvfrji3o7dlgnvq2@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-12-maxime.ripard@bootlin.com>
 <1ef58196-f04a-8b75-6d01-8ec5e22bfc7f@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bbvyuxsaqegbncis"
Content-Disposition: inline
In-Reply-To: <1ef58196-f04a-8b75-6d01-8ec5e22bfc7f@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--bbvyuxsaqegbncis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Tue, May 15, 2018 at 01:33:55PM +0000, Hugues FRUCHET wrote:
> I've taken the whole serie and made some tests on STM32 platform using=20
> DVP parallel interface.
> Now JPEG is OK and I've not seen any regressions appart on framerate=20
> control linked to this current patchset.

Thanks a lot for your feedback, I've (hopefully) fixed all the issues
you reported here, most of the time taking your fix directly, except
for 2 where I reworked the code instead.

> Here are issues observed around framerate control:
> 1) Framerate enumeration is buggy and all resolutions are claimed=20
> supporting 15/30/60:
> v4l2-ctl --list-formats-ext
> ioctl: VIDIOC_ENUM_FMT
>          Index       : 0
>          Type        : Video Capture
>          Pixel Format: 'JPEG' (compressed)
>          Name        : JFIF JPEG
>                  Size: Discrete 176x144
>                          Interval: Discrete 0.067s (15.000 fps)
>                          Interval: Discrete 0.033s (30.000 fps)
>                          Interval: Discrete 0.017s (60.000 fps)

One small question though, I don't seem to have that output for
v4l2-ctl, is some hook needed in the v4l2 device for it to work?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--bbvyuxsaqegbncis
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr9QrYACgkQ0rTAlCFN
r3RGvA//Y0/cZI5Lr2/kvd6s+DGyVJiQ0viC8QEPZFgiIbSh5yErtA8NIkXlaLLb
PST9rErm9BPG1622kkDaMzXu7WNZs2qWda2UQWbj5t9MWzt1VF7UlzadKVB6hTV0
HOeyB92uEH2kVT6Lauy3ufKV7aUU5/LXIcmMuWNs+N2wSMKFa8fOvNShTVm/2aLa
z8wD6RvE9z2qyLrdPKw71UY8qGoKLpp7lQRd89XUXnhxScSnXB7zdTH1Fhj5ypr8
A/2QrnGjbnqgqVPF9CX3gG/2R8giMzthXybZH/H5xkStrzLZicEd/VdcPmU44651
JiCYl0gQQN1h/oG3AuEaJaQiDb7Huvm2Xyv1mwlg314nqs/7hfERkoh86/FMXA7f
Xxaqgd3yfMnlKt75YXPV7NsQbeGij8NRQwTzAhDipOyIK/xOqSwzuiMZs5e71YUy
DPkHadeocYl6WcUz1s0SyrQB22U17BOjND/j7R+VxBoJbalyMnARzMlX8HKGIGxM
ni5+2W535f02KmTfqV1kmXwxLXI+35riLZVWPoG7KHsjhFZwSq544S2hjaB/b7RU
ClJU0b85fkjemGHOsLBjWkrN9bnsh8581naKv62nyI+fzbWEt4Pge6wSx7NOuKpq
zdkmPS+FqHMYd6pQCSsnrj1QxXOhZ0DAUiGn3cuLofYfM8x/4OY=
=ODc/
-----END PGP SIGNATURE-----

--bbvyuxsaqegbncis--
