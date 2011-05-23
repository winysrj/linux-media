Return-path: <mchehab@pedra>
Received: from mailfe07.c2i.net ([212.247.154.194]:55318 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469Ab1EWLC6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:02:58 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Fix warning about invalid trigraph sequence.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:01:45 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Z6j2NojnDW7N/IQ"
Message-Id: <201105231301.45428.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Z6j2NojnDW7N/IQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_Z6j2NojnDW7N/IQ
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0004.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0004.patch"

=46rom e3b824b49f3d853ba16d9cdda836bd2fe81c7775 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:59:37 +0200
Subject: [PATCH] Fix warning about invalid trigraph sequence.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/video/cpia2/cpia2_v4l.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/video/cp=
ia2/cpia2_v4l.c
index 5111bbc..e909838 100644
=2D-- a/drivers/media/video/cpia2/cpia2_v4l.c
+++ b/drivers/media/video/cpia2/cpia2_v4l.c
@@ -438,7 +438,7 @@ static int cpia2_querycap(struct file *file, void *fh, =
struct v4l2_capability *v
 		strcat(vc->card, " (676/");
 		break;
 	default:
=2D		strcat(vc->card, " (???/");
+		strcat(vc->card, " (XXX/");
 		break;
 	}
 	switch (cam->params.version.sensor_flags) {
@@ -458,7 +458,7 @@ static int cpia2_querycap(struct file *file, void *fh, =
struct v4l2_capability *v
 		strcat(vc->card, "500)");
 		break;
 	default:
=2D		strcat(vc->card, "???)");
+		strcat(vc->card, "XXX)");
 		break;
 	}
=20
=2D-=20
1.7.1.1


--Boundary-00=_Z6j2NojnDW7N/IQ--
