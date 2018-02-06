Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:37952 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750990AbeBFNxM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 08:53:12 -0500
Date: Tue, 6 Feb 2018 14:53:10 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] tree-wide: fix comparison to bitshift when dealing
 with a mask
Message-ID: <20180206135310.deiaz55xemc26xn4@ninjato>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
 <20180206131044.oso33fvv553trrd7@mwanda>
 <alpine.DEB.2.20.1802061414340.3306@hadrien>
 <20180206132335.luut6em3kut7f7ej@mwanda>
 <alpine.DEB.2.20.1802061439110.3306@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nv4vdnzmkzj6i6tc"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802061439110.3306@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nv4vdnzmkzj6i6tc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Julia,

> and got the results below.  I can make a version for the kernel shortly.

It should probably take care of right-shifting, too?

Thanks,

   Wolfram


--nv4vdnzmkzj6i6tc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlp5s0IACgkQFA3kzBSg
KbZnMhAAtcrOwmDhNVIvu1qLxCpz0Xl6aCJJhY0/KEasBtIo5m/FnhexSgHvEEob
O1I2LBjvA4zVL97MC/HFwVQswap8pi9UiGitOE/eq1rKeUa6htla/YLFEXKCesAx
hj/W26/hc755ZjIzo5uQN9/sno6YV2E9nVeEvW+9mtnWyglwek1cT6Lhd1Oaqt3N
c86qDxwPgSAiu20rwkb6HSVoRDFGzLYJXgnlgKajQorK05iIkosiUvwOYVj8pjR7
JvygMZBIE4Qo3jjVCyDZ7rWiWWUdjV3Suk54TPuttPOEzcyyFMy72lWyP6liN9CD
qVRLx7q8eRtOJux+rrm/HwlRjL+rFFTq2mplbhZPDsW2Pzwj/KjSqdXSQa1DGael
uAREsa2dfWTtrXasUfvsFYNIIdeaFuCvjXzLP0QTQG52NG/80Lr+/NzDuIXKz573
xo4IgwA3WLGPcglZRjDpYyjyHxjY2gx4aV+qoMo8Pjyz+hqeggUb2mMRHDJ1p60+
4DxF+TjefKuwBhcZ4UQOAOo2rU8Cm0ToJDx5fw1swge9KL9H9QO71MT7zW6k43+U
9XLN5z7ZUXqO+7fH11tUuU3n/WLvMXwHiRkIP8gbX0Xavyyc1C5EecFpw3r9Uwqr
4uXuZVvNkUYWddXemoLVnzIGJf8jC3onir7DqXfg53T8QMVqjZE=
=yQRN
-----END PGP SIGNATURE-----

--nv4vdnzmkzj6i6tc--
