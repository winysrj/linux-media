Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:34011 "EHLO
        homiemail-a80.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750970AbeEBVqh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 May 2018 17:46:37 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] [BUG] em28xx: Fix DualHD broken second tuner
Date: Wed,  2 May 2018 16:46:18 -0500
Message-Id: <1525297578-28250-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of a hard coded i2c address breaks the creation of the
second tuner in DualHD 01595 models. The issue is compounded
by lack of any error message stating that a driver failed
initialization. Use addr, which contains the correct address
for each tuner.

Fixes: ad32495b1513 ("media: em28xx-dvb: simplify DVB module probing logic")

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a54cb8d..4ab71a2 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1392,7 +1392,7 @@ static int em28174_dvb_init_hauppauge_wintv_dualhd_01595(struct em28xx *dev)
 
 	dvb->i2c_client_tuner = dvb_module_probe("si2157", NULL,
 						 adapter,
-						 0x60, &si2157_config);
+						 addr, &si2157_config);
 	if (!dvb->i2c_client_tuner) {
 		dvb_module_release(dvb->i2c_client_demod);
 		return -ENODEV;
-- 
2.7.4
