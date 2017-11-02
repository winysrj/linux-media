Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38852 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755031AbdKBR0u (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 13:26:50 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] au0828: make const array addr_list static
Date: Thu,  2 Nov 2017 17:26:48 +0000
Message-Id: <20171102172648.13780-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate array addr_list on the stack but instead make it
static. Makes the object code smaller by over 360 bytes:

Before:
   text    data     bss     dec     hex filename
   8036    1488     192    9716    25f4 au0828-input.o

After:
   text    data     bss     dec     hex filename
   7696    1488     192    9376    24a0 au0828-input.o

(gcc version 7.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/usb/au0828/au0828-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/au0828/au0828-input.c b/drivers/media/usb/au0828/au0828-input.c
index 7996eb83a54e..af68afe085b5 100644
--- a/drivers/media/usb/au0828/au0828-input.c
+++ b/drivers/media/usb/au0828/au0828-input.c
@@ -269,7 +269,7 @@ static void au0828_rc_stop(struct rc_dev *rc)
 static int au0828_probe_i2c_ir(struct au0828_dev *dev)
 {
 	int i = 0;
-	const unsigned short addr_list[] = {
+	static const unsigned short addr_list[] = {
 		 0x47, I2C_CLIENT_END
 	};
 
-- 
2.14.1
