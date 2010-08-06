Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39269 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab0HFGbb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Aug 2010 02:31:31 -0400
Date: Fri, 6 Aug 2010 08:31:00 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] media: ir-keytable: null dereference in debug code
Message-ID: <20100806063059.GN9031@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"ir_dev->props" can be NULL.  We only use raw mode if "ir_dev->props" is
non-NULL and "ir_dev->props->driver_type == RC_DRIVER_IR_RAW".

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/ir-keytable.c b/drivers/media/IR/ir-keytable.c
index 15a0f19..cf97427 100644
--- a/drivers/media/IR/ir-keytable.c
+++ b/drivers/media/IR/ir-keytable.c
@@ -499,7 +499,8 @@ int __ir_input_register(struct input_dev *input_dev,
 
 	IR_dprintk(1, "Registered input device on %s for %s remote%s.\n",
 		   driver_name, rc_tab->name,
-		   ir_dev->props->driver_type == RC_DRIVER_IR_RAW ? " in raw mode" : "");
+		   (ir_dev->props && ir_dev->props->driver_type == RC_DRIVER_IR_RAW) ?
+			" in raw mode" : "");
 
 	return 0;
 
