Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40537 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbbBXErn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 23:47:43 -0500
Date: Tue, 24 Feb 2015 10:17:32 +0530
From: Tapasweni Pathak <tapaswenipathak@gmail.com>
To: kyungmin.park@samsung.com, a.hajda@samsung.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: tapaswenipathak@gmail.com
Subject: [PATCH] drivers: media: i2c : s5c73m3: Replace dev_err with pr_err
Message-ID: <20150224044731.GA5804@kt-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace dev_err statement with pr_err to fix null dereference.

Found by Coccinelle.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index f60b265..63eb190 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -52,7 +52,7 @@ static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
 		xfer.rx_buf = addr;

 	if (spi_dev == NULL) {
-		dev_err(&spi_dev->dev, "SPI device is uninitialized\n");
+		pr_err("SPI device is uninitialized\n");
 		return -ENODEV;
 	}

--
1.7.9.5

