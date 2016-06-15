Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58742 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbcFOMsr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 08:48:47 -0400
Date: Wed, 15 Jun 2016 14:48:42 +0200
From: Sebastian Reichel <sre@kernel.org>
To: "Andrew F. Davis" <afd@ti.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-pwm@vger.kernel.org,
	lguest@lists.ozlabs.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] hsi: Build hsi_boardinfo.c into hsi core if enabled
Message-ID: <20160615124842.GA6702@earth>
References: <201606140808.bRJtAy1i%fengguang.wu@intel.com>
 <57602D10.4080708@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <57602D10.4080708@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, Jun 14, 2016 at 11:13:04AM -0500, Andrew F. Davis wrote:
> If the HSI core is built as a module hsi_boardinfo may still
> be built-in as its Kconfig type is bool, which can cause build
> issues. Fix this by building this code into the HSI core when
> enabled.
>=20
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrew F. Davis <afd@ti.com>
> ---
> This build error seems to be due to Kconfig symbol CONFIG_HSI_BOARDINFO
> being a bool but depending on a tristate (CONFIG_HSI). This is normally
> okay when it is just a flag to enable a feature in source, but the
> helper code file hsi_boardinfo.c is built as a separate entity when
> enabled. This patch is probably how it was intended, and is more like
> how others do this kind of thing.
>=20
> This patch should be applied before the parent patch:

Thanks, I applied both patches.

-- Sebastian

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJXYU6oAAoJENju1/PIO/qae6QP/35LQ3B8vO2lZZLD3fJoRLEz
yJp80KFgWVGLlJIxoywl6Lm8tK1b48miCd73ee7Euagta3zJqZMutPO3lCiaExQh
QXIykcVyzZXxa6AELhlPXbJlffoetyTvq7n831+Hk1IqhwOgCpm8jSVszgw11fyH
FIDtsW7QpUnhq/lBIl+6yc8OYszH3N69Cv0sS3J5neDT2W9dochTcv01JEMAmFIL
8TWT+5hZ/7WvvXt2tDJ03uP7aNbpDOAhutNaAjsYZEA9pX+SVa17O9eQGT5tAT5a
0pWIFazcVt06+phTF28XlkPqVhSA0wtXeRoyLuz+UHFjGWJiwmbKTJ6QipFclEL7
yXNE8V+g2FRiH4ZqBQ3EQtzusatln5CixirVF1wtPXp75mpZ9XHynDS2tvI6GmO+
7jPGFRtp8QueA6LzlQN6AskCEm7BpVX2CbwTc4k3W5BDn3kmeVKdcd7a5fVLfN7Z
y6e3kkYa8MSNfu/GFEXzeYfraIrtjwE2JfcqjDp8SgOcEaxI46n5fXNhqs4Mq/Kd
FXUswYrJPl+hbCAklxt0YouQP55fzhBBc6FZIf3sCg/Tw1RhUs7ka0X0yKwGBp1r
K8rHk8x9QA7ypJ66vOr4bYmqvXn5SzBb6pF4HkKLFDIrWYTrym/z2uD+H4wFq6ZN
3viKiXS2qFAhhSbKm82E
=h2dd
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
