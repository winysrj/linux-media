Return-path: <linux-media-owner@vger.kernel.org>
Received: from os.inf.tu-dresden.de ([141.76.48.99]:54600 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZCZBjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 21:39:01 -0400
Date: Thu, 26 Mar 2009 02:38:41 +0100
From: "Udo A. Steinberg" <udo@hypervisor.org>
To: Darron Broad <darron@kewl.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org,
	mchehab@redhat.com
Subject: Re: Hauppauge/IR breakage with 2.6.28/2.6.29
Message-ID: <20090326023841.40ab3ad1@laptop.hypervisor.org>
In-Reply-To: <29212.1238027207@kewl.org>
References: <20090326000932.6aa1a456@laptop.hypervisor.org>
	<29212.1238027207@kewl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4rDDy=NHUIJ0FbsxFzLqImj";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/4rDDy=NHUIJ0FbsxFzLqImj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 26 Mar 2009 00:26:47 +0000 Darron Broad (DB) wrote:

DB> It's something I forget to deal with in that patch. A solution
DB> would be to allow a device address to be a module param to
DB> override the more modern addresses of 0x1e and 0x1f.
DB>=20
DB> I can't remember addresses off the top of my head but I believe
DB> the modern silver remotes use 0x1f and the older black ones
DB> use 0x1e. I think the black one I have came with a now dead
DB> DEC2000.
DB>=20
DB> The problem with reverting the patch is that it makes modern
DB> systems unusable as HTPCs when the television uses RC5. This
DB> is a more important IMHO than supporting what in reality is
DB> an obsolete remote control.

Hi,

Maybe there aren't many old remotes out there anymore, but from looking at
the table at http://www.sbprojects.com/knowledge/ir/rc5.htm it appears the
remote is not doing anything wrong by using RC5 address 0x0 to talk to what
could be considered a TV (card).

The more fundamental issue here is that both devices/remotes use the same
RC5 address - not surprising if you own two devices of the same device clas=
s.

So I'm all for your suggestion of adding a parameter that will allow the
user to either specify the address(es) to accept or ignore. Which of the
following options would you consider most convenient for the unknowing user?

1) parameter specifies the only device id that ir-kbd-i2c will accept
2) parameter specifies a 32-bit mask of acceptable device ids. Any device id
   whose bit is set will be accepted, others will be filtered
3) parameter specifies a 32-bit mask of device ids to filter. Any device id
   whose bit is set will be filtered, others will be accepted

Cheers,

	- Udo

--Sig_/4rDDy=NHUIJ0FbsxFzLqImj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAknK3KEACgkQnhRzXSM7nSnaCACfWdtkumTN2vj0AaG5viqwO0KW
exMAmMY+ugbsve0pxzL8amHb6WTtuwU=
=Hs+c
-----END PGP SIGNATURE-----

--Sig_/4rDDy=NHUIJ0FbsxFzLqImj--
