Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:54797 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0HIR6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 13:58:07 -0400
Date: Mon, 9 Aug 2010 10:56:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] v4l2-ctrls.c: needs to include slab.h
Message-Id: <20100809105635.4208c7ac.randy.dunlap@oracle.com>
In-Reply-To: <20100809132314.789e13f3.sfr@canb.auug.org.au>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

v4l2-ctrls.c needs to include slab.h to prevent build errors:

drivers/media/video/v4l2-ctrls.c:766: error: implicit declaration of function 'kzalloc'
drivers/media/video/v4l2-ctrls.c:786: error: implicit declaration of function 'kfree'
drivers/media/video/v4l2-ctrls.c:1528: error: implicit declaration of function 'kmalloc'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/video/v4l2-ctrls.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100809.orig/drivers/media/video/v4l2-ctrls.c
+++ linux-next-20100809/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
