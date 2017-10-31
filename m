Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40786 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932272AbdJaKTo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 06:19:44 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] pt3: remove redundant assignment to mask
Date: Tue, 31 Oct 2017 10:19:42 +0000
Message-Id: <20171031101942.19923-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable mask is being set to 0x80 and then set to this value again
in the following for-loop. Remove the extraneous first setting of mask.
Cleans up clang warning:

drivers/media/pci/pt3/pt3_i2c.c:88:2: warning: Value stored to 'mask'
is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/pt3/pt3_i2c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/pci/pt3/pt3_i2c.c b/drivers/media/pci/pt3/pt3_i2c.c
index ec6a8a2e4744..b66138c7b364 100644
--- a/drivers/media/pci/pt3/pt3_i2c.c
+++ b/drivers/media/pci/pt3/pt3_i2c.c
@@ -85,7 +85,6 @@ static void put_byte_write(struct pt3_i2cbuf *cbuf, u8 val)
 {
 	u8 mask;
 
-	mask = 0x80;
 	for (mask = 0x80; mask > 0; mask >>= 1)
 		cmdbuf_add(cbuf, (val & mask) ? I_DATA_H_NOP : I_DATA_L_NOP);
 	cmdbuf_add(cbuf, I_DATA_H_ACK0);
-- 
2.14.1
