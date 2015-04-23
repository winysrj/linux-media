Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:35327 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031023AbbDWVLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:42 -0400
Received: by lbbuc2 with SMTP id uc2so22761258lbb.2
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:41 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 09/12] cxusb: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:08 +0300
Message-Id: <1429823471-21835-9-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/cxusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index ffc3704..ab71511 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1350,6 +1350,7 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe_adap[0].fe;
+	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
-- 
1.9.1

