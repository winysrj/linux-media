Return-path: <linux-media-owner@vger.kernel.org>
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57197 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759736Ab2CVUjb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 16:39:31 -0400
Date: Thu, 22 Mar 2012 20:39:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] Convert I2C drivers to dev_pm_ops
Message-ID: <20120322203929.GA31883@opensource.wolfsonmicro.com>
References: <1332448493-31828-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <1332448493-31828-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 22, 2012 at 08:34:53PM +0000, Mark Brown wrote:

> +		.pm	= msp3400_pm_ops,

Gah, missing &s - will resend tomorrow.

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPa437AAoJEBus8iNuMP3dNe0QAIINZINwvmR7iMmJ1MlnAUru
yzlkQK6yKSd6YgmEvpFRBeAafVqU+cMtThHDBHpX+B0/Peuy3RlrJADw1Ciq0FtC
4/XqFFn+ne6gP3Nh7TA2pGcOzD4v1HbSMuodvuk9gU1J1FqOvVf1vd9qbglMlByc
UPdyl9DC/XKVm0JOwpbEGiYlfLnbqzZXXa01EJIBsg30OggrcxSasjCF/+Zo9CUQ
GnWTFgAuc452KzgiKZFKnBxzhtbiPnWHO7SVQyYe5HVsaVubCRE55ArVpU3WGLK9
oNh5BLZdH/6kczpzPAJF+aw5YN+kpOfpBUxXw3pDPnBsubDv7dmTnDSnLJgP5Fq4
e5iyVKIf22dTjMqBJsMpNixlcMSDdWIhN0Ks7eJ9IO3dfg2hbVbS/7Wb8kH6HL+6
020/woX3rUHPRDJUkCIdDfJ3HU+j75QBRzryvS/sKVSgsvIkSCGqgcSxSFEUOzQA
F1EtYiaWljgmX5wHiV8J+H+n9KjDaDfK5JKss8O4Kvk0UL+kMXXqgm/fzj3y3jwq
gQPBlH5JtSpFS6/kUUE7Y1QD6HE1GK41DWplMDFKvMUcVbKo0BgATuRSf63q4MXt
7W210sPvUhKRxq+jVGY7Qso2ElKoifgDllkt9eleO353f/YeQgC0a2ikeZD6OOED
FcaZlp33bAeDPdQCYCnG
=oMZo
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
