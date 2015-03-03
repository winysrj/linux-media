Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36215 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbbCCDQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 22:16:17 -0500
Date: Tue, 3 Mar 2015 08:46:10 +0530
From: Tapasweni Pathak <tapaswenipathak@gmail.com>
To: kyungmin.park@samsung.com, a.hajda@samsung.com,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: tapaswenipathak@gmail.com
Subject: [PATCH v2] drivers: media: i2c : s5c73m3: Fix null dereference
Message-ID: <20150303031610.GA25471@kt-Inspiron-3542>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace dev_err statement which dereferences a null with pr_err_once.

Move if(!spi_dev) above if(dir...) block.

Found using Coccinelle.

Signed-off-by: Tapasweni Pathak <tapaswenipathak@gmail.com>
---
Changes since v1:
Replace pr_err with pr_err_once.
Move if(!spi_dev).
Reword commit message.
Reword subject.

 drivers/media/i2c/s5c73m3/s5c73m3-spi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index f60b265..376b78f 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -46,16 +46,16 @@ static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
 		.len	= len,
 	};

+	if(!spi_dev) {
+		pr_err_once("SPI device is unintialized\n");
+		return -ENODEV;
+	}
+
 	if (dir == SPI_DIR_TX)
 		xfer.tx_buf = addr;
 	else
 		xfer.rx_buf = addr;

-	if (spi_dev == NULL) {
-		dev_err(&spi_dev->dev, "SPI device is uninitialized\n");
-		return -ENODEV;
-	}
-
 	spi_message_init(&msg);
 	spi_message_add_tail(&xfer, &msg);

--
1.7.9.5

