Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35429 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaH0HKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 03:10:10 -0400
Date: Wed, 27 Aug 2014 08:09:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Foley <pefoley2@pefoley.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Message-ID: <20140827070943.GQ17528@sirena.org.uk>
References: <1409073919-27336-1-git-send-email-broonie@kernel.org>
 <53FCDE16.1000205@infradead.org>
 <20140826192624.GN17528@sirena.org.uk>
 <53FCE70A.6000907@infradead.org>
 <53FCE947.6000103@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zxsahKoLyYcOmAWl"
Content-Disposition: inline
In-Reply-To: <53FCE947.6000103@infradead.org>
Subject: Re: [PATCH] [media] v4l2-pci-skeleton: Only build if PCI is available
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zxsahKoLyYcOmAWl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 26, 2014 at 01:08:39PM -0700, Randy Dunlap wrote:
> On 08/26/14 12:59, Randy Dunlap wrote:
> > On 08/26/14 12:26, Mark Brown wrote:

> >> No, it's not - if it's going to depend on COMPILE_TEST at all it need to
> >> be a hard dependency.

> > How about just drop COMPILE_TEST?  This code only builds if someone enabled
> > BUILD_DOCSRC.  That should be enough (along with PCI and some VIDEO kconfig
> > symbols) to qualify it.

> I'll add BUILD_DOCSRC to the depends list in the Kconfig file...

OK, that symbol probably does the job - I wasn't aware of it previously.

--zxsahKoLyYcOmAWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/YQ0AAoJELSic+t+oim9pOYP/1YNgGu/TXoQFbwEETGP/WjR
XTsjpzGqnFDYUU3tl0QiX6J9a0JNXJTp7rzY8KjN22w1U4O+3PrEz0DzC8IuRY7Y
HzCTLQdZfMxcR7ZCNYp7lFxwas4k3ojDEunFKo4AW7FkSR0Rv1ZjJPTLT/lkDtGE
iC9Jq7gs11pk7IliTmZ9sjBLcRfTGWuSgTFfsHSG3v3jF6nZcX7NkLX7f+tzNJWt
RLGgQbzih2iUY6XWWn0PoHZ1WQt9GvHnix3g5O+1aqvhQNmVVLRLegaz4TLbyutb
VXT5Lpop4g0RgHOi6lg9mfMdRP4/x9FtIN0G8xhagLtt5P11QSE224ZzIunHYDrp
XR6303TIC+KTCrb9wZ/tw5wWvInUqkzayr4SVj9y8W96wXzYfPLnl5S9jm/xllWm
GInerlGZtUEQYbczNWWungZN8VUpjQCkr5Fr2LzoVvxhw49NC3HRVSedTTK4O+wn
STJBKkZJg0p25VJSy7fXaFl5BW4nXpz9a9+R3ZC6U41EIx5gqfCAOMaI9cEfRSwv
5s6x3d5XDu5q9SJuS2XEerAHgDKNsczUVCbBInXRdyIZ2OP9Lq4SUTfCZn5xtrGg
fImR3vLX1SzJIEoEjkOxj/5KWFo6KaRpD9jnyfs1W5+FrH59/FsIIsZb/TDM5slM
oxqMK96EBO2OZH+8Bx/l
=FC9P
-----END PGP SIGNATURE-----

--zxsahKoLyYcOmAWl--
