Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49332 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934486Ab3DIXyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 19:54:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] af9035: do not use buggy mxl5007t read reg
Date: Wed, 10 Apr 2013 02:53:20 +0300
Message-Id: <1365551600-3394-6-git-send-email-crope@iki.fi>
In-Reply-To: <1365551600-3394-1-git-send-email-crope@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That backward compatibility hack option is no longer needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 6c039eb..cfcf79b 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -965,7 +965,6 @@ static struct mxl5007t_config af9035_mxl5007t_config[] = {
 		.loop_thru_enable = 0,
 		.clk_out_enable = 0,
 		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
-		.use_broken_read_reg_intentionally = 1,
 	}, {
 		.xtal_freq_hz = MxL_XTAL_24_MHZ,
 		.if_freq_hz = MxL_IF_4_57_MHZ,
@@ -973,7 +972,6 @@ static struct mxl5007t_config af9035_mxl5007t_config[] = {
 		.loop_thru_enable = 1,
 		.clk_out_enable = 1,
 		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
-		.use_broken_read_reg_intentionally = 1,
 	}
 };
 
-- 
1.7.11.7

