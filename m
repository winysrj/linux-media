Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34574 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753348AbdHUNdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Aug 2017 09:33:41 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] bt8xx: Make i2c_algo_bit_data const
Date: Mon, 21 Aug 2017 19:03:32 +0530
Message-Id: <1503322412-25960-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make this const as it is only used in a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/pci/bt8xx/bttv-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index 274fd03..eccd1e3 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -97,7 +97,7 @@ static int bttv_bit_getsda(void *data)
 	return state;
 }
 
-static struct i2c_algo_bit_data bttv_i2c_algo_bit_template = {
+static const struct i2c_algo_bit_data bttv_i2c_algo_bit_template = {
 	.setsda  = bttv_bit_setsda,
 	.setscl  = bttv_bit_setscl,
 	.getsda  = bttv_bit_getsda,
-- 
1.9.1
