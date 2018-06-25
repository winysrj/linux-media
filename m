Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:42897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755094AbeFYKeA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 06:34:00 -0400
MIME-Version: 1.0
Message-ID: <trinity-4a571672-2f7b-4c84-b8f3-cb8c60903c5b-1529922838627@3c-app-gmx-bs15>
From: "Robert Schlabbach" <Robert.Schlabbach@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: disable null packet filter for WinTVdualHD
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 Jun 2018 12:33:58 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch disables the null packet filter for the Hauppauge
WinTV-dualHD. There are applications which require the unfiltered
transport stream (e.g. DOCSIS segment load analyzers).

Tests showed that the device is capable of delivering two unfiltered
EuroDOCSIS 3.0 transport streams simultaneously, i.e. over 100 Mbit/s
worth of data, without any losses.

Signed-off-by: Robert Schlabbach <Robert.Schlabbach@gmx.net>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 6c843831..3b797d0c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -543,7 +543,7 @@ static const struct em28xx_reg_seq hauppauge_dualhd_dvb[] = {
 	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,    100},
 	{EM2874_R80_GPIO_P0_CTRL,      0xdf, 0xff,    100}, /* demod 2 reset */
 	{EM2874_R80_GPIO_P0_CTRL,      0xff, 0xff,    100},
-	{EM2874_R5F_TS_ENABLE,         0x44, 0xff,     50},
+	{EM2874_R5F_TS_ENABLE,         0x00, 0xff,     50}, /* disable TS filters */
 	{EM2874_R5D_TS1_PKT_SIZE,      0x05, 0xff,     50},
 	{EM2874_R5E_TS2_PKT_SIZE,      0x05, 0xff,     50},
 	{-1,                             -1,   -1,     -1},
-- 
2.17.1
