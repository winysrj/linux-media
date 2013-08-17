Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:42766 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3HQQbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Aug 2013 12:31:31 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Ming Lei <ming.lei@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v1 38/49] media: usb: em28xx: prepare for enabling irq in complete()
Date: Sun, 18 Aug 2013 00:25:03 +0800
Message-Id: <1376756714-25479-39-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
References: <1376756714-25479-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Tested-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index fc157af..0d698f9 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -941,6 +941,7 @@ static void em28xx_irq_callback(struct urb *urb)
 {
 	struct em28xx *dev = urb->context;
 	int i;
+	unsigned long flags;
 
 	switch (urb->status) {
 	case 0:             /* success */
@@ -956,9 +957,9 @@ static void em28xx_irq_callback(struct urb *urb)
 	}
 
 	/* Copy data from URB */
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock, flags);
 	dev->usb_ctl.urb_data_copy(dev, urb);
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock, flags);
 
 	/* Reset urb buffers */
 	for (i = 0; i < urb->number_of_packets; i++) {
-- 
1.7.9.5

