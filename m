Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56756 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3JXKwj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Oct 2013 06:52:39 -0400
Message-ID: <5268FBE3.80000@ti.com>
Date: Thu, 24 Oct 2013 13:52:19 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	<devicetree@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, Dave Airlie <airlied@gmail.com>,
	<linux-media@vger.kernel.org>, <sylvester.nawrocki@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFR 2/2] drm/panel: Add simple panel support
References: <1381947912-11741-1-git-send-email-treding@nvidia.com> <3768216.eiA2v5KI6a@avalon> <525FD8DD.3090509@ti.com> <1853455.BSevh91aGB@avalon>
In-Reply-To: <1853455.BSevh91aGB@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="2P4B5XH29PRSXwTvPdhRtp9DkMRCR1cxq"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--2P4B5XH29PRSXwTvPdhRtp9DkMRCR1cxq
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 24/10/13 13:40, Laurent Pinchart wrote:

>> panel {
>> 	remote =3D <&remote-endpoint>;
>> 	common-video-property =3D <asd>;
>> };
>>
>> panel {
>> 	port {
>> 		endpoint {
>> 			remote =3D <&remote-endpoint>;
>> 			common-video-property =3D <asd>;
>> 		};
>> 	};
>> };
>=20
> Please note that the common video properties would be in the panel node=
, not=20
> in the endpoint node (unless you have specific requirements to do so, w=
hich=20
> isn't the common case).

Hmm, well, the panel driver must look for its properties either in the
panel node, or in the endpoint node (I guess it could look them from
both, but that doesn't sound good).

If you write the panel driver, and in all your cases the properties work
fine in the panel node, does that mean they'll work fine with everybody?

I guess there are different kinds of properties. Something like a
regulator is obviously property of the panel. But anything related to
the video itself, like DPI's bus width, or perhaps even something like
"orientation" if the panel supports such, could need to be in the
endpoint node.

But yes, I understand what you mean. With "common-video-property" I
meant common properties like DPI bus width.

>> If that can be supported in the SW by adding complexity to a few funct=
ions,
>> and it covers practically all the panels, isn't it worth it?
>>
>> Note that I have not tried this, so I don't know if there are issues.
>> It's just a thought. Even if there's need for a endpoint node, perhaps=

>> the port node can be made optional.
>=20
> It can be worth it, as long as we make sure that simplified bindings co=
ver the=20
> needs of the generic code.
>=20
> We could assume that, if the port subnode isn't present, the device wil=
l have=20
> a single port, with a single endpoint. However, isn't the number of end=
points=20

Right.

> a system property rather than a device property ? If a port of a device=
 is=20

Yes.

> connected to two remote ports it will require two endpoints. We could s=
elect=20
> the simplified or full bindings based on the system topology though.

The drivers should not know about simplified/normal bindings. They
should use CDF DT helper functions to get the port and endpoint
information. The helper functions would do the assuming.

 Tomi



--2P4B5XH29PRSXwTvPdhRtp9DkMRCR1cxq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSaPvjAAoJEPo9qoy8lh71N+QP/2YpqUNY0oNTGdphnPRXXRdW
Drde4D+1hf+/QfhIBsOkw06iI5jB99rwhQw9BUSk0rSrPW3pIdOGG+R9/7CeeNRa
rozcFb1Yk7LUHkVbDyRbdnd2cj9UGSNJ7iwpWZ/FKN3ZKLK3XF9PiXa7bwa9wUm0
JzryacTvJ5ySl1LJFpjpq4PScPZmO+Pa47lOwALAKCiphy9C2HFJU4PQlWW7nmcU
hz2UcswXTgQXoAiPuwevjke5boi5jN0hp8pAMpt9bWqfSBzniQoRep/cIoKm7XVZ
ckHdvVM95YqTcYTgGpy1IDd6+0BqO7TCRAQFNQav7jk6WV5ojVA8PNrjkwCLyPQV
PN8fALI++JMmjdJ4G12Wf0jQ4tuoe8Qx3x/oS/Lj7U+oVFbq06JKznNO2+guN2z4
Pr95xhr9Gq0s8myRnQABi8t0a3kWWRe+V5/40UhbPyt4VChjjKVKpvpFprGtPHWK
io4XJVwqS2+MJ1I21ZxzRbEcQZT/exKm+5dYqHWVX6zYuEs2nqM0icLZI+XQMEya
aFdD5ZvntOx7F41Uu6IKqr64URKidpacUuho/Ecbtz10E+qtE9eiCyxCV1lBpURZ
YEhiS7TDDsBdFyJQXDs8hwY2wNtntJNsaQDfpYwAQtRTVGV/LVLfaPYfOW71xP2Q
TD01Gc94dWgS8xusCCBg
=NDX3
-----END PGP SIGNATURE-----

--2P4B5XH29PRSXwTvPdhRtp9DkMRCR1cxq--
