Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53718 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751985AbeERJGA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 05:06:00 -0400
Date: Fri, 18 May 2018 11:05:49 +0200
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
Message-ID: <20180518090549.bdzgo2x5w2nndhia@flea>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
 <20180416123701.15901-12-maxime.ripard@bootlin.com>
 <1ef58196-f04a-8b75-6d01-8ec5e22bfc7f@st.com>
 <20180517085207.wvfrji3o7dlgnvq2@flea>
 <feb37eec-44ea-eb4a-ed59-32fe697e4bcb@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6oi7lcplupsnvank"
Content-Disposition: inline
In-Reply-To: <feb37eec-44ea-eb4a-ed59-32fe697e4bcb@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6oi7lcplupsnvank
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hugues,

On Thu, May 17, 2018 at 01:29:24PM +0000, Hugues FRUCHET wrote:
> No special modification of v4l2-ctl, I'm using currently v4l-utils 1.12.3.
> What output do you have ?

The same one, without the resolution and framerate. I'm pretty sure
this is a driver issue and not an usperspace one.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--6oi7lcplupsnvank
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr+l2wACgkQ0rTAlCFN
r3QHAg/9HBYAasJcjAd4l2uUOfoxBjLBrY65q89CXGdGOIMZDKsirUhSNhW2dWmC
X/xtHk7n+hk8OS9pUqGW5JiXlyvjJ1xHJN7Gac0pu/hNS3q/8EyYuisUYjZVPcWi
wfk/Am6iUC8SBA8jBNGoL+2haZbNB2ae6KzpRuX8BGAW1Vs5xrw0QIyNeDBH73Ef
5fi6kDFO4+TaHbM5pklqxc6F+/E0e6AWhuCJ2SpKNDV5wea+ZDO7z2Fk2DOZRUAJ
ZMtZVy3KN6igeu9GY/Kfa4FgNN9uPnJzU0x0lEvOJLlH8yEboI6vWt/kGnLhP5ZI
xBkmj1iovv0cohZu/hEeMFqH2E2zUFmz4AzzyL9BmoZ5MKHfgj2ThFTQV8o32wAj
ydrGeeeRxIIePcFmf/kWHQb3RrR1wGcqQGZCYTPpFbOAjMkm9Rk9mWzJY7ViHGAH
whW+9iMKr/l/aOR7M3kTpU2J3XjrR84iDnjzWhA+tpHalP9dGWnZVe6TYp/NzXXP
7L8bdswm2p20eugQhH69PPEc7mY/W4vowHy84lQS4gtkIqtb8qq5FIoHMdXvKhz+
Hx1WtDJ6vDPgSXkXH1iEFfCqBVsGSsWmiUhzD/AjSCAYQVIRpzOD43jr4PID8c4A
9MWypxbaAA4hldSa2eJlwbE8Oj4dR1BAGqGNvnCsMrayGfx/ifM=
=VIpA
-----END PGP SIGNATURE-----

--6oi7lcplupsnvank--
