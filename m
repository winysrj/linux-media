Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40510 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932278Ab3GKJLC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jul 2013 05:11:02 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-input@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Ming Lei <ming.lei@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
Subject: [PATCH 33/50] wireless: libertas: spin_lock in complete() cleanup
Date: Thu, 11 Jul 2013 17:05:56 +0800
Message-Id: <1373533573-12272-34-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
References: <1373533573-12272-1-git-send-email-ming.lei@canonical.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Complete() will be run with interrupt enabled, so change to
spin_lock_irqsave().

Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/net/wireless/libertas/if_usb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 2798077..f6a8396 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -626,6 +626,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 				      struct lbs_private *priv)
 {
 	u8 i;
+	unsigned long flags;
 
 	if (recvlength > LBS_CMD_BUFFER_SIZE) {
 		lbs_deb_usbd(&cardp->udev->dev,
@@ -636,7 +637,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 
 	BUG_ON(!in_interrupt());
 
-	spin_lock(&priv->driver_lock);
+	spin_lock_irqsave(&priv->driver_lock, flags);
 
 	i = (priv->resp_idx == 0) ? 1 : 0;
 	BUG_ON(priv->resp_len[i]);
@@ -646,7 +647,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 	kfree_skb(skb);
 	lbs_notify_command_response(priv, i);
 
-	spin_unlock(&priv->driver_lock);
+	spin_unlock_irqrestore(&priv->driver_lock, flags);
 
 	lbs_deb_usbd(&cardp->udev->dev,
 		    "Wake up main thread to handle cmd response\n");
-- 
1.7.9.5

