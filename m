Return-path: <mchehab@pedra>
Received: from mailfe01.c2i.net ([212.247.154.2]:56095 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752209Ab1EWLJI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:09:08 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Make code more readable by not using the return value of the WARN() macro. Set ret variable in an undefined case.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:07:53 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JAk2NFgVtFEQdpE"
Message-Id: <201105231307.53836.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_JAk2NFgVtFEQdpE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_JAk2NFgVtFEQdpE
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0005.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0005.patch"

=46rom 94b88b92763f9309018ba04c200a8842ce1ff0ed Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:07:08 +0200
Subject: [PATCH] Make code more readable by not using the return value of t=
he WARN() macro. Set ret variable in an undefined case.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/video/sr030pc30.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc3=
0.c
index c901721..6cc64c9 100644
=2D-- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -726,8 +726,10 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, i=
nt on)
 	const struct sr030pc30_platform_data *pdata =3D info->pdata;
 	int ret;
=20
=2D	if (WARN(pdata =3D=3D NULL, "No platform data!\n"))
+	if (pdata =3D=3D NULL) {
+		WARN(1, "No platform data!\n");
 		return -ENOMEM;
+	}
=20
 	/*
 	 * Put sensor into power sleep mode before switching off
@@ -746,6 +748,7 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, in=
t on)
 	if (on) {
 		ret =3D sr030pc30_base_config(sd);
 	} else {
+		ret =3D 0;
 		info->curr_win =3D NULL;
 		info->curr_fmt =3D NULL;
 	}
=2D-=20
1.7.1.1


--Boundary-00=_JAk2NFgVtFEQdpE--
