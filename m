Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46952 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbcESOhO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 10:37:14 -0400
Message-ID: <1463668626.25686.3.camel@collabora.com>
Subject: Re: gstreamer: v4l2videodec plugin
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>, ayaka <ayaka@soulik.info>
Date: Thu, 19 May 2016 10:37:06 -0400
In-Reply-To: <1463664351.2988.47.camel@pengutronix.de>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
	 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
	 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
	 <1463223553.4185.3.camel@collabora.com> <5737151F.2090201@linaro.org>
	 <1463664351.2988.47.camel@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ALOz/beloX958LC21NyY"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-ALOz/beloX958LC21NyY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 19 mai 2016 =C3=A0 15:25 +0200, Philipp Zabel a =C3=A9crit=C2=A0:
> Is there any reason not to update the MFC driver to use G_SELECTION?
> The
> g_crop implementation could be kept for backwards compatibility.

Videobuf2 already provide this backward compatible implementation, so
there is no reason not to port that driver (if this is not done
already, maybe ask Kamil ?).

Nicolas
--=-ALOz/beloX958LC21NyY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlc9z5MACgkQcVMCLawGqBzxiACeJO5ArLFAIcHFjTfNtAk8DMPj
XKAAoNUWitlpTRFmFykv+divP71sRpfO
=Lxm6
-----END PGP SIGNATURE-----

--=-ALOz/beloX958LC21NyY--

