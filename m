Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:39086 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab0GXWLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Jul 2010 18:11:14 -0400
Received: from mail-in-08-z2.arcor-online.net (mail-in-08-z2.arcor-online.net [151.189.8.20])
	by mx.arcor.de (Postfix) with ESMTP id EF2F4D8056
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 00:11:11 +0200 (CEST)
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net [151.189.21.48])
	by mail-in-08-z2.arcor-online.net (Postfix) with ESMTP id 0F17677F30
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 00:11:12 +0200 (CEST)
Received: from quake.FAMILY-BUSINESS (dslb-094-216-072-244.pools.arcor-ip.net [94.216.72.244])
	(Authenticated sender: rettenberger.familie@arcor.de)
	by mail-in-08.arcor-online.net (Postfix) with ESMTPSA id C7AC820557C
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 00:11:11 +0200 (CEST)
Received: from sarge.family-business (host70.natpool.mwn.de [138.246.7.70])
	by quake.FAMILY-BUSINESS (Postfix) with ESMTPSA id 0C935A4048
	for <linux-media@vger.kernel.org>; Sun, 25 Jul 2010 00:11:11 +0200 (CEST)
To: linux-media@vger.kernel.org
Subject: [PATCH] Terratec Cinergy USB (HD) (remote control key codes)
From: Sebastian Rettenberger <rettenberger.sebastian@arcor.de>
Date: Sun, 25 Jul 2010 00:11:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007250011.08123.rettenberger.sebastian@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I figured out that my remote control of the Cinergy T USB XXS
(HD)
has slightly different key codes then the one already in the
dvb_usb_dib0700 module.

The following patch adds the key codes
to
table.

Best regards,
Sebastian

---

Add key codes for Cinergy T USB XXS
(HD) (device ID: 0ccd:00ab) remote control.
Signed-off-by: Sebastian
Rettenberger <rettenberger.sebastian@arcor.de>
---
a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2010-07-24
19:05:45.659569355 +0200
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c  
    2010-07-24 19:08:31.667571034 +0200
@@ -639,6 +639,56 @@ static struct
dvb_usb_rc_key dib0700_rc_
        { 0xeb58, KEY_RECORD },
        { 0xeb5c,
KEY_NEXT },
 
+       /* Terratec Cinergy USB (HD) */
+       { 0x1401,
KEY_POWER },
+       { 0x1402, KEY_1 },
+       { 0x1403, KEY_2 },
+       {
0x1404, KEY_3 },
+       { 0x1405, KEY_4 },
+       { 0x1406, KEY_5 },
+    
  { 0x1407, KEY_6 },
+       { 0x1408, KEY_7 },
+       { 0x1409, KEY_8 },
+
      { 0x140a, KEY_9 },
+       { 0x140b, KEY_VIDEO },
+       { 0x140c,
KEY_0 },
+       { 0x140d, KEY_REFRESH },
+       { 0x140f, KEY_EPG },
+    
  { 0x1410, KEY_UP },
+       { 0x1411, KEY_LEFT },
+       { 0x1412, KEY_OK
},
+       { 0x1413, KEY_RIGHT },
+       { 0x1414, KEY_DOWN },
+       {
0x1416, KEY_INFO },
+       { 0x1417, KEY_RED },
+       { 0x1418, KEY_GREEN
},
+       { 0x1419, KEY_YELLOW },
+       { 0x141a, KEY_BLUE },
+       {
0x141b, KEY_CHANNELUP },
+       { 0x141c, KEY_VOLUMEUP },
+       { 0x141d,
KEY_MUTE },
+       { 0x141e, KEY_VOLUMEDOWN },
+       { 0x141f,
KEY_CHANNELDOWN },
+       { 0x1440, KEY_PAUSE },
+       { 0x1441, KEY_HOME
},
+       { 0x1442, KEY_MENU }, /* DVD Menu */
+       { 0x1443,
KEY_SUBTITLE },
+       { 0x1444, KEY_TEXT }, /* Teletext */
+       {
0x1445, KEY_DELETE },
+       { 0x1446, KEY_TV },
+       { 0x1447, KEY_DVD
},
+       { 0x1448, KEY_STOP },
+       { 0x1449, KEY_VIDEO },
+       {
0x144a, KEY_AUDIO }, /* Music */
+       { 0x144b, KEY_SCREEN }, /* Pic */
+
      { 0x144c, KEY_PLAY },
+       { 0x144d, KEY_BACK },
+       { 0x144e,
KEY_REWIND },
+       { 0x144f, KEY_FASTFORWARD },
+       { 0x1454,
KEY_PREVIOUS },
+       { 0x1458, KEY_RECORD },
+       { 0x145c, KEY_NEXT
},
+
        /* Key codes for the Haupauge WinTV Nova-TD, copied from
nova-t-usb2.c (Nova-T USB2) */
        { 0x1e00, KEY_0 },
        { 0x1e01,
KEY_1 },
