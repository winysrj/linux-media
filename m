Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55297 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbdFJHNg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 03:13:36 -0400
MIME-Version: 1.0
Message-ID: <trinity-3ccfe6a4-860f-4c5c-a2cc-d3027dbb4777-1497078814431@3capp-mailcom-bs10>
From: juvann@caramail.fr
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] em28xx TerraTec Cinergy Hybrid T USB XS with
 demodulator MT352 is not detect by em28xx
Content-Type: text/plain; charset=UTF-8
Date: Sat, 10 Jun 2017 09:13:34 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TerraTec Cinergy Hybrid T USB XS with demodulator MT352 stop working with kernel 3.xx and newer.
I have already sent this patch without a success reply, I hope this time you can accept it.

--- /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c.orig   2014-05-06 16:59:58.000000000 +0200
+++ /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c   2014-05-07 15:18:31.719524453 +0200
@@ -2233,7 +2233,7 @@
        { USB_DEVICE(0x0ccd, 0x005e),
                        .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
        { USB_DEVICE(0x0ccd, 0x0042),
-                       .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
+                       .driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
        { USB_DEVICE(0x0ccd, 0x0043),
                        .driver_info = EM2870_BOARD_TERRATEC_XS },
        { USB_DEVICE(0x0ccd, 0x008e),   /* Cinergy HTC USB XS Rev. 1 */

This patch is working also on kernel 4.xx I have tested kernel 4.3 and 4.9

Thank you
Giovanni
