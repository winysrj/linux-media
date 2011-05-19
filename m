Return-path: <mchehab@pedra>
Received: from mailfe01.c2i.net ([212.247.154.2]:51185 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752653Ab1ESIgR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 04:36:17 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe01.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 129163894 for linux-media@vger.kernel.org; Thu, 19 May 2011 10:36:12 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [RFC] Make dvb_net.c optional
Date: Thu, 19 May 2011 10:35:04 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_4YN1NMHcPPl/jff"
Message-Id: <201105191035.04185.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_4YN1NMHcPPl/jff
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

In my setup I am building the DVB code without dvb_net.c, because there is no 
IP-stack currently in my "Linux kernel". Is this worth a separate 
configuration entry?

--HPS

--Boundary-00=_4YN1NMHcPPl/jff
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb_net.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb_net.diff"

=46rom e7fe34933638e882e1ed1eab1761ecd14ef9125e Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 19 May 2011 02:26:33 +0200
Subject: [PATCH] Make dvb_net configurable.

=2D--
 ../media_tree/drivers/media/dvb/dvb-core/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/../media_tree/drivers/media/dvb/dvb-core/Makefile b/../media_t=
ree/drivers/media/dvb/dvb-core/Makefile
index 0b51828..8f22bcd 100644
=2D-- a/../media_tree/drivers/media/dvb/dvb-core/Makefile
+++ b/../media_tree/drivers/media/dvb/dvb-core/Makefile
@@ -2,8 +2,10 @@
 # Makefile for the kernel DVB device drivers.
 #
=20
+dvb-net-$(CONFIG_DVB_NET) :=3D dvb_net.o
+
 dvb-core-objs :=3D dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
=2D		 dvb_net.o dvb_ringbuffer.o dvb_math.o
+		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
=20
 obj-$(CONFIG_DVB_CORE) +=3D dvb-core.o
=2D-=20
1.7.1.1


--Boundary-00=_4YN1NMHcPPl/jff--
