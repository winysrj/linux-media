Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932424AbcISVWE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:22:04 -0400
Date: Mon, 19 Sep 2016 23:21:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/17] smiapp: Obtain frame layout from the frame
 descriptor
Message-ID: <20160919212157.c3tnp72yufmqmyxm@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-13-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="biogmpq4wkzf7udp"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-13-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--biogmpq4wkzf7udp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:26PM +0300, Sakari Ailus wrote:
> Besides the image data, SMIA++ compliant sensors also provide embedded
> data in form of registers used to capture the image. Store this
> information for later use in frame descriptor and routing.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

> [...]
>
> +	if (sensor->embedded_end > sensor->image_start)
> +		sensor->image_start = sensor->embedded_end;

Maybe add a dev_dbg about sensor format information being broken?

-- Sebastian

--biogmpq4wkzf7udp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4Fb1AAoJENju1/PIO/qaMcEP/3FYIhXwcspXcV4VtI6/x6n5
qJzxeFLuUfYolOG0xzoDCYjrKUAvHAKJP6ogSp5tuK9l+1kwt6atKpNpbjMgI9QI
o4KfjEqP5p8Rp0CwfHnbiDeRLiF4bhIdIOh4LTCBZ3W/5AuOGW1Jz+inSFQEJ+BT
Uqrskyx4DHrnYDeEyBY5zyueMtz8tZG1aaiB/YOuzpioAhE4BvR3wgcmwsLPuxho
0wTanLdKE0MHCx4SLJpJPPV59jdJgWGVNj4YuTJlw5Dyb+CcI8Y+thrq8efEz8sS
kRXuTGcogidKqefARSaRP3qPqvYfoZbuC2PGNHsZV5e0wC5v0bmkTjSOASsWuZuR
PLxeeJ4PvHFcFAM4Fx3WWaLaKDIVA1n4PTLKkAt0Echumi7rzxSNj09LcFDN/mIZ
c83Wc/xD6JA+8dnajcYj8MvZU24hREbs9YhEVbcmv9nWb1pdDVUCGPSB4r9GOsU0
ElXBll4aecEzrqKHJos3NTXzIBe0ujLkrluvayCrTLkluaZz8x+tRjUGS+hWei8L
GtLibZVSPMDVsjw2E7kMmnZvbMzVZdnRS8U19TNSh+9sttvzTLO5YGTLrvP8awWs
A8I6Vc6Om2yVBSjAaJhO7e6eIK9vGdqFqdkNSadhtRTKzG7duMxcrl86XaK87pCv
wu5ehH2lcT364sWpQyzG
=LhAR
-----END PGP SIGNATURE-----

--biogmpq4wkzf7udp--
