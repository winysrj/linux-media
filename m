Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45505 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752949AbdC0Net (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 09:34:49 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi.shyti@samsung.com>,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH] [media] rc: ir-spi: remove unnecessary initialization
Date: Mon, 27 Mar 2017 22:34:35 +0900
Message-id: <20170327133435.23492-1-andi.shyti@samsung.com>
References: <CGME20170327133445epcas5p4eef3b88af9e952fb8d0ab00eb4dafbd5@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/ir-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index c8863f36686a..4ca43383a8e8 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -58,7 +58,7 @@ static int ir_spi_tx(struct rc_dev *dev,
 	/* convert the pulse/space signal to raw binary signal */
 	for (i = 0; i < count; i++) {
 		int j;
-		u16 val = ((i + 1) % 2) ? idata->pulse : idata->space;
+		u16 val;
 
 		if (len + buffer[i] >= IR_SPI_MAX_BUFSIZE)
 			return -EINVAL;
-- 
2.11.0
