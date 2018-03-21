Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:51511 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751550AbeCURIb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 13:08:31 -0400
Date: Wed, 21 Mar 2018 18:08:27 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 11/12] media: ov5640: Add 60 fps support
Message-ID: <20180321170827.dcd72sx5fqv2vezk@flea>
References: <20180302143500.32650-1-maxime.ripard@bootlin.com>
 <20180302143500.32650-12-maxime.ripard@bootlin.com>
 <ff080b97-3f7a-36fa-0e1c-16e83106d6a1@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nq7cxgmwm662uupn"
Content-Disposition: inline
In-Reply-To: <ff080b97-3f7a-36fa-0e1c-16e83106d6a1@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nq7cxgmwm662uupn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

Thanks for all your feedback, I'll merge your suggested changes in the
next iteration.

On Tue, Mar 13, 2018 at 02:32:14PM +0000, Hugues FRUCHET wrote:
> >   	if (fi->numerator =3D=3D 0) {
> >   		fi->denominator =3D maxfps;
> >   		fi->numerator =3D 1;
> > -		return OV5640_30_FPS;
> > +		return OV5640_60_FPS;
>
> [...]
>
> About 60 fps by default if (fi->numerator =3D=3D 0): shouldn't we stick t=
o a=20
> default value supported by all modes such as 30fps ?

30 fps is not supported by all modes either, so I guess 15 fps would
be a better pick?

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--nq7cxgmwm662uupn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlqykYsACgkQ0rTAlCFN
r3TT1w//cUGuuIvgStcofckuEf+LigjswDw3SiQBNHzTzWspkRW31VDCnznY6KiY
Eg6Z3VdpOkyKvJdUmxTs03fDDIYMuN9i8AyUuaKCxlMzOpKmGerWiSzTOzLwQOuJ
Ucx+hDqOVbqh1S1+bbzgbTQzOTtGZcQutLxWt84qBoNSWODn+B9NG1t9fZu4Y02f
9UxB/A/gmw36DW4vAI2TfOYQAakuMiSe4XrvS6bItE9YHH6O6pPqx9nuiRnqpB1B
U9alTQdzJw/ZLSugs66EvwhY8owEWTc7JXeyRww9k8JaxxlOqqAN+Yh5zuTJSxwI
ARFRv7el/sgZk8TnrGatmR3gx9EQ6jOLAY2IBd2bYMpmBw6usV+qnc1ltjQNCstk
XSOZyGzViJm5Ly3yfjAaTKQAJ29szQUFE+ONh8pnrbBRARc/A7l21/SIDzvjYDay
25WNpn500mrC6ABRYxYCmqOzfruaA0S2NsZvjQSdGMRgkin5r0LH01jfLQ/3iOTG
8AsMxo/KA8kBXR+vk0GnD4JQ6/ObIUysCem+Sx9jquIAvphvP5LOsi3gWWzbeb97
/yZRRUGnN9ZtaIlscmt5lSwRDOUhb55V4YUPL/L5JzgSsWPu5WQyhd/Iv+gG2CAM
70CLnG/AqHJSSHVXVezVyEZKb+IHJarI6vP2ran9CqpSdFqwwMc=
=Sga+
-----END PGP SIGNATURE-----

--nq7cxgmwm662uupn--
