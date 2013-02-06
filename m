Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3BFLvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 06:51:21 -0500
Date: Wed, 6 Feb 2013 12:51:17 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.9] [media] media: Convert to
 devm_ioremap_resource()
Message-ID: <20130206115117.GA9643@avionic-0098.mockup.avionic-design.de>
References: <E1U33Q6-0006hT-Oh@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <E1U33Q6-0006hT-Oh@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 12:33:04PM +0100, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following p=
atch were queued at the=20
> http://git.linuxtv.org/media_tree.git tree:
>=20
> Subject: [media] media: Convert to devm_ioremap_resource()
> Author:  Thierry Reding <thierry.reding@avionic-design.de>
> Date:    Mon Jan 21 06:09:07 2013 -0300
>=20
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Hi Mauro,

Greg already took this through the driver-core tree because of the
dependencies, so I don't think it's necessary to have it in yours as
well.

Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJREkO1AAoJEN0jrNd/PrOhZIoQAI25kmurBNaLzQc1GGoI6p1+
ex3bu3SLx3rpRuLSZpfMHXnxDOxnfLPwLr780do8Yf5ckxWNUzgWlGbRnyQUGl4Y
+BswvFtQ3AWFrs3PyegHOYjfFuQTd4wgV7YVrFqooJEUfBT340N/xTCGkeY1dA/l
MuMhCpIb6cFCc8GYRPfJf2axWvnl9AUdl6FRv5YQJwo187WZFOTpgMid3r9x2OLe
CXC7xZJBoVaIpOQGYo0GoDVs0QGe76uLmqwQ0h3PSxJfRaKFwzskPxum6JkB01Pi
6sMjJnj5UDDUSrFgCuyV+6M8XGXHgdYbTljq0wzctLWaKTuIXgbCkGeaMYDBw4C+
ui778P9jxW9aurLimjYXAaoqvvWlrIgFK8parm2Esle4c1jImNBIoeiee2TSiD44
q80o+4fY4MuYCWZM3sv3+pATuadfS2voEcfTJ+QXJIljU4sI7FDvE4PKKa4qsiDT
rsrk1cKdAZTfXXpsdmLOU/j+mK3fa19idCpEzDHXwIqhL9Ze7S9d44DipS912K/J
f0Jvmur+XIvRBL34MzDYhzB4OKo9dLaZWlRnLy9hBRaBpRBcerQn/X5Gh1lJKjLE
AFlk+RAB3TQQMyqiDjwOyrkGOk/7+643o9MsRICarc7wOgV846KedPlhk6QnRZbo
GJNDKkGXQgRPVGTPEp75
=oYX1
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
