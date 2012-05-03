Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40988 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab2ECPAV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 May 2012 11:00:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SPxVt-0003EN-Vr
	for linux-media@vger.kernel.org; Thu, 03 May 2012 17:00:13 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 17:00:13 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 17:00:13 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: common DVB USB issues we has currently
Date: Thu, 03 May 2012 10:59:59 -0400
Message-ID: <4FA29D6F.3090507@interlinx.bc.ca>
References: <4FA293AA.5000601@iki.fi> <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A904BB3E33247C5833016E1"
Cc: Antti Palosaari <Antti.Palosaari@iki.fi>
In-Reply-To: <CAGoCfiw9h8ZqAnrdpg3J8rtnna=JiXj6JYL-gU58xS2HmMuT_w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A904BB3E33247C5833016E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-05-03 10:48 AM, Devin Heitmueller wrote:
>=20
> I doubt this is a dvb-usb problem, but rather something specific to
> the realtek parts (suspend/resume does work with other devices that
> rely on dvb-usb).

Dunno if it's at all relevant but I used to be able (circa 2.6.32
perhaps?  it's a bit foggy now) to suspend/resume with my HVR-950q
installed and modules loaded.  Now suspending with them loaded hangs the
suspend and they can't even reliably be rmmod/modprobed pre and post
suspend/resume.

I just wonder if that change in behavior is pointing at something.

Cheers,
b.




--------------enig8A904BB3E33247C5833016E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+inW8ACgkQl3EQlGLyuXDQwQCgpj+2OreH5HjALRDLle1gjxc4
JX4AnRrwv3ojcM0niKo4VfECgXHgVWgj
=NyA9
-----END PGP SIGNATURE-----

--------------enig8A904BB3E33247C5833016E1--

