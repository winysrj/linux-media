Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:47588 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932794AbdJPXKu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 19:10:50 -0400
Received: by mail-pg0-f54.google.com with SMTP id r25so8021852pgn.4
        for <linux-media@vger.kernel.org>; Mon, 16 Oct 2017 16:10:50 -0700 (PDT)
Date: Mon, 16 Oct 2017 16:10:47 -0700
From: Kees Cook <keescook@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devendra sharma <devendra.sharma9091@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: dvb-core: Convert timers to use timer_setup()
Message-ID: <20171016231047.GA99788@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devendra sharma <devendra.sharma9091@gmail.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/dvb-core/dmxdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 18e4230865be..3ddd44e1ee77 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -329,9 +329,9 @@ static int dvb_dmxdev_set_buffer_size(struct dmxdev_filter *dmxdevfilter,
 	return 0;
 }
 
-static void dvb_dmxdev_filter_timeout(unsigned long data)
+static void dvb_dmxdev_filter_timeout(struct timer_list *t)
 {
-	struct dmxdev_filter *dmxdevfilter = (struct dmxdev_filter *)data;
+	struct dmxdev_filter *dmxdevfilter = from_timer(dmxdevfilter, t, timer);
 
 	dmxdevfilter->buffer.error = -ETIMEDOUT;
 	spin_lock_irq(&dmxdevfilter->dev->lock);
@@ -346,8 +346,6 @@ static void dvb_dmxdev_filter_timer(struct dmxdev_filter *dmxdevfilter)
 
 	del_timer(&dmxdevfilter->timer);
 	if (para->timeout) {
-		dmxdevfilter->timer.function = dvb_dmxdev_filter_timeout;
-		dmxdevfilter->timer.data = (unsigned long)dmxdevfilter;
 		dmxdevfilter->timer.expires =
 		    jiffies + 1 + (HZ / 2 + HZ * para->timeout) / 1000;
 		add_timer(&dmxdevfilter->timer);
@@ -754,7 +752,7 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
 	dmxdevfilter->type = DMXDEV_TYPE_NONE;
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
-	init_timer(&dmxdevfilter->timer);
+	timer_setup(&dmxdevfilter->timer, dvb_dmxdev_filter_timeout, 0);
 
 	dvbdev->users++;
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
