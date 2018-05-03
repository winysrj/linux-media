Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44839 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751236AbeECVUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 9/9] cx231xx: Add I2C_MUX dependency
Date: Thu,  3 May 2018 16:20:15 -0500
Message-Id: <1525382415-4049-10-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
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
