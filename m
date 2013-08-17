Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36839 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3HQQbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:31:40 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 39/49] media: usb: sn9x102: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:04 +0800
Message-Id: <1376756714-25479-40-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/usb/sn9c102/sn9c102_core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
index 2cb44de..33dc595 100644
--- a/drivers/media/usb/sn9c102/sn9c102_core.c
+++ b/drivers/media/usb/sn9c102/sn9c102_core.c
@@ -784,12 +784,14 @@ end_of_frame:
 				      cam->sensor.pix_format.pixelformat ==
 				      V4L2_PIX_FMT_JPEG) && eof)) {
 					u32 b;
+					unsigned long flags;
 
 					b = (*f)->buf.bytesused;
 					(*f)->state = F_DONE;
 					(*f)->buf.sequence= ++cam->frame_count;
 
-					spin_lock(&cam->queue_lock);
+					spin_lock_irqsave(&cam->queue_lock,
+							  flags);
 					list_move_tail(&(*f)->frame,
 						       &cam->outqueue);
 					if (!list_empty(&cam->inqueue))
@@ -799,7 +801,8 @@ end_of_frame:
 							frame );
 					else
 						(*f) = NULL;
-					spin_unlock(&cam->queue_lock);
+					spin_unlock_irqrestore(&cam->queue_lock,
+							       flags);
 
 					memcpy(cam->sysfs.frame_header,
 					       cam->sof.header, soflen);
-- 
1.7.9.5

