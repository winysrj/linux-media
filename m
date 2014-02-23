Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33550 "EHLO
	mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbaBWG0e (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 01:26:34 -0500
Date: Sun, 23 Feb 2014 16:54:13 +1100
From: Peter Ross <pross@xvid.org>
To: linux-uvc-devel@lists.sourceforge.net
Cc: linux-media@vger.kernel.org
Subject: [PATCHv2 0/2] uvcvideo: Support Logitech RGB Bayer formats
Message-ID: <cover.1393133476.git.pross@xvid.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


PATCHv1 discussion: http://sourceforge.net/mailarchive/message.php?msg_id=
=3D31541036
and http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure=
/70192

On Sun, Oct 20, 2013 at 11:54:10AM +0200, Oleksij Rempel wrote
[..]
>> Hello Peter, Laurent,
>> Peter do have time to update this patches for latest kernel? Laurent
>>
>> would you accept them?

Here are is updated pachset. They have been tested against uvcvideo-next
today (3.14.0-rc) using FFmpeg's V4L2 grabber.

Peter Ross (2):
  videodev2: add V4L2_PIX_FMT_Sxxxx10_1X10 formats
  uvcvideo: Support Logitech RGB Bayer formats

 drivers/media/usb/uvc/uvc_driver.c | 176 +++++++++++++++++++++++++++++++++=
++++
 drivers/media/usb/uvc/uvc_video.c  |  48 ++++++++++
 drivers/media/usb/uvc/uvcvideo.h   |  22 +++++
 include/uapi/linux/videodev2.h     |   4 +
 4 files changed, 250 insertions(+)

--=20
1.8.3.2

-- Peter
(A907 E02F A6E5 0CD2 34CD 20D2 6760 79C5 AC40 DD6B)

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEARECAAYFAlMJjQUACgkQZ2B5xaxA3WsHYwCePPdHLuYL2p3Xg1fkpFzczGZ9
q8IAoMV83ySA1myzTLpByldPhswHtGCF
=nD/C
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
