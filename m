Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:43529 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754179Ab1EWLPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:15:00 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Fix compile warning: Dereferencing type-punned pointer will break strict-aliasing rules.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:13:47 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_rFk2Nsgk/+WHINo"
Message-Id: <201105231313.47765.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_rFk2Nsgk/+WHINo
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_rFk2Nsgk/+WHINo
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0007.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0007.patch"

=46rom c7a1e3b3f761a8bd75799248dd83499f59eaedae Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:13:06 +0200
Subject: [PATCH] Fix compile warning: Dereferencing type-punned pointer wil=
l break strict-aliasing rules.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/video/v4l2-ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-io=
ctl.c
index 506edcc..213ba7d 100644
=2D-- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -2264,7 +2264,7 @@ static int check_array_args(unsigned int cmd, void *p=
arg, size_t *array_size,
 				break;
 			}
 			*user_ptr =3D (void __user *)buf->m.planes;
=2D			*kernel_ptr =3D (void **)&buf->m.planes;
+			*kernel_ptr =3D (void *)&buf->m.planes;
 			*array_size =3D sizeof(struct v4l2_plane) * buf->length;
 			ret =3D 1;
 		}
@@ -2278,7 +2278,7 @@ static int check_array_args(unsigned int cmd, void *p=
arg, size_t *array_size,
=20
 		if (ctrls->count !=3D 0) {
 			*user_ptr =3D (void __user *)ctrls->controls;
=2D			*kernel_ptr =3D (void **)&ctrls->controls;
+			*kernel_ptr =3D (void *)&ctrls->controls;
 			*array_size =3D sizeof(struct v4l2_ext_control)
 				    * ctrls->count;
 			ret =3D 1;
=2D-=20
1.7.1.1


--Boundary-00=_rFk2Nsgk/+WHINo--
