Return-path: <mchehab@pedra>
Received: from mailfe05.c2i.net ([212.247.154.130]:49705 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755204Ab1EWOXn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:23:43 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Increase a timeout, so that bad scheduling does not accidentially cause a timeout.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:22:30 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_m2m2NgdEHOcbfki"
Message-Id: <201105231622.30789.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_m2m2NgdEHOcbfki
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_m2m2NgdEHOcbfki
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0015.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0015.patch"

=46rom 18faaafc9cbbe478bb49023bbeae490149048560 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:21:47 +0200
Subject: [PATCH] Increase a timeout, so that bad scheduling does not accide=
ntially cause a timeout.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/stb0899_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_drv.c b/drivers/media/dvb/=
frontends/stb0899_drv.c
index 37a222d..ddb9141 100644
=2D-- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -706,7 +706,7 @@ static int stb0899_send_diseqc_msg(struct dvb_frontend =
*fe, struct dvb_diseqc_ma
 	stb0899_write_reg(state, STB0899_DISCNTRL1, reg);
 	for (i =3D 0; i < cmd->msg_len; i++) {
 		/* wait for FIFO empty	*/
=2D		if (stb0899_wait_diseqc_fifo_empty(state, 10) < 0)
+		if (stb0899_wait_diseqc_fifo_empty(state, 100) < 0)
 			return -ETIMEDOUT;
=20
 		stb0899_write_reg(state, STB0899_DISFIFO, cmd->msg[i]);
=2D-=20
1.7.1.1


--Boundary-00=_m2m2NgdEHOcbfki--
