Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbbJCPYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 11:24:03 -0400
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Don Fry <pcnet32@frontier.com>,
	Oliver Neukum <oneukum@suse.com>
Cc: linux-net-drivers@solarflare.com, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] usbnet: remove ifdefed out call to dma_supported
Date: Sat,  3 Oct 2015 17:19:37 +0200
Message-Id: <1443885579-7094-14-git-send-email-hch@lst.de>
In-Reply-To: <1443885579-7094-1-git-send-email-hch@lst.de>
References: <1443885579-7094-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/usb/usbnet.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index b4cf107..9497d51 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1661,12 +1661,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 * bind() should set rx_urb_size in that case.
 	 */
 	dev->hard_mtu = net->mtu + net->hard_header_len;
-#if 0
-// dma_supported() is deeply broken on almost all architectures
-	// possible with some EHCI controllers
-	if (dma_supported (&udev->dev, DMA_BIT_MASK(64)))
-		net->features |= NETIF_F_HIGHDMA;
-#endif
 
 	net->netdev_ops = &usbnet_netdev_ops;
 	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
-- 
1.9.1

