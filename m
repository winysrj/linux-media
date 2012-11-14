Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:57175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422702Ab2KNMGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:06:39 -0500
Date: Wed, 14 Nov 2012 13:06:22 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 2/6] video: add of helper for videomode
Message-ID: <20121114120622.GC2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-3-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:43:19PM +0100, Steffen Trumtrar wrote:
[...]
> +optional properties:
> + - native-mode: the native mode for the display, in case multiple modes are
> +		provided. When omitted, assume the first node is the native.

I forgot: The first sentence in this description should also start with
a capital letter as you terminate with a full stop.

Thierry

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIbBAEBAgAGBQJQo4k+AAoJEN0jrNd/PrOh2BMP93MAR+pS4eGgB5cunoapIzMl
7MOas914oB0++XF7Dte/7YaHwlkzdg2Nbm4At6rmqN8OE632iccgee8sNfG4XdGO
JWKlQ1z1fpuuDnfBzVpISE1s4jT94KCv+vZB/TBCAal5ZmOXfy0lQ03ej0vHPhWY
W1PRUTGxQINET6iM8nVnXMazWzufUxeRUBY+aiRW0Kv8WYO9m3Gxx4w9clNrEMKm
VBENWctOdv/IgUnSolTXd2dqrz5sfFGjMiR2yYzd7sZBhSiFllG9rUyc43YU0nNc
JdcIFQKi1UKIXreKmgqq29OUWNvO3RPLYrfGtnBV1tSEv1LrQANuziDjMFc6ZcbT
5SxNZMGJw3a2RU4vEj5z15p7NQ6J87bx9cknc8M6r3ldOizhwoaS2paOYUm1YoSC
8l6Ux8rjz1i2/+MUW473tiWpb1DASCoyWFax87N/U/fHnnME7TFnEvA7nCfuQ6bH
KK/Uwig44xndBWdj4JwSgCoej+POPpvQd4g6kHkfvRaA14nVgXlAqfJvOxs1LIYS
DUcjItrNFI+vPTXuOYq3AVFe1aTc2TNoNtbunKYHp+h3LDPy8ooUgIXnmN03tF/R
u1ewFIQFwluDDxoEDfGxP0sddEyRA7TYbb4PPS/hMGJNNIs5YzSqoSWjZ7BiyTCk
gh52oDykeaILepSy3f8=
=SfNW
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
