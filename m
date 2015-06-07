Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:41344 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbbFGOmx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 10:42:53 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Erik Andren <erik.andren@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] [media] gscpa_m5602: use msecs_to_jiffies for conversions
Date: Sun,  7 Jun 2015 16:34:40 +0200
Message-Id: <1433687680-1736-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

API compliance scanning with coccinelle flagged:
./drivers/media/usb/gspca/m5602/m5602_s5k83a.c:180:9-25:
	 WARNING: timeout (100) seems HZ dependent

Numeric constants passed to schedule_timeout() make the effective
timeout HZ dependent which makes little sense in a polling loop for
the cameras rotation state.
Fixed up by converting the constant to jiffies with msecs_to_jiffies()

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was compile tested with i386_defconfig + 

Patch is against 4.1-rc6 (localversion-next is -next-20150605)

 drivers/media/usb/gspca/m5602/m5602_s5k83a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
index 7cbc3a0..bf6b215 100644
--- a/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
+++ b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
@@ -177,7 +177,7 @@ static int rotation_thread_function(void *data)
 	__s32 vflip, hflip;
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!schedule_timeout(100)) {
+	while (!schedule_timeout(msecs_to_jiffies(100))) {
 		if (mutex_lock_interruptible(&sd->gspca_dev.usb_lock))
 			break;
 
-- 
1.7.10.4

