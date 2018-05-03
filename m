Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44842 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751216AbeECVUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 7/9] cx231xx: Remove unnecessary parameter clear
Date: Thu,  3 May 2018 16:20:13 -0500
Message-Id: <1525382415-4049-8-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The default is now 0, no need to override

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
Changes since v1:
- regen

 drivers/media/usb/cx231xx/cx231xx-dvb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 669c154..2d27e96 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -1048,7 +1048,6 @@ static int dvb_init(struct cx231xx *dev)
 		lgdt3306a_config = hauppauge_955q_lgdt3306a_config;
 		lgdt3306a_config.fe = &dev->dvb->frontend[0];
 		lgdt3306a_config.i2c_adapter = &adapter;
-		lgdt3306a_config.deny_i2c_rptr = 0;
 
 		/* perform probe/init/attach */
 		client = dvb_module_probe("lgdt3306a", NULL, demod_i2c,
-- 
2.7.4
