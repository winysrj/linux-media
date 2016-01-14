Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42207 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbcANPCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 10:02:30 -0500
Message-ID: <1452783743.10009.18.camel@collabora.com>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Kamil Debski <k.debski@samsung.com>,
	'Wu-Cheng Li' <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	standby24x7@gmail.com, ricardo.ribalda@gmail.com, ao2@ao2.it,
	bparrot@ti.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Date: Thu, 14 Jan 2016 10:02:23 -0500
In-Reply-To: <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
	 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
	 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Eg+JeZ429AGVvJ7by+PN"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Eg+JeZ429AGVvJ7by+PN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kamil,

Le mercredi 13 janvier 2016 =C3=A0 17:43 +0100, Kamil Debski a =C3=A9crit=
=C2=A0:
> Good to hear that there are new codecs to use the V4L2 codec API :)
>=20
> My two cents are following - when you add a control that does the same wo=
rk
> as a driver specific control then it would be great if you modified the
> driver that
> uses the specific control to also support the newly added control.
> This way future applications=C2=A0 could use the control you added for bo=
th new
> and
> old drivers.

When i first notice this MFC specific control, I believed it was use to
produce I-Frame only streams (rather then a toggle, to produce one key-
frame on demand). So I wanted to verify the implementation to make sure
what Wu-Cheng is doing make sense. Though, I found that we set:

=C2=A0 ctx->force_frame_type =3D ctrl->val;

And never use that value anywhere else in the driver code. Hopefully
I'm just missing something, but if it's not implemented, maybe it's
better not to expose it. Otherwise, this may lead to hard to find
streaming issues. I do hope we can add this feature though, as it's
very useful feature for real time encoding.

cheers,
Nicolas
--=-Eg+JeZ429AGVvJ7by+PN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaXuH8ACgkQcVMCLawGqByzoQCfRRUJdsWqZxEeG9QiyG0qWmnC
5PwAnjwsg01zeQZNUhu9sQt+hEVza9JX
=2qfj
-----END PGP SIGNATURE-----

--=-Eg+JeZ429AGVvJ7by+PN--

