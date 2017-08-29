Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:46302 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751512AbdH2UaW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 16:30:22 -0400
Date: Tue, 29 Aug 2017 22:30:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: julia.lawall@lip6.fr, jacmet@sunsite.dk, jglauber@cavium.com,
        david.daney@cavium.com, hans.verkuil@cisco.com, mchehab@kernel.org,
        awalls@md.metrocast.net, serjk@netup.ru, aospan@netup.ru,
        isely@pobox.com, ezequiel@vanguardiasur.com.ar,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] [media] usb: make i2c_adapter const
Message-ID: <20170829203020.i4yjro22z6t6xemt@ninjato>
References: <1503138855-585-1-git-send-email-bhumirks@gmail.com>
 <1503138855-585-5-git-send-email-bhumirks@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iuxy4r5pw2n2xcdx"
Content-Disposition: inline
In-Reply-To: <1503138855-585-5-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--iuxy4r5pw2n2xcdx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 19, 2017 at 04:04:15PM +0530, Bhumika Goyal wrote:
> Make these const as they are only used in a copy operation.
> Done using Coccinelle
>=20
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--iuxy4r5pw2n2xcdx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlmlztsACgkQFA3kzBSg
KbYQ0g/+Nzohplnc6IImXvpo78cbZk+1bo3R99SI1+iAs0obzUgKUod56zRruMr8
X2Mwzob+6bkIU4ajTu5fGU3PCTYD+067FMSY4Nt+drTtWbS3MBbrlAcP2efYfSgI
8069VYH3xNzZ9F8XeVfVjeoBJL6JfDpOo/hJwS3ZV3DZj7c8D5TSHFmIvkSHrSKW
q4aKMb6J5309TgaTSAu/4u7z3voK81C49KLi0CIxNdos+0401kMbzgkyTxI0CRAq
Yqk1J7cgLaiTNdEXAi3TsFmYeX9KJ1Ec2YGxMVesY92J00C4GNjZWvDWHTPbvUae
UpRkp9Yg7yFnG5oy71R0HISUsPXbet4FMflTnPYnaW1CPu7ktLXa0rkolfD+M0XP
CSAGiFmLn/U6WiUcwT+CPBouEvA7+pTRz4PL+lnsonoTMo21N9NfA/SFZ1e10iPb
jHzCBQQaHRQUsPWeevvR9KJQQMq9NTJ+YwiW5kjqUirC2kmVql08xpmnB30iIOu+
kr/+gqvwfB4Hrk9YcxX5wE7E9x2TM2F1+tZph/6HoYFpfAw1USY0GS90msxKteG+
vl0ftsOZ/mBif9aWgBuZy162HtuCvRQx9yNMFAjOOOT8/QO+SDFmMUHG11bpOrDJ
1akGJaaf/1ajAUmxrqBc1fq78jHc8W6e8+m4hNDVg64T+F6BCbk=
=/QqD
-----END PGP SIGNATURE-----

--iuxy4r5pw2n2xcdx--
