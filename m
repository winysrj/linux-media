Return-path: <linux-media-owner@vger.kernel.org>
Received: from dimen.winder.org.uk ([87.127.116.10]:33066 "EHLO
	dimen.winder.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbcAYRdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:33:43 -0500
Message-ID: <1453743221.15408.86.camel@winder.org.uk>
Subject: Re: SV: PCTV 292e support
From: Russel Winder <russel@winder.org.uk>
To: Andy Furniss <adf.lists@gmail.com>,
	Peter =?ISO-8859-1?Q?F=E4ssberg?= <pf@leissner.se>,
	DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Mon, 25 Jan 2016 17:33:41 +0000
In-Reply-To: <56A570C7.5090107@gmail.com>
References: <1453613292.2497.26.camel@winder.org.uk>
	 <ijvkgaod4jhqyaoroevcea7f.1453613737402@email.android.com>
	 <1453615078.2497.29.camel@winder.org.uk>
	 <1453618564.2497.51.camel@winder.org.uk>
	 <1453625202.2497.54.camel@winder.org.uk> <56A4A262.1090708@gmail.com>
	 <1453639842.2497.69.camel@winder.org.uk> <56A570C7.5090107@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-BPbF4b7C655qAnyhPJRF"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-BPbF4b7C655qAnyhPJRF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-01-25 at 00:48 +0000, Andy Furniss wrote:
> Russel Winder wrote:
> > On Sun, 2016-01-24 at 10:07 +0000, Andy Furniss wrote:
>=20
> > It finds all the physical channels, quite happily describes all the
> > virtual channels in the T1 channels, fails to find anything in one
> > of the T2 channels and finds unnamed channels in the other T2
> > channel. The device itself is fine, as it gets all T1 and T2
> > channels
> > on Windows. This implies something awry with it in a Linux context.
>=20
> OK, I can't reproduce this on Tacoleneston which has three T2 muxes.

I have managed to get some proper T2 tuning. :-)

Someone emailed me privately to tell me about:=C2=A0

https://github.com/OpenELEC/dvb-firmware

The 292e demod firmware in their is 8 bug fix release further on that
the one I had. It looks like there was a crucial bug fix in there.

> I am using some old git version (Jun 10), I'll try current as time
> allows.
>=20
> One of the T2s only has 2 channels anyway and as is normal AFAIK
> channels that aren't running at time of scan don't get audio/video
> pids
> listed, but the rest of the info is there.
>=20
> There is a timeout option eg -T 3 trebles the timeouts - maybe try
> that.

I had tried -T 2 but that didn't do any good. I suspect the firmware I
had just wasn't up to it, but the new one was.

>=20
> > The whole point of my activity is to rewrite Me TV. This is
> > intended
> > as a very lightweight DVB player. The idea is not to have MythTV,
> > Kodi, etc. which are intended to be media centres. I just want a
> > television window with EPG. Original Me TV was GTK+2, Xine, DVBv3
> > with direct access to the kernel API. I am rewriting for libdvbv5,
> > GStreamer, GTK+3.
> >=20
> > I am starting with scan and tune codes so as to set up dvr0 as the
> > input source for the rendering. dvbv5-zap -p is an experimental
> > tool
> > to plug into a gst-launcher-1.0 script just to trial things. My
> > code
> > has the same problems dvbv5-zap has, describing my problem in terms
> > of dvbv5-zap behaviour just means it isn't my code that is wrong,
> > there is an issue somewhere in the libdvbv5 code or the device
> > driver.
>=20
> Interesting, so you know a lot more than me about this stuff :-)

I doubt that, but I am learning a lot very quickly!

I think having D, Rust, Python, and C++ bindings to libdvbv5 would help
tremendously getting it traction. Writing stuff in C with all the 1970s
programming paradigms is a real turn off in 2010s.

> Experience as a user of 292/290s - they do need some time/grace to
> tune
> in/stop spewing "junk". IIRC I added 5sec somewhere in TVH in
> addition
> to whatever it already uses.
>=20
> I guess going from T to T2 is worse - and then factor in that some
> T2s
> are much lower power than others.

I am finding locking behaviour to be very strange. Sometimes I get an
immediate lock on a -50.0 signal, sometimes -35.0 signal fails to lock.
I am not sure if this is just a timing/sampling thing or whether there
is a quality of signal thing I am missing.

As I am focused on lightweight, I am working with non-fixed aerials so
low signal strengths. Though for testing I have an aerial with powered
high gain.

> It did seem in the thread that I started where EAGAIN worked around,
> that the code was giving no grace at all and expecting to be able to
> parse stream content straight away. I may mis-remember though!


--=20
Russel.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Dr Russel Winder      t: +44 20 7585 2200   voip: sip:russel.winder@ekiga.n=
et
41 Buckmaster Road    m: +44 7770 465 077   xmpp: russel@winder.org.uk
London SW11 1EN, UK   w: www.russel.org.uk  skype: russel_winder


--=-BPbF4b7C655qAnyhPJRF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlamXHUACgkQ+ooS3F10Be9o5QCaA+Qq+r3qd8BZhRKygjfDz5O7
+G0An165wfWFzZUM592Chmzm592YZn5p
=BAtE
-----END PGP SIGNATURE-----

--=-BPbF4b7C655qAnyhPJRF--

