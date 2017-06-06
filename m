Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:45043 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdFFPSV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 11:18:21 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] sir_ir: annotate hardware config module parameters
Date: Tue,  6 Jun 2017 16:18:19 +0100
Message-Id: <1496762299-29650-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This module was merged after commit 5a8fc6a3cebb ("Annotate hardware
config module parameters in drivers/media/"), so add add the missing
hardware annotations.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/sir_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/sir_ir.c b/drivers/media/rc/sir_ir.c
index 5ee3a23..f8738e5 100644
--- a/drivers/media/rc/sir_ir.c
+++ b/drivers/media/rc/sir_ir.c
@@ -400,10 +400,10 @@ MODULE_DESCRIPTION("Infrared receiver driver for SIR type serial ports");
 MODULE_AUTHOR("Milan Pikula");
 MODULE_LICENSE("GPL");
 
-module_param(io, int, 0444);
+module_param_hw(io, int, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
-module_param(irq, int, 0444);
+module_param_hw(irq, int, 0444);
 MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 
 module_param(threshold, int, 0444);
-- 
2.9.4
