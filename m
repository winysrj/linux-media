Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45843 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754920AbeDKU1a (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 16:27:30 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] media: cx88: enable IR transmitter on HVR-1300
Date: Wed, 11 Apr 2018 21:27:28 +0100
Message-Id: <20180411202728.6916-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The HVR 1300 has a Z8F0811 IR device, which can do both IR transmit
and receive. The transmit part was not probed.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/cx88/cx88-input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 6f4e6923a91a..16233e837fcc 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -632,8 +632,9 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 		memset(&core->init_data, 0, sizeof(core->init_data));
 
 		if (*addrp == 0x71) {
-			/* Hauppauge XVR */
-			core->init_data.name = "cx88 Hauppauge XVR remote";
+			/* Hauppauge Z8F0811 */
+			strlcpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
+			core->init_data.name = core->board.name;
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 			core->init_data.type = RC_PROTO_BIT_RC5 |
 				RC_PROTO_BIT_RC6_MCE | RC_PROTO_BIT_RC6_6A_32;
-- 
2.14.3
