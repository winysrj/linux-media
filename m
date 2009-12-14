Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:59699 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbZLNRJC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 12:09:02 -0500
Date: Mon, 14 Dec 2009 09:08:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] radio/si470x: #include <sched.h>
Message-Id: <20091214090813.a9e3d77f.randy.dunlap@oracle.com>
In-Reply-To: <20091214165927.c08c4784.sfr@canb.auug.org.au>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Driver needs to #include <sched.h>:

drivers/media/radio/si470x/radio-si470x-common.c:452: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
drivers/media/radio/si470x/radio-si470x-common.c:452: error: implicit declaration of function 'signal_pending'
drivers/media/radio/si470x/radio-si470x-common.c:452: error: implicit declaration of function 'schedule'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/radio/si470x/radio-si470x.h |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20091214.orig/drivers/media/radio/si470x/radio-si470x.h
+++ linux-next-20091214/drivers/media/radio/si470x/radio-si470x.h
@@ -29,6 +29,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/input.h>
