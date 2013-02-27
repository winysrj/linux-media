Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:39461 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943Ab3B0PqQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:46:16 -0500
Message-ID: <512E2A1B.6040704@ti.com>
Date: Wed, 27 Feb 2013 17:45:31 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Dave Airlie <airlied@linux.ie>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH v17 2/7] video: add display_timing and videomode
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de> <1359104515-8907-3-git-send-email-s.trumtrar@pengutronix.de> <51223615.4090709@iki.fi>
In-Reply-To: <51223615.4090709@iki.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig8D4F70B7470859BB845B6389"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig8D4F70B7470859BB845B6389
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ping.

On 2013-02-18 16:09, Tomi Valkeinen wrote:
> Hi Steffen,
>=20
> On 2013-01-25 11:01, Steffen Trumtrar wrote:
>=20
>> +/* VESA display monitor timing parameters */
>> +#define VESA_DMT_HSYNC_LOW		BIT(0)
>> +#define VESA_DMT_HSYNC_HIGH		BIT(1)
>> +#define VESA_DMT_VSYNC_LOW		BIT(2)
>> +#define VESA_DMT_VSYNC_HIGH		BIT(3)
>> +
>> +/* display specific flags */
>> +#define DISPLAY_FLAGS_DE_LOW		BIT(0)	/* data enable flag */
>> +#define DISPLAY_FLAGS_DE_HIGH		BIT(1)
>> +#define DISPLAY_FLAGS_PIXDATA_POSEDGE	BIT(2)	/* drive data on pos. ed=
ge */
>> +#define DISPLAY_FLAGS_PIXDATA_NEGEDGE	BIT(3)	/* drive data on neg. ed=
ge */
>> +#define DISPLAY_FLAGS_INTERLACED	BIT(4)
>> +#define DISPLAY_FLAGS_DOUBLESCAN	BIT(5)
>=20
> <snip>
>=20
>> +	unsigned int dmt_flags;	/* VESA DMT flags */
>> +	unsigned int data_flags; /* video data flags */
>=20
> Why did you go for this approach? To be able to represent
> true/false/not-specified?
>=20
> Would it be simpler to just have "flags" field? What does it give us to=

> have those two separately?
>=20
> Should the above say raising edge/falling edge instead of positive
> edge/negative edge?
>=20
>  Tomi
>=20



--------------enig8D4F70B7470859BB845B6389
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRLiobAAoJEPo9qoy8lh71288P/1mHpTBjp+F4XUAKRdQ1KaaX
EIvTd8/DjltO8lTrXsIE7aYIfsHIAVNayTYdwRyxUNwMM+rvN1xFwSxVXV3dfJUV
yGihyg5zFNwFQoNZ+H0kzGYZyjWa6by2ILu39lGSnKDs+4MZby2QlxLjQXrLIlUe
xVqUrxUVLf2+iaHUhrdoi/ZZmE8qK1qzTCI4mmZtyQWkXgop11c+xKgWCoDvPtnd
mnwtVOPdUW+TLg2TVfVUHoY87fxk+mNvC7cm8n25LdTwDHEwT8FCyduAWRveJqYb
x3vctW0Fz1cqS/0mZ6MFT9OExy9DbyYMVZ4YgNX1jupeNT6V6kiKR9+31vs8M6lP
rK54jhudTOe7eB20561VD3vKiT1O5GUn2KPj3tL8P2CxF4xKWy4gvEHHv7s4wvmR
rbUARk2E9D4gl0UhW1y20nurTxMw6xGRGaD4PRRXH8F1c6rnho8Qgc1SXlI40OKj
0ta3uN1DFQS8LGCV6BfEffB5LmpuByEjoO/hJ2kjunUSSrdYxHgbq1vRSM6ACe6b
1tME9pfQmM2VCn8x+ECehEsDoawx2yBJvfwk0JDz0sTvZaz92tsrx8ORL/zxuiKc
6jsaZwrmCNnYCs+dSJRSFWnn9AG8nbSnMO+6815TEADHxLTvZew5BNkd95SzLAFi
QAg2E8INo4IOxs84Hs9J
=9R2k
-----END PGP SIGNATURE-----

--------------enig8D4F70B7470859BB845B6389--
