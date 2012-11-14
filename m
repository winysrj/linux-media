Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422711Ab2KNMvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:51:43 -0500
Date: Wed, 14 Nov 2012 13:51:19 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 6/6] drm_modes: add of_videomode helpers
Message-ID: <20121114125119.GG2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-7-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-7-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 14, 2012 at 12:43:23PM +0100, Steffen Trumtrar wrote:
[...]
> +EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
> +#endif
>  /**

Nit: there should be a blank line between the last two.

Thierry

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo5PHAAoJEN0jrNd/PrOh2bAQAKJ/n47kxLl7/OHDAeN6Znay
shpIyjZQSOV0ncb7J6JGlyJkQnDhYxB7zrcWFSePgNpltztfuxhTcw21ViHf2CpP
TOYcXCwugbaKN7i4V+25gI6GqwCbX4eqUpGEsMW7uLn5Qk+Nv1q7/m/m1GI72ozs
IKNhInB4VzyUgEoFnb575MH9Za9kHw00sN1JEHq0ymjkFJnJ/ft5j3LE1bAsw29H
xwSHQKdDoNFwQ9f/cDybt9jPDCDt75ZZh775qbTpIxKH8wJMqMTmlfpgq9K0Kucv
XTNbF17GyX4Li4D02PrBfdi++pNONtQJXrMGcl/IzP83ZPUrfDmo/CEeJ+T89xqy
uY2smevUS3zKkA4RpJ2ZaNTYe2Ys8+sdzDYwiCwxgCbXIy/2JfM46onRDX4eXbaW
ncrIH1Xcb3o5e5d6pvis/MRUJUR9m5a0aPHwbMh+6dITHPjBOnkai+imRIYE2dxL
YmtnT1u61CUi4quRNy6NyOPHTQLT7Dki7tnWccXi/hWFBP0m5FnLnWVdeE+ligTC
cB+qM2b+H7zzHaru5z4vN89pn2SRCi8ozMsF07YPZH0lpi3KXBKc9E7s+5pyZJmE
py9lDzIeGk3UV1bm+Rk/22uq7L2mCzxoZP0hGey5tk63EUoB81Yumd9VHccVqT5M
dLIMUdvkkiXMI5s4njUc
=XRNf
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
