Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42222 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcANPFy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 10:05:54 -0500
Message-ID: <1452783947.10009.20.camel@collabora.com>
Subject: Re: [PATCH v3 0/2] new control V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Wu-Cheng Li <wuchengli@chromium.org>, pawel@osciak.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl, k.debski@samsung.com,
	crope@iki.fi, standby24x7@gmail.com, ricardo.ribalda@gmail.com,
	ao2@ao2.it, bparrot@ti.com, kyungmin.park@samsung.com,
	jtp.park@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	tiffany.lin@mediatek.com, djkurtz@chromium.org
Date: Thu, 14 Jan 2016 10:05:47 -0500
In-Reply-To: <1452783007-80883-1-git-send-email-wuchengli@chromium.org>
References: <1452783007-80883-1-git-send-email-wuchengli@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IqT+0WtcRMglZYlAmQ6U"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-IqT+0WtcRMglZYlAmQ6U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 14 janvier 2016 =C3=A0 22:50 +0800, Wu-Cheng Li a =C3=A9crit=C2=A0=
:
> v3 addressed Hans' comment to remove the name of the control in s5p-
> mfc.
>=20
> Wu-Cheng Li (2):
> =C2=A0 v4l: add V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.

Hans suggested to name it V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME.

regards,
Nicolas

> =C2=A0 s5p-mfc: add the support of V4L2_CID_MPEG_VIDEO_FORCE_I_FRAME.
>=20
> =C2=A0Documentation/DocBook/media/v4l/controls.xml |=C2=A0=C2=A08 +++++++=
+
> =C2=A0drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 12 ++++++++++++
> =C2=A0drivers/media/v4l2-core/v4l2-ctrls.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 ++
> =C2=A0include/uapi/linux/v4l2-controls.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A01 +
> =C2=A04 files changed, 23 insertions(+)
>=20
--=-IqT+0WtcRMglZYlAmQ6U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaXuUwACgkQcVMCLawGqBzXfgCeIz0fR65AvnnGTy11y7FjdcsD
ckgAoJMeBt3p4nG1az9Pwu03ManNkJfj
=sAtU
-----END PGP SIGNATURE-----

--=-IqT+0WtcRMglZYlAmQ6U--

