Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37441 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753764AbdHUNgC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 09:36:02 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, awalls@md.metrocast.net, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] cx18: Make i2c_algo_bit_data const
Date: Mon, 21 Aug 2017 19:05:50 +0530
Message-Id: <1503322550-26023-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/cx18/cx18-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index eabdd4c..d94ba24 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -216,7 +216,7 @@ static int cx18_getsda(void *data)
 #define CX18_SCL_PERIOD (10) /* usecs. 10 usec is period for a 100 KHz clock */
 #define CX18_ALGO_BIT_TIMEOUT (2) /* seconds */
 
-static struct i2c_algo_bit_data cx18_i2c_algo_template = {
+static const struct i2c_algo_bit_data cx18_i2c_algo_template = {
 	.setsda		= cx18_setsda,
 	.setscl		= cx18_setscl,
 	.getsda		= cx18_getsda,
-- 
1.9.1
