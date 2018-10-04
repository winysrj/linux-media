Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:44722 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbeJDUzo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 16:55:44 -0400
From: Colin King <colin.king@canonical.com>
To: Andy Walls <awalls@md.metrocast.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] media: ivtv: make const array addr_list static
Date: Thu,  4 Oct 2018 15:02:14 +0100
Message-Id: <20181004140214.20512-1-colin.king@canonical.com>
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
 drivers/media/pci/ivtv/ivtv-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index 5e4e52147fb7..55ef1385519e 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -239,7 +239,7 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
 	 * allocations, so this function must be called after all other i2c
 	 * devices we care about are registered.
 	 */
-	const unsigned short addr_list[] = {
+	static const unsigned short addr_list[] = {
 		0x1a,	/* Hauppauge IR external - collides with WM8739 */
 		0x18,	/* Hauppauge IR internal */
 		I2C_CLIENT_END
-- 
2.17.1
