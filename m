Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:51629 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933184AbeAKMhX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 07:37:23 -0500
Date: Thu, 11 Jan 2018 13:37:11 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Yong Deng <yong.deng@magewell.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v5 0/5] Add OV5640 parallel interface and RGB565/YUYV
 support
Message-ID: <20180111123711.snz5skdpydudxnhh@flea.lan>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <20180108153811.5xrvbaekm6nxtoa6@flea>
 <3010811e-ed37-4489-6a9f-6cc835f41575@st.com>
 <20180110153724.l77zpdgxfbzkznuf@flea>
 <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hc743kok26txqmh7"
Content-Disposition: inline
In-Reply-To: <2089de18-1f7f-6d6e-7aee-9dc424bca335@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hc743kok26txqmh7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Wed, Jan 10, 2018 at 03:51:07PM +0000, Hugues FRUCHET wrote:
> Good news Maxime !
>=20
> Have you seen that you can adapt the polarities through devicetree ?
>=20
> +                       /* Parallel bus endpoint */
> +                       ov5640_to_parallel: endpoint {
> [...]
> +                               hsync-active =3D <0>;
> +                               vsync-active =3D <0>;
> +                               pclk-sample =3D <1>;
> +                       };

It's what I did, with the polarity infos on both side of the
endpoints.
Here it is:
http://code.bulix.org/4vgchd-257344?raw

You can see that the polarity are inverted on both sides of the link,
which seems weird :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--hc743kok26txqmh7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpXWnYACgkQ0rTAlCFN
r3TbPA//duIqNjy4gPvRJTuwfkg9UQhNUEORR+KUius89+FtObU8qAtov5+Oi7B9
vDnjBkJzaJUMPwAVY4P2rYff/lTH65sJf6z6B8HB8GDxssnSOWu3y279p/cf8Rtg
NGPZoBTmszrg07mE9iZV5bT9p5vuqdZlyk+rXXKx85jmkh8ewqyd7O0W50MrooY5
oYEzFByGuAbQesQlSq0lTsyB9IlZXiAQUI8JUig2exDeyMawZCiU68l1GAG0VnGw
QP+WjVXPSn8riU9yNp0BKUI+UT3/nc0VrskcCndiPKtjaI0LnaM1Bx8jywbuI666
boCWS3m8czJkjkQDOVlv/i82ArwUlb05VJvBZejy3bhVjWTkai17ced5b8E9HuKR
NhEt3hC6bRhvjbHuothK4CQy6jJPXuHvoI/8vpnvoWVbBCRSCa5csNgaBnNbiDa5
E1Z42Om5tvl/Z+OfmaU7/dqjwEzwTXxRCFRRsAPI7xTClVMmDOMkEhR1l3eaEh2W
XGgap4HdWKEoP7g/iR6uoFsn+qQJNMNhhLpCVZjawQLN4l3VD7mvCG5piTeYMVFS
OswM0MrbLQV5DKWCdHsr0AL2Au2uAFNgE2D5j/aDFsiaodNt3CR50a0DxQpVwpNQ
jAWUHhEC6RNxswoTKVmi7lO9tolTIUSM7kAuuknpt/jjhv2qzhc=
=W/+J
-----END PGP SIGNATURE-----

--hc743kok26txqmh7--
