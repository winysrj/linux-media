Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:54081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1IAFKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 01:10:40 -0400
Date: Thu, 1 Sep 2011 07:10:37 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 02/21] [media] tuner/xc2028: Fix frequency offset for
 radio mode.
Message-ID: <20110901051037.GB18473@avionic-0098.mockup.avionic-design.de>
References: <1312442059-23935-1-git-send-email-thierry.reding@avionic-design.de>
 <1312442059-23935-3-git-send-email-thierry.reding@avionic-design.de>
 <4E5E7E2B.90603@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <4E5E7E2B.90603@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Mauro Carvalho Chehab wrote:
> Em 04-08-2011 04:14, Thierry Reding escreveu:
> > In radio mode, no frequency offset is needed. While at it, split off the
> > frequency offset computation for digital TV into a separate function.
>=20
> Nah, it is better to keep the offset calculation there. there is already
> a set_freq for DVB. breaking the frequency logic even further seems to
> increase the driver's logic. Also, patch is simpler and easier to review.

Okay, no problem. Feel free to replace the patch with yours.

> The patch bellow seems to be better. On a quick review, I think that the=
=20
> 	send_seq(priv, {0x00, 0x00})
> sequence may be wrong. I suspect that the device is just discarding that,
> but changing it needs more testing.

I ran across that as well, but I didn't dare touch it because I wasn't sure
what the broader impact would be.

Thierry

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk5fE80ACgkQZ+BJyKLjJp9nkgCfdjy1xFdPkyCSvuyAwuePKUUH
UyYAn36TbWFlGlWEN9Log1F5F/jyrxG/
=MeWN
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
