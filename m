Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37111 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbbFWOxo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 10:53:44 -0400
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org
Cc: Antonio Borneo <borneo.antonio@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] [media] s5c73m3: Remove redundant spi driver bus initialization
Date: Tue, 23 Jun 2015 22:53:19 +0800
Message-Id: <1435071199-24630-1-git-send-email-borneo.antonio@gmail.com>
In-Reply-To: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
References: <1435070714-24174-1-git-send-email-borneo.antonio@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In ancient times it was necessary to manually initialize the bus
field of an spi_driver to spi_bus_type. These days this is done in
spi_register_driver(), so we can drop the manual assignment.

Signed-off-by: Antonio Borneo <borneo.antonio@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/media/i2c/s5c73m3/s5c73m3-spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 63eb190..fa4a5eb 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -149,7 +149,6 @@ int s5c73m3_register_spi_driver(struct s5c73m3 *state)
 	spidrv->remove = s5c73m3_spi_remove;
 	spidrv->probe = s5c73m3_spi_probe;
 	spidrv->driver.name = S5C73M3_SPI_DRV_NAME;
-	spidrv->driver.bus = &spi_bus_type;
 	spidrv->driver.owner = THIS_MODULE;
 	spidrv->driver.of_match_table = s5c73m3_spi_ids;
 
-- 
2.4.4

