Return-path: <mchehab@pedra>
Received: from mailfe02.c2i.net ([212.247.154.34]:58062 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752797Ab1EWLLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:11:07 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Make nchg variable signed because the code compares this variable against negative values.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:09:54 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CCk2NoKH5Hke3In"
Message-Id: <201105231309.54265.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_CCk2NoKH5Hke3In
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_CCk2NoKH5Hke3In
Content-Type: text/x-patch;
  charset="ISO-8859-1";
  name="dvb-usb-0006.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvb-usb-0006.patch"

=46rom b05d4913df24f11c7b7a2e07201bb87a04a949bc Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:09:18 +0200
Subject: [PATCH] Make nchg variable signed because the code compares this v=
ariable against negative values.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/video/gspca/sonixj.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca=
/sonixj.c
index 6415aff..81b8a60 100644
=2D-- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -60,7 +60,7 @@ struct sd {
=20
 	u32 pktsz;			/* (used by pkt_scan) */
 	u16 npkt;
=2D	u8 nchg;
+	s8 nchg;
 	s8 short_mark;
=20
 	u8 quality;			/* image quality */
=2D-=20
1.7.1.1


--Boundary-00=_CCk2NoKH5Hke3In--
