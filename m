Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64930 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJK3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:10:29 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 29/50] USBNET: rtl8150: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:52 +0800
Message-Id: <1373533573-12272-30-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: netdev@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/usb/rtl8150.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 6cbdac6..199e0fb 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -372,6 +372,7 @@ static void read_bulk_callback(struct urb *urb)
 	u16 rx_stat;
 	int status = urb->status;
 	int result;
+	unsigned long flags;
 
 	dev = urb->context;
 	if (!dev)
@@ -413,9 +414,9 @@ static void read_bulk_callback(struct urb *urb)
 	netdev->stats.rx_packets++;
 	netdev->stats.rx_bytes += pkt_len;
 
-	spin_lock(&dev->rx_pool_lock);
+	spin_lock_irqsave(&dev->rx_pool_lock, flags);
 	skb = pull_skb(dev);
-	spin_unlock(&dev->rx_pool_lock);
+	spin_unlock_irqrestore(&dev->rx_pool_lock, flags);
 	if (!skb)
 		goto resched;
 
-- 
1.7.9.5

