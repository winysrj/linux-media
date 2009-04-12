Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailc.rambler.ru ([81.19.66.27]:7423 "EHLO mailc.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbZDLTvJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Apr 2009 15:51:09 -0400
From: Victor <ErV2005@rambler.ru>
Reply-To: ErV2005@rambler.ru
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: Dark picture on Genius E-Messenger 112 webcam with yesterday's v4l-dvb code.
Date: Sun, 12 Apr 2009 23:50:50 +0400
References: <200904111816.14704.ErV2005@rambler.ru> <20090412190831.0350590f@free.fr>
In-Reply-To: <20090412190831.0350590f@free.fr>
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1514734.XD2LJgA86f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200904122351.04289.ErV2005@rambler.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1514734.XD2LJgA86f
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

On Sunday 12 April 2009 21:08:31 you wrote:
> On Sat, 11 Apr 2009 18:16:14 +0400
>
> Victor <ErV2005@rambler.ru> wrote:
> > Hello.
>
> Hello Victor,
>
> > I'm using Genius E-Messenger 112 webcam on Slackware 12.2 with
> > 2.6.27.7 kernel (custom-built) and yesterday's v4l-dvb sources
> > checked out via "mercurial" ("hg log" returns "11445:dba0b6fae413" as
> > latest commit). the camera uses gspca_main and gspca_pac207 kernel
> > modules.`
> >
> > Camera works (with LD_PRELOAD=3Dv4l2convert.so) in mplayer (mplayer
> > tv://) and skype, but picture is way too dark. It looks like
> > "contrast" is permanently set at maximum, and doesn't change
> > (although it looks like camera tries to adjust brightness
> > automatically).
> >
> > How can this be fixed?
>
> Did you try to change the webcam controls? (there are brightness,
> exposure, autogain and gain - they may be changed by programs as
> v4l2ucp or vlc)
I can modify brightness, exposure, gain/autogain from vlc.
It looks like the problem is related to automatic gain function. Automatic=
=20
gain is enabled by default. When it is enabled, it slowly sets "gain" to th=
e=20
maximum, "brightness" to minimum, and "exposure" according to the situation=
=20
(somewhere in the middle).
"Normal" results are produced when gain is near zero.
That's why picture looks bad.=20
I could run vlc each time I'm going to use webcam, of course, but I'd like =
to=20
keep automatic brightness/contrast/gain feature and fix it.

As I understand it, automatic exposure is handled by=20
"gspca_auto_gain_n_exposure" routine which is located at line 2048 in gspca=
=2Ec,=20
but "gspca_auto_gain_n_exposure" is actually called=20
from "pac207_do_auto_gain", line 338 of pac207.c, and at least some data th=
at=20
could produce wrong result (avg_lum) seems to be read from the frame data o=
f=20
the webcam (line 385 of pac207.c).=20

So I'm not quite sure - given this info,
> You may ask to Hans de Goede who is the maintainer of the pac207
> driver.
>
> Cheers.
should I continue discussion here or contact maintainer of pac207 instead?

=2D-=20
Best regards, Victor

--nextPart1514734.XD2LJgA86f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEcBAABAgAGBQJJ4kYaAAoJEFQ9XFmrgYhxYXsIAMPRotiQn3+XC9+ynA3qQeg8
iz0uupMLGEXszmDUHtmtyMlIl6e+xEa8KKgnISvvZRyH02wak3TpL9OErHDykaKa
AAtxnccCvNBj5GEDTCOWi3wYNfIRCeNZgwbex7v2wKOMTqeTHH0O3nT4lw5ZMbz3
NbklSR79O1AVlrdSsfGebWTmq5MbXSCSKRXKHhkb5x73aje2pkVi3QvftCWJcHNW
OZbBLyCJw4wvn4sb4/4FY9CFfmZ0JMCgE68Dftwswvgs5EgHjlzWnvn4nppMFBOp
4HZ4/dN4s5ciQDkq68Tu5LvZ1qs4M3e/qbbo9FUt624qFqTo4FkgZ2yoJTxo128=
=eE6l
-----END PGP SIGNATURE-----

--nextPart1514734.XD2LJgA86f--
