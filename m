Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:58618 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdBBOxa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 09:53:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Isely <isely@pobox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] [media] pvrusb2: reduce stack usage pvr2_eeprom_analyze()
Date: Thu,  2 Feb 2017 15:53:04 +0100
Message-Id: <20170202145318.3803805-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver uses a relatively large data structure on the stack, which
showed up on my radar as we get a warning with the "latent entropy"
GCC plugin:

drivers/media/usb/pvrusb2/pvrusb2-eeprom.c:153:1: error: the frame size of 1376 bytes is larger than 1152 bytes [-Werror=frame-larger-than=]

The warning is usually hidden as we raise the warning limit to 2048
when the plugin is enabled, but I'd like to lower that again in the
future, and making this function smaller helps to do that without
build regressions.

Further analysis shows that putting an 'i2c_client' structure on
the stack is not really supported, as the embedded 'struct device'
is not initialized here, and we are only saved by the fact that
the function that is called here does not use the pointer at all.

Fixes: d855497edbfb ("V4L/DVB (4228a): pvrusb2 to kernel 2.6.18")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
index 276b17fb9aad..b8fcd9660094 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
@@ -122,15 +122,10 @@ int pvr2_eeprom_analyze(struct pvr2_hdw *hdw)
 	memset(&tvdata,0,sizeof(tvdata));
 
 	eeprom = pvr2_eeprom_fetch(hdw);
-	if (!eeprom) return -EINVAL;
-
-	{
-		struct i2c_client fake_client;
-		/* Newer version expects a useless client interface */
-		fake_client.addr = hdw->eeprom_addr;
-		fake_client.adapter = &hdw->i2c_adap;
-		tveeprom_hauppauge_analog(&fake_client,&tvdata,eeprom);
-	}
+	if (!eeprom)
+		return -EINVAL;
+
+	tveeprom_hauppauge_analog(NULL, &tvdata, eeprom);
 
 	trace_eeprom("eeprom assumed v4l tveeprom module");
 	trace_eeprom("eeprom direct call results:");
-- 
2.9.0

