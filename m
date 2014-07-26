Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaGZCZs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 22:25:48 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] rc-core: don't use dynamic_pr_debug for IR_dprintk()
Date: Fri, 25 Jul 2014 23:25:36 -0300
Message-Id: <1406341536-14418-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The hole point of IR_dprintk() is that, once a level is
given at debug parameter, all enabled IR parsers will show their
debug messages.

While converting it to dynamic_printk might be a good idea,
right now it just makes very hard to debug the drivers, as
one needs to both pass debug=1 or debug=2 to rc-core and
to use the dynamic printk to enable all the desired lines.

That doesn't make sense!

So, revert to the old way, as a single line is changed,
and the debug parameter will now work as expected.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 include/media/rc-core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 3047837db1cc..2c7fbca40b69 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -26,7 +26,7 @@ extern int rc_core_debug;
 #define IR_dprintk(level, fmt, ...)				\
 do {								\
 	if (rc_core_debug >= level)				\
-		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
+		printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);	\
 } while (0)
 
 enum rc_driver_type {
-- 
1.9.3

