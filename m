Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38715 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755857AbdKBRRD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 13:17:03 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] cx88: make const arrays default_addr_list and pvr2000_addr_list static
Date: Thu,  2 Nov 2017 17:16:59 +0000
Message-Id: <20171102171659.13315-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Don't populate arrays default_addr_list and pvr2000_addr_list on the
stack but instead make them static. Makes the object code smaller by
over 340 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  12520	   2800	     64	  15384	   3c18	drivers/media/pci/cx88/cx88-input.o

After:
   text	   data	    bss	    dec	    hex	filename
  12142	   2832	     64	  15038	   3abe	drivers/media/pci/cx88/cx88-input.o

(gcc version 7.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/pci/cx88/cx88-input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index e02449bf2041..4e9953e61a12 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -593,11 +593,11 @@ static int get_key_pvr2000(struct IR_i2c *ir, enum rc_proto *protocol,
 void cx88_i2c_init_ir(struct cx88_core *core)
 {
 	struct i2c_board_info info;
-	const unsigned short default_addr_list[] = {
+	static const unsigned short default_addr_list[] = {
 		0x18, 0x6b, 0x71,
 		I2C_CLIENT_END
 	};
-	const unsigned short pvr2000_addr_list[] = {
+	static const unsigned short pvr2000_addr_list[] = {
 		0x18, 0x1a,
 		I2C_CLIENT_END
 	};
-- 
2.14.1
