Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34591 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031261AbbDWVLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:34 -0400
Received: by lbcga7 with SMTP id ga7so22831194lbc.1
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:33 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 04/12] cx23885: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:03 +0300
Message-Id: <1429823471-21835-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885-dvb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 745caab..37fd013 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1912,6 +1912,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = fe0->dvb.frontend;
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
@@ -1957,6 +1958,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = fe0->dvb.frontend;
+		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -2093,6 +2095,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach tuner */
 		memset(&si2157_config, 0, sizeof(si2157_config));
 		si2157_config.fe = fe0->dvb.frontend;
+		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
@@ -2172,6 +2175,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach tuner */
 			memset(&si2157_config, 0, sizeof(si2157_config));
 			si2157_config.fe = fe0->dvb.frontend;
+			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
-- 
1.9.1

