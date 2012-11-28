Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57907 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2K1Nec (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 08:34:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Tdhmk-0003U8-0s
	for linux-media@vger.kernel.org; Wed, 28 Nov 2012 14:34:42 +0100
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 14:34:42 +0100
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 14:34:42 +0100
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: ivtv driver inputs randomly "block"
Date: Wed, 28 Nov 2012 08:34:20 -0500
Message-ID: <50B612DC.7010906@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org> <CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com> <50B60D54.4010302@interlinx.bc.ca> <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4E0147CA8118C6C878B7BDDA"
In-Reply-To: <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4E0147CA8118C6C878B7BDDA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-11-28 08:13 AM, Ezequiel Garcia wrote:
>=20
> Try again with
> modprobe ivtv ivtv_debug=3D10

That actually errored out but I think you meant:

# modprobe ivtv debug=3D10

which actually was successful in loading the module.  Now we just wait
for the failure and see.

I will update here as soon as I see it again.

Cheers,
b.



--------------enig4E0147CA8118C6C878B7BDDA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlC2EtwACgkQl3EQlGLyuXD5awCgyjvDbyXIWu4IMJOg3Gymp+ao
TNAAoKk4heeBjShmSdIrZK6+MvPPqGpY
=XVzp
-----END PGP SIGNATURE-----

--------------enig4E0147CA8118C6C878B7BDDA--

