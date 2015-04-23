Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33641 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031015AbbDWVLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:41 -0400
Received: by lbbzk7 with SMTP id zk7so22827073lbb.0
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:39 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 08/12] dvbsky: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:07 +0300
Message-Id: <1429823471-21835-8-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/dvbsky.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/dvbsky.c b/drivers/media/usb/dvb-usb-v2/dvbsky.c
index 0f73b1d..57c8c2d 100644
--- a/drivers/media/usb/dvb-usb-v2/dvbsky.c
+++ b/drivers/media/usb/dvb-usb-v2/dvbsky.c
@@ -549,6 +549,7 @@ static int dvbsky_t680c_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
@@ -633,6 +634,7 @@ static int dvbsky_t330_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
-- 
1.9.1

