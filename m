Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA95mwY015255
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 04:05:48 -0500
Received: from m13-128.163.com (m13-128.163.com [220.181.13.128])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBA95URv010001
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 04:05:31 -0500
Date: Wed, 10 Dec 2008 17:05:12 +0800 (CST)
From: niuxinlong_1984 <niuxinlong_1984@163.com>
To: "Jim Paris" <jim@jtan.com>
Message-ID: <24406735.417391228899912348.JavaMail.coremail@bj163app128.163.com>
In-Reply-To: <c3eafdd5ba7cb667ed30.1228864539@hypnosis.jim>
References: <c3eafdd5ba7cb667ed30.1228864539@hypnosis.jim>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: quoted-printable
Cc: video4linux-list@redhat.com
Subject: Re:[PATCH 1 of 2] gspca: allow subdrivers to handle v4l2_streamparm
	requests
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

=20
=20


=D4=DA2008-12-10=A3=AC"Jim Paris" <jim@jtan.com> =D0=B4=B5=C0=A3=BA
># HG changeset patch
># User jim@jtan.com
># Date 1228860341 18000
># Node ID c3eafdd5ba7cb667ed301e7feed6b02b57f1aa7a
># Parent  51458dbe1fdab9f2463a49772fb8be39eabe520c
>gspca: allow subdrivers to handle v4l2_streamparm requests
>
>Add get_streamparm and set_streamparm operations so subdrivers can
>get/set stream parameters such as framerate.
>
>Signed-off-by: Jim Paris <jim@jtan.com>
>
>diff -r 51458dbe1fda -r c3eafdd5ba7c linux/drivers/media/video/gspca/gspca=
.c
>--- a/linux/drivers/media/video/gspca/gspca.c=09Tue Dec 09 16:55:39 2008 -=
0500
>+++ b/linux/drivers/media/video/gspca/gspca.c=09Tue Dec 09 17:05:41 2008 -=
0500
>@@ -1337,6 +1337,16 @@
> =09memset(parm, 0, sizeof *parm);
> =09parm->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
> =09parm->parm.capture.readbuffers =3D gspca_dev->nbufread;
>+
>+=09if (gspca_dev->sd_desc->get_streamparm) {
>+=09=09int ret;
>+=09=09if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>+=09=09=09return -ERESTARTSYS;
>+=09=09ret =3D gspca_dev->sd_desc->get_streamparm(gspca_dev, parm);
>+=09=09mutex_unlock(&gspca_dev->usb_lock);
>+=09=09return ret;
>+=09}
>+
> =09return 0;
> }
>=20
>@@ -1351,6 +1361,16 @@
> =09=09parm->parm.capture.readbuffers =3D gspca_dev->nbufread;
> =09else
> =09=09gspca_dev->nbufread =3D n;
>+
>+=09if (gspca_dev->sd_desc->set_streamparm) {
>+=09=09int ret;
>+=09=09if (mutex_lock_interruptible(&gspca_dev->usb_lock))
>+=09=09=09return -ERESTARTSYS;
>+=09=09ret =3D gspca_dev->sd_desc->set_streamparm(gspca_dev, parm);
>+=09=09mutex_unlock(&gspca_dev->usb_lock);
>+=09=09return ret;
>+=09}
>+
> =09return 0;
> }
>=20
>diff -r 51458dbe1fda -r c3eafdd5ba7c linux/drivers/media/video/gspca/gspca=
.h
>--- a/linux/drivers/media/video/gspca/gspca.h=09Tue Dec 09 16:55:39 2008 -=
0500
>+++ b/linux/drivers/media/video/gspca/gspca.h=09Tue Dec 09 17:05:41 2008 -=
0500
>@@ -74,6 +74,8 @@
> typedef int (*cam_cf_op) (struct gspca_dev *, const struct usb_device_id =
*);
> typedef int (*cam_jpg_op) (struct gspca_dev *,
> =09=09=09=09struct v4l2_jpegcompression *);
>+typedef int (*cam_streamparm_op) (struct gspca_dev *,=20
>+=09=09=09=09  struct v4l2_streamparm *);
> typedef int (*cam_qmnu_op) (struct gspca_dev *,
> =09=09=09struct v4l2_querymenu *);
> typedef void (*cam_pkt_op) (struct gspca_dev *gspca_dev,
>@@ -106,6 +108,8 @@
> =09cam_jpg_op get_jcomp;
> =09cam_jpg_op set_jcomp;
> =09cam_qmnu_op querymenu;
>+=09cam_streamparm_op get_streamparm;
>+=09cam_streamparm_op set_streamparm;
> };
>=20
> /* packet types when moving from iso buf to frame buf */
>
>--
>video4linux-list mailing list
>Unsubscribe mailto:video4linux-list-request@redhat.com?subject=3Dunsubscri=
be
>https://www.redhat.com/mailman/listinfo/video4linux-list
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
