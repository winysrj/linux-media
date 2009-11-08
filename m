Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54351 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654AbZKHCDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Nov 2009 21:03:54 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
References: <1257630476.15927.400.camel@localhost>
	 <1257644240.6895.5.camel@palomino.walls.org>
	 <829197380911071744q50fc6e18o527322e1120b9689@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/0n8++4g/I31jTuX+hFB"
Date: Sun, 08 Nov 2009 02:03:54 +0000
Message-ID: <1257645834.15927.634.camel@localhost>
Mime-Version: 1.0
Subject: Re: [PATCH 10/75] V4L/DVB: declare MODULE_FIRMWARE for modules
 using  XC2028 and XC3028L tuners
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-/0n8++4g/I31jTuX+hFB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-07 at 20:44 -0500, Devin Heitmueller wrote:
> On Sat, Nov 7, 2009 at 8:37 PM, Andy Walls <awalls@radix.net> wrote:
> > On Sat, 2009-11-07 at 21:47 +0000, Ben Hutchings wrote:
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >> ---
> >> I'm not really sure whether it's better to do this in the drivers whic=
h
> >> specify which firmware file to use, or just once in the xc2028 tuner
> >> driver.  Your call.
> >>
> >> Ben.
> >
> > Ben,
> >
> > I would suspect it's better left in the xc2028 tuner driver module.
> >
> > Rationale:
> >
> > a. it will be consistent with other modules like the cx25840 module.
> > ivtv and cx23885 load the cx25840 module yet the MODULE_FIRMWARE
> > advertisement for the CX2584[0123] or CX2388[578] A/V core firmware is
> > in the cx25840 module.
> >
> > b. not every ivtv or cx18 supported TV card, for example, needs the
> > XCeive tuner chip firmware, so it's not a strict requirement for those
> > modules.  It is a strict(-er) requirement for the xc2028 module.
> >
> > My $0.02
> >
> > Regards,
> > Andy
>=20
> It's not clear to me what this MODULE_FIRMWARE is going to be used
> for, but if it's for some sort of module dependency system, then it
> definitely should *not* be a dependency for em28xx.  There are lots of
> em28xx based devices that do not use the xc3028, and those users
> should not be expected to go out and find/extract the firmware for
> some tuner they don't have.

This information is currently used by initramfs builders to find
required firmware files.  I also use this information in the Debian
kernel upgrade script to warn if a currently loaded driver may require
firmware in the new kernel version and the firmware is not installed.
This is important during the transition of various drivers from built-in
to separate firmware.

Neither of these uses applies to TV tuners, but the information may
still be useful in installers.

> Also, how does this approach handle the situation where there are two
> different possible firmwares depending on the card using the firmware.
>  As in the example above, you the xc3028 can require either the xc3028
> or xc3028L firmware depending on the board they have.  Does this
> change now result in both firmware images being required?

It really depends on how the information is used.  Given that there are
many drivers that load different firmware files for different devices
(or even support multiple different versions with different names), it
would be rather stupid to treat these declaration as requirements.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-/0n8++4g/I31jTuX+hFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASvYnBOe/yOyVhhEJAQKlRQ//fyuHJyt+1+gLQiZGjHyqdwmf6+x1tLqM
H4HPlybsKWrEDmmH+BaOGEgJTX0+xel7yV2eTGDqyZV8advQQvoT5pdLdjAjpWbS
clLo3X0Ke7/oAGMfkVC6C96TL+PQasJZSATEbPb3Zm0Pg4XI7lpiOJhnb4IMmpH2
M5sGFkWbxTVlfw6JV75LLYPn0IyLHCVn0ECKzn/yW1VE5C2/IqwXyYwq4BG9TwzE
9xCBx4cSFTsoZIEhD6BtyuSglPF4InH3S5Qf+UTHf0uLhserVC6p3gcWVHs5U0bP
m0l1mWJskNfYO+VDgofQNmvvLVcDNB8+R/luA/I5rx5LTll3z4huHo02TIpc/HTF
woVeUPS8aBC+mTorZw1v/1odMJ1ajcEotioWk2ouc1iJYPeXrPm6jUSYUHlGlIVZ
qe5rvDpN/k1PW3qcHAa1l1dLTXtDhPl2TPdc7FoxEuHgpRmJ+M8vlFXkw3ljJpX6
fAx5anCxKfdaT8DjA25BeYJbNbn0elcSR2EHHDCoGkQVg1I/zv8zkHxaMKLN7yuW
idcVB46IwYRQhGz93kiIEZrPkpBZHXiAJUdls170BnWyqNPzh5A0v7sboTdjJfzl
ocRJVX0mglscMLcy+8VY/7RVfitqi1BaKj3HXG5Wl5zopLu1zrYMQHShCyHQBqzp
y2Pnm+/+TC8=
=/qaH
-----END PGP SIGNATURE-----

--=-/0n8++4g/I31jTuX+hFB--
