Return-path: <linux-media-owner@vger.kernel.org>
Received: from cain.gsoft.com.au ([203.31.81.10]:60010 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0DVNMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 09:12:21 -0400
From: "Daniel O'Connor" <darius@dons.net.au>
Reply-To: darius@dons.net.au
To: linux-media@vger.kernel.org
Subject: Re: DViCo Dual Fusion Express (cx23885) remote control issue
Date: Thu, 22 Apr 2010 22:41:20 +0930
References: <201004151519.58012.darius@dons.net.au>
In-Reply-To: <201004151519.58012.darius@dons.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2047839.NZhbMQMRh1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004222241.28624.darius@dons.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2047839.NZhbMQMRh1
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, 15 Apr 2010, Daniel O'Connor wrote:
> I haven't delved much further yet (planning to printf my way through
> the probe routines) as I am a Linux kernel noob (plenty of FreeBSD
> experience though!).

I found that it is intermittent with no pattern I can determine.

When it doesn't work the probe routine is not called, but I am not sure=20
how i2c_register_driver decides to call the probe routine.

Does anyone have an idea what the cause could be? Or at least somewhere=20
to start looking :)

Thanks.

=2D-=20
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C

--nextPart2047839.NZhbMQMRh1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (FreeBSD)

iD8DBQBL0EsA5ZPcIHs/zowRAhGsAJ9BanCngP13D9l5kE/nesobP7CNyACfXpfO
0rMl87nvF5DWLcb9N81lFhA=
=WS9X
-----END PGP SIGNATURE-----

--nextPart2047839.NZhbMQMRh1--
