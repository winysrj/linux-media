Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56458 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165Ab3DIXyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 19:54:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/5] af9015: do not use buggy mxl5007t read reg
Date: Wed, 10 Apr 2013 02:53:18 +0300
Message-Id: <1365551600-3394-4-git-send-email-crope@iki.fi>
In-Reply-To: <1365551600-3394-1-git-send-email-crope@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That backward compatibility hack option is no longer needed.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index a523a25..4d2587a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -931,7 +931,6 @@ static struct tda18218_config af9015_tda18218_config = {
 static struct mxl5007t_config af9015_mxl5007t_config = {
 	.xtal_freq_hz = MxL_XTAL_24_MHZ,
 	.if_freq_hz = MxL_IF_4_57_MHZ,
-	.use_broken_read_reg_intentionally = 1,
 };
 
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
-- 
1.7.11.7

