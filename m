Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36058 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbFEKzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 06:55:40 -0400
Received: by wiam3 with SMTP id m3so15056750wia.1
        for <linux-media@vger.kernel.org>; Fri, 05 Jun 2015 03:55:39 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: dhowells@redhat.com, crope@iki.fi,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] [media] lmedm04: Enable dont_poll for TS2020 tuner.
Date: Fri,  5 Jun 2015 11:55:07 +0100
Message-Id: <1433501707-2231-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following a change made to TS2020 tuner in patches
ts2020: Provide DVBv5 API signal strength
ts2020: Allow stats polling to be suppressed

Polling on the driver must be suppressed because
the demuxer is stopped by I2C messages.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 5de6f7c..f1983f2 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -799,6 +799,7 @@ static struct m88rs2000_config m88rs2000_config = {
 static struct ts2020_config ts2020_config = {
 	.tuner_address = 0x60,
 	.clk_out_div = 7,
+	.dont_poll = true
 };
 
 static int dm04_lme2510_set_voltage(struct dvb_frontend *fe,
-- 
2.1.4

