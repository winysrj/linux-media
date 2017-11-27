Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:64383 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbdK0NVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 08:21:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Anton Sviridenko <anton@corp.bluecherry.net>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] [media] solo6x10: use ktime_get_ts64() for time sync
Date: Mon, 27 Nov 2017 14:19:55 +0100
Message-Id: <20171127132027.1734806-3-arnd@arndb.de>
In-Reply-To: <20171127132027.1734806-1-arnd@arndb.de>
References: <20171127132027.1734806-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

solo6x10 correctly deals with time stamps and will never
suffer from overflows, but it uses the deprecated 'struct timespec'
type and 'ktime_get_ts()' interface to read the monotonic clock.

This changes it to use ktime_get_ts64() instead, so we can
eventually remove ktime_get_ts().

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/solo6x10/solo6x10-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/solo6x10/solo6x10-core.c b/drivers/media/pci/solo6x10/solo6x10-core.c
index ca0873e47bea..19ffd2ed3cc7 100644
--- a/drivers/media/pci/solo6x10/solo6x10-core.c
+++ b/drivers/media/pci/solo6x10/solo6x10-core.c
@@ -47,18 +47,19 @@ MODULE_PARM_DESC(full_eeprom, "Allow access to full 128B EEPROM (dangerous)");
 
 static void solo_set_time(struct solo_dev *solo_dev)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 
-	ktime_get_ts(&ts);
+	ktime_get_ts64(&ts);
 
-	solo_reg_write(solo_dev, SOLO_TIMER_SEC, ts.tv_sec);
-	solo_reg_write(solo_dev, SOLO_TIMER_USEC, ts.tv_nsec / NSEC_PER_USEC);
+	/* no overflow because we use monotonic timestamps */
+	solo_reg_write(solo_dev, SOLO_TIMER_SEC, (u32)ts.tv_sec);
+	solo_reg_write(solo_dev, SOLO_TIMER_USEC, (u32)ts.tv_nsec / NSEC_PER_USEC);
 }
 
 static void solo_timer_sync(struct solo_dev *solo_dev)
 {
 	u32 sec, usec;
-	struct timespec ts;
+	struct timespec64 ts;
 	long diff;
 
 	if (solo_dev->type != SOLO_DEV_6110)
@@ -72,11 +73,11 @@ static void solo_timer_sync(struct solo_dev *solo_dev)
 	sec = solo_reg_read(solo_dev, SOLO_TIMER_SEC);
 	usec = solo_reg_read(solo_dev, SOLO_TIMER_USEC);
 
-	ktime_get_ts(&ts);
+	ktime_get_ts64(&ts);
 
-	diff = (long)ts.tv_sec - (long)sec;
+	diff = (s32)ts.tv_sec - (s32)sec;
 	diff = (diff * 1000000)
-		+ ((long)(ts.tv_nsec / NSEC_PER_USEC) - (long)usec);
+		+ ((s32)(ts.tv_nsec / NSEC_PER_USEC) - (s32)usec);
 
 	if (diff > 1000 || diff < -1000) {
 		solo_set_time(solo_dev);
-- 
2.9.0
