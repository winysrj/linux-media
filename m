Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:56035 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932104AbeAHPiP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Jan 2018 10:38:15 -0500
Date: Mon, 8 Jan 2018 16:38:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180108153811.5xrvbaekm6nxtoa6@flea>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="svijk2twi5xfreba"
Content-Disposition: inline
In-Reply-To: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--svijk2twi5xfreba
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Wed, Jan 03, 2018 at 10:57:27AM +0100, Hugues Fruchet wrote:
> Enhance OV5640 CSI driver to support also DVP parallel interface.
> Add RGB565 (LE & BE) and YUV422 YUYV format in addition to existing
> YUV422 UYVY format.
> Some other improvements on chip identifier check and removal
> of warnings in powering phase around gpio handling.

I've been trying to use your patches on top of 4.14, but I cannot seem
to get any signal out of it.

What is your test setup and which commands are you running?

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--svijk2twi5xfreba
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpTkGIACgkQ0rTAlCFN
r3T9QQ//QEAsQ+K1knpUpX1Xr9LZIPfpwmpxOYgT4qssv4L8QSjlGqtxRVw9bi0r
qFkvgykSN2rpAWsM5TbaBe436Zqor1UqirjUshisUB3TAlmaIcR9MRydb0TpWOce
OeCuARuS9JytW1n/Ox1QS26ZnZ+uu17SFCgsFzUzgsfd8mBXj6ajWUHnDDEFa5J1
Q3QZdUiQ6tdVkNGn6NGJu6qYEHKhfiwX5YU9nWtvrSjn4XqALaK7+uihctTir1cH
gQJAtX+rcjJx3703UKAoa4iVc2xiMrGT2fnEuKZKpZ2kbuEyaZg1ELuKuSOVpXAv
LKbStOx36fssya2r2uUbJ8fBawxpVS4yYA+4M1y7iKVipDAWtz4d81xj3BsAY4Xr
yYvaHKZY5OUAtFMZAkJKifKNg7qrLeq5k6G2vhsDf1uDyJEVmrljBqAG8Qw/RYLz
FNto17/9jE2UuFvMy/SaB2nG4CrjXPNTj957JnRaMFPeY1jS9WiTG6YYSzMcM+nM
pD4mWS3WXDCjJ/jUxBRVA3VHmghd3U7MvCgAlVA9h9gsU+QgEd7lXmuWliIbgJoJ
zfn63DUPgDro0/ZhyUlS/QnYpnou3AiEU2rD9CItXohvaYxrA+zXKddBwVdZg1CV
8IqdvVYeKUS6GgJXn381IM+cjVsjJS9uNl43pJ+KDBLOtqr5Fog=
=fp9s
-----END PGP SIGNATURE-----

--svijk2twi5xfreba--
