Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:59455 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756809AbcKXIzJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 03:55:09 -0500
Subject: Re: [PATCH] [media] ti-vpe: get rid of some smatch warnings
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <af93189d4ebc7851eb387145d0ea8db52698308e.1479812941.git.mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
Message-ID: <f2565f83-6907-184e-6e1d-1700aa2bff60@ti.com>
Date: Thu, 24 Nov 2016 10:54:33 +0200
MIME-Version: 1.0
In-Reply-To: <af93189d4ebc7851eb387145d0ea8db52698308e.1479812941.git.mchehab@s-opensource.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature";
        boundary="EnhpFx3gUIhMUw3e7MXtpifX7BQmBlsFE"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--EnhpFx3gUIhMUw3e7MXtpifX7BQmBlsFE
Content-Type: multipart/mixed; boundary="Uae7P2C6JMDRDP3QuqrOmtqaOJQIM4T7B";
 protected-headers="v1"
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
 Mauro Carvalho Chehab <mchehab@infradead.org>, Benoit Parrot
 <bparrot@ti.com>, Mauro Carvalho Chehab <mchehab@kernel.org>,
 Hans Verkuil <hans.verkuil@cisco.com>
Message-ID: <f2565f83-6907-184e-6e1d-1700aa2bff60@ti.com>
Subject: Re: [PATCH] [media] ti-vpe: get rid of some smatch warnings
References: <af93189d4ebc7851eb387145d0ea8db52698308e.1479812941.git.mchehab@s-opensource.com>
In-Reply-To: <af93189d4ebc7851eb387145d0ea8db52698308e.1479812941.git.mchehab@s-opensource.com>

--Uae7P2C6JMDRDP3QuqrOmtqaOJQIM4T7B
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 22/11/16 13:09, Mauro Carvalho Chehab wrote:
> When compiled on i386, it produces several warnings:
>=20
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
> 	./arch/x86/include/asm/bitops.h:457:22: warning: asm output is not an =
lvalue
>=20
> I suspect that some gcc optimization could be causing the asm code to b=
e
> incorrectly generated. Splitting it into two macro calls fix the issues=

> and gets us rid of 6 smatch warnings, with is a good thing. As it shoul=
d
> not cause any troubles, as we're basically doing the same thing, let's
> apply such change to vpe.c.
>=20
> Cc: Benoit Parrot <bparrot@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)

I think the point of COMPILE_TEST is to improve the quality of the code.
This patch doesn't improve the quality, on the contrary.

If those warnings on a (buggy?) i386 gcc are a problem, I suggest
removing COMPILE_TEST for vpe.

 Tomi


--Uae7P2C6JMDRDP3QuqrOmtqaOJQIM4T7B--

--EnhpFx3gUIhMUw3e7MXtpifX7BQmBlsFE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJYNqrJAAoJEPo9qoy8lh71wNMQAKti0l3vdkql92X939aFn6dF
+YekanYcal0+jQEaXaAkHmtW0SmchXO1PmVX9h25548jkj7idXhsBuqJJe3na3Xk
yoZmqy0OYN2SMVkNp/R8FpybJi//C/pP5atDwuzrIdq45fqFvjcGjuP0DA0KohUO
f8HR/26LfLC0U97dHyw+lNMRLZRL90wv96FFBNxk4QqBVNThB4LkoWQ4Z7BFSp/i
LZMczjyuPIyoSuAz+k/qDt5PjTRT2pIS0ashnFEewrgHtRI7U2bRCiTYfOD1UEcZ
Oek5hlcOuySuCI5Qvakz6WApqyOcFpXezotMuzPy5f5HIU0LHNVRU8gSST9B4szz
EO6rd59e943jb7CBTNjTPxLUrYxQQDVhKqPA0C30JAH9l6MeSh45gXOwvYst08Zk
gBo0yialxH4mFxbL1w7cb40qK/Waa5RL0SNLiI8ULTu3Yh98jbcqx+bLq1WBg4hu
4R7qk8oM2GLCxor8cCWMxpqxnreYoB5lqcgf5tYwkjL0/raQ5d9HOUlHooPr/B9u
A2xwXdWl9uE4zTuVvd0iN0iEv06zuwPB99h2eqghHUOp79y8EIinb4kkpV0blzK5
4go9RS0H55G+sR9V4UQrwfuS0XZLjvXMBAf6rgW19tyzuNFrAqLRyVqrx1aT9Czz
n6BSerSj7iWK6zXyxuoW
=/hnS
-----END PGP SIGNATURE-----

--EnhpFx3gUIhMUw3e7MXtpifX7BQmBlsFE--
