Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34346 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbcFTINB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 04:13:01 -0400
Received: by mail-lf0-f53.google.com with SMTP id h129so31715839lfh.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 01:12:02 -0700 (PDT)
Date: Mon, 20 Jun 2016 10:05:09 +0200
From: Henrik Austad <henrik@austad.us>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	alsa-devel@alsa-project.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
	linux-media@vger.kernel.org
Subject: Re: [very-RFC 0/8] TSN driver for the kernel
Message-ID: <20160620080509.GA8011@sisyphus.home.austad.us>
References: <1465686096-22156-1-git-send-email-henrik@austad.us>
 <20160613114713.GA9544@localhost.localdomain>
 <20160613195136.GC2441@netboy>
 <20160614121844.54a125a5@lxorguk.ukuu.org.uk>
 <5760C84C.40408@sakamocchi.jp>
 <20160615080602.GA13555@localhost.localdomain>
 <5764DA85.3050801@sakamocchi.jp>
 <20160618224549.GF32724@icarus.home.austad.us>
 <20160619094629.GC5853@netboy>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20160619094629.GC5853@netboy>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 19, 2016 at 11:46:29AM +0200, Richard Cochran wrote:
> On Sun, Jun 19, 2016 at 12:45:50AM +0200, Henrik Austad wrote:
> > edit: this turned out to be a somewhat lengthy answer. I have tried to=
=20
> > shorten it down somewhere. it is getting late and I'm getting increasin=
gly=20
> > incoherent (Richard probably knows what I'm talking about ;) so I'll st=
op=20
> > for now.
>=20
> Thanks for your responses, Henrik.  I think your explanations are on spot.
>=20
> > note that an adjustable sample-clock is not a *requirement* but in gene=
ral=20
> > you'd want to avoid resampling in software.
>=20
> Yes, but..
>=20
> Adjusting the local clock rate to match the AVB network rate is
> essential.  You must be able to *continuously* adjust the rate in
> order to compensate drift.  Again, there are exactly two ways to do
> it, namely in hardware (think VCO) or in software (dynamic
> resampling).

Don't get me wrong, having an adjustable clock for the sampling is=20
essential -but it si not -required-.

> What you cannot do is simply buffer the AV data and play it out
> blindly at the local clock rate.

No, that you cannot do that, that would not be pretty :)

> Regarding the media clock, if I understand correctly, there the talker
> has two possibilities.  Either the talker samples the stream at the
> gPTP rate, or the talker must tell the listeners the relationship
> (phase offset and frequency ratio) between the media clock and the
> gPTP time.  Please correct me if I got the wrong impression...

Last first; AFAIK, there is no way for the Talker to tell a Listener the=20
phase offset/freq ratio other than how each end-station/bridge in the=20
gPTP-domain calculates this on psync_update event messages. I could be=20
wrong though, and different encoding formats can probably convey such=20
information. I have not seen any such mechanisms in the underlying 1722=20
format though.

So a Talker should send a stream sampled as if the gPTP time drove the=20
AD/DA sample frequency directly. Whether the local sampling is driven by=20
gPTP or resampled to match gPTP-time prior to transmit is left as an=20
implementation detail for the end-station.

Did all that make sense?

Thanks!
--=20
Henrik Austad

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAldno7UACgkQ6k5VT6v45llOgACgk72paNK2UKfkh92hcQYFyjif
qlwAn27DMOWmCGKj1eyajMDKnCmGmRUv
=QN1y
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
