Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42642 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300AbcANTCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 14:02:31 -0500
Message-ID: <1452798133.3306.3.camel@collabora.com>
Subject: Re: [PATCH] v4l: add V4L2_CID_MPEG_VIDEO_FORCE_FRAME_TYPE.
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Kamil Debski <k.debski@samsung.com>,
	'Wu-Cheng Li' <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl, crope@iki.fi,
	standby24x7@gmail.com, ricardo.ribalda@gmail.com, ao2@ao2.it,
	bparrot@ti.com, 'Andrzej Hajda' <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Date: Thu, 14 Jan 2016 14:02:13 -0500
In-Reply-To: <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
References: <1452686611-145620-1-git-send-email-wuchengli@chromium.org>
	 <1452686611-145620-2-git-send-email-wuchengli@chromium.org>
	 <003f01d14e21$78f7ad40$6ae707c0$@samsung.com>
	 <1452783743.10009.18.camel@collabora.com>
	 <00ac01d14ef0$0702b2f0$150818d0$@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-brlVbyPf4xej2aoZ8DtX"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-brlVbyPf4xej2aoZ8DtX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 14 janvier 2016 =C3=A0 18:21 +0100, Kamil Debski a =C3=A9crit=C2=
=A0:
> I had a look into the documentation of MFC. It is possible to force
> two types of a frame to be coded.
> The one is a keyframe, the other is a not coded frame. As I
> understand this is a type of frame that means that image did not
> change from previous frame. I am sure I seen it in an MPEG4 stream in
> a movie trailer. The initial board with the age rating is displayed
> for a couple of seconds and remains static. Thus there is one I-frame=20
> and a number of non-coded frames.
>=20
> That is the reason why the control was implemented in MFC as a menu
> and not a button. Thus the question remains - is it better to leave
> it as a menu, or should there be two (maybe more in the future)
> buttons?

Then I believe we need both. Because with the menu, setting I-Frame, I
would expect to only receive keyframes from now-on. While the useful
feature we are looking for here, is to get the next buffer (or nearby)
to be a keyframe. It's the difference between creating an I-Frame only
stream and requesting a key-frame manually for recovery (RTP use case).
In this end, we should probably take that time to review the features
we have as we need:

- A way to trigger a key frame to be produce
- A way to produce a I-Frame only stream
- A way to set the key-frame distance (in frames) even though this
could possibly be emulated using the trigger.

cheers,
Nicolas
--=-brlVbyPf4xej2aoZ8DtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaX8LUACgkQcVMCLawGqBy+NgCgz5q9VWw+FIGC6xKtcn0MSEWn
e9AAn0NzyR4+QkHx8o160oqZcv92dGoM
=7kPt
-----END PGP SIGNATURE-----

--=-brlVbyPf4xej2aoZ8DtX--

