Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56961 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935224Ab1JFJPR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 05:15:17 -0400
Received: by eyg7 with SMTP id 7so182224eyg.19
        for <linux-media@vger.kernel.org>; Thu, 06 Oct 2011 02:15:16 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: =?iso-8859-1?q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
Subject: Re: [PATCH] pctv452e: hm.. tidy bogus code up
Date: Thu, 6 Oct 2011 12:15:22 +0300
Cc: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
	Michael Schimek <mschimek@gmx.at>,
	Hans Petter Selasky <hselasky@c2i.net>,
	Doychin Dokov <root@net1.cc>,
	Steffen Barszus <steffenbpunkt@googlemail.com>,
	Dominik Kuhlen <dkuhlen@gmx.net>
References: <201109302358.11233.liplianin@me.by> <4E8D6867.7000807@web.de>
In-Reply-To: <4E8D6867.7000807@web.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qGXjOiiRZbMygp0"
Message-Id: <201110061215.22452.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_qGXjOiiRZbMygp0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

=D0=92 =D1=81=D0=BE=D0=BE=D0=B1=D1=89=D0=B5=D0=BD=D0=B8=D0=B8 =D0=BE=D1=82 =
6 =D0=BE=D0=BA=D1=82=D1=8F=D0=B1=D1=80=D1=8F 2011 11:35:51 =D0=B0=D0=B2=D1=
=82=D0=BE=D1=80 Andr=C3=A9 Weidemann =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=
=D0=BB:
> Hi Mauro,
>=20
> On 30.09.2011 22:58, Igor M. Liplianin wrote:
> > Currently, usb_register calls two times with cloned structures, but for
> > different driver names. Let's remove it.
>=20
> It looks like the comments and the patch under
> http://patchwork.linuxtv.org/patch/8042/ got mixed up.
>=20
> Regards,
>   Andr=C3=A9
git format-patch generated original in attachement.
=2D-=20
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

--Boundary-00=_qGXjOiiRZbMygp0
Content-Type: text/plain;
  charset="us-ascii";
  name="0001-pctv452e-hm.-tidy-bogus-code-up.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="0001-pctv452e-hm.-tidy-bogus-code-up.txt"

=46rom 2e078ba46048c34b501174c5abc766a3bf812bb0 Mon Sep 17 00:00:00 2001
=46rom: Igor M. Liplianin <liplianin@me.by>
Date: Fri, 30 Sep 2011 23:13:29 +0300
Subject: [PATCH] pctv452e: hm.. tidy bogus code up
To: <mchehab@infradead.org>, <linux-media@vger.kernel.org>

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
=2D--
 drivers/media/dvb/dvb-usb/pctv452e.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/pctv452e.c b/drivers/media/dvb/dvb-u=
sb/pctv452e.c
index 9a5c811..f9aec5c 100644
=2D-- a/drivers/media/dvb/dvb-usb/pctv452e.c
+++ b/drivers/media/dvb/dvb-usb/pctv452e.c
@@ -1012,7 +1012,7 @@ static struct dvb_usb_device_properties tt_connect_s2=
_3600_properties =3D {
=20
 	.i2c_algo =3D &pctv452e_i2c_algo,
=20
=2D	.generic_bulk_ctrl_endpoint =3D 1, /* allow generice rw function*/
+	.generic_bulk_ctrl_endpoint =3D 1, /* allow generic rw function*/
=20
 	.num_device_descs =3D 2,
 	.devices =3D {
@@ -1055,22 +1055,9 @@ static struct usb_driver pctv452e_usb_driver =3D {
 	.id_table   =3D pctv452e_usb_table,
 };
=20
=2Dstatic struct usb_driver tt_connects2_3600_usb_driver =3D {
=2D	.name       =3D "dvb-usb-tt-connect-s2-3600-01.fw",
=2D	.probe      =3D pctv452e_usb_probe,
=2D	.disconnect =3D pctv452e_usb_disconnect,
=2D	.id_table   =3D pctv452e_usb_table,
=2D};
=2D
 static int __init pctv452e_usb_init(void)
 {
 	int ret =3D usb_register(&pctv452e_usb_driver);
=2D
=2D	if (ret) {
=2D		err("%s: usb_register failed! Error %d", __FILE__, ret);
=2D		return ret;
=2D	}
=2D	ret =3D usb_register(&tt_connects2_3600_usb_driver);
 	if (ret)
 		err("%s: usb_register failed! Error %d", __FILE__, ret);
=20
@@ -1080,7 +1067,6 @@ static int __init pctv452e_usb_init(void)
 static void __exit pctv452e_usb_exit(void)
 {
 	usb_deregister(&pctv452e_usb_driver);
=2D	usb_deregister(&tt_connects2_3600_usb_driver);
 }
=20
 module_init(pctv452e_usb_init);
=2D-=20
1.7.5.1


--Boundary-00=_qGXjOiiRZbMygp0--
