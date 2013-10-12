Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34386 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038Ab3JLBUR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Oct 2013 21:20:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] em28xx: MaxMedia UB425-TC change demod settings
Date: Sat, 12 Oct 2013 04:20:01 +0300
Message-Id: <1381540801-23645-3-git-send-email-crope@iki.fi>
In-Reply-To: <1381540801-23645-1-git-send-email-crope@iki.fi>
References: <1381540801-23645-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That version of DRX-K chip supports only 2.

drxk: SCU_RESULT_INVPAR while sending cmd 0x0203 with params:
drxk: Warning -22 on qam_demodulator_command

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 0697aad..2324ac6 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -387,6 +387,7 @@ static struct drxk_config maxmedia_ub425_tc_drxk = {
 	.microcode_name = "dvb-demod-drxk-01.fw",
 	.chunk_size = 62,
 	.load_firmware_sync = true,
+	.qam_demod_parameter_count = 2,
 };
 
 static struct drxk_config pctv_520e_drxk = {
-- 
1.8.3.1

