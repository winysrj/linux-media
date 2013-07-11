Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:42051 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJKG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:10:06 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 26/50] USBNET: cdc-phonet: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:49 +0800
Message-Id: <1373533573-12272-27-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: netdev@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/usb/cdc-phonet.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index 7d78669..413ec32 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -99,6 +99,7 @@ static void tx_complete(struct urb *req)
 	struct net_device *dev = skb->dev;
 	struct usbpn_dev *pnd = netdev_priv(dev);
 	int status = req->status;
+	unsigned long flags;
 
 	switch (status) {
 	case 0:
@@ -115,10 +116,10 @@ static void tx_complete(struct urb *req)
 	}
 	dev->stats.tx_packets++;
 
-	spin_lock(&pnd->tx_lock);
+	spin_lock_irqsave(&pnd->tx_lock, flags);
 	pnd->tx_queue--;
 	netif_wake_queue(dev);
-	spin_unlock(&pnd->tx_lock);
+	spin_unlock_irqrestore(&pnd->tx_lock, flags);
 
 	dev_kfree_skb_any(skb);
 	usb_free_urb(req);
-- 
1.7.9.5

