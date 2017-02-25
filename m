Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:47627 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdBYMRx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:17:53 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 09/19] [media] serial_ir: iommap is a memory address, not bool
Date: Sat, 25 Feb 2017 11:51:24 +0000
Message-Id: <eaadc6e5e6de627b175a617ad636aed5ea4d386e.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This has been broken for a long time, so presumably it is not used. I
have no hardware to test this on.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=61401

Fixes: 90ab5ee ("module_param: make bool parameters really bool")

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/serial_ir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index 923fb22..7b3a3b5 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -56,7 +56,7 @@ struct serial_ir_hw {
 static int type;
 static int io;
 static int irq;
-static bool iommap;
+static ulong iommap;
 static int ioshift;
 static bool softcarrier = true;
 static bool share_irq;
@@ -836,7 +836,7 @@ module_param(io, int, 0444);
 MODULE_PARM_DESC(io, "I/O address base (0x3f8 or 0x2f8)");
 
 /* some architectures (e.g. intel xscale) have memory mapped registers */
-module_param(iommap, bool, 0444);
+module_param(iommap, ulong, 0444);
 MODULE_PARM_DESC(iommap, "physical base for memory mapped I/O (0 = no memory mapped io)");
 
 /*
-- 
2.9.3
