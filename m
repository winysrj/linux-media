Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34251 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbbFFHpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 03:45:10 -0400
Received: by lbcmx3 with SMTP id mx3so57330471lbc.1
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2015 00:45:08 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH 1/2] saa7164: change Si2168 reglen to 0 bit
Date: Sat,  6 Jun 2015 10:44:57 +0300
Message-Id: <1433576698-1780-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i2c_reg_len for Si2168 should be 0 for correct I2C communication.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/saa7164/saa7164-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index 8a6455d..c2b7382 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -621,7 +621,7 @@ struct saa7164_board saa7164_boards[] = {
 			.name		= "SI2168-1",
 			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
 			.i2c_bus_addr	= 0xc8 >> 1,
-			.i2c_reg_len	= REGLEN_8bit,
+			.i2c_reg_len	= REGLEN_0bit,
 		}, {
 			.id		= 0x25,
 			.type		= SAA7164_UNIT_TUNER,
@@ -635,7 +635,7 @@ struct saa7164_board saa7164_boards[] = {
 			.name		= "SI2168-2",
 			.i2c_bus_nr	= SAA7164_I2C_BUS_2,
 			.i2c_bus_addr	= 0xcc >> 1,
-			.i2c_reg_len	= REGLEN_8bit,
+			.i2c_reg_len	= REGLEN_0bit,
 		} },
 	},
 };
-- 
1.9.1

