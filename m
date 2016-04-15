Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:51904 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcDOQKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 12:10:01 -0400
Message-ID: <1460736595.973.5.camel@ndufresne.ca>
Subject: Re: gstreamer: v4l2videodec plugin
From: Nicolas Dufresne <nicolas@ndufresne.ca>
Reply-To: nicolas@ndufresne.ca
To: Rob Clark <robdclark@gmail.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 15 Apr 2016 12:09:55 -0400
In-Reply-To: <CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
	 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
	 <CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GvIembwNX/u7lFuscRSY"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GvIembwNX/u7lFuscRSY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 15 avril 2016 =C3=A0 11:58 -0400, Rob Clark a =C3=A9crit=C2=A0:
> The issue is probably the YUV format, which we cannot really deal
> with
> properly in gallium..=C2=A0 it's a similar issue to multi-planer even if
> it
> is in a single buffer.
>=20
> The best way to handle this would be to import the same dmabuf fd
> twice, with appropriate offsets, to create one GL_RED eglimage for Y
> and one GL_RG eglimage for UV, and then combine them in shader in a
> similar way to how you'd handle separate Y and UV planes..

That's the strategy we use in GStreamer, as very few GL stack support
implicit color conversions. For that to work you need to implement the
"offset" field in winsys_handle, that was added recently, and make sure
you have R8 and RG88 support (usually this is just mapping).

cheers,
Nicolas
--=-GvIembwNX/u7lFuscRSY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlcRElMACgkQcVMCLawGqBz77gCeLNwTe4cigUd0/s01Ex3z1a+V
BngAmwb/PF6sOubagqT2jqCS8jLb5qT5
=rzQ4
-----END PGP SIGNATURE-----

--=-GvIembwNX/u7lFuscRSY--

