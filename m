Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33366 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbbLFAX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 19:23:58 -0500
Message-ID: <1449361427.31991.17.camel@collabora.com>
Subject: Re: v4l2 kernel module debugging methods
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
Date: Sat, 05 Dec 2015 19:23:47 -0500
In-Reply-To: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
References: <CAJ2oMhKbYfqz1Vy5-ERPTZAkNZt=9+rzr6yNduQiyfAWM_Zfug@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kamWAJz9F0PdekzPzx1U"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-kamWAJz9F0PdekzPzx1U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le dimanche 06 d=C3=A9cembre 2015 =C3=A0 00:00 +0200, Ran Shalit a =C3=A9cr=
it=C2=A0:
> Hello,
>=20
> I would like to ask a general question regarding methods to debug a
> v4l2 device driver.
> Since I assume that the kernel driver will probably won't work in
> first try after coding everything inside the device driver...
>=20
> 1. Do you think qemu/kgdb debugger is a good method for the device
> driver debugging , or is it plain printing ?
>=20
> 2. Is there a simple way to display the image of a YUV-like buffer in
> memory ?

Most Linux distribution ships GStreamer. You can with GStreamer read
and display a raw YUV images (you need to know the specific format)
using videoparse element.

=C2=A0 gst-launch-1.0 filesrc location=3Dmy.yuv ! videoparse format=3Dyuy2 =
width=3D320 height=3D240 ! imagefreeze ! videoconvert ! autovideosink

You could also encode and store to various formats, replacing the
imagefreeze ... section with an encoder and a filesink. Note that
videoparse unfortunatly does not allow passing strides array or
offsets. So it will work only if you set the width/height to padded
width/height.

regards,
Nicolas
--=-kamWAJz9F0PdekzPzx1U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlZjgBMACgkQcVMCLawGqBwbtQCfS5YXdvBx+ERUHBJBdmqH0Eyz
LlgAnipCsQnn9FMRcMEGgcjue42EZm1H
=T7vn
-----END PGP SIGNATURE-----

--=-kamWAJz9F0PdekzPzx1U--

