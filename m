Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:43310 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0KJVMM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 16:12:12 -0500
Date: Wed, 10 Nov 2010 22:11:59 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Subject: Re: Bounty for the first Open Source driver for Kinect
Message-Id: <20101110221159.8bdcbfd7.ospite@studenti.unina.it>
In-Reply-To: <AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
References: <yanpj3usd6gfp0xwdbaxlkni.1289407954066@email.android.com>
	<AANLkTimE-MWjG0JRCenOA4xhammTMS_11uvh7E+qWrNe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_22_11_59_+0100_Wn5Gng/33yKZ=Vec"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Wed__10_Nov_2010_22_11_59_+0100_Wn5Gng/33yKZ=Vec
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Nov 2010 21:54:58 +0100
Mohamed Ikbel Boulabiar <boulabiar@gmail.com> wrote:

> The bounty is already taken by that developer.
>

Which surely deserves it :)

> But now, the Kinect thing is supported like a GPL userspace library.
> Maybe still need more work to be rewritten as a kernel module.
>
> The device has also a microphone (still need to be hacked), an
> accelerometer and even a motor/engine.
> The design should be similar to the ps3eye (but 2 video output).

PS3 Eye uses bulk transfers while I see Kinect uses iso transfers,
anyway gspca handles both so in the end, yes, the driver could be quite
similar, and the packet scanning routine could be taken from the
userspace library if the license allows that.

> The engine controller and the accelerometer needs to be adressed to
> which place ? Linux-input ?.
>

I think so, exposing the accelerometer as an event device sounds
natural, about the motor I still don't know. Do those show up as usb
HID devices somehow?

About integrating the audio part (which has not even been guessed yet)
is where I shamelessly show my ignorance :)

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Wed__10_Nov_2010_22_11_59_+0100_Wn5Gng/33yKZ=Vec
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzbCp8ACgkQ5xr2akVTsAGQxgCgjVEStKiyqKjktpG4ydXtOpgu
2VMAoLEDvxAV60ztLdZdY/N9c5gZSxVI
=pJyk
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_22_11_59_+0100_Wn5Gng/33yKZ=Vec--
