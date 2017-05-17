Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53743 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752823AbdEQRc5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 13:32:57 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] sir_ir: attempt to free already free_irq
Date: Wed, 17 May 2017 18:32:50 +0100
Message-Id: <ba2f084497d416f97bc1963366cd05a365fc32df.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
In-Reply-To: <cover.1495035457.git.sean@mess.org>
References: <cover.1495035457.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the probe fails (e.g. port already in use), rmmod causes null deref.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 90a5f8f..c27d6b4 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -381,6 +381,8 @@ static int sir_ir_probe(struct platform_device *dev)
 
 static int sir_ir_remove(struct platform_device *dev)
 {
+	drop_hardware();
+	drop_port();
 	return 0;
 }
 
@@ -421,8 +423,6 @@ static int __init sir_ir_init(void)
 
 static void __exit sir_ir_exit(void)
 {
-	drop_hardware();
-	drop_port();
 	platform_device_unregister(sir_ir_dev);
 	platform_driver_unregister(&sir_ir_driver);
 }
-- 
2.9.4
