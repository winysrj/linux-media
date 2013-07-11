Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:57851 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3GKJGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:06:52 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 02/50] USB: cdc-wdm: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:25 +0800
Message-Id: <1373533573-12272-3-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/class/cdc-wdm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 8a230f0..5f78d18 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -143,10 +143,12 @@ found:
 static void wdm_out_callback(struct urb *urb)
 {
 	struct wdm_device *desc;
+	unsigned long flags;
+
 	desc = urb->context;
-	spin_lock(&desc->iuspin);
+	spin_lock_irqsave(&desc->iuspin, flags);
 	desc->werr = urb->status;
-	spin_unlock(&desc->iuspin);
+	spin_unlock_irqrestore(&desc->iuspin, flags);
 	kfree(desc->outbuf);
 	desc->outbuf = NULL;
 	clear_bit(WDM_IN_USE, &desc->flags);
@@ -158,8 +160,9 @@ static void wdm_in_callback(struct urb *urb)
 	struct wdm_device *desc = urb->context;
 	int status = urb->status;
 	int length = urb->actual_length;
+	unsigned long flags;
 
-	spin_lock(&desc->iuspin);
+	spin_lock_irqsave(&desc->iuspin, flags);
 	clear_bit(WDM_RESPONDING, &desc->flags);
 
 	if (status) {
@@ -203,7 +206,7 @@ skip_error:
 	wake_up(&desc->wait);
 
 	set_bit(WDM_READ, &desc->flags);
-	spin_unlock(&desc->iuspin);
+	spin_unlock_irqrestore(&desc->iuspin, flags);
 }
 
 static void wdm_int_callback(struct urb *urb)
@@ -212,6 +215,7 @@ static void wdm_int_callback(struct urb *urb)
 	int status = urb->status;
 	struct wdm_device *desc;
 	struct usb_cdc_notification *dr;
+	unsigned long flags;
 
 	desc = urb->context;
 	dr = (struct usb_cdc_notification *)desc->sbuf;
@@ -260,7 +264,7 @@ static void wdm_int_callback(struct urb *urb)
 		goto exit;
 	}
 
-	spin_lock(&desc->iuspin);
+	spin_lock_irqsave(&desc->iuspin, flags);
 	clear_bit(WDM_READ, &desc->flags);
 	set_bit(WDM_RESPONDING, &desc->flags);
 	if (!test_bit(WDM_DISCONNECTING, &desc->flags)
@@ -269,7 +273,7 @@ static void wdm_int_callback(struct urb *urb)
 		dev_dbg(&desc->intf->dev, "%s: usb_submit_urb %d",
 			__func__, rv);
 	}
-	spin_unlock(&desc->iuspin);
+	spin_unlock_irqrestore(&desc->iuspin, flags);
 	if (rv < 0) {
 		clear_bit(WDM_RESPONDING, &desc->flags);
 		if (rv == -EPERM)
-- 
1.7.9.5

