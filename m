Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58393 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab3JLBUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 21:20:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] em28xx: MaxMedia UB425-TC offer firmware for demodulator
Date: Sat, 12 Oct 2013 04:19:59 +0300
Message-Id: <1381540801-23645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Downloading new firmware for DRX-K demodulator is not obligatory but
usually it offers important bug fixes compared to default firmware
burned into chip rom. DRX-K demod driver will continue even without
the firmware, but in that case it will print warning to system log
to tip user he should install firmware.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index bb1e8dc..f8a2212 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -384,6 +384,8 @@ static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.adr = 0x29,
 	.single_master = 1,
 	.no_i2c_bridge = 1,
+	.microcode_name = "dvb-demod-drxk-01.fw",
+	.chunk_size = 62,
 	.load_firmware_sync = true,
 };
 
@@ -1234,11 +1236,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				goto out_free;
 			}
 		}
-
-		/* TODO: we need drx-3913k firmware in order to support DVB-T */
-		em28xx_info("MaxMedia UB425-TC/Delock 61959: only DVB-C " \
-				"supported by that driver version\n");
-
 		break;
 	case EM2884_BOARD_PCTV_510E:
 	case EM2884_BOARD_PCTV_520E:
-- 
1.8.3.1

