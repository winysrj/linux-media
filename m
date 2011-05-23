Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:45323 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754107Ab1EWN7Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 09:59:25 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated structure is transferred from userspace to kernelspace. Keep the old ioctl around for compatibility so that existing code is not broken.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 15:58:13 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1fm2NoyJX7KgPM9"
Message-Id: <201105231558.13084.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_1fm2NoyJX7KgPM9
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_1fm2NoyJX7KgPM9
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0013.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0013.patch"

=46rom be7d0f72ebf4d945cfb2a5c9cc871707f72e1e3c Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 15:56:31 +0200
Subject: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated str=
ucture is transferred from userspace to kernelspace. Keep the old ioctl aro=
und for compatibility so that existing code is not broken.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/dvb-core/dvb_frontend.c |    5 +++--
 include/linux/dvb/frontend.h              |    3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/=
dvb-core/dvb_frontend.c
index 31e2c0d..d93c1ec 100644
=2D-- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1507,7 +1507,8 @@ static int dvb_frontend_ioctl(struct file *file,
 	if (down_interruptible (&fepriv->sem))
 		return -ERESTARTSYS;
=20
=2D	if ((cmd =3D=3D FE_SET_PROPERTY) || (cmd =3D=3D FE_GET_PROPERTY))
+	if ((cmd =3D=3D FE_SET_PROPERTY) || (cmd =3D=3D FE_GET_PROPERTY) ||
+	    (cmd =3D=3D FE_GET_PROPERTY_OLD))
 		err =3D dvb_frontend_ioctl_properties(file, cmd, parg);
 	else {
 		fe->dtv_property_cache.state =3D DTV_UNDEFINED;
@@ -1562,7 +1563,7 @@ static int dvb_frontend_ioctl_properties(struct file =
*file,
 			dprintk("%s() Property cache is full, tuning\n", __func__);
=20
 	} else
=2D	if(cmd =3D=3D FE_GET_PROPERTY) {
+	if(cmd =3D=3D FE_GET_PROPERTY || cmd =3D=3D FE_GET_PROPERTY_OLD) {
=20
 		tvps =3D (struct dtv_properties __user *)parg;
=20
diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
index 493a2bf..05b38c4 100644
=2D-- a/include/linux/dvb/frontend.h
+++ b/include/linux/dvb/frontend.h
@@ -374,7 +374,8 @@ struct dtv_properties {
 };
=20
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
=2D#define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
+#define FE_GET_PROPERTY		   _IOW('o', 83, struct dtv_properties)
+#define FE_GET_PROPERTY_OLD	   _IOR('o', 83, struct dtv_properties)
=20
=20
 /**
=2D-=20
1.7.1.1


--Boundary-00=_1fm2NoyJX7KgPM9--
