Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44658 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbeJDUwd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 16:52:33 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: bttv-input: make const array addr_list static
Date: Thu,  4 Oct 2018 14:59:06 +0100
Message-Id: <20181004135906.20320-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The const array addr_list can be made static, saves populating it on
the stack and will make it read-only.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/bt8xx/bttv-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 5cf929370398..d34fbaa027c2 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -370,7 +370,7 @@ static int get_key_pv951(struct IR_i2c *ir, enum rc_proto *protocol,
 /* Instantiate the I2C IR receiver device, if present */
 void init_bttv_i2c_ir(struct bttv *btv)
 {
-	const unsigned short addr_list[] = {
+	static const unsigned short addr_list[] = {
 		0x1a, 0x18, 0x64, 0x30, 0x71,
 		I2C_CLIENT_END
 	};
-- 
2.17.1
