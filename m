Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:34450 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755106AbdIHQjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 12:39:45 -0400
Received: by mail-pg0-f49.google.com with SMTP id q68so5693200pgq.1
        for <linux-media@vger.kernel.org>; Fri, 08 Sep 2017 09:39:45 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH] media: default for RC_CORE should be n
Date: Fri,  8 Sep 2017 09:39:29 -0700
Message-Id: <20170908163929.9277-1-sthemmin@microsoft.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linus policy on Kconfig is that the default should be no
for all new devices. I.e the user rebuild a new kernel from an
old config should not by default get a larger kernel.

Fixes: b4c184e506a4 ("[media] media: reorganize the main Kconfig items")
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
---
 drivers/media/rc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index d9ce8ff55d0c..5aa384afcfef 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -2,7 +2,7 @@
 menuconfig RC_CORE
 	tristate "Remote Controller support"
 	depends on INPUT
-	default y
+	default n
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters,
-- 
2.11.0
