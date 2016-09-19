Return-path: <linux-media-owner@vger.kernel.org>
Received: from ring0.de ([5.45.101.7]:54802 "EHLO ring0.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751579AbcISVab (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 17:30:31 -0400
Date: Mon, 19 Sep 2016 23:30:26 +0200
From: Sebastian Reichel <sre@ring0.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 14/17] smiapp: Remove useless newlines and other small
 cleanups
Message-ID: <20160919213025.tn7kkdicoxshphxy@earth>
References: <1473938551-14503-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938551-14503-15-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nz4pnktmuqaddrqi"
Content-Disposition: inline
In-Reply-To: <1473938551-14503-15-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nz4pnktmuqaddrqi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:22:28PM +0300, Sakari Ailus wrote:
> The code probably has been unindented at some point but rewrapping has not
> been done. Do it now.
>=20
> Also remove a useless memory allocation failure message.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--nz4pnktmuqaddrqi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4FjxAAoJENju1/PIO/qahzsP/i05GDOuVb/E3JYW3/nwNlY7
xxfZ6HMgaiPe+YvbbBfB/eXJf1vUbQ8DhBy5GZXbcDzVBTH8RlK1ZehL/jCNlt7M
cgDmPzZsLwXaFsXUm4XXNAz1uJw9qOyXtsM0L+VReN4G6zNxM74hzlnfMN7crcbp
B+siR64AXxg5Xhaj6F6ak5EIdJ9p0oj5wQXpjG77Ns/jl+85/M7pUcWNmsfcgkdo
l7J2n3LpgrIhFJe2gS80Mh1D0KQZ7jkoqSFne+EuElMGWzEi1XAYu9z3CLa4+EoZ
Yf2R2J/tsFzizS8PHkoJHOw8GlHp8HfhwdCVYQ47g7XHXo5cHp5oB1NWU26EbRJ+
RssmNeSz+edmX/Io77NGFVwBjbzmxPeVeVfZvtF2r/Jql9FijFzbjhaezm3iC5tM
SczJxZ7naFgrEyVRrDJMbJ2wneN9LiKDxw0Umqx+f18QsF9maKGR9zwV5/6xyObR
ieTvSH5TOVkK6OKjjZ4wdAKSN5jA1X2usTwRqx4p4EJ63abg7vH2Wm9SSaFgcv6w
VYRA1JYuOdlbiX7bhl4KuysELEGVYZi/iAsBQoQ9nphHpxVKKEF+C5mvRiFYatGT
1g3oDtIoTiQzB+ffFyFIFeJW1+pyNJ5NYAmt51itk8ChOo+oOgpgVRuxIEsU8rHw
nKPwmtFQff4xtktiv1gF
=HoPX
-----END PGP SIGNATURE-----

--nz4pnktmuqaddrqi--
