Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:55616 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0BPRWj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 12:22:39 -0500
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id EF24039DF9D
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:22:35 +0100 (CET)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id STivizupJQPH for <linux-media@vger.kernel.org>;
	Tue, 16 Feb 2010 18:22:35 +0100 (CET)
Received: from hyperion.delvare (jdelvare.pck.nerim.net [62.212.121.182])
	by bamako.nerim.net (Postfix) with ESMTP id E783339DF99
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2010 18:22:34 +0100 (CET)
Date: Tue, 16 Feb 2010 18:22:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] bttv: Let the user disable IR support
Message-ID: <20100216182237.1a06719e@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new module parameter "disable_ir" to disable IR support. Several
other drivers do that already, and this can be very handy for
debugging purposes.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 linux/drivers/media/video/bt8xx/bttv-driver.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/bt8xx/bttv-driver.c	2010-02-16 18:13:31.000000000 +0100
+++ v4l-dvb/linux/drivers/media/video/bt8xx/bttv-driver.c	2010-02-16 18:16:47.000000000 +0100
@@ -81,6 +81,7 @@ static int video_nr[BTTV_MAX] = { [0 ...
 static int radio_nr[BTTV_MAX] = { [0 ... (BTTV_MAX-1)] = -1 };
 static int vbi_nr[BTTV_MAX] = { [0 ... (BTTV_MAX-1)] = -1 };
 static int debug_latency;
+static int disable_ir;
 
 static unsigned int fdsr;
 
@@ -107,6 +108,7 @@ module_param(bttv_gpio,         int, 064
 module_param(bttv_debug,        int, 0644);
 module_param(irq_debug,         int, 0644);
 module_param(debug_latency,     int, 0644);
+module_param(disable_ir,        int, 0444);
 
 module_param(fdsr,              int, 0444);
 module_param(gbuffers,          int, 0444);
@@ -139,6 +141,7 @@ MODULE_PARM_DESC(bttv_verbose,"verbose s
 MODULE_PARM_DESC(bttv_gpio,"log gpio changes, default is 0 (no)");
 MODULE_PARM_DESC(bttv_debug,"debug messages, default is 0 (no)");
 MODULE_PARM_DESC(irq_debug,"irq handler debug messages, default is 0 (no)");
+MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
 MODULE_PARM_DESC(gbuffers,"number of capture buffers. range 2-32, default 8");
 MODULE_PARM_DESC(gbufsize,"size of the capture buffers, default is 0x208000");
 MODULE_PARM_DESC(reset_crop,"reset cropping parameters at open(), default "
@@ -4498,8 +4501,10 @@ static int __devinit bttv_probe(struct p
 		request_modules(btv);
 	}
 
-	init_bttv_i2c_ir(btv);
-	bttv_input_init(btv);
+	if (!disable_ir) {
+		init_bttv_i2c_ir(btv);
+		bttv_input_init(btv);
+	}
 
 	/* everything is fine */
 	bttv_num++;


-- 
Jean Delvare
