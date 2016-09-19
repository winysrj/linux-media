Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753103AbcISUdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 16:33:22 -0400
Date: Mon, 19 Sep 2016 22:33:15 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 05/17] smiapp: Provide a common function to obtain
 native pixel array size
Message-ID: <20160919203314.ctgbi2moxkgpqxmh@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-6-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jwz2omkgc7tsodjn"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-6-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--jwz2omkgc7tsodjn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Thu, Sep 15, 2016 at 02:22:19PM +0300, Sakari Ailus wrote:
> The same pixel array size is required for the active format of each
> sub-device sink pad and try format of each sink pad of each opened file
> handle as well as for the native size rectangle.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--jwz2omkgc7tsodjn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4EuKAAoJENju1/PIO/qaKjMP/2eopFuDCNuE1yUWs3lOYO91
yLR8R05jxF4H4jqYW8A72v+pvj2B1SBNmqBzS8CFL8PULjFdtKRGoEixRGFpGsX/
OtN4T8Gv+ym4+aufxgbzpK0NHlgOjbocHul6aXqbqpnbozUrVaNiOUGUfzEqUir5
XsH4vkR8/TLhy8I72PWx7Oz198naTHEIOv4jYKa1ULnDHK457+i97PgI6Yd9vW/5
X8xGY9A1e1NAtIQ4K/BscNPzTqIfBK/7ctEXvFNXebC+KyOUsX+OrHq0vlZ0k1q2
DUUbMwJbb47Ci6dnAGWyECsWMqr5CGaGf+6P33w5Rn+RAMq6iTSzxbelTaItz+iz
2Xm0htAs1WGTGHsr9Xfu9NbtBy3P0u+97ZLlZme3gQ9szFVrCEAtnsok94N0HnSZ
FO9gRFJjalbiU+wB4LcHndzI2Du4c3ogyfKW1Sw1JU5a9NpsERoowhTWD3iDDAUm
beQoa1LN+8ffznjNya9L10+qG++j10vXnc7pDXA5MfVNjETogmcE4NbYl10fNoXL
EYGoyNoxV7JAit/R4zXaRlCNTQoVcaDsFVAZxx9PdsKuzQZy3kNNT7AweOaYpv9Y
1/sJo/Fw496Mpx0R8ndNDX3fVffEJF57A2CeSN9WbiwUDFQPkZ0HP8ajjZlItVds
i7aZGaboDgNvEH8AkyWw
=Mboc
-----END PGP SIGNATURE-----

--jwz2omkgc7tsodjn--
