Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:44382 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJKW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:10:22 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 28/50] USBNET: kaweth: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:51 +0800
Message-Id: <1373533573-12272-29-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: netdev@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/usb/kaweth.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/kaweth.c b/drivers/net/usb/kaweth.c
index afb117c..4addbbf 100644
--- a/drivers/net/usb/kaweth.c
+++ b/drivers/net/usb/kaweth.c
@@ -598,6 +598,7 @@ static void kaweth_usb_receive(struct urb *urb)
 	struct kaweth_device *kaweth = urb->context;
 	struct net_device *net = kaweth->net;
 	int status = urb->status;
+	unsigned long flags;
 
 	int count = urb->actual_length;
 	int count2 = urb->transfer_buffer_length;
@@ -630,12 +631,12 @@ static void kaweth_usb_receive(struct urb *urb)
 		kaweth->stats.rx_errors++;
 		dev_dbg(dev, "Status was -EOVERFLOW.\n");
 	}
-	spin_lock(&kaweth->device_lock);
+	spin_lock_irqsave(&kaweth->device_lock, flags);
 	if (IS_BLOCKED(kaweth->status)) {
-		spin_unlock(&kaweth->device_lock);
+		spin_unlock_irqrestore(&kaweth->device_lock, flags);
 		return;
 	}
-	spin_unlock(&kaweth->device_lock);
+	spin_unlock_irqrestore(&kaweth->device_lock, flags);
 
 	if(status && status != -EREMOTEIO && count != 1) {
 		dev_err(&kaweth->intf->dev,
-- 
1.7.9.5

