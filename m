Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.130]:62692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaBZLCn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 08/16] [media] arv: fix sleep_on race
Date: Wed, 26 Feb 2014 12:01:48 +0100
Message-Id: <1393412516-3762435-9-git-send-email-arnd@arndb.de>
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

interruptible_sleep_on is racy and going away. In the arv driver that
race has probably never caused problems since it would require a whole
video frame to be captured before the read function has a chance to
go to sleep, but using wait_event_interruptible lets us kill off the
old interface. In order to do this, we have to slightly adapt the
meaning of the ar->start_capture field to distinguish between not having
started a frame and having completed it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/arv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
index e346d32d..e9410e4 100644
--- a/drivers/media/platform/arv.c
+++ b/drivers/media/platform/arv.c
@@ -109,7 +109,7 @@ extern struct cpuinfo_m32r	boot_cpu_data;
 struct ar {
 	struct v4l2_device v4l2_dev;
 	struct video_device vdev;
-	unsigned int start_capture;	/* duaring capture in INT. mode. */
+	int start_capture;	/* duaring capture in INT. mode. */
 #if USE_INT
 	unsigned char *line_buff;	/* DMA line buffer */
 #endif
@@ -307,11 +307,11 @@ static ssize_t ar_read(struct file *file, char *buf, size_t count, loff_t *ppos)
 	/*
 	 * Okay, kick AR LSI to invoke an interrupt
 	 */
-	ar->start_capture = 0;
+	ar->start_capture = -1;
 	ar_outl(arvcr1 | ARVCR1_HIEN, ARVCR1);
 	local_irq_restore(flags);
 	/* .... AR interrupts .... */
-	interruptible_sleep_on(&ar->wait);
+	wait_event_interruptible(ar->wait, ar->start_capture == 0);
 	if (signal_pending(current)) {
 		printk(KERN_ERR "arv: interrupted while get frame data.\n");
 		ret = -EINTR;
-- 
1.8.3.2

