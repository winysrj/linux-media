Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49498 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2LJIqa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 03:46:30 -0500
Message-ID: <50C5A13D.7040908@ti.com>
Date: Mon, 10 Dec 2012 10:45:49 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	<linux-fbdev@vger.kernel.org>, <kernel@pengutronix.de>,
	David Airlie <airlied@linux.ie>,
	<devicetree-discuss@lists.ozlabs.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	<dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCHv15 3/7] video: add of helper for display timings/videomode
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de>  <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de>  <50B37EEC.6090808@ti.com> <20121126161055.GB30791@pengutronix.de>  <50B39F46.7050808@ti.com> <1354889568.2533.118.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1354889568.2533.118.camel@pizza.hi.pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigD5913F5C38A1C760756BBE03"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigD5913F5C38A1C760756BBE03
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-12-07 16:12, Philipp Zabel wrote:
> Hi,
>=20
> Am Montag, den 26.11.2012, 18:56 +0200 schrieb Tomi Valkeinen:

>> So what does the pixelclk-inverted mean? Normally the SoC drives pixel=

>> data on rising edge, and the panel samples it at falling edge? And
>> vice-versa for inverted? Or the other way around?
>>
>> When is hsync/vsync set? On rising or falling edge of pclk?
>>
>> My point here is that the pixelclk-inverted is not crystal clear thing=
,
>> like the hsync/vsync/de-active values are.
>>
>> And while thinking about this, I realized that the meaning of
>> pixelclk-inverted depends on what component is it applied to. Presumin=
g
>> normal pixclk means "pixel data on rising edge", the meaning of that
>> depends on do we consider the SoC or the panel. The panel needs to
>> sample the data on the other edge from the one the SoC uses to drive t=
he
>> data.
>>
>> Does the videomode describe the panel, or does it describe the setting=
s
>> programmed to the SoC?
>=20
> How about calling this property pixelclk-active, active high meaning
> driving pixel data on rising edges and sampling on falling edges (the
> pixel clock is high between driving and sampling the data), and active
> low meaning driving on falling edges and sampling on rising edges?
> It is the same from the SoC perspective and from the panel perspective,=

> and it mirrors the usage of the other *-active properties.

This sounds good to me. It's not quite correct, as neither pixelclock or
pixel data are not really "active" when the clock is high/low, but it
still makes sense and is clear (at least with a short description).

 Tomi



--------------enigD5913F5C38A1C760756BBE03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQxaE9AAoJEPo9qoy8lh71tfkP/3hzeIGnvSuFoVrLGiV/IyGu
2Uk+qSL1REVac/EJZGngR5nMNur+E3nAc/VqdoFPxL3eUQN64aq2/tbD+sB1HzH1
oYz0mVwzowUkGCEM1DVgtVoO9KW4HGHX0//6Jn8w1LlUSvLwJJl1NXlirsfxS5Qu
nr5XG/hzf+zfCF1lsRKxlBxY2Q0JBIL72CkPkCYdMNVpcKKNuqVNl0zGw2aGHm2M
qvo9o00rAW23DKRJOY6GPls1JDMpo+f8RGJExXvJlbONZjouNQM5lHr/UxNVrZum
Izzn7j2Q1pGupDluiNdFPXBKDn0o6aU27xSUTQCu5s3pKuJxiPKT/QBw60eueaPo
8VZvAmrxlC+zEEAwW+T+AXKWfUmnUE4fr4XmMWbg9zclOPf7pdJDJSU15pDG2TYy
5UV0TvuqeSA9MJaZnnhO7kI/YPi0KRCP3zwQf0LNestdxm+3VfpE2oINYJ2eoWq1
WxwQ7SnX/HDuaeCNIcaZB6U5dQ98M0ziyNy7P9aS0dN46CnSYTmLm+h2yhk6eFkS
TvST+YWV+Be3BFVppoH31ICkNotKBI2qGfVH6GcCjXtp1S9N45tC5HbojBLlwze3
SGTb5ZkbV/SHib/OnZtzW+P/+bbmIOplySOf9RQ9zFlf/1mGThXgEEbp36U1lic6
Izb71Op2WrU2TebUsesg
=BhOc
-----END PGP SIGNATURE-----

--------------enigD5913F5C38A1C760756BBE03--
