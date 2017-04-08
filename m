Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:57371 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdDHGLw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 02:11:52 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH 1/2] Fix Ukraine, Kyiv
Date: Sat,  8 Apr 2017 09:04:15 +0300
Message-Id: <20170408060416.7327-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 dvb-t/{ua-Kiev => ua-Kyiv} | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename dvb-t/{ua-Kiev => ua-Kyiv} (98%)

diff --git a/dvb-t/ua-Kiev b/dvb-t/ua-Kyiv
similarity index 98%
rename from dvb-t/ua-Kiev
rename to dvb-t/ua-Kyiv
index 6bf096b..2e45d59 100644
--- a/dvb-t/ua-Kiev
+++ b/dvb-t/ua-Kyiv
@@ -1,4 +1,4 @@
-# Ukraine, Kiev
+# Ukraine, Kyiv
 [CHANNEL]
 	DELIVERY_SYSTEM = DVBT2
 	FREQUENCY = 526000000
-- 
2.10.2
