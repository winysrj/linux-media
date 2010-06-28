Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:51972 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0F1P7v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 11:59:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by poutre.nerim.net (Postfix) with ESMTP id 5C6A539DE95
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 17:59:48 +0200 (CEST)
Received: from poutre.nerim.net ([127.0.0.1])
	by localhost (poutre.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9SXauv9YMewc for <linux-media@vger.kernel.org>;
	Mon, 28 Jun 2010 17:59:47 +0200 (CEST)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by poutre.nerim.net (Postfix) with ESMTP id 5A5F439DEBF
	for <linux-media@vger.kernel.org>; Mon, 28 Jun 2010 17:59:47 +0200 (CEST)
Date: Mon, 28 Jun 2010 17:59:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] V4L/DVB: cx88: Let the user disable IR support
Message-ID: <20100628175949.293d1673@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It might be useful to be able to disable the IR support, either for
debugging purposes, or just for users who know they won't use the IR
remote control anyway. On many cards, IR support requires expensive
polling/sampling which is better avoided if never needed.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/media/video/cx88/cx88-cards.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.34-rc3.orig/drivers/media/video/cx88/cx88-cards.c	2010-04-09 17:53:58.000000000 +0200
+++ linux-2.6.34-rc3/drivers/media/video/cx88/cx88-cards.c	2010-04-09 17:54:14.000000000 +0200
@@ -45,6 +45,10 @@ static unsigned int latency = UNSET;
 module_param(latency,int,0444);
 MODULE_PARM_DESC(latency,"pci latency timer");
 
+static int disable_ir;
+module_param(disable_ir, int, 0444);
+MODULE_PARM_DESC(latency, "Disable IR support");
+
 #define info_printk(core, fmt, arg...) \
 	printk(KERN_INFO "%s: " fmt, core->name , ## arg)
 
@@ -3498,8 +3502,10 @@ struct cx88_core *cx88_core_create(struc
 	}
 
 	cx88_card_setup(core);
-	cx88_i2c_init_ir(core);
-	cx88_ir_init(core, pci);
+	if (!disable_ir) {
+		cx88_i2c_init_ir(core);
+		cx88_ir_init(core, pci);
+	}
 
 	return core;
 }


-- 
Jean Delvare
