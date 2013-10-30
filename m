Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:33997 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab3J3PQZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 11:16:25 -0400
Date: Wed, 30 Oct 2013 16:16:20 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Antti Palosaari <crope@iki.fi>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
Message-ID: <20131030151620.GB3663@katana>
References: <1382386335-3879-1-git-send-email-crope@iki.fi>
 <52658CA7.5080104@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <52658CA7.5080104@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

sorry for the delay. The Kernel Summit made a pretty busy time out of
the last weeks...

> I found one of my drivers was crashing when DTV USB stick was
> plugged. Patch in that mail patch fixes the problem.

Well, if you have a parent, it should be set. This is always a good
idea. Can't really tell why not having it causes the BUG, though.

> I quickly looked possible I2C patches causing the problem and saw
> that one as most suspicions:
>=20
> commit 3923172b3d700486c1ca24df9c4c5405a83e2309
> i2c: reduce parent checking to a NOOP in non-I2C_MUX case

Did you try reverting it? I am not sure this is the one.

> >i2c i2c-6: adapter [RTL2830 tuner I2C adapter] registered
> >BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
> >IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]

Can we have the full BUG output?

Regards,

   Wolfram


--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScSLDAAoJEBQN5MwUoCm2K+gP/3ZREG1A1ff3Hrz4RD+K8TPv
CoJQYcsHUgQ1Ct8AUkigqX1xAP5EdzIEG4Y3n2de5KmUjgKo+tdJz+vAnj4w7lsg
s1+KeRicrZYZlbkbr3w7JW0DzTjs+oiNnZsRBD9HU/FWlBGpNrwi6SNaTyy/bcu2
QzeIK/qOHZ74+gBOaYbkrY0pp7sfUknXwrGp9F7/W+T1fB7xYA/hs+NZsvEQkw8r
fyQ5UbApm4RLor5oNguGSJNPvs76sGqHiRToEOJxRZ6WgWUImYAy66RA8nv5xWEX
VOtA44waBOge61Huoq3pK4tJ8U3FVa6R3tDoFPc9Rymdc8p/heC4kfO+SeeK7wGl
Qhu0exUkqTSU9XGlaEzxc3Va2nbi9vaMZYWddXmJ9ma+m2CwBZVSCApvV9NfhfJ1
S+vXmVdIO7kpj61VnNC4KUrz+3wozHE6d1E4nT9oO1+/3IGqIJkuZzONoYxaXocQ
W6xaYzpZEJNMreaxg69SO1GuAEUJkQE9W5Hq8Zb5jpc3fa6y39+bBAqWN/WBnSV6
WpIBWYotXR0IDkRJXSqyK0AHJLWCVZLF+tl2CYnlB3xIJQ73Cldbb6CSNQQwh/x2
CJi0/uQYWGQgaAFwe9+pEQFHgpCV165ZPny2PTY28eOynUlKd8vTwNBQsh8BX3/s
LMQa8696JmV/l9zY3RvY
=AAm9
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
