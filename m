Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:34821 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751589AbdHGUVE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 16:21:04 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 6/6] [media] rc: saa7134: raw decoder can support any protocol
Date: Mon,  7 Aug 2017 21:20:59 +0100
Message-Id: <3dcc7f69b6d55dc6cbe68be9b60789ad8913fe4b.1502137029.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
In-Reply-To: <cover.1502137028.git.sean@mess.org>
References: <cover.1502137028.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Any protocol for which we have a software decoder, can be enabled. Without
this only the protocol of the default keymap can be used (rc-5).

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/pci/saa7134/saa7134-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index b1f3769eac45..9337e4615519 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -860,8 +860,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	rc->priv = dev;
 	rc->open = saa7134_ir_open;
 	rc->close = saa7134_ir_close;
-	if (raw_decode)
+	if (raw_decode) {
 		rc->driver_type = RC_DRIVER_IR_RAW;
+		rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
+	}
 
 	rc->device_name = ir->name;
 	rc->input_phys = ir->phys;
-- 
2.13.4
