Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45588 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932505AbdJXPXF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 11:23:05 -0400
Received: by mail-pg0-f67.google.com with SMTP id b192so14800589pga.2
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 08:23:05 -0700 (PDT)
Date: Tue, 24 Oct 2017 08:23:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: radio: Convert timers to use timer_setup()
Message-ID: <20171024152303.GA104951@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/radio/radio-cadet.c         | 7 +++----
 drivers/media/radio/wl128x/fmdrv_common.c | 7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 6888b7db449d..7575e5370a49 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -281,9 +281,9 @@ static bool cadet_has_rds_data(struct cadet *dev)
 }
 
 
-static void cadet_handler(unsigned long data)
+static void cadet_handler(struct timer_list *t)
 {
-	struct cadet *dev = (void *)data;
+	struct cadet *dev = from_timer(dev, t, readtimer);
 
 	/* Service the RDS fifo */
 	if (mutex_trylock(&dev->lock)) {
@@ -309,7 +309,6 @@ static void cadet_handler(unsigned long data)
 	/*
 	 * Clean up and exit
 	 */
-	setup_timer(&dev->readtimer, cadet_handler, data);
 	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
 	add_timer(&dev->readtimer);
 }
@@ -318,7 +317,7 @@ static void cadet_start_rds(struct cadet *dev)
 {
 	dev->rdsstat = 1;
 	outb(0x80, dev->io);        /* Select RDS fifo */
-	setup_timer(&dev->readtimer, cadet_handler, (unsigned long)dev);
+	timer_setup(&dev->readtimer, cadet_handler, 0);
 	dev->readtimer.expires = jiffies + msecs_to_jiffies(50);
 	add_timer(&dev->readtimer);
 }
diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index ab3428bf63fe..800d69c3f80b 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -543,13 +543,13 @@ static inline void fm_irq_common_cmd_resp_helper(struct fmdev *fmdev, u8 stage)
  * interrupt process. Therefore reset stage index to re-enable default
  * interrupts. So that next interrupt will be processed as usual.
  */
-static void int_timeout_handler(unsigned long data)
+static void int_timeout_handler(struct timer_list *t)
 {
 	struct fmdev *fmdev;
 	struct fm_irq *fmirq;
 
 	fmdbg("irq: timeout,trying to re-enable fm interrupts\n");
-	fmdev = (struct fmdev *)data;
+	fmdev = from_timer(fmdev, t, irq_info.timer);
 	fmirq = &fmdev->irq_info;
 	fmirq->retry++;
 
@@ -1550,8 +1550,7 @@ int fmc_prepare(struct fmdev *fmdev)
 	atomic_set(&fmdev->tx_cnt, 1);
 	fmdev->resp_comp = NULL;
 
-	setup_timer(&fmdev->irq_info.timer, &int_timeout_handler,
-		    (unsigned long)fmdev);
+	timer_setup(&fmdev->irq_info.timer, int_timeout_handler, 0);
 	/*TODO: add FM_STIC_EVENT later */
 	fmdev->irq_info.mask = FM_MAL_EVENT;
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
