Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:55187 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab1AIEBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 23:01:19 -0500
Date: Sat, 8 Jan 2011 19:53:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] ir-raw: fix sparse non-ANSI function warning
Message-Id: <20110108195353.3925990e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse warning for non-ANSI function declaration:

drivers/media/rc/ir-raw.c:247:30: warning: non-ANSI function declaration of function 'ir_raw_get_allowed_protocols'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/rc/ir-raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx0107.orig/drivers/media/rc/ir-raw.c
+++ lnx0107/drivers/media/rc/ir-raw.c
@@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(ir_raw_event_handle);
 
 /* used internally by the sysfs interface */
 u64
-ir_raw_get_allowed_protocols()
+ir_raw_get_allowed_protocols(void)
 {
 	u64 protocols;
 	mutex_lock(&ir_raw_handler_lock);
