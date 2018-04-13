Return-path: <linux-media-owner@vger.kernel.org>
Received: from 14.mo7.mail-out.ovh.net ([178.33.251.19]:35366 "EHLO
        14.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752015AbeDMQOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Apr 2018 12:14:38 -0400
Received: from player758.ha.ovh.net (unknown [10.109.120.13])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 05437A1A96
        for <linux-media@vger.kernel.org>; Fri, 13 Apr 2018 15:48:41 +0200 (CEST)
From: Andi Shyti <andi@etezian.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: [PATCH v2] media: ir-spi: update Andi's e-mail
Date: Fri, 13 Apr 2018 22:48:29 +0900
Message-Id: <20180413134829.18872-1-andi@etezian.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andi Shyti <andi.shyti@samsung.com>

Because I will be leaving Samsung soon, update my e-mail to the
etezian.org mail.

CC: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Sean Young <sean@mess.org>
Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
Hi Sean,

thanks for the review and sorry for the late reply. Here is the
patch with my mail changed also in the MODULE_AUTHOR macro.

Thanks,
Andi

v1 - v2
changed the mail also in the MODULE_AUTHOR macro

 drivers/media/rc/ir-spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-spi.c b/drivers/media/rc/ir-spi.c
index 7163d5ce2e64..66334e8d63ba 100644
--- a/drivers/media/rc/ir-spi.c
+++ b/drivers/media/rc/ir-spi.c
@@ -2,7 +2,7 @@
 // SPI driven IR LED device driver
 //
 // Copyright (c) 2016 Samsung Electronics Co., Ltd.
-// Copyright (c) Andi Shyti <andi.shyti@samsung.com>
+// Copyright (c) Andi Shyti <andi@etezian.org>
 
 #include <linux/delay.h>
 #include <linux/fs.h>
@@ -173,6 +173,6 @@ static struct spi_driver ir_spi_driver = {
 
 module_spi_driver(ir_spi_driver);
 
-MODULE_AUTHOR("Andi Shyti <andi.shyti@samsung.com>");
+MODULE_AUTHOR("Andi Shyti <andi@etezian.org>");
 MODULE_DESCRIPTION("SPI IR LED");
 MODULE_LICENSE("GPL v2");
-- 
2.17.0
