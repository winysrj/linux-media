Return-path: <linux-media-owner@vger.kernel.org>
Received: from dudelab.org ([212.12.33.202]:23517 "EHLO mail.dudelab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab0ASKjR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2010 05:39:17 -0500
Received: from abrasax.taupan.ath.cx (p5DE8A8F0.dip.t-dialin.net [93.232.168.240])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "Friedrich Delgado Friedrichs", Issuer "User CA" (verified OK))
	by mail.dudelab.org (Postfix) with ESMTP id EDBCC228148
	for <linux-media@vger.kernel.org>; Tue, 19 Jan 2010 11:40:25 +0100 (CET)
Date: Tue, 19 Jan 2010 11:39:12 +0100
From: Friedrich Delgado Friedrichs <friedel@nomaden.org>
To: linux-media@vger.kernel.org
Subject: Re: Hauppauge Win TV HVR-1300: streaming and grabbing fail after a
 while, changing resolution renders card inoperable
Message-ID: <20100119103911.GA27938@taupan.ath.cx>
Reply-To: friedel@nomaden.org
References: <20100117133300.GA3668@taupan.ath.cx>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20100117133300.GA3668@taupan.ath.cx>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm sorry, two of the problems described in my mail have nothing to do
with the driver. There's a daemon running that accesses the tuner and
vbi (nxtvepg), which causes problems 1 and 2.

I've failed to notice this because nxtvepg can (normally) detect
tvtime and xawtv and doesn't interfere with them, so I assumed it
might have a general mechanism for detecting if the tv driver is in
use by a different app.

The third problem remains:

Friedel wrote:
> 3) changing resolutions causes mpeg encoder stream to become
> completely inoperable

> When I switch resolutions in mythtv recording profile, but also via
> e.g.
>=20
> v4l2-ctl -d /dev/video1 --set-fmt-video=3Dwidth=3D720,height=3D568
>=20
> I seem to totally break the encoder. There's no stream any more,
>=20
> ~> cat /dev/video1
> cat: /dev/video1: Input/output error
>=20
> And switching the resolution back doesn't help. Unloading the modules
> doesn't help either, I have to reboot the box.
>=20
> dmesg output pastebinned at http://pastebin.com/f4e27757a
>=20
> Tests were done with a 2.6.32 kernel from ubuntu.

Which I assume is a vanilla kernel. I might be wrong about this, too.

I could test with newer drivers or a newer kernel of course, if you
suspect that the problem might not be fixed yet.

> Please ask if there's any information you can't easily infer from this
> mail or the attached logs.


--=20
        Friedrich Delgado Friedrichs <friedel@nomaden.org>
                             TauPan on Ircnet and Freenode ;)

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVi8UACgkQCTmCEtF2zEBNmwCcD1OTCArFuultbyVqYhRQTvsz
+ngAoISG/olxFNGhD6Ju5FThh/DI4hjN
=B58J
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
