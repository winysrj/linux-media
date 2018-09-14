Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43937 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeINXlb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:41:31 -0400
Received: by mail-qt0-f193.google.com with SMTP id g53-v6so9583822qtg.10
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 11:25:50 -0700 (PDT)
Message-ID: <92552cb2c21877c0093b8a327582450b9305df18.camel@ndufresne.ca>
Subject: Re: [PATCH v3 0/5] Fix OV5640 exposure & gain
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Fri, 14 Sep 2018 14:25:46 -0400
In-Reply-To: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
References: <1536673701-32165-1-git-send-email-hugues.fruchet@st.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-m2F8zCtmjmxqvaDVoN1R"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-m2F8zCtmjmxqvaDVoN1R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Interesting, I just hit this problem yesterday. Same module as Steve, =20
with MIPI CSI-2 OV5640 (on Sabre Lite).

Tested-By: Nicolas Dufresne <nicolas.dufresne@collabora.com>

Le mardi 11 septembre 2018 =C3=A0 15:48 +0200, Hugues Fruchet a =C3=A9crit =
:
> This patch serie fixes some problems around exposure & gain in OV5640
> driver.
>=20
> The 4th patch about autocontrols requires also a fix in v4l2-ctrls.c:
>=20
https://www.mail-archive.com/linux-media@vger.kernel.org/msg133164.html
>=20
> Here is the test procedure used for exposure & gain controls check:
> 1) Preview in background
> $> gst-launch-1.0 v4l2src ! "video/x-raw, width=3D640, Height=3D480" !
> queue ! waylandsink -e &
> 2) Check gain & exposure values
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=3D0 max=3D65535 step=3D1
> default=3D0 value=3D330 flags=3Dinactive, volatile
>                            gain (int)    : min=3D0 max=3D1023 step=3D1
> default=3D0 value=3D19 flags=3Dinactive, volatile
> 3) Put finger in front of camera and check that gain/exposure values
> are changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=3D0 max=3D65535 step=3D1
> default=3D0 value=3D660 flags=3Dinactive, volatile
>                            gain (int)    : min=3D0 max=3D1023 step=3D1
> default=3D0 value=3D37 flags=3Dinactive, volatile
> 4) switch to manual mode, image exposition must not change
> $> v4l2-ctl --set-ctrl=3Dgain_automatic=3D0
> $> v4l2-ctl --set-ctrl=3Dauto_exposure=3D1
> Note the "1" for manual exposure.
>=20
> 5) Check current gain/exposure values:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=3D0 max=3D65535 step=3D1
> default=3D0 value=3D330
>                            gain (int)    : min=3D0 max=3D1023 step=3D1
> default=3D0 value=3D20
>=20
> 6) Put finger behind camera and check that gain/exposure values are
> NOT changing:
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=3D0 max=3D65535 step=3D1
> default=3D0 value=3D330
>                            gain (int)    : min=3D0 max=3D1023 step=3D1
> default=3D0 value=3D20
> 7) Update exposure, check that it is well changed on display and that
> same value is returned:
> $> v4l2-ctl --set-ctrl=3Dexposure=3D100
> $> v4l2-ctl --get-ctrl=3Dexposure
> exposure: 100
>=20
> 9) Update gain, check that it is well changed on display and that
> same value is returned:
> $> v4l2-ctl --set-ctrl=3Dgain=3D10
> $> v4l2-ctl --get-ctrl=3Dgain
> gain: 10
>=20
> 10) Switch back to auto gain/exposure, verify that image is correct
> and values returned are correct:
> $> v4l2-ctl --set-ctrl=3Dgain_automatic=3D1
> $> v4l2-ctl --set-ctrl=3Dauto_exposure=3D0
> $> v4l2-ctl --all | grep -e exposure -e gain | grep "(int)"
>                        exposure (int)    : min=3D0 max=3D65535 step=3D1
> default=3D0 value=3D330 flags=3Dinactive, volatile
>                            gain (int)    : min=3D0 max=3D1023 step=3D1
> default=3D0 value=3D22 flags=3Dinactive, volatile
> Note the "0" for auto exposure.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D history =3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> version 3:
>   - Change patch 5/5 by removing set_mode() orig_mode parameter as
> per jacopo' suggestion:
>     https://www.spinics.net/lists/linux-media/msg139457.html
>=20
> version 2:
>   - Fix patch 3/5 commit comment and rename binning function as per
> jacopo' suggestion:
>    =20
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg133272.html
>=20
> Hugues Fruchet (5):
>   media: ov5640: fix exposure regression
>   media: ov5640: fix auto gain & exposure when changing mode
>   media: ov5640: fix wrong binning value in exposure calculation
>   media: ov5640: fix auto controls values when switching to manual
> mode
>   media: ov5640: fix restore of last mode set
>=20
>  drivers/media/i2c/ov5640.c | 128 ++++++++++++++++++++++++++---------
> ----------
>  1 file changed, 73 insertions(+), 55 deletions(-)
>=20

--=-m2F8zCtmjmxqvaDVoN1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW5v9KwAKCRBxUwItrAao
HNP2AKC80ukkjORcWx542NcbXjnoffnjvACgsK4pscFKGDX+Ey/2e3OAKaKy2es=
=uRrv
-----END PGP SIGNATURE-----

--=-m2F8zCtmjmxqvaDVoN1R--
