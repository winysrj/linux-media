Return-path: <linux-media-owner@vger.kernel.org>
Received: from b186.blue.fastwebserver.de ([62.141.42.186]:48003 "EHLO
	mail.gw90.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758450AbZHRLHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 07:07:17 -0400
Subject: [Request for testing] new dib0700 code (was: Re: dib0700 diversity
 support)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LRH.1.10.0908181222400.7725@pub1.ifh.de>
References: <1250177934.6590.120.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908140947560.14872@pub3.ifh.de>
	 <1250244562.5438.3.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908181052400.7725@pub1.ifh.de>
	 <1250590149.5938.33.camel@mattotaupa.wohnung.familie-menzel.net>
	 <alpine.LRH.1.10.0908181222400.7725@pub1.ifh.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wh4z08gQXWaFKjfvgZ5+"
Date: Tue, 18 Aug 2009 13:07:10 +0200
Message-Id: <1250593630.5938.75.camel@mattotaupa.wohnung.familie-menzel.net>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-wh4z08gQXWaFKjfvgZ5+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Patrick,


Am Dienstag, den 18.08.2009, 12:27 +0200 schrieb Patrick Boettcher:
> On Tue, 18 Aug 2009, Paul Menzel wrote:
> > Am Dienstag, den 18.08.2009, 10:54 +0200 schrieb Patrick Boettcher:
> >> On Fri, 14 Aug 2009, Paul Menzel wrote:
> >>>> I'll post a request for testing soon.
> >>>
> >>> I am looking forward to it.
> >>
> >> Can you please try the drivers from here:
> >> http://linuxtv.org/hg/~pb/v4l-dvb/
> >
> > I installed it as described in [1].
> >
> >        # clone
> >        make
> >        sudo make install
> >        sudo make unload
> >        # insert stick again
> >
> > [1] http://sidux.com/module-Wikula-history-tag-TerraTec.html

[=E2=80=A6]

> > Ok, I do not know how to test this objectively. Not knowing what how to
> > do this, I just insert the console output of Kaffeine while scanning fo=
r
> > channels. See the end of this message.

Are those values showing the signal strength?

> > In summary I would they I did not see any difference in quality between
> > the two versions at a bad reception spot. I thought the signal bar
> > showed values increased by 2?4 %, so a little bit better.
>=20
> Can be weather conditions....

I tested both version in a 30 minutes time frame.

> The SNR could give a clue how far you are away from receiving, but it is=20
> currently not implemented.
>=20
> I hate to request it, but can you try the windows driver with the device=20
> without touching the antenna at that point. Like that we can exclude any

Well, I cannot do it right now. But I can test it the Wednesday next
week. I hope this is alright. Maybe some other people can test it
sooner. (I therefore changed the subject.)


Thanks,

Paul

--=-wh4z08gQXWaFKjfvgZ5+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqKi14ACgkQPX1aK2wOHVjnxACZAXtnnKv316dqqmCs2DsQNqy8
JEQAn0NBuB5WTnAdHM4cbx37PgDbM1iq
=a2lS
-----END PGP SIGNATURE-----

--=-wh4z08gQXWaFKjfvgZ5+--

