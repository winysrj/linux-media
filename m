Return-path: <linux-media-owner@vger.kernel.org>
Received: from cain.gsoft.com.au ([203.31.81.10]:62521 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0DWAaj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 20:30:39 -0400
From: "Daniel O'Connor" <darius@dons.net.au>
Reply-To: darius@dons.net.au
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: DViCo Dual Fusion Express (cx23885) remote control issue
Date: Fri, 23 Apr 2010 09:59:58 +0930
Cc: linux-media@vger.kernel.org
References: <201004151519.58012.darius@dons.net.au> <201004222241.28624.darius@dons.net.au> <4BD0984E.4070609@vorgon.com>
In-Reply-To: <4BD0984E.4070609@vorgon.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3174691.Z3Djbm7WdJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004231000.07508.darius@dons.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart3174691.Z3Djbm7WdJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 23 Apr 2010, Timothy D. Lenz wrote:
> On 4/22/2010 6:11 AM, Daniel O'Connor wrote:
> > On Thu, 15 Apr 2010, Daniel O'Connor wrote:
> >> I haven't delved much further yet (planning to printf my way
> >> through the probe routines) as I am a Linux kernel noob (plenty of
> >> FreeBSD experience though!).
> >
> > I found that it is intermittent with no pattern I can determine.
> >
> > When it doesn't work the probe routine is not called, but I am not
> > sure how i2c_register_driver decides to call the probe routine.
> >
> > Does anyone have an idea what the cause could be? Or at least
> > somewhere to start looking :)
>
> A patch was posted that was suposed to be merged that fixed the ir
> problem, at least for me. Though my problem was not intermittent. The
> patch worked for me. Now if I could just get both tuners to keep
> working

Hmm do you have a subject line or message ID I can search for?

I haven't found any problems with tuners not working although I don't=20
often fire them both up at once.

=2D-=20
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C

--nextPart3174691.Z3Djbm7WdJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (FreeBSD)

iD8DBQBL0OoP5ZPcIHs/zowRAlzqAKClmGckZCzsHcG80NytqSHQOKmx5wCgkra7
gc4a5MY9mpJvK4xAdBaUx+A=
=HH4w
-----END PGP SIGNATURE-----

--nextPart3174691.Z3Djbm7WdJ--
