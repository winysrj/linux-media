Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:55543 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab0DKJtO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 05:49:14 -0400
Received: from whale.cadsoft.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id o3B9CwA6005876
	for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 11:12:58 +0200
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by whale.cadsoft.de (8.14.3/8.14.3) with ESMTP id o3B9Cq7q028763
	for <linux-media@vger.kernel.org>; Sun, 11 Apr 2010 11:12:52 +0200
Message-ID: <4BC19294.4010200@tvdr.de>
Date: Sun, 11 Apr 2010 11:12:52 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Add FE_CAN_PSK_8 to allow apps to identify PSK_8 capable
 DVB devices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The enum fe_caps provides flags that allow an application to detect
whether a device is capable of handling various modulation types etc.
A flag for detecting PSK_8, however, is missing.
This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.

Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Tested-by: Derek Kelly <user.vdr@gmail.com>


--- linux/include/linux/dvb/frontend.h.001      2010-04-05 16:13:08.000000000 +0200
+++ linux/include/linux/dvb/frontend.h  2010-04-10 12:08:47.000000000 +0200
@@ -62,6 +62,7 @@
        FE_CAN_8VSB                     = 0x200000,
        FE_CAN_16VSB                    = 0x400000,
        FE_HAS_EXTENDED_CAPS            = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
+       FE_CAN_PSK_8                    = 0x8000000,  /* frontend supports "8psk modulation" */
        FE_CAN_2G_MODULATION            = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
        FE_NEEDS_BENDING                = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
        FE_CAN_RECOVER                  = 0x40000000, /* frontend can recover from a cable unplug automatically */
--- linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c.001     2010-04-05 16:13:08.000000000 +0200
+++ linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-04-10 12:18:37.000000000 +0200
@@ -349,7 +349,7 @@
                         * FE_CAN_QAM_16 is for compatibility
                         * (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
                         */
-                       FE_CAN_QPSK | FE_CAN_QAM_16
+                       FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_PSK_8
        },

        .release = gp8psk_fe_release,
--- linux/drivers/media/dvb/frontends/cx24116.c.001     2010-04-05 16:13:08.000000000 +0200
+++ linux/drivers/media/dvb/frontends/cx24116.c 2010-04-10 13:40:32.000000000 +0200
@@ -1496,7 +1496,7 @@
                        FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
                        FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
                        FE_CAN_2G_MODULATION |
-                       FE_CAN_QPSK | FE_CAN_RECOVER
+                       FE_CAN_QPSK | FE_CAN_RECOVER | FE_CAN_PSK_8
        },

        .release = cx24116_release,
