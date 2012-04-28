Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54968 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab2D1WVl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 18:21:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SOG1K-0007mD-Rz
	for linux-media@vger.kernel.org; Sun, 29 Apr 2012 00:21:38 +0200
Received: from d67-193-214-242.home3.cgocable.net ([67.193.214.242])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 00:21:38 +0200
Received: from brian by d67-193-214-242.home3.cgocable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Sun, 29 Apr 2012 00:21:38 +0200
To: linux-media@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: HVR-1600 QAM recordings with slight glitches in them
Date: Sat, 28 Apr 2012 18:21:28 -0400
Message-ID: <4F9C6D68.3090202@interlinx.bc.ca>
References: <jn2ibp$pot$1@dough.gmane.org>  <1335307344.8218.11.camel@palomino.walls.org>  <jn7pph$qed$1@dough.gmane.org> <1335624964.2665.37.camel@palomino.walls.org> <4F9C38BE.3010301@interlinx.bc.ca> <4F9C559E.6010208@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigACB1966D9C54569E7EEB4539"
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	stoth@kernellabs.com
In-Reply-To: <4F9C559E.6010208@interlinx.bc.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigACB1966D9C54569E7EEB4539
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12-04-28 04:39 PM, Brian J. Murrell wrote:
> I typically have one more splitter downstream from that 3 way splitter
> which is a 4 way splitter to feed all of the tuners on my Mythtv box an=
d
> introducing that splitter reduces the SNR at the HVR-1600 to between
> "13c" and "13e" (31.6 - 31.8 dB).

Interestingly enough, I moved the Myth backend to it's usual home, in
the basement, right next to the incoming cable signal and replaced that
25' run that I had going to where it was temporarily with a smaller, say
10' run (of RG-59 so still room for improvement) and my SNR at the
HVR-1600, even after all of the splitters is now "015c" or 34.8 dB.

I'm still going to go replacing all of that RG-59 with shorter, custom
made lengths of RG6 cables.  I can't go "too short" when making those
can I or would even a 6-12 inch cable be perfectly fine?  I'm thinking
of the runs between that last 4 way splitter and the tuners in the Myth
backend.

b.


--------------enigACB1966D9C54569E7EEB4539
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk+cbWgACgkQl3EQlGLyuXD2agCgnyBGnwnc763jgX+/QkwguM9s
LXAAoMUTqQIHOQHpV6vhRRQQCKOK53iI
=N48X
-----END PGP SIGNATURE-----

--------------enigACB1966D9C54569E7EEB4539--

