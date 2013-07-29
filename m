Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42103 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab3G2GTu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 02:19:50 -0400
Message-ID: <51F6097F.4080001@ti.com>
Date: Mon, 29 Jul 2013 09:19:43 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: =?UTF-8?B?SmFrdWIgUGlvdHIgQ8WCYXBh?= <jpc-ml@zenburn.net>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [omapdss] fault in dispc_write_irqenable [was: Re: [omap3isp]
 xclk deadlock]
References: <51D37796.2000601@zenburn.net> <1604535.2Z0SUEyxcF@avalon> <51E0165C.5000401@zenburn.net> <3227918.6DpNM0vnE9@avalon> <51F22A58.9030208@ti.com> <51F297C0.1080501@zenburn.net>
In-Reply-To: <51F297C0.1080501@zenburn.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="QaAjisiEe27KviIvkENUw4ao8WOOltrEr"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--QaAjisiEe27KviIvkENUw4ao8WOOltrEr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26/07/13 18:37, Jakub Piotr C=C5=82apa wrote:

>> Using omapfb, or...? I hope not
>> omap_vout, because that's rather unmaintained =3D).
>=20
> Laurent's live application is using the V4L2 API for video output (to
> get free YUV conversion and DMA) so I guess this unfortunatelly counts
> as using omap_vout. Are there any alternatives I should look into? IIUC=


Ok. Do you have a call trace for the dispc_write_irqenable crash? Maybe
it's something simple to fix.

 Tomi



--QaAjisiEe27KviIvkENUw4ao8WOOltrEr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJR9gl/AAoJEPo9qoy8lh71ORUQAIUfj44UMv0qhTgtlnV1zuA0
k11GDjpzWH438vUdR7GZwey4Nea2eoMsajk+Sp4WzWg0IrfAztHQpWV+s2ro6pIZ
pUPHaaq0FiH33Xa4u+au8HDc9INgpj6xKiLaTXdqCh7YWvuiTCdgal3YNASBzfBl
Se3MguIKW8irRhu8h9FHXotZZW5wbgSm7/0rcmwQX/jQWjIQ25C3nr+yROIQ6bXU
rQIBMhqblaO06G0KqmXxMod9clwAM4kX+C8IXTWdhFmBge17kTddaSW3hmjwHrub
qdYUqM2RcE475eUD2/tVz4apB0Y9ZOejKRWlS9kQiHOuKpFcl6SdkJqbrWlG5dCu
l2BctDZU7eLvHopv+Ni2LanjqUQVGgN8v3klaA2xTVnK9tbmknlpmB2VklUTaMjy
drNMCQFlt3rBi4fJH4tDS3Bswk0BaN3houjxEXix7jaLPuW8Cw5+Yo4Orb0u9PJD
/OgQ8y3V/9V5Ow82ZmCQg880y5YJGljA2Q8gGXvsX0aEoGXYlFdbCOhI3nswwqxC
vDFqUj0iOpoPbX2SeCDVV+HTgK2NwAmBgutytfLAUTJVpF5oEqDGyJUqFWG6yFm5
RGOFx9GRGpKMBDdKEj0C6xlYukxWZJehMCUb7u9l2wu8t5Fu3uAfnscFJnHwbLYJ
mke/YCJ5mmntdV30ux7v
=O3dO
-----END PGP SIGNATURE-----

--QaAjisiEe27KviIvkENUw4ao8WOOltrEr--
