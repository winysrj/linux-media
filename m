Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:61949 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754774AbdBQJpr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 04:45:47 -0500
Subject: Re: [Patch 0/2] media: ti-vpe: allow user specified stride
To: Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>
References: <20170213130658.31907-1-bparrot@ti.com>
CC: <linux-kernel@vger.kernel.org>, Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <2aeeb8ff-879d-9f56-9b4d-3e8b01c880a2@ti.com>
Date: Fri, 17 Feb 2017 11:45:41 +0200
MIME-Version: 1.0
In-Reply-To: <20170213130658.31907-1-bparrot@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="sfEShDcD6BC5jWu0unwRqO0tm76N4dJMo"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--sfEShDcD6BC5jWu0unwRqO0tm76N4dJMo
Content-Type: multipart/mixed; boundary="79kbN1Ahmd7U2KcoE2GegR4KrvxPNskHT";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Benoit Parrot <bparrot@ti.com>, Hans Verkuil <hverkuil@xs4all.nl>,
 Mauro Carvalho Chehab <mchehab@osg.samsung.com>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jyri Sarha <jsarha@ti.com>,
 Peter Ujfalusi <peter.ujfalusi@ti.com>
Message-ID: <2aeeb8ff-879d-9f56-9b4d-3e8b01c880a2@ti.com>
Subject: Re: [Patch 0/2] media: ti-vpe: allow user specified stride
References: <20170213130658.31907-1-bparrot@ti.com>
In-Reply-To: <20170213130658.31907-1-bparrot@ti.com>

--79kbN1Ahmd7U2KcoE2GegR4KrvxPNskHT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 13/02/17 15:06, Benoit Parrot wrote:
> This patch series enables user specified buffer stride to be used
> instead of always forcing the stride from the driver side.
>=20
> Benoit Parrot (2):
>   media: ti-vpe: vpdma: add support for user specified stride
>   media: ti-vpe: vpe: allow use of user specified stride
>=20
>  drivers/media/platform/ti-vpe/vpdma.c | 14 ++++----------
>  drivers/media/platform/ti-vpe/vpdma.h |  6 +++---
>  drivers/media/platform/ti-vpe/vpe.c   | 34 ++++++++++++++++++++++++---=
-------
>  3 files changed, 31 insertions(+), 23 deletions(-)

Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>

 Tomi


--79kbN1Ahmd7U2KcoE2GegR4KrvxPNskHT--

--sfEShDcD6BC5jWu0unwRqO0tm76N4dJMo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYpsZFAAoJEPo9qoy8lh71Tw8QAIINJbP3Zzp23+2BUYX+gyNE
NSwyOtP9q52/KhqZcFqjTSmC1dyTWH/yTw9sh0LqKMgrj0qXl7WlLuqvy0Noc4C7
j/lFx282fm9F8hMVBKkaU0cBiOcyqQHQXMysA46St+SaAQ4vGgUM2pnTpCW40A57
YRD3ES0myru7ruX1YbGZljukbni1UHeuqxlKBjpAr9NN20TOwurHtiGGOJaEohyi
ljZ4KtkBIaVvFEW/HdO58iqCHufjUbLlrD0hVT47lobr4Ho0cAdVFUWDPt2nhiwE
J/+czJeib+Ag7PzUmQcN09EqVHmrrgI/16VjS6PmN41FeF5RMQiP+idi9J3w2FVl
5QlAEZxyiM+NFTAknnhSWCLhzHSLl9MH2bkT4zaIoeKR1cftmYiB1iHvjNGkEjZt
eXcE9bMxq7KdS0BD4QsNIFZInPrzvW5SazAw5tG6BWSBLRPfC5mjvTOv5XMQefi1
yptVkxakGQ5MOFWsSrRSHtgUn8gFVsdypNmgpZGLhAsAWmHLhtW8gE6H0u/xgei2
A4IoRGrMObjZO80LEs0B+EZIAAppCWkWcYKKnrulDr3fOZWzwHHN1N6QD7oNzufq
FqbM5BdocwOS+H67EQCXbpxTTmL8LMIdQUmiaD8tskXcgr/FSiGhVLjsuJUJIGea
jIOS9objwJhSpnZA3e0+
=D1dD
-----END PGP SIGNATURE-----

--sfEShDcD6BC5jWu0unwRqO0tm76N4dJMo--
