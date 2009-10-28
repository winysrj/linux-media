Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail07mass.ifxnetworks.com ([190.60.24.77]:46144 "EHLO
	tutopia.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754076AbZJ1TwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 15:52:25 -0400
Received: from unknown (HELO [10.0.0.1]) (vnishimoto@tutopia.com.br@[200.158.237.30])
          (envelope-sender <vnishimoto@tutopia.com.br>)
          by mail07mass.ifxnetworks.com (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 28 Oct 2009 19:45:49 -0000
Message-ID: <4AE89F6B.7010700@tutopia.com.br>
Date: Wed, 28 Oct 2009 17:45:47 -0200
From: Vagner Nishimoto <vnishimoto@tutopia.com.br>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: pboettcher@kernellabs.com
Subject: [PATCH] Add support for Geniatech/MyGica U870 remote control
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This patch add codes for the "Total Media In Hand" remote control used by
Geniatech/MyGica U870 and X8507.

Thank's

Signed-off-by: Vagner Nishimoto <vnishimoto@tutopia.com.br>

--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-09-20
15:14:20.000000000 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2009-10-26
03:34:52.062907991 -0200
@@ -926,6 +926,43 @@ static struct dvb_usb_rc_key dib0700_rc_

 	{ 0x8618, KEY_RECORD },
 	{ 0x861a, KEY_STOP },
+
+	/* Key codes for the Total Media In Hand (Geniatech/MyGica U870 remote control) */
+	{ 0x0038, KEY_TV },
+	{ 0x000c, KEY_MEDIA },
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
+	{ 0x0003, KEY_3 },
+	{ 0x0004, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0006, KEY_6 },
+	{ 0x0007, KEY_7 },
+	{ 0x0008, KEY_8 },
+	{ 0x0009, KEY_9 },
+	{ 0x0000, KEY_0 },
+	{ 0x000a, KEY_MUTE },
+	{ 0x0029, KEY_ESC },
+	{ 0x0012, KEY_CHANNELUP },
+	{ 0x0013, KEY_CHANNELDOWN },
+	{ 0x002b, KEY_VOLUMEUP },
+	{ 0x002c, KEY_VOLUMEDOWN },
+	{ 0x0020, KEY_UP },
+	{ 0x0021, KEY_DOWN },
+	{ 0x0011, KEY_LEFT },
+	{ 0x0010, KEY_RIGHT },
+	{ 0x000d, KEY_OK },
+	{ 0x001f, KEY_RECORD },
+	{ 0x0017, KEY_PLAY },
+	{ 0x0016, KEY_PAUSE },
+	{ 0x000b, KEY_STOP },
+	{ 0x0027, KEY_FASTFORWARD },
+	{ 0x0026, KEY_REWIND },
+	{ 0x001e, KEY_TIME },
+	{ 0x000e, KEY_CAMERA },
+	{ 0x002d, KEY_MENU },
+	{ 0x000f, KEY_ZOOM },
+	{ 0x0014, KEY_SHUFFLE },
+	{ 0x0025, KEY_POWER },
 };

 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
