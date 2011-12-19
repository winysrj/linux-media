Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:63032 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1LSIUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 03:20:09 -0500
Date: Mon, 19 Dec 2011 09:20:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] tm6000 : improve loading speed on hauppauge 900H
Message-ID: <20111219082003.GA9289@avionic-0098.mockup.avionic-design.de>
References: <1324059307-7094-1-git-send-email-castet.matthieu@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1324059307-7094-1-git-send-email-castet.matthieu@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Matthieu CASTET wrote:
> - enable fast usb quirk
> - use usleep_range instead on msleep for short sleep
> - merge i2c out and usb delay
> - do like the windows driver that upload the tuner firmware with 80 bytes
> packets
>=20
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> CC: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/staging/tm6000/tm6000-cards.c |    2 ++
>  drivers/staging/tm6000/tm6000-core.c  |   16 +++++++++++++++-
>  drivers/staging/tm6000/tm6000-i2c.c   |    8 +-------
>  3 files changed, 18 insertions(+), 8 deletions(-)

You seem to be basing your work on old code. You should probably update the
patch against a later branch (e.g. staging/for_v3.3 from the media tree):

	http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.3

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7u87MACgkQZ+BJyKLjJp9+AwCgjxBatYISFdOf4wgFj/ZVGOly
tA0AnRXUq/8ag7Im//5bEflC4ltNWjSS
=L5hn
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
