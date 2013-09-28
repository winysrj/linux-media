Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46108 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab3I1W4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Sep 2013 18:56:21 -0400
Date: Sat, 28 Sep 2013 23:56:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Ben Dooks <ben-linux@fluff.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sangbeom Kim <sbkim73@samsung.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
Message-ID: <20130928225614.GR19304@sirena.org.uk>
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
 <1380392497-27406-4-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OOz7ZB592LYQf07"
Content-Disposition: inline
In-Reply-To: <1380392497-27406-4-git-send-email-tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/5] ASoC: samsung: Use CONFIG_ARCH_S3C64XX to check for
 S3C64xx support
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--0OOz7ZB592LYQf07
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 28, 2013 at 08:21:36PM +0200, Tomasz Figa wrote:
> Since CONFIG_PLAT_S3C64XX is going to be removed, this patch modifies
> the s3c-i2s-v2 driver to use the proper way of checking for S3C64xx
> support - CONFIG_ARCH_S3C64XX.

Acked-by: Mark Brown <broonie@linaro.org>

--0OOz7ZB592LYQf07
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSR16KAAoJELSic+t+oim9+dMP/RJpgnBErQM5bz0RQBrAAzRi
6nDP5Ppp/GrQIUzrdj8PS7mLjC5ip+AFQ4kmGLi0X7CKEm2a7q/j+b4O+U4gNOum
XGyYjCwg0UoEQu4oALt72uPVppO3sNrCqMsdOMexyzdIKP9WzFnlLJDzL8X1qcCu
qaRZzMORrb76GZeGVQcxJIDLX+R9xu1XvPWbTXg9JEhcLqZuYIWGRBrx99t+alEF
vZm0Qu6ydduHmgVmBWjuaA3qDwrDEbRwZiuVlK7TwLLjYL6+dCp6xWmhBZUWsni/
WAVyciNE+GNrswdz+I75qlGGcDj75W0OomqWMkZcUDSz2T1jm+yoEBi+Mrharotj
BhWj4B+vKUlG5cPvZsBnXbhCd/pl3sIUNa8aL8uNda0BsR/3HewGkKwLvizy0qPP
pfkmf4y1bS2s89hQfbYx5Dm00alVjQxTs4LCKF/WOAC6YxRxHvoaub4ENG/NDomk
Zkn0sKFAqoVeSD0IeJc79gE18HIf+FjUG4NmzL1JxOSprC4yxnfVxvYzEQjD4plb
opNs7Riht8qg9LKr0l8Y+sulaHFMVEfgH/wNg7XhyuhIWxwCyzNh2Msm6DmooR25
4hPNimcXl09SPeM2PN20E6QxBLlYXOWxkUwOu/1VeM8m/gUdy83TOvaVF3cRcdJN
yuGGJMF/+J3iIe6B23zy
=mlUA
-----END PGP SIGNATURE-----

--0OOz7ZB592LYQf07--
