Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:43537 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbeAEAFQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 19:05:16 -0500
Received: from homiemail-a116.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 102E58ED86
        for <linux-media@vger.kernel.org>; Thu,  4 Jan 2018 16:05:16 -0800 (PST)
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/9] em28xx: Increase max em28xx boards to max dvb adapters
Date: Thu,  4 Jan 2018 18:04:14 -0600
Message-Id: <1515110659-20145-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
References: <1515110659-20145-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maximum 4 em28xx boards is too low, this can be maxed out by two devices.
This allows all the dvb adapters in the system to be em28xx if so desired.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/usb/em28xx/em28xx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 7be8ac9..3dbcc9d 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -166,7 +166,7 @@
 #define EM28XX_STOP_AUDIO       0
 
 /* maximum number of em28xx boards */
-#define EM28XX_MAXBOARDS 4 /*FIXME: should be bigger */
+#define EM28XX_MAXBOARDS DVB_MAX_ADAPTERS /* All adapters could be em28xx */
 
 /* maximum number of frames that can be queued */
 #define EM28XX_NUM_FRAMES 5
-- 
2.7.4
