Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:38476 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751531Ab1EWNM5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 09:12:57 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Make DVB NET configurable in the kernel.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 15:11:44 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Q0l2N9W0R8Js7Mr"
Message-Id: <201105231511.44508.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_Q0l2N9W0R8Js7Mr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_Q0l2N9W0R8Js7Mr
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0012.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0012.patch"

=46rom 7222450a9d6f96f652237c65019fb25f54586d01 Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 14:43:35 +0200
Subject: [PATCH] Make DVB NET configurable in the kernel.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/Kconfig                |   12 +++++++++++-
 drivers/media/dvb/dvb-core/Makefile  |    4 +++-
 drivers/media/dvb/dvb-core/dvb_net.h |   26 ++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index 6995940..dc61895 100644
=2D-- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -68,7 +68,6 @@ config VIDEO_V4L2_SUBDEV_API
=20
 config DVB_CORE
 	tristate "DVB for Linux"
=2D	depends on NET && INET
 	select CRC32
 	help
 	  DVB core utility functions for device handling, software fallbacks etc.
@@ -85,6 +84,17 @@ config DVB_CORE
=20
 	  If unsure say N.
=20
+config DVB_NET
+	bool "DVB Network Support"
+	default (NET && INET)
+	depends on NET && INET
+	help
+	  The DVB network support in the DVB core can
+	  optionally be disabled if this
+	  option is set to N.
+
+	  If unsure say Y.
+
 config VIDEO_MEDIA
 	tristate
 	default (DVB_CORE && (VIDEO_DEV =3D n)) || (VIDEO_DEV && (DVB_CORE =3D n)=
) || (DVB_CORE && VIDEO_DEV)
diff --git a/drivers/media/dvb/dvb-core/Makefile b/drivers/media/dvb/dvb-co=
re/Makefile
index 0b51828..8f22bcd 100644
=2D-- a/drivers/media/dvb/dvb-core/Makefile
+++ b/drivers/media/dvb/dvb-core/Makefile
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
diff --git a/drivers/media/dvb/dvb-core/dvb_net.h b/drivers/media/dvb/dvb-c=
ore/dvb_net.h
index 3a3126c..8a0907f 100644
=2D-- a/drivers/media/dvb/dvb-core/dvb_net.h
+++ b/drivers/media/dvb/dvb-core/dvb_net.h
@@ -32,6 +32,8 @@
=20
 #define DVB_NET_DEVICES_MAX 10
=20
+#ifdef CONFIG_DVB_NET
+
 struct dvb_net {
 	struct dvb_device *dvbdev;
 	struct net_device *device[DVB_NET_DEVICES_MAX];
@@ -45,3 +47,27 @@ void dvb_net_release(struct dvb_net *);
 int  dvb_net_init(struct dvb_adapter *, struct dvb_net *, struct dmx_demux=
 *);
=20
 #endif
+
+#ifndef CONFIG_DVB_NET
+
+struct dvb_dev_stub;
+
+struct dvb_net {
+	struct dvb_dev_stub *dvbdev;
+};
+
+static inline void dvb_net_release(struct dvb_net *dvbnet)
+{
+	dvbnet->dvbdev =3D 0;
+}
+
+static inline int dvb_net_init(struct dvb_adapter *adap,
+    struct dvb_net *dvbnet, struct dmx_demux *dmx)
+{
+	dvbnet->dvbdev =3D (void *)1;
+	return 0;
+}
+
+#endif
+
+#endif
=2D-=20
1.7.1.1


--Boundary-00=_Q0l2N9W0R8Js7Mr--
