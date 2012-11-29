Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:47784 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab2K2Jae (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 04:30:34 -0500
Message-ID: <50B72B34.6080808@ti.com>
Date: Thu, 29 Nov 2012 11:30:28 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <hvaibhav@ti.com>, <linux-media@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>,
	Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com> <1421983.jJNXU7RvjW@avalon>
In-Reply-To: <1421983.jJNXU7RvjW@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1E1569D2376A14706E77B630"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig1E1569D2376A14706E77B630
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-28 17:13, Laurent Pinchart wrote:
> Hi Tomi,
>=20
> On Monday 12 November 2012 15:33:38 Tomi Valkeinen wrote:
>> Hi,
>>
>> This patch removes use of cpu_is_* funcs from omap_vout, and uses omap=
dss's
>> version instead. The other patch removes an unneeded plat/dma.h includ=
e.
>>
>> These are based on current omapdss master branch, which has the omapds=
s
>> version code. The omapdss version code is queued for v3.8. I'm not sur=
e
>> which is the best way to handle these patches due to the dependency to=

>> omapdss. The easiest option is to merge these for 3.9.
>>
>> There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last =
OMAP
>> dependency in the omap_vout driver. I'm not going to touch that, as it=

>> doesn't look as trivial as this cpu_is_* removal, and I don't have muc=
h
>> knowledge of the omap_vout driver.
>>
>> Compiled, but not tested.
>=20
> Tested on a Beagleboard-xM.
>=20
> Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks.

> The patches depend on unmerged OMAP DSS patches. Would you like to push=
 this=20
> series through linuxtv or through your DSS tree ? The later might be ea=
sier,=20
> depending on when the required DSS patches will hit mainline.

The DSS patches will be merged for 3.8. I can take this via the omapdss
tree, as there probably won't be any conflicts with other v4l2 stuff.

Or, we can just delay these until 3.9. These patches remove omap
platform dependencies, helping the effort to get common ARM kernel.
However, as there's still the VRFB code in the omap_vout driver, the
dependency remains. Thus, in way, these patches alone don't help
anything, and we could delay these for 3.9 and hope that
omap_vout_vrfb.c gets converted also for that merge window.

 Tomi



--------------enig1E1569D2376A14706E77B630
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQtys0AAoJEPo9qoy8lh71j/wP/RmpUGLbU2L3uAozPqw2os6U
nTT81JEzJNn5WsVvRbywdS27MtqJjvVl9xWHJBomQVeZ7dYQLJqaC6tPihY2fV50
2PUe4vHHVIeMDYxAHA1xzm28/3awz5slogxF4tefLbzYdSuhATtZrliS3z5Kr5rH
eV5Fs9kQ98tdEXZf+sfJ44IdEbjFhsLFulytvpmpkADaM4R0uI1bnaU7x7/4e8lE
1I3tH8sJhkdHmL4wshXiurfPElGq1KiPcj2jd+8PB+vH+u8EOhDewtHhmNa6SOaV
+/GHLw11u81C4wBlEbcl8XSSqvJZ2qgyEUkW7hLQ8G7JaTsbvDHpLj8F8oAfD/XG
dimNIoYxowZ8x9Cb7WVlB6age/zwaJ2eixHAcJEREEa5aEuW5sh9L0ZwpumAqFej
fUdVD8FJ0fuoohmsR0JQAflFqp6RDXoAKFMVSyVZpqX55KtckLAV9ImsQfyJztTi
siOyHTyGwE9ovOi8+sQMT/OKNzWG1mGpWSuGzs/gPaKA82WpmAYPcKsloXJlt8yl
FM9WhEFtXfUAhYIbfw02pWPu0dDsCqni0GyOhGAQZMN9R3eRRBiIGYHT5yq8A1vy
mxBPzItE5p8XpNvSU2L/7U7/K8phVhqPXg5loIEQG59EAYWSXuCKYS18ilUNc0Ti
GNyXNvFCy5LHfrUQ5lx8
=pGaO
-----END PGP SIGNATURE-----

--------------enig1E1569D2376A14706E77B630--
