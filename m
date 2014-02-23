Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55818 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaBWLjZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 06:39:25 -0500
Received: from [192.168.1.221] ([93.218.100.117]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0M7kwW-1XCVg32fY0-00vSgu for
 <linux-media@vger.kernel.org>; Sun, 23 Feb 2014 12:39:23 +0100
Message-ID: <5309DDE5.6040101@rempel-privat.de>
Date: Sun, 23 Feb 2014 12:39:17 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Peter Ross <pross@xvid.org>, linux-uvc-devel@lists.sourceforge.net
CC: linux-media@vger.kernel.org
Subject: Re: [linux-uvc-devel] [PATCHv2 0/2] uvcvideo: Support Logitech RGB
 Bayer formats
References: <cover.1393133476.git.pross@xvid.org>
In-Reply-To: <cover.1393133476.git.pross@xvid.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="efcEsunmnXrbPepEGfjU2hW21jFE2bIdj"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--efcEsunmnXrbPepEGfjU2hW21jFE2bIdj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 23.02.2014 06:54, schrieb Peter Ross:
>=20
> PATCHv1 discussion: http://sourceforge.net/mailarchive/message.php?msg_=
id=3D31541036
> and http://article.gmane.org/gmane.linux.drivers.video-input-infrastruc=
ture/70192
>=20
> On Sun, Oct 20, 2013 at 11:54:10AM +0200, Oleksij Rempel wrote
> [..]
>>> Hello Peter, Laurent,
>>> Peter do have time to update this patches for latest kernel? Laurent
>>>
>>> would you accept them?
>=20
> Here are is updated pachset. They have been tested against uvcvideo-nex=
t
> today (3.14.0-rc) using FFmpeg's V4L2 grabber.
>=20
> Peter Ross (2):
>   videodev2: add V4L2_PIX_FMT_Sxxxx10_1X10 formats
>   uvcvideo: Support Logitech RGB Bayer formats
>=20
>  drivers/media/usb/uvc/uvc_driver.c | 176 +++++++++++++++++++++++++++++=
++++++++
>  drivers/media/usb/uvc/uvc_video.c  |  48 ++++++++++
>  drivers/media/usb/uvc/uvcvideo.h   |  22 +++++
>  include/uapi/linux/videodev2.h     |   4 +
>  4 files changed, 250 insertions(+)
>=20


I have some problems to use this patch set with guvcview. Frame rate
info seems to be corrupt for bayer. There are only some random values.


--=20
Regards,
Oleksij


--efcEsunmnXrbPepEGfjU2hW21jFE2bIdj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlMJ3ekACgkQHwImuRkmbWmxCAD/UdEG37EuxRSpVDGD9vDZRo4i
Fw7AdflRZQjrvGhE+UEA/RN7yVGHPQcpgfqDBxz7NfXuWHAjvRSDUMQXtVW0JlLV
=ooxi
-----END PGP SIGNATURE-----

--efcEsunmnXrbPepEGfjU2hW21jFE2bIdj--
