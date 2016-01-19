Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53033 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbcASSAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 13:00:54 -0500
Message-ID: <1453226443.5933.7.camel@collabora.com>
Subject: V4L2 Colorspace for RGB formats
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Dimitrios Katsaros <patcherwork@gmail.com>,
	linux-media@vger.kernel.org
Date: Tue, 19 Jan 2016 13:00:43 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GGNvDsXKYVjyW3Er0Mn/"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-GGNvDsXKYVjyW3Er0Mn/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Hans,

we are having issues in GStreamer with the colorspace in V4L2. The API
does not provide any encoding for RGB formats. The encoding matrix for
those is usually the identity matrix, anything else makes very little
sense to me. For example, vivid will declare a stream with RGB based
pixel format as having the default for sRGB colorspace, which lead to
non-identity syCC encoding.

Shall we simply ignore the encoding set by drivers when the pixel
format is RGB based ? To me it makes very little sense, but the code in
GStreamer is very generic and this wrong information lead to errors
when the data is converted to YUV and back to RGB.

https://bugzilla.gnome.org/show_bug.cgi?id=3D759624

cheers,
Nicolas
--=-GGNvDsXKYVjyW3Er0Mn/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlaeecsACgkQcVMCLawGqBzL5QCgtDj3QUfOF2umjxIVHAc5JCf6
tTEAn0lA39gK9khbbmBzGEpDl02gRP5h
=ZKrQ
-----END PGP SIGNATURE-----

--=-GGNvDsXKYVjyW3Er0Mn/--

