Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36574 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbcEOHmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2016 03:42:11 -0400
Message-ID: <1463298116.4185.5.camel@collabora.com>
Subject: Re: gstreamer: v4l2videodec plugin
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
Cc: ayaka <ayaka@soulik.info>
Date: Sun, 15 May 2016 10:41:56 +0300
In-Reply-To: <5735941E.6020703@mm-sol.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
	 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
	 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ncYzggkMXuZZ4mOVTHmz"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ncYzggkMXuZZ4mOVTHmz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 13 mai 2016 =C3=A0 11:45 +0300, Stanimir Varbanov a =C3=A9crit=
=C2=A0:
> One thing which bothers me is how the extra-controls property
> working,
> i.e. I failed to change the h264 profile for example with below
> construct:
>=20
> extra-controls=3D"controls,h264_profile=3D4;"

Yes, and profile should be negotiated with downstream in GStreamer. For
common controls, like bitrate, it should be exposed as separate
properties instead.

Nicolas
--=-ncYzggkMXuZZ4mOVTHmz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlc4KEQACgkQcVMCLawGqBy9cgCfb3GP8vLXzpxwLgB0RtY5lvZn
JlEAoKk0ZJC596dJ9SwOuzEv0dLiU4Py
=2LgY
-----END PGP SIGNATURE-----

--=-ncYzggkMXuZZ4mOVTHmz--

