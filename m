Return-path: <mchehab@pedra>
Received: from mailfe03.c2i.net ([212.247.154.66]:43186 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752363Ab1EWOI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 10:08:26 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Inlined functions should be static.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:07:13 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Rom2NzMace1mZk2"
Message-Id: <201105231607.13668.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Rom2NzMace1mZk2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_Rom2NzMace1mZk2
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0014.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0014.patch"

=46rom 446037f0f999759b4b801b6512d18bae769465bb Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 16:06:22 +0200
Subject: [PATCH] Inlined functions should be static.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/frontends/stb0899_algo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb=
/frontends/stb0899_algo.c
index 2da55ec..d70eee0 100644
=2D-- a/drivers/media/dvb/frontends/stb0899_algo.c
+++ b/drivers/media/dvb/frontends/stb0899_algo.c
@@ -23,7 +23,7 @@
 #include "stb0899_priv.h"
 #include "stb0899_reg.h"
=20
=2Dinline u32 stb0899_do_div(u64 n, u32 d)
+static inline u32 stb0899_do_div(u64 n, u32 d)
 {
 	/* wrap do_div() for ease of use */
=20
=2D-=20
1.7.1.1


--Boundary-00=_Rom2NzMace1mZk2--
