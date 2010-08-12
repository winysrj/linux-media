Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50267 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0HLHrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 03:47:47 -0400
Date: Thu, 12 Aug 2010 09:47:07 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] IR: ir-raw-event: null pointer dereference
Message-ID: <20100812074707.GJ645@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The original code dereferenced ir->raw after freeing it and setting it
to NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index 43094e7..8e0e1b1 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -279,9 +279,11 @@ int ir_raw_event_register(struct input_dev *input_dev)
 			"rc%u",  (unsigned int)ir->devno);
 
 	if (IS_ERR(ir->raw->thread)) {
+		int ret = PTR_ERR(ir->raw->thread);
+
 		kfree(ir->raw);
 		ir->raw = NULL;
-		return PTR_ERR(ir->raw->thread);
+		return ret;
 	}
 
 	mutex_lock(&ir_raw_handler_lock);
