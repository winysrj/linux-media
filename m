Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:51073 "EHLO
        homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755196AbeDQQk1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:40:27 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@s-opensource.com
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 8/9] cx231xx: Remove RC_CORE dependency
Date: Tue, 17 Apr 2018 11:39:54 -0500
Message-Id: <1523983195-28691-9-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
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
