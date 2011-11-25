Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:39766 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1KYNhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 08:37:00 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RTvxZ-0000aQ-V7
	for linux-media@vger.kernel.org; Fri, 25 Nov 2011 14:36:57 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 14:36:57 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 14:36:57 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: gnutv should not ignore SIGPIPE
Date: Fri, 25 Nov 2011 08:36:40 -0500
Message-ID: <jao5l8$v03$1@dough.gmane.org>
References: <jao3r9$i9e$1@dough.gmane.org> <201111251534.05480.remi@remlab.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43DC9E316F4B923C21C70095"
In-Reply-To: <201111251534.05480.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43DC9E316F4B923C21C70095
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 11-11-25 08:34 AM, R=E9mi Denis-Courmont wrote:
>=20
> Anyway, the problem is not so mucgh ignoring SIGPIPE as ignoring EPIPE =
write=20
> errors.

Yes, that is the other way to skin that cat I suppose.

What's the best/proper way to go about getting this fixed?

Cheers,
b.



--------------enig43DC9E316F4B923C21C70095
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk7PmegACgkQl3EQlGLyuXBCuQCgz2MlCL7YiSLskBT0qX07Czbk
exAAoLYoID5HVPO2YIZGP+iW9XRFs+PC
=ht2g
-----END PGP SIGNATURE-----

--------------enig43DC9E316F4B923C21C70095--

