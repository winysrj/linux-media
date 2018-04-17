Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51052 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754481AbeDQQk0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:26 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 7/8] cx231xx: Remove unnecessary parameter clear
Date: Tue, 17 Apr 2018 11:39:53 -0500
Message-Id: <1523983195-28691-8-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default is now 0, no need to override

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index ac1d8e6..7fd096b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1052,7 +1052,6 @@ static int dvb_init(struct cx231xx *dev)
 		lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
 		lgdt3306a_config.fe = &dev->dvb->frontend[0];
 		lgdt3306a_config.i2c_adapter = &adapter;
-		lgdt3306a_config.deny_i2c_rptr = 0;
 
 		/* perform tuner probe/init/attach */
 		client = dvb_module_probe("lgdt3306a", NULL, demod_i2c,
-- 
2.7.4
