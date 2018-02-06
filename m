Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:38002 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbeBFN5y (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 08:57:54 -0500
Date: Tue, 6 Feb 2018 14:57:51 +0100
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
Message-ID: <20180206135751.o7z7sxs3xtm5kbag@ninjato>
References: <20180205201002.23621-1-wsa+renesas@sang-engineering.com>
 <20180206131044.oso33fvv553trrd7@mwanda>
 <alpine.DEB.2.20.1802061414340.3306@hadrien>
 <20180206132335.luut6em3kut7f7ej@mwanda>
 <alpine.DEB.2.20.1802061439110.3306@hadrien>
 <20180206135310.deiaz55xemc26xn4@ninjato>
 <alpine.DEB.2.20.1802061453440.3306@hadrien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mahk6tikjhx33ffa"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802061453440.3306@hadrien>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mahk6tikjhx33ffa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I did that too but got no results.  Perhaps right shifting constants is
> pretty uncommon.  I can put that in the complete rule though.

Please do. Even if rare, we would want this bug pointed out, right? :)


--mahk6tikjhx33ffa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlp5tF8ACgkQFA3kzBSg
Kbaulg//Uy+7N6z27n0M2XlhBexh66B4hi11mW+Iajq+i8SUCUOOByD4uW//bBTb
JuPWFvFlhQXZ+PyegluGubEH8k/pLeLU30NAKgGsy4+/p32PRFaJ/L91RtZw9Cv+
r6yK2nnVIrkrWNV2xzT6sWDItCmejBpa6AyziTHFfyMNggc4keI7/AovCVxDgFTi
BKws/o6zU9/jDJosdWrxHU3e0qmDhgYCWUP7atQKReksZdpFqLqSrW3SyjSAR4xa
ZNLGwx/O8tCFUDrRrvUschbt38ou/QMJY7+4vF2lYTu3/hRKWBjIty8XbxU3N0i0
A6W/vtEn9dyj+IPSkQHklgKmg3boCAbkCq1RK17R0bzkkUgODbZYdyIvx3SsTtjF
v/6LpnVIZTauPlhDMjpwOQyAj3qXUdlvx7h2Fw/BZhYbN+LLGTYHzCNTtiJ1r3aP
VlESEFJ5ogRYSX5q6NJGgDt0rhOxWCLSWaqG0t0w7+10Z0fDnglV+hdEp50Y/UTt
A8wwLFu1q0pf35+DZJVzRuDeMeWQKEhrYd8XQRMEekU6x3cCD8afCGlrnXBmMIMF
qhP+Xuba6Bi5rkKYOhDuKuLPYt+LNW6oXfnuNJfnje07SbMMkUU8EeUiBBUIVGNi
eBiMpVD5lUZz9lzCOqF03aqq7H4ACLUwG9efHTdeewL/moEGIAw=
=QEjS
-----END PGP SIGNATURE-----

--mahk6tikjhx33ffa--
