Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:36439 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424AbbDWVLh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:37 -0400
Received: by lagv1 with SMTP id v1so21950976lag.3
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:36 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 06/12] cx231xx: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:05 +0300
Message-Id: <1429823471-21835-6-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 610d567..66ee161 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -797,6 +797,7 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -852,6 +853,7 @@ static int dvb_init(struct cx231xx *dev)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = dev->dvb->frontend;
+		si2157_config.if_port = 1;
 		si2157_config.inversion = true;
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
-- 
1.9.1

