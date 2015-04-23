Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33625 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbbDWVLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:39 -0400
Received: by lbbzk7 with SMTP id zk7so22826661lbb.0
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:38 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 07/12] af9035: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:06 +0300
Message-Id: <1429823471-21835-7-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 80a29f5..7b7f75d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1569,6 +1569,7 @@ static int it930x_tuner_attach(struct dvb_usb_adapter *adap)
 
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe[0];
+	si2157_config.if_port = 1;
 	ret = af9035_add_i2c_dev(d, "si2157", 0x63,
 			&si2157_config, state->i2c_adapter_demod);
 
-- 
1.9.1

