Return-path: <mchehab@pedra>
Received: from mailfe08.c2i.net ([212.247.154.226]:52089 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752229Ab1EWLUY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 07:20:24 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] The USB_SPEED... keywords are already defined by the USB stack. Rename currently unused macros to avoid possible future warnings and errors.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 13:19:11 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_vKk2NRQ65TgMIxM"
Message-Id: <201105231319.11284.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Boundary-00=_vKk2NRQ65TgMIxM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

--HPS

--Boundary-00=_vKk2NRQ65TgMIxM
Content-Type: text/x-patch;
  charset="us-ascii";
  name="dvb-usb-0001.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="dvb-usb-0001.patch"

=46rom f7a0f7254da47ff88f69314f14043b01ba0764eb Mon Sep 17 00:00:00 2001
=46rom: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 12:43:50 +0200
Subject: [PATCH] The USB_SPEED_XXX keywords are already defined by the USB =
stack. Rename currently unused macros to avoid possible future warnings and=
 errors.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
=2D--
 drivers/media/dvb/dvb-usb/gp8psk.h |    6 +++---
 drivers/media/dvb/dvb-usb/vp7045.h |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/dvb/dvb-usb=
/gp8psk.h
index 831749a..c271b68 100644
=2D-- a/drivers/media/dvb/dvb-usb/gp8psk.h
+++ b/drivers/media/dvb/dvb-usb/gp8psk.h
@@ -78,9 +78,9 @@ extern int dvb_usb_gp8psk_debug;
 #define ADV_MOD_DVB_BPSK 9     /* DVB-S BPSK */
=20
 #define GET_USB_SPEED                     0x07
=2D #define USB_SPEED_LOW                    0
=2D #define USB_SPEED_FULL                   1
=2D #define USB_SPEED_HIGH                   2
+ #define TH_USB_SPEED_LOW                 0
+ #define TH_USB_SPEED_FULL                1
+ #define TH_USB_SPEED_HIGH                2
=20
 #define RESET_FX2                         0x13
=20
diff --git a/drivers/media/dvb/dvb-usb/vp7045.h b/drivers/media/dvb/dvb-usb=
/vp7045.h
index 969688f..7ce6c00 100644
=2D-- a/drivers/media/dvb/dvb-usb/vp7045.h
+++ b/drivers/media/dvb/dvb-usb/vp7045.h
@@ -36,9 +36,9 @@
  #define Tuner_Power_OFF                  0
=20
 #define GET_USB_SPEED                     0x07
=2D #define USB_SPEED_LOW                    0
=2D #define USB_SPEED_FULL                   1
=2D #define USB_SPEED_HIGH                   2
+ #define TH_USB_SPEED_LOW                 0
+ #define TH_USB_SPEED_FULL                1
+ #define TH_USB_SPEED_HIGH                2
=20
 #define LOCK_TUNER_COMMAND                0x09
=20
=2D-=20
1.7.1.1


--Boundary-00=_vKk2NRQ65TgMIxM--
