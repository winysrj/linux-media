Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:39778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab2GBB6A (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jul 2012 21:58:00 -0400
Date: Mon, 2 Jul 2012 11:58:00 +1000
From: Anton Blanchard <anton@samba.org>
To: mchehab@infradead.org, david@hardeman.nu
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] winbond-cir: Fix txandrx module info
Message-ID: <20120702115800.1275f944@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


We aren't getting any module info for the txandx option because
of a typo:

parm:           txandrx:bool

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/drivers/media/rc/winbond-cir.c
===================================================================
--- linux-2.6.orig/drivers/media/rc/winbond-cir.c	2011-11-20 20:30:57.831906589 +1100
+++ linux-2.6/drivers/media/rc/winbond-cir.c	2011-11-20 20:32:13.472362123 +1100
@@ -232,7 +232,7 @@ MODULE_PARM_DESC(invert, "Invert the sig
 
 static int txandrx; /* default = 0 */
 module_param(txandrx, bool, 0444);
-MODULE_PARM_DESC(invert, "Allow simultaneous TX and RX");
+MODULE_PARM_DESC(txandrx, "Allow simultaneous TX and RX");
 
 static unsigned int wake_sc = 0x800F040C;
 module_param(wake_sc, uint, 0644);
