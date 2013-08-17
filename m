Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55397 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3HQQb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:31:59 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 41/49] media: usb: tm6000: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:06 +0800
Message-Id: <1376756714-25479-42-git-send-email-ming.lei@canonical.com>
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
 drivers/media/usb/tm6000/tm6000-video.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index cc1aa14..8bb440f 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -434,6 +434,7 @@ static void tm6000_irq_callback(struct urb *urb)
 	struct tm6000_dmaqueue  *dma_q = urb->context;
 	struct tm6000_core *dev = container_of(dma_q, struct tm6000_core, vidq);
 	int i;
+	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:
@@ -450,9 +451,9 @@ static void tm6000_irq_callback(struct urb *urb)
 		break;
 	}
 
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock, flags);
 	tm6000_isoc_copy(urb);
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock, flags);
 
 	/* Reset urb buffers */
 	for (i = 0; i < urb->number_of_packets; i++) {
-- 
1.7.9.5

