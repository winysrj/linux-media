Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbbJCPXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Oct 2015 11:23:52 -0400
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Don Fry <pcnet32@frontier.com>,
	Oliver Neukum <oneukum@suse.com>
Cc: linux-net-drivers@solarflare.com, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] mpsc: use dma_set_mask insted of dma_supported
Date: Sat,  3 Oct 2015 17:19:33 +0200
Message-Id: <1443885579-7094-10-git-send-email-hch@lst.de>
In-Reply-To: <1443885579-7094-1-git-send-email-hch@lst.de>
References: <1443885579-7094-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This ensures the dma mask that is supported by the driver is recorded
in the device structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/tty/serial/mpsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index 82bb6d1..11e084e 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -755,7 +755,7 @@ static int mpsc_alloc_ring_mem(struct mpsc_port_info *pi)
 		pi->port.line);
 
 	if (!pi->dma_region) {
-		if (!dma_supported(pi->port.dev, 0xffffffff)) {
+		if (!dma_set_mask(pi->port.dev, 0xffffffff)) {
 			printk(KERN_ERR "MPSC: Inadequate DMA support\n");
 			rc = -ENXIO;
 		} else if ((pi->dma_region = dma_alloc_noncoherent(pi->port.dev,
-- 
1.9.1

