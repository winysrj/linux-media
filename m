Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42069 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753902AbdDELdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 07:33:00 -0400
Date: Wed, 5 Apr 2017 13:32:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v6 19/39] media: Add i.MX media core driver
Message-ID: <20170405113256.GB26831@amd>
References: <1490661656-10318-1-git-send-email-steve_longerbeam@mentor.com>
 <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <1490661656-10318-20-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> +https://boundarydevices.com/products/nit6x_5mp

I'd use /product/ in url, as it redirects there.

> +https://boundarydevices.com/product/nit6x_5mp_mipi

=2E.and for consistency.

> +The following example configures a direct conversion pipeline to capture
> +from the OV5640, transmitting on MIPI CSI-2 virtual channel 1. $sensorfmt
> +can be any format supported by the OV5640. $sensordim is the frame
> +dimension part of $sensorfmt (minus the mbus pixel code). $outputfmt can
> +be any format supported by the ipu1_ic_prpenc entity at its output pad:
> +
> +.. code-block:: none
> +
> +   # Setup links
> +   media-ctl -l "'ov5640 1-003c':0 -> 'imx6-mipi-csi2':0[1]"
> +   media-ctl -l "'imx6-mipi-csi2':2 -> 'ipu1_csi1':0[1]"
> +   media-ctl -l "'ipu1_csi1':1 -> 'ipu1_ic_prp':0[1]"
> +   media-ctl -l "'ipu1_ic_prp':1 -> 'ipu1_ic_prpenc':0[1]"
> +   media-ctl -l "'ipu1_ic_prpenc':1 -> 'ipu1_ic_prpenc capture':0[1]"
> +   # Configure pads
> +   media-ctl -V "'ov5640 1-003c':0 [fmt:$sensorfmt field:none]"
> +   media-ctl -V "'imx6-mipi-csi2':2 [fmt:$sensorfmt field:none]"
> +   media-ctl -V "'ipu1_csi1':1 [fmt:AYUV32/$sensordim field:none]"
> +   media-ctl -V "'ipu1_ic_prp':1 [fmt:AYUV32/$sensordim field:none]"
> +   media-ctl -V "'ipu1_ic_prpenc':1 [fmt:$outputfmt field:none]"
> +
> +Streaming can then begin on "ipu1_ic_prpenc capture" node. The v4l2-ctl
> +tool can be used to select any supported YUV or RGB pixelformat on the
> +capture device node.

Nothing for you to fix here, but we should really create some
library-like interface for media-ctl.=20
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljk1egACgkQMOfwapXb+vJ5IgCggCvxfyD4R6Us7FPjxi32EFmg
D/AAnju+IxNVTY0XcTGrgbp0gHmNfQbv
=5k4J
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
