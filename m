Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:52646 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759307AbeD0V4f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 17:56:35 -0400
Date: Fri, 27 Apr 2018 23:56:33 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: Re: [PATCH] v4l: vsp1: Fix vsp1_regs.h license header
Message-ID: <20180427215633.xrzij4bj7hflbph7@ninjato>
References: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7b5wjbhorexlzput"
Content-Disposition: inline
In-Reply-To: <20180427214647.892-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--7b5wjbhorexlzput
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 28, 2018 at 12:46:47AM +0300, Laurent Pinchart wrote:
> All source files of the vsp1 driver are licensed under the GPLv2+ except
> for vsp1_regs.h which is licensed under GPLv2. This is caused by a bad
> copy&paste that dates back from the initial version of the driver. Fix
> it.
>=20
> Cc: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
> Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech.se>
> Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.co=
m>

Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--7b5wjbhorexlzput
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlrjnIwACgkQFA3kzBSg
Kbau5g/7BQakCaol0Ell+FDych9PWRBz+Ti6RIguRaRrLY3MLcu5G+F8nInV38OY
MsJnD0FXcII/4qACiTOjpdMIyG1whEFqCIJ+oElJpAxf5hPhCvdWJlsrGXYURX1I
ZkaBxHEONp6UZdkkztmyTssfGWr3XDQP6W3CzLUCPpgsxboIEiW4/jSv+Zujhe83
38LRTc32YFefd5eoL26rxKSgeZToBcyd/RKdVgrXDpP3rwoGDULVieY8rjBBeEdu
2pJEmVyvDTpGkggbSRbru/iTc08FW30UAL6bNkVRBpzmhECYuk1VuPHEo9hNw7sZ
yLbZOpHzY5Hkqzh/z3bAuGRCKhuNctOFsKQWqu+NPJ2MkpMOLFF046SanBy3wRFl
0OsNIyFYKYrEr1Dt9ptgf+bjHdY92P/qfJnsuZLZ1xtEENvK3B4WUBeylemvSwxt
HtV4FSogmAyXo8ak7QBfZwouRMw0Rwm2zQCQ5Ivz2phEeAV0pztzq0fObVO8mNe2
J00nWZfQNfcsvovs7vDIht6GFCTYHxEC3JHOGpxqnczYfBOPbdbNpIUkuCvNmLMt
IWtAL2pKVlOgXNYHUtVgY2lL8AwYHHh+EJgpqinu2nnc1qAFpjU8ZzSn3W7tP0zW
+omHpVBG+rHhD63anZNNv75b701knHWQiY1za4JEAh0xHx4n5KI=
=/cfh
-----END PGP SIGNATURE-----

--7b5wjbhorexlzput--
