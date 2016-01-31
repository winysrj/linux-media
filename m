Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38152 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbcAaFr4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2016 00:47:56 -0500
Received: by mail-ig0-f180.google.com with SMTP id mw1so13975204igb.1
        for <linux-media@vger.kernel.org>; Sat, 30 Jan 2016 21:47:56 -0800 (PST)
From: Abhilash Jindal <klock.android@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] [media] dvb-frontend: Use boottime
Date: Sun, 31 Jan 2016 00:47:31 -0500
Message-Id: <1454219251-21760-1-git-send-email-klock.android@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wall time obtained from ktime_get_real is susceptible to sudden jumps due to
user setting the time or due to NTP.  Boot time is constantly increasing time
better suited for comparing two timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c |    8 ++++----
 drivers/media/dvb-frontends/stv0299.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index c38ef1a..8058df9 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -901,10 +901,10 @@ void dvb_frontend_sleep_until(ktime_t *waketime, u32 add_usec)
 	s32 delta, newdelta;
 
 	ktime_add_us(*waketime, add_usec);
-	delta = ktime_us_delta(ktime_get_real(), *waketime);
+	delta = ktime_us_delta(ktime_get_boottime(), *waketime);
 	if (delta > 2500) {
 		msleep((delta - 1500) / 1000);
-		newdelta = ktime_us_delta(ktime_get_real(), *waketime);
+		newdelta = ktime_us_delta(ktime_get_boottime(), *waketime);
 		delta = (newdelta > delta) ? 0 : newdelta;
 	}
 	if (delta > 0)
@@ -2454,7 +2454,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 			u8 last = 1;
 			if (dvb_frontend_debug)
 				printk("%s switch command: 0x%04lx\n", __func__, swcmd);
-			nexttime = ktime_get_real();
+			nexttime = ktime_get_boottime();
 			if (dvb_frontend_debug)
 				tv[0] = nexttime;
 			/* before sending a command, initialize by sending
@@ -2465,7 +2465,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 			for (i = 0; i < 9; i++) {
 				if (dvb_frontend_debug)
-					tv[i+1] = ktime_get_real();
+					tv[i+1] = ktime_get_boottime();
 				if ((swcmd & 0x01) != last) {
 					/* set voltage to (last ? 13V : 18V) */
 					fe->ops.set_voltage(fe, (last) ? SEC_VOLTAGE_13 : SEC_VOLTAGE_18);
diff --git a/drivers/media/dvb-frontends/stv0299.c b/drivers/media/dvb-frontends/stv0299.c
index a817780..c43f36d 100644
--- a/drivers/media/dvb-frontends/stv0299.c
+++ b/drivers/media/dvb-frontends/stv0299.c
@@ -422,7 +422,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 	if (debug_legacy_dish_switch)
 		printk ("%s switch command: 0x%04lx\n",__func__, cmd);
 
-	nexttime = ktime_get_real();
+	nexttime = ktime_get_boottime();
 	if (debug_legacy_dish_switch)
 		tv[0] = nexttime;
 	stv0299_writeregI (state, 0x0c, reg0x0c | 0x50); /* set LNB to 18V */
@@ -431,7 +431,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 
 	for (i=0; i<9; i++) {
 		if (debug_legacy_dish_switch)
-			tv[i+1] = ktime_get_real();
+			tv[i+1] = ktime_get_boottime();
 		if((cmd & 0x01) != last) {
 			/* set voltage to (last ? 13V : 18V) */
 			stv0299_writeregI (state, 0x0c, reg0x0c | (last ? lv_mask : 0x50));
-- 
1.7.9.5

