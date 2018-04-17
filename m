Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51078 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754433AbeDQQk1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:27 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 9/9] cx231xx: Add I2C_MUX dependency
Date: Tue, 17 Apr 2018 11:39:55 -0500
Message-Id: <1523983195-28691-10-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cx231xx requires i2c mux adapter capability.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 8a6acc2..98890a3 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX231XX
 	tristate "Conexant cx231xx USB video capture support"
-	depends on VIDEO_DEV && I2C
+	depends on VIDEO_DEV && I2C && I2C_MUX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEOBUF_VMALLOC
-- 
2.7.4
