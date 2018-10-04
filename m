Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44960 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbeJDVJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 17:09:07 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: cx23885: make const array addr_list static
Date: Thu,  4 Oct 2018 15:15:35 +0100
Message-Id: <20181004141535.20809-1-colin.king@canonical.com>
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
 drivers/media/pci/cx23885/cx23885-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index dd67135d2bb6..d0df3dfff694 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -340,7 +340,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 	/* Instantiate the IR receiver device, if present */
 	if (0 == bus->i2c_rc) {
 		struct i2c_board_info info;
-		const unsigned short addr_list[] = {
+		static const unsigned short addr_list[] = {
 			0x6b, I2C_CLIENT_END
 		};
 
-- 
2.17.1
