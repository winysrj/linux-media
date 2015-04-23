Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33592 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031262AbbDWVLg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 17:11:36 -0400
Received: by lbbzk7 with SMTP id zk7so22825831lbb.0
        for <linux-media@vger.kernel.org>; Thu, 23 Apr 2015 14:11:34 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 05/12] smipcie: specify if_port for si2157 devices
Date: Fri, 24 Apr 2015 00:11:04 +0300
Message-Id: <1429823471-21835-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
References: <1429823471-21835-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the if_port parameter for all Si2157-based devices.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/smipcie/smipcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index 4115925..143fd78 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -657,6 +657,7 @@ static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
 	/* attach tuner */
 	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = port->fe;
+	si2157_config.if_port = 1;
 
 	memset(&client_info, 0, sizeof(struct i2c_board_info));
 	strlcpy(client_info.type, "si2157", I2C_NAME_SIZE);
-- 
1.9.1

