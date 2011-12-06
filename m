Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab1LFIMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 03:12:08 -0500
Date: Tue, 6 Dec 2011 09:12:00 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Stefan Ringel <linuxtv@stefanringel.de>,
	linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
Message-ID: <20111206081200.GA8756@avionic-0098.mockup.avionic-design.de>
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de>
 <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de>
 <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de>
 <4EDCB33E.8090100@redhat.com>
 <20111205153800.GA32512@avionic-0098.mockup.avionic-design.de>
 <4EDD0BBF.3020804@redhat.com>
 <4EDD235A.9000100@stefanringel.de>
 <4EDD268E.9010603@redhat.com>
 <20111206065119.GA26724@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20111206065119.GA26724@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Thierry Reding wrote:
> * Mauro Carvalho Chehab wrote:
> > That means that all we need is to get rid of TM6000_QUIRK_NO_USB_DELAY.
>=20
> I've just reviewed my patches again and it seems that no-USB-delay quirk
> patch was only partially applied. The actual location where it was introd=
uced
> was in tm6000_read_write_usb() to allow the msleep(5) to be skipped, whic=
h on
> some devices isn't required and significantly speeds up firmware upload. =
So I
> don't think we should get rid of it.
>=20
> If it helps I can rebase the code against your branch (which one would th=
at
> be exactly?) and resend the rest of the series.

Looking more closely, I think my original patch was applied wrongly. If you
look at the original patch:

	http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/37=
552

and look at the applied version in this commit:

	42845708363fc92a190f5c47e6fe750e3919f867

Then you see that the hunk from the tm6000_read_write_usb() function was
applied to the tm6000_reset() function instead.

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7dzlAACgkQZ+BJyKLjJp/RcgCgj+nTZMdrHWzLRsk4lzTxsQRr
lqAAn2yoekaS12SL1nSdaEU9cehw5AoC
=PrXd
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
