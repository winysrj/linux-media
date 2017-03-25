Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:51471 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdCYMC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 1/8] [media] staging: sir: fill in missing fields and fix probe
Date: Sat, 25 Mar 2017 12:02:19 +0000
Message-Id: <d9be670943f4f9f54d8aac84f9db07853ba1666f.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
In-Reply-To: <cover.1490443026.git.sean@mess.org>
References: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some fields are left blank.

Cc: stable@vger.kernel.org # v4.11
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/staging/media/lirc/lirc_sir.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index e498ae8..9905990 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -227,6 +227,7 @@ static int init_chrdev(void)
 	if (!rcdev)
 		return -ENOMEM;
 
+	rcdev->input_name = "SIR IrDA port";
 	rcdev->input_phys = KBUILD_MODNAME "/input0";
 	rcdev->input_id.bustype = BUS_HOST;
 	rcdev->input_id.vendor = 0x0001;
@@ -234,6 +235,7 @@ static int init_chrdev(void)
 	rcdev->input_id.version = 0x0100;
 	rcdev->tx_ir = sir_tx_ir;
 	rcdev->allowed_protocols = RC_BIT_ALL_IR_DECODER;
+	rcdev->driver_name = KBUILD_MODNAME;
 	rcdev->map_name = RC_MAP_RC6_MCE;
 	rcdev->timeout = IR_DEFAULT_TIMEOUT;
 	rcdev->dev.parent = &sir_ir_dev->dev;
@@ -740,7 +742,13 @@ static int init_sir_ir(void)
 
 static int sir_ir_probe(struct platform_device *dev)
 {
-	return 0;
+	int retval;
+
+	retval = init_chrdev();
+	if (retval < 0)
+		return retval;
+
+	return init_sir_ir();
 }
 
 static int sir_ir_remove(struct platform_device *dev)
@@ -780,18 +788,8 @@ static int __init sir_ir_init(void)
 		goto pdev_add_fail;
 	}
 
-	retval = init_chrdev();
-	if (retval < 0)
-		goto fail;
-
-	retval = init_sir_ir();
-	if (retval)
-		goto fail;
-
 	return 0;
 
-fail:
-	platform_device_del(sir_ir_dev);
 pdev_add_fail:
 	platform_device_put(sir_ir_dev);
 pdev_alloc_fail:
-- 
2.9.3
