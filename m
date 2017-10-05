Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:53157 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdJEAxB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 20:53:01 -0400
Received: by mail-pg0-f51.google.com with SMTP id i195so7410421pgd.9
        for <linux-media@vger.kernel.org>; Wed, 04 Oct 2017 17:53:00 -0700 (PDT)
Date: Wed, 4 Oct 2017 17:52:58 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] media/saa7146: Convert timers to use timer_setup()
Message-ID: <20171005005258.GA23682@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly. This requires adding a pointer to
hold the timer's target file, as there won't be a way to pass this in the
future.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/media/common/saa7146/saa7146_fops.c | 2 +-
 drivers/media/common/saa7146/saa7146_vbi.c  | 9 +++++----
 include/media/drv-intf/saa7146_vv.h         | 1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index 930d2c94d5d3..c4664f0da874 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -559,7 +559,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	vbi->start[1] = 312;
 	vbi->count[1] = 16;
 
-	init_timer(&vv->vbi_read_timeout);
+	timer_setup(&vv->vbi_read_timeout, NULL, 0);
 
 	vv->ov_fb.capability = V4L2_FBUF_CAP_LIST_CLIPPING;
 	vv->ov_fb.flags = V4L2_FBUF_FLAG_PRIMARY;
diff --git a/drivers/media/common/saa7146/saa7146_vbi.c b/drivers/media/common/saa7146/saa7146_vbi.c
index d79e4d7ecd9f..f65c0b934c22 100644
--- a/drivers/media/common/saa7146/saa7146_vbi.c
+++ b/drivers/media/common/saa7146/saa7146_vbi.c
@@ -348,9 +348,10 @@ static void vbi_stop(struct saa7146_fh *fh, struct file *file)
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
-static void vbi_read_timeout(unsigned long data)
+static void vbi_read_timeout(struct timer_list *t)
 {
-	struct file *file = (struct file*)data;
+	struct saa7146_vv *vv = from_timer(vv, t, vbi_read_timeout);
+	struct file *file = vv->vbi_read_timeout_file;
 	struct saa7146_fh *fh = file->private_data;
 	struct saa7146_dev *dev = fh->dev;
 
@@ -401,8 +402,8 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 			    sizeof(struct saa7146_buf),
 			    file, &dev->v4l2_lock);
 
-	vv->vbi_read_timeout.function = vbi_read_timeout;
-	vv->vbi_read_timeout.data = (unsigned long)file;
+	vv->vbi_read_timeout.function = (TIMER_FUNC_TYPE)vbi_read_timeout;
+	vv->vbi_read_timeout_file = file;
 
 	/* initialize the brs */
 	if ( 0 != (SAA7146_USE_PORT_B_FOR_VBI & dev->ext_vv_data->flags)) {
diff --git a/include/media/drv-intf/saa7146_vv.h b/include/media/drv-intf/saa7146_vv.h
index 0da6ccc0615b..fbe36d05fb79 100644
--- a/include/media/drv-intf/saa7146_vv.h
+++ b/include/media/drv-intf/saa7146_vv.h
@@ -107,6 +107,7 @@ struct saa7146_vv
 	struct saa7146_dmaqueue		vbi_dmaq;
 	struct v4l2_vbi_format		vbi_fmt;
 	struct timer_list		vbi_read_timeout;
+	struct file			*vbi_read_timeout_file;
 	/* vbi workaround interrupt queue */
 	wait_queue_head_t		vbi_wq;
 	int				vbi_fieldcount;
-- 
2.7.4


-- 
Kees Cook
Pixel Security
