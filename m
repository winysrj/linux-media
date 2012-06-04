Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58952 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760585Ab2FDNcx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jun 2012 09:32:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SbXOr-0008Eg-1g
	for linux-media@vger.kernel.org; Mon, 04 Jun 2012 15:32:49 +0200
Received: from mail.interlinx.bc.ca ([216.58.37.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 15:32:48 +0200
Received: from brian by mail.interlinx.bc.ca with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 15:32:48 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: Fwd: [Bug 827538] DVB USB device firmware requested in module_init()
Date: Mon, 04 Jun 2012 09:32:36 -0400
Message-ID: <4FCCB8F4.7090407@interlinx.bc.ca>
References: <bug-827538-199927-UDXT6TGYkq@bugzilla.redhat.com> <4FC91D64.6090305@iki.fi> <4FCA41D7.2060206@iki.fi> <4FCACF9C.8060509@iki.fi> <4FCB76D3.7090800@interlinx.bc.ca> <4FCB77FB.50804@iki.fi> <4FCBD095.30901@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig171C4864D7CDE80358876402"
In-Reply-To: <4FCBD095.30901@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig171C4864D7CDE80358876402
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-06-03 05:01 PM, Antti Palosaari wrote:
>=20
> That firmware downloading patch is done top of my new dvb-usb
> development tree. I have converted very limited set of drivers for that=

> tree, af9015, au6610, ec168 and anysee (and those are only on my local
> hard disk). I tried to backport patch for the current dvb-usb but I ran=

> many problems and gave up. Looks like it is almost impossible to conver=
t
> old dvb-usb without big changes...
>=20
> So what driver you are using?

I'm using the hvr-950q per
https://bugzilla.kernel.org/show_bug.cgi?id=3D43145 and
https://bugzilla.kernel.org/show_bug.cgi?id=3D43146.

> It is possible I can convert your driver
> too and then it is possible to test.

Great.  Ideally it would be great to get this backported and applied to
the linux 3.2.0 release stream.

Cheers,
b.



--------------enig171C4864D7CDE80358876402
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/MuPQACgkQl3EQlGLyuXBrNgCfQ5uL/Lhm2w2wqoBz7D1QlkhU
qEkAn02o1n6aUcZn9KrN8g924syQgmft
=0/2W
-----END PGP SIGNATURE-----

--------------enig171C4864D7CDE80358876402--

