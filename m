Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns1.tyldum.com ([91.189.178.231]:44345 "EHLO ns1.tyldum.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab0DQRhI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 13:37:08 -0400
Received: from tyldum.com (unknown [192.168.168.50])
	by ns1.tyldum.com (Postfix) with ESMTP
	for <linux-media@vger.kernel.org>; Sat, 17 Apr 2010 19:37:03 +0200 (CEST)
Date: Sat, 17 Apr 2010 07:47:49 +0200
From: Vidar Tyldum Hansen <vidar@tyldum.com>
To: linux-media@vger.kernel.org
Subject: Re: mantis crashes
Message-ID: <20100417054749.GA6067@mail.tyldum.com>
References: <20100413150153.GB11631@mail.tyldum.com>
 <87ochne35i.fsf@nemi.mork.no>
 <20100413165616.GC11631@mail.tyldum.com>
 <loom.20100414T133315-652@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <loom.20100414T133315-652@post.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 14, 2010 at 11:41:18AM +0000, hans van den Bogert wrote:
> So it kinda looks like this is a ubuntu thing? Or are there alternative=
=20
> conclusions?

Yesterday I was able to lend a card from someone who has the same setup
as me (Ubuntu Karmic with latest kernel and using s2-lipnianin) and same
Terratec card. He too uses the blunt aproach and just build the v4l-tree
and installs it on top of the Ubuntu kernel.

After 5 hours of runtime the system crashed again. This time I had a
keyboard hooked up, which flashed caps-lock and scroll-lock. Kernel
panic, in other words. Different binay garbage in my syslog this time.

So the card hardware is ruled out, and since I know can establish that
it is a kernel panic I am almost rcertainly ruling out hardware in
general. The system is stable if the card is not used.

Things left to try hardware-wise is to switch to a different PCI slot,
but I guess I'll go down the new kernel route... I'll have to do some
research regarding v4l versions in .31, .32 and .33 to figure out to
which kernel I can 'backport' mantis without replacing v4l completely.

I am by no means a developer so this will hurt.

--=20
       Vidar Tyldum Hansen
                                 vidar@tyldum.com               PGP: 0x3110=
AA98

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvJS4UACgkQsJJnSzEQqpgLfQCfTRb70JfRBXEJzBR58MBVLZpp
P0AAn0A+72GBUN2bfox0+S87vOZkEVU5
=Be5n
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
