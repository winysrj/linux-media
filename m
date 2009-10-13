Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.186]:23298 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZJMTd7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 15:33:59 -0400
Received: by gv-out-0910.google.com with SMTP id r4so137201gve.37
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 12:32:11 -0700 (PDT)
Date: Tue, 13 Oct 2009 21:31:19 +0200
From: Giuseppe Borzi <gborzi@gmail.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Dazzle TV Hybrid USB and em28xx
Message-ID: <20091013213119.7e790e7b@ieee.org>
In-Reply-To: <829197380910121723i59d2498en10d166f523889fbd@mail.gmail.com>
References: <loom.20091011T180513-771@post.gmane.org>
	<829197380910111218q5739eb5ex9a87f19899a13e98@mail.gmail.com>
	<loom.20091012T223603-551@post.gmane.org>
	<829197380910121437m4f1fb7cld8d7dc351f468671@mail.gmail.com>
	<20091013012255.260afea3@ieee.org>
	<829197380910121723i59d2498en10d166f523889fbd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sBLXSC7LJ/Iy5kHMBRzDd9D"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/sBLXSC7LJ/Iy5kHMBRzDd9D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> On Mon, Oct 12, 2009 at 7:22 PM, Giuseppe Borzi <gborzi@gmail.com>
> wrote:
> >>
> >> Yeah, that happens with Ubuntu Karmic. =C2=A0The v4l-dvb firedtv driver
> >> depends on headers that are private to ieee1394 and not in their
> >> kernel headers package.
> >>
> >> To workaround the issue, open v4l/.config and set the firedtv
> >> driver from "=3Dm" to "=3Dn"
> >>
> >> Devin
> >>
> >
> > Thanks Devin,
> > following your instruction for firedtv I've compiled
> > v4l-dvb-5578cc977a13 but the results aren't so good. After doing an
> > "make rminstall" , compiling and "make install" I plugged the USB
> > stick, the various devices were created (including /dev/dvb) and
> > here is the dmesg output (now it's identified as card=3D1)
> >
> > then I started checking if it works. The command "vlc channels.conf"
> > works, i.e. it plays the first channel in the list, but is unable to
> > switch channel. me-tv doesn't start, but I think this is related to
> > the recent gnome upgrade. w_scan doesn't find any channel.
>=20
> Open v4l/em28xx-cards.c and comment out line 181 so it looks like:
>=20
> //        {EM2880_R04_GPO,        0x04,   0xff,          100},/*
> zl10353 reset */
>=20
> This is an issue I have been actively debugging for two other users.
>=20
> > Analog TV only shows video, no audio. Tried this both with sox and
> > vlc. When you say that I have to choose the right TV standard (PAL
> > for my region) do you mean I have to select this in the TV app I'm
> > using (tvtime, vlc, xawtv) or as a module option? I've not seen any
> > em28xx option for TV standard, so I suppose it's in the app.
>=20
> Correct - the em28xx module does not have module parameters for the
> standard - you have to select it in the application.
>=20
> > Finally, I've noticed that the device is much less hot than it
> > happened with out of kernel modules and the card=3D11 workaround.
> > Is your latest post "em28xx mode switching" related to my device?
>=20
> Yes, it is one device effected by that discussion.
>=20
> Devin
>=20

Thanks Devin,
now DVB works as expected, i.e. I can change channel and w_scan
finds the channels available in my area. The stick is recognized as
card=3D1 instead of 53 as I expected, but still it works fine.
Still no sound for analog TV, but that's a minor problem.

Thanks again.

--=20
***********************************************************
  Giuseppe Borzi, Assistant Professor at the
  University of Messina - Department of Civil Engineering
  Address: Contrada di Dio, Messina, I-98166, Italy
  Tel:     +390903977323
  Fax:     +390903977480
  email:   gborzi@ieee.org
  url:     http://ww2.unime.it/dic/gborzi/index.php
***********************************************************

--Sig_/sBLXSC7LJ/Iy5kHMBRzDd9D
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrU1YcACgkQVX4H2P5hPtP6VwCfUtTAFg/4bGgDQvbRCaJhh9SP
7jgAnAsF2U1EfDIUZP7DCh8V3tVl3HP3
=eXNH
-----END PGP SIGNATURE-----

--Sig_/sBLXSC7LJ/Iy5kHMBRzDd9D--
