Return-path: <mchehab@pedra>
Received: from mailfe06.c2i.net ([212.247.154.162]:56914 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752439Ab1EZH7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 03:59:40 -0400
Received: from [188.126.198.129] (account mc467741@c2i.net HELO laptop002.hselasky.homeunix.org)
  by mailfe06.swip.net (CommuniGate Pro SMTP 5.2.19)
  with ESMTPA id 130980087 for linux-media@vger.kernel.org; Thu, 26 May 2011 09:59:38 +0200
From: Hans Petter Selasky <hselasky@c2i.net>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH v2] Remove unused definitions which can cause conflict with definitions in usb/ch9.h.
Date: Thu, 26 May 2011 09:58:23 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105260958.23397.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 0dd2949dfeae431ed4ffbd00fd14a10dc3747ad0 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Thu, 26 May 2011 09:56:55 +0200
Subject: [PATCH] Remove unused definitions which can cause conflict with definitions in usb/ch9.h.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 drivers/media/dvb/dvb-usb/gp8psk.h |    3 ---
 drivers/media/dvb/dvb-usb/vp7045.h |    3 ---
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/gp8psk.h b/drivers/media/dvb/dvb-usb/gp8psk.h
index 831749a..ed32b9d 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk.h
+++ b/drivers/media/dvb/dvb-usb/gp8psk.h
@@ -78,9 +78,6 @@ extern int dvb_usb_gp8psk_debug;
 #define ADV_MOD_DVB_BPSK 9     /* DVB-S BPSK */
 
 #define GET_USB_SPEED                     0x07
- #define USB_SPEED_LOW                    0
- #define USB_SPEED_FULL                   1
- #define USB_SPEED_HIGH                   2
 
 #define RESET_FX2                         0x13
 
diff --git a/drivers/media/dvb/dvb-usb/vp7045.h b/drivers/media/dvb/dvb-usb/vp7045.h
index 969688f..cf5ec46 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.h
+++ b/drivers/media/dvb/dvb-usb/vp7045.h
@@ -36,9 +36,6 @@
  #define Tuner_Power_OFF                  0
 
 #define GET_USB_SPEED                     0x07
- #define USB_SPEED_LOW                    0
- #define USB_SPEED_FULL                   1
- #define USB_SPEED_HIGH                   2
 
 #define LOCK_TUNER_COMMAND                0x09
 
-- 
1.7.1.1

