Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44858 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751234AbeECVUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 17:20:25 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH v2 8/9] cx231xx: Remove RC_CORE dependency
Date: Thu,  3 May 2018 16:20:14 -0500
Message-Id: <1525382415-4049-9-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
References: <1525382415-4049-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_CX231XX_RC requires RC_CORE, but VIDEO_CX231XX
does not require RC to compile or function.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 6276d9b..8a6acc2 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -3,7 +3,6 @@ config VIDEO_CX231XX
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
-- 
2.7.4
