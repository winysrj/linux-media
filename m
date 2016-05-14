Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34960 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbcENK7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 06:59:19 -0400
Message-ID: <1463223553.4185.3.camel@collabora.com>
Subject: Re: gstreamer: v4l2videodec plugin
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
Cc: ayaka <ayaka@soulik.info>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
Date: Sat, 14 May 2016 13:59:13 +0300
In-Reply-To: <5735941E.6020703@mm-sol.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
	 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
	 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-p/Ojp+MtOmUXcGjB+A1m"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-p/Ojp+MtOmUXcGjB+A1m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 13 mai 2016 =C3=A0 11:45 +0300, Stanimir Varbanov a =C3=A9crit=
=C2=A0:
> yes, of course :)
>=20
> Just FYI, I applied the WIP patches on my side and I'm very happy to
> report that they just works. So If you need some testing on qcom
> video
> accelerator just ping me.
>=20
> One thing which bothers me is how the extra-controls property
> working,
> i.e. I failed to change the h264 profile for example with below
> construct:
>=20
> extra-controls=3D"controls,h264_profile=3D4;"

While I got you. I would be very interested to know who QCOM driver
interpreted the width and height expose on capture side of the decoder.
I'm adding Philippe Zabel in CC here (he's maintaining the
CODA/Freescale decoder). In Samsung MFC driver, the width and height
expose by the driver is the display size. Though, recently, Philippe is
reporting that his driver is exposing the coded size. Fixing one in
GStreamer will break the other, so I was wondering what other drivers
are doing.

cheers,
Nicolas
--=-p/Ojp+MtOmUXcGjB+A1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlc3BQEACgkQcVMCLawGqBxi7QCgrtfCUKa3ltBRsZzGXnn45LyG
DI8AniJu2Rp/psYTE4tLjwZc6yIQ5tvS
=ZG5y
-----END PGP SIGNATURE-----

--=-p/Ojp+MtOmUXcGjB+A1m--

