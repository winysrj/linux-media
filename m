Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50979 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbbEZN0l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2015 09:26:41 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <vinod.koul@intel.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dan.j.williams@intel.com>, <dmaengine@vger.kernel.org>,
	<linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-spi@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 03/13] serial: 8250_dma: Support for deferred probing when requesting DMA channels
Date: Tue, 26 May 2015 16:25:58 +0300
Message-ID: <1432646768-12532-4-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to use ma_request_slave_channel_compat_reason() to request the DMA
channels. In case of error, return the error code we received including
-EPROBE_DEFER

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dma.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dma.c b/drivers/tty/serial/8250/8250_dma.c
index 21d01a491405..a617eca4e97d 100644
--- a/drivers/tty/serial/8250/8250_dma.c
+++ b/drivers/tty/serial/8250/8250_dma.c
@@ -182,21 +182,19 @@ int serial8250_request_dma(struct uart_8250_port *p)
 	dma_cap_set(DMA_SLAVE, mask);
 
 	/* Get a channel for RX */
-	dma->rxchan = dma_request_slave_channel_compat(mask,
-						       dma->fn, dma->rx_param,
-						       p->port.dev, "rx");
-	if (!dma->rxchan)
-		return -ENODEV;
+	dma->rxchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
+					dma->rx_param, p->port.dev, "rx");
+	if (IS_ERR(dma->rxchan))
+		return PTR_ERR(dma->rxchan);
 
 	dmaengine_slave_config(dma->rxchan, &dma->rxconf);
 
 	/* Get a channel for TX */
-	dma->txchan = dma_request_slave_channel_compat(mask,
-						       dma->fn, dma->tx_param,
-						       p->port.dev, "tx");
-	if (!dma->txchan) {
+	dma->txchan = dma_request_slave_channel_compat_reason(mask, dma->fn,
+					dma->tx_param, p->port.dev, "tx");
+	if (IS_ERR(dma->txchan)) {
 		dma_release_channel(dma->rxchan);
-		return -ENODEV;
+		return PTR_ERR(dma->txchan);
 	}
 
 	dmaengine_slave_config(dma->txchan, &dma->txconf);
-- 
2.3.5

