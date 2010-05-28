Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756802Ab0E1T7q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 15:59:46 -0400
Received: from int-mx05.intmail.prod.int.phx2.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.18])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4SJxkae028656
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 15:59:46 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx05.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o4SJxjrH027473
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 15:59:46 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o4SJxjDY007310
	for <linux-media@vger.kernel.org>; Fri, 28 May 2010 15:59:45 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o4SJxjgb007308
	for linux-media@vger.kernel.org; Fri, 28 May 2010 15:59:45 -0400
Date: Fri, 28 May 2010 15:59:45 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] IR: let all protocol decoders have a go at raw data
Message-ID: <20100528195945.GA7305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mceusb driver I'm about to submit handles just about any raw IR you
can throw at it. The ir-core loads up all protocol decoders, starting
with NEC, then RC5, then RC6. RUN_DECODER() was trying them in the same
order, and exiting if any of the decoders didn't like the data. The
default mceusb remote talks RC6(6A). Well, the RC6 decoder never gets a
chance to run unless you move the RC6 decoder to the front of the list.

What I believe to be correct is to have RUN_DECODER keep trying all of
the decoders, even when one triggers an error. I don't think the errors
matter so much as it matters that at least one was successful -- i.e.,
that _sumrc is > 0. The following works for me w/my mceusb driver and
the default decoder ordering -- NEC and RC5 still fail, but RC6 still
gets a crack at it, and successfully does its job.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/media/IR/ir-raw-event.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/IR/ir-raw-event.c b/drivers/media/IR/ir-raw-event.c
index ea68a3f..44162db 100644
--- a/drivers/media/IR/ir-raw-event.c
+++ b/drivers/media/IR/ir-raw-event.c
@@ -36,14 +36,15 @@ static DEFINE_SPINLOCK(ir_raw_handler_lock);
  */
 #define RUN_DECODER(ops, ...) ({					    \
 	struct ir_raw_handler		*_ir_raw_handler;		    \
-	int _sumrc = 0, _rc;						    \
+	int _sumrc = 0, _rc, _fail;					    \
 	spin_lock(&ir_raw_handler_lock);				    \
 	list_for_each_entry(_ir_raw_handler, &ir_raw_handler_list, list) {  \
 		if (_ir_raw_handler->ops) {				    \
 			_rc = _ir_raw_handler->ops(__VA_ARGS__);	    \
 			if (_rc < 0)					    \
-				break;					    \
-			_sumrc += _rc;					    \
+				_fail++;				    \
+			else						    \
+				_sumrc += _rc;				    \
 		}							    \
 	}								    \
 	spin_unlock(&ir_raw_handler_lock);				    \

-- 
Jarod Wilson
jarod@redhat.com

