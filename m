Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:45943 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751086AbeEEPIC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 11:08:02 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH] [bug] cx231xx: Fix recursive dependency
Date: Sat,  5 May 2018 10:07:53 -0500
Message-Id: <1525532873-3033-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

0day build bot reported an unnoticed recursive dependency, fix it
by removing the select statement.

fixes: c66d4d99a8fb ("cx231xx: Add I2C_MUX dependency")
Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/cx231xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 98890a3..1b11ae1 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -6,7 +6,6 @@ config VIDEO_CX231XX
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
-	select I2C_MUX
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
-- 
2.7.4
