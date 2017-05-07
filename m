Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:56023 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752715AbdEGWpZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:45:25 -0400
From: Anton Blanchard <anton@ozlabs.org>
To: mchehab@kernel.org, andi.shyti@samsung.com, sean@mess.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] ir-spi: Fix issues with lirc API
Date: Sun,  7 May 2017 11:00:11 +1000
Message-Id: <20170507010011.2786-1-anton@ozlabs.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Anton Blanchard <anton@samba.org>

The ir-spi driver has 2 issues which prevents it from working with
lirc:

1. The ir-spi driver uses 16 bits of SPI data to create one cycle of
the waveform. As such our SPI clock needs to be 16x faster than the
carrier frequency.

The driver is inconsistent in how it currently handles this. It
initializes it to the carrier frequency:

But the commit message has some example code which initialises it
to 16x the carrier frequency:

	val = 608000;
	ret = ioctl(fd, LIRC_SET_SEND_CARRIER, &val);

To maintain compatibility with lirc, always do the frequency adjustment
in the driver.

2. lirc presents pulses in microseconds, but the ir-spi driver treats
them as cycles of the carrier. Similar to other lirc drivers, do the
conversion with DIV_ROUND_CLOSEST().

Fixes: fe052da49201 ("[media] rc: add support for IR LEDs driven through SPI")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Blanchard <anton@samba.org>
---
 drivers/media/rc/ir-spi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index c8863f36686a..f39cf8cb639f 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -57,10 +57,13 @@ static int ir_spi_tx(struct rc_dev *dev,
 
 	/* convert the pulse/space signal to raw binary signal */
 	for (i = 0; i < count; i++) {
+		unsigned int periods;
 		int j;
 		u16 val = ((i + 1) % 2) ? idata->pulse : idata->space;
 
-		if (len + buffer[i] >= IR_SPI_MAX_BUFSIZE)
+		periods = DIV_ROUND_CLOSEST(buffer[i] * idata->freq, 1000000);
+
+		if (len + periods >= IR_SPI_MAX_BUFSIZE)
 			return -EINVAL;
 
 		/*
@@ -69,13 +72,13 @@ static int ir_spi_tx(struct rc_dev *dev,
 		 * contain a space duration.
 		 */
 		val = (i % 2) ? idata->space : idata->pulse;
-		for (j = 0; j < buffer[i]; j++)
+		for (j = 0; j < periods; j++)
 			idata->tx_buf[len++] = val;
 	}
 
 	memset(&xfer, 0, sizeof(xfer));
 
-	xfer.speed_hz = idata->freq;
+	xfer.speed_hz = idata->freq * 16;
 	xfer.len = len * sizeof(*idata->tx_buf);
 	xfer.tx_buf = idata->tx_buf;
 
-- 
2.11.0
