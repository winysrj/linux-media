Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62826 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab3GKJIa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:08:30 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>,
	Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 14/50] USB: serial: mos7720: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:37 +0800
Message-Id: <1373533573-12272-15-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/usb/serial/mos7720.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 51da424..9b8c866 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -338,14 +338,15 @@ static void async_complete(struct urb *urb)
 {
 	struct urbtracker *urbtrack = urb->context;
 	int status = urb->status;
+	unsigned long flags;
 
 	if (unlikely(status))
 		dev_dbg(&urb->dev->dev, "%s - nonzero urb status received: %d\n", __func__, status);
 
 	/* remove the urbtracker from the active_urbs list */
-	spin_lock(&urbtrack->mos_parport->listlock);
+	spin_lock_irqsave(&urbtrack->mos_parport->listlock, flags);
 	list_del(&urbtrack->urblist_entry);
-	spin_unlock(&urbtrack->mos_parport->listlock);
+	spin_unlock_irqrestore(&urbtrack->mos_parport->listlock, flags);
 	kref_put(&urbtrack->ref_count, destroy_urbtracker);
 }
 
-- 
1.7.9.5

