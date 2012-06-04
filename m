Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59304 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab2FDNzI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 09:55:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SbXkQ-0007S1-Va
	for linux-media@vger.kernel.org; Mon, 04 Jun 2012 15:55:06 +0200
Received: from mail.interlinx.bc.ca ([216.58.37.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 15:55:06 +0200
Received: from brian by mail.interlinx.bc.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 15:55:06 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
Date: Mon, 04 Jun 2012 09:54:53 -0400
Message-ID: <4FCCBE2D.7090505@interlinx.bc.ca>
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com> <4FC91D64.6090305@iki.fi> <4FCA41D7.2060206@iki.fi> <4FCACF9C.8060509@iki.fi> <4FCB76D3.7090800@interlinx.bc.ca> <4FCB77FB.50804@iki.fi> <4FCBD095.30901@iki.fi> <4FCCB8F4.7090407@interlinx.bc.ca> <CAGoCfixoe5jyYrgwNnadbFsvRqF1P3rk5jMZbmtmvhyvAieZ0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D909205A3A22D602FB0C842"
In-Reply-To: <CAGoCfixoe5jyYrgwNnadbFsvRqF1P3rk5jMZbmtmvhyvAieZ0g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D909205A3A22D602FB0C842
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12-06-04 09:35 AM, Devin Heitmueller wrote:
>=20
> The 950q doesn't use the dvb-usb framework (nor does it load the
> firmware at init).  Whatever is going on there is completely unrelated
> to what Antti is debugging.

Ahhh.  Pity.  I was almost giddy there for a second.  :-/

Cheers,
b.



--------------enig8D909205A3A22D602FB0C842
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/Mvi0ACgkQl3EQlGLyuXBMFgCeM0FSr0yewEM23Gjfu3ei8ggA
LlUAoIawim0TYapJqgBMGqbj9fkhFVm+
=7r91
-----END PGP SIGNATURE-----

--------------enig8D909205A3A22D602FB0C842--

