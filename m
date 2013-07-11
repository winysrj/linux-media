Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57375 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab3GKJMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:12:54 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>, devel@driverdev.osuosl.org
Subject: [PATCH 47/50] staging: btmtk_usb: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:06:10 +0800
Message-Id: <1373533573-12272-48-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: devel@driverdev.osuosl.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/staging/btmtk_usb/btmtk_usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/btmtk_usb/btmtk_usb.c b/drivers/staging/btmtk_usb/btmtk_usb.c
index 0e783e8..ea10d4f 100644
--- a/drivers/staging/btmtk_usb/btmtk_usb.c
+++ b/drivers/staging/btmtk_usb/btmtk_usb.c
@@ -1218,6 +1218,7 @@ static void btmtk_usb_tx_complete(struct urb *urb)
 	struct sk_buff *skb = urb->context;
 	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
 	struct btmtk_usb_data *data = hci_get_drvdata(hdev);
+	unsigned long flags;
 
 	BT_DBG("%s: %s urb %p status %d count %d\n", __func__, hdev->name,
 					urb, urb->status, urb->actual_length);
@@ -1231,9 +1232,9 @@ static void btmtk_usb_tx_complete(struct urb *urb)
 		hdev->stat.err_tx++;
 
 done:
-	spin_lock(&data->txlock);
+	spin_lock_irqsave(&data->txlock, flags);
 	data->tx_in_flight--;
-	spin_unlock(&data->txlock);
+	spin_unlock_irqrestore(&data->txlock, flags);
 
 	kfree(urb->setup_packet);
 
-- 
1.7.9.5

