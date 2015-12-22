Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:38813 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932861AbbLVUjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Dec 2015 15:39:06 -0500
Date: Tue, 22 Dec 2015 21:38:53 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] rc: sunxi-cir: Initialize the spinlock properly
Message-ID: <20151222203853.GC30359@lukather>
References: <1450758455-22945-1-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6nSyB+bcl/pT7+kx"
Content-Disposition: inline
In-Reply-To: <1450758455-22945-1-git-send-email-wens@csie.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6nSyB+bcl/pT7+kx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 22, 2015 at 12:27:35PM +0800, Chen-Yu Tsai wrote:
> The driver allocates the spinlock but fails to initialize it correctly.
> The kernel reports a BUG indicating bad spinlock magic when spinlock
> debugging is enabled.
>=20
> Call spin_lock_init() on it to initialize it correctly.
>=20
> Fixes: b4e3e59fb59c ("[media] rc: add sunxi-ir driver")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

You should probably Cc stable on this one.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6nSyB+bcl/pT7+kx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWebTdAAoJEBx+YmzsjxAgd94QAKsaB5cEGYTnteKDSXNQxHC1
YzSnlmUht05Fm8cxlN/UYmw0xZcj8HzUBC2XbSfp7n9LmwriRJSgb7CpZnT5CqoA
xTxvPMjpF6PGP8ms6WKoNbIgdUwRCA6XeifXyS6+l9AnnU9LMkJbaZXdfsn3AmOw
pt1NN8/rkwmjeZCid0ucebe1dNK3C890gFcSy/LMFLhc329shFImVzPA/mcaW5V+
hkPLmzhLbZrq1/z8Nr/L63QhZWzXnKNoSKUxLX+Jh6lXbTM+jRXKc275hqKy7VeH
03kdYzm8ipU0Lt1OmLk2N62XgbXqWPTGo9KsjwYaKCaBYO2b85D/gwBY0lzAWpk/
hwfzTRkBy5MMm9x6uZ+MKJjvOT2MaKjCNM5CFFVaQDCpYvIAjhl3WDiN7l20X5Ee
+RjtgeR6cCOBLK1Kbnwzgc9gb3W7MvTrpbdaOOCDc9MDe+3kRf1EKMo5czHpe4Wr
ox8S7M+9WpmI2GcCDsE1rw+rmfj6eu3P0C1GLKEKy7eCFAJaix/uS15JQdqn8gBP
bGJVWVufSqrCE2tb+nvA5BqXZFBtFKymJ1G/BrxrFko2+vdL8CQW4OlOigoOtxCw
RI+U1rg9N8ywd4PrKBmoaXqiL0CHPkcJLj5tFyByaQsmEsVD0p0mdLDcU9IYhnby
Xu3RFg7ZA2/9+roSMYVd
=DiQW
-----END PGP SIGNATURE-----

--6nSyB+bcl/pT7+kx--
