Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:55641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab1IBITJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 04:19:09 -0400
Date: Fri, 2 Sep 2011 10:19:05 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Goff <goffa72@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
Message-ID: <20110902081904.GA27008@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
 <4E5E7E2B.90603@redhat.com>
 <20110901051037.GB18473@avionic-0098.mockup.avionic-design.de>
 <4E5F7E71.5010209@aapt.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <4E5F7E71.5010209@aapt.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Andrew Goff wrote:
> Hi Thierry,
>=20
> I have been having problems with the radio tuner in my leadtek 1800h
> card. This card has the xc2028 tuner. Using fmtools i would get an
> error message similar to - frequency out of range 0.0 - 0.0.
>=20
> After seeing you patches at the beginning of last month I installed
> the recent drivers at the time and applied your patches. The
> frequency out of range error went away but the only sound I got was
> static. I then discovered the frequency is out by 2.7MHz, so if I
> want to listen to 104.9 I need to tune the radio to 107.6.
>=20
> On Ubuntu 10.04 the card works fine, the errors started when
> applying the recent V4L drivers that I require for another card.
>=20
> Are you able to help resolve this problem and get this card working
> properly again.

So you are saying that the card was previously working for you, but when you
apply the xc2028 patches from my series on top the tuning is off by 2.7 MHz?

I don't know the Leadtek 1800 at all, but perhaps it's actually compensating
for the offset before passing the frequency to the tuner?

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5gkXgACgkQZ+BJyKLjJp9z6QCfcy70OS6f74Dv4Rm4plJv4Z5O
CYQAn2h2gwFcMX5lcebwGTSs7McEnrub
=nHpx
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
