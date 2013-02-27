Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:38728 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049Ab3B0QOP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 11:14:15 -0500
Message-ID: <512E30BD.7010603@ti.com>
Date: Wed, 27 Feb 2013 18:13:49 +0200
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
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH v17 2/7] video: add display_timing and videomode
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de> <1359104515-8907-3-git-send-email-s.trumtrar@pengutronix.de> <51223615.4090709@iki.fi> <512E2A1B.6040704@ti.com> <20130227160540.GA10491@pengutronix.de>
In-Reply-To: <20130227160540.GA10491@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig6E8BABB66675C1BD3801463B"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig6E8BABB66675C1BD3801463B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-27 18:05, Steffen Trumtrar wrote:
> Ah, sorry. Forgot to answer this.
>=20
> On Wed, Feb 27, 2013 at 05:45:31PM +0200, Tomi Valkeinen wrote:
>> Ping.
>>
>> On 2013-02-18 16:09, Tomi Valkeinen wrote:
>>> Hi Steffen,
>>>
>>> On 2013-01-25 11:01, Steffen Trumtrar wrote:
>>>
>>>> +/* VESA display monitor timing parameters */
>>>> +#define VESA_DMT_HSYNC_LOW		BIT(0)
>>>> +#define VESA_DMT_HSYNC_HIGH		BIT(1)
>>>> +#define VESA_DMT_VSYNC_LOW		BIT(2)
>>>> +#define VESA_DMT_VSYNC_HIGH		BIT(3)
>>>> +
>>>> +/* display specific flags */
>>>> +#define DISPLAY_FLAGS_DE_LOW		BIT(0)	/* data enable flag */
>>>> +#define DISPLAY_FLAGS_DE_HIGH		BIT(1)
>>>> +#define DISPLAY_FLAGS_PIXDATA_POSEDGE	BIT(2)	/* drive data on pos. =
edge */
>>>> +#define DISPLAY_FLAGS_PIXDATA_NEGEDGE	BIT(3)	/* drive data on neg. =
edge */
>>>> +#define DISPLAY_FLAGS_INTERLACED	BIT(4)
>>>> +#define DISPLAY_FLAGS_DOUBLESCAN	BIT(5)
>>>
>>> <snip>
>>>
>>>> +	unsigned int dmt_flags;	/* VESA DMT flags */
>>>> +	unsigned int data_flags; /* video data flags */
>>>
>>> Why did you go for this approach? To be able to represent
>>> true/false/not-specified?
>>>
>=20
> We decided somewhere between v3 and v8 (I think), that those flags can =
be
> high/low/ignored.

Okay. Why aren't they enums, though? That always makes more clear which
defines are to be used with which fields.

>>> Would it be simpler to just have "flags" field? What does it give us =
to
>>> have those two separately?
>>>
>=20
> I decided to split them, so it is clear that some flags are VESA define=
d and
> the others are "invented" for the display-timings framework and may be
> extended.

Hmm... Okay. Is it relevant that they are VESA defined? It just feels to
complicate handling the flags =3D).

>>> Should the above say raising edge/falling edge instead of positive
>>> edge/negative edge?
>>>
>=20
> Hm, I used posedge/negedge because it is shorter (and because of my Ver=
ilog past
> pretty natural to me :-) ). I don't know what others are thinking thoug=
h.

I guess it's quite clear, but it's still different terms than used
elsewhere, e.g. documentation for videomodes.

Another thing I noticed while using the new videomode, display_timings.h
has a few names that are quite short and generic. Like "TE_MIN", which
is now a global define. And "timing_entry". Either name could be well
used internally in some .c file, and could easily clash.

 Tomi



--------------enig6E8BABB66675C1BD3801463B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRLjC9AAoJEPo9qoy8lh71m+0P/RPDx491Eic5r4Yc0NlEDMf0
VL64T3j2dns71crKbMkctgiPOBZDjCzp08xd4UsqNj7hkgu94p+5OyHfmZXq7xJw
ycJElBI+1y3IhnRWOq+vUgUlGgUFPfDY1OeyKflk8dTK/HwcQex3yyt//kLJS4Ge
971IZrkVPFnUi00LTgxOf2wVIq5bms+sEG0hbGes7qFkejfkYDMNIUNVt2nRXpf7
aC8SpmPOsOp5MDeTKCP17m0N8/A7rGM03O9PV6L+xvq6sDRRaBHwLhQG3sCMnvP+
3OCTmB9EDJOYxmLIu9aqCT0RccZl+y61HYZJm7aXO8iZ+G4NK/62wbO5UDJB7hvl
6/KIDWM1kz33jynXVOB8aLViyabQ9bqaWGo5waKJKelsZb8G7JrHpfJC/JiN6krv
LofFbl+C8UEI3kRoDhJ4MZX2OkFy+HeAMQHSKkLUwAYoA9OamgIDK5Em6P1W0X6V
N1gfDxXbXW5wJ+YBDhs6eauZzVvPNWmWZbB4vL+5JX0et+QtBypEwX56lVUZ7bOD
cQA762XeYHGkiruzx7idxuw29w9lK7J1xHVqnu6PfLf5Lndgv+lFzphepz1v6mCx
zJUiDNp/3l8U86eOfoRmriFr2l90i7hkOWQLy1cibBy/gip/KiDtWdWJExvkRkmA
i1TyIWKhCK+12h3e7//4
=Lf4m
-----END PGP SIGNATURE-----

--------------enig6E8BABB66675C1BD3801463B--
