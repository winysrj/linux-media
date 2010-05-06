Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.115.56]:47395 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751259Ab0EFXlu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 6 May 2010 19:41:50 -0400
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Thu, 6 May 2010 16:41:45 -0700
Date: Thu, 6 May 2010 16:41:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] IR: add header file to fix build
Message-Id: <20100506164144.f2e176c3.rdunlap@xenotime.net>
In-Reply-To: <20100506151502.f97afe54.sfr@canb.auug.org.au>
References: <20100506151502.f97afe54.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error:
drivers/media/IR/rc-map.c:51: error: implicit declaration of function 'msleep'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/media/IR/rc-map.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100506.orig/drivers/media/IR/rc-map.c
+++ linux-next-20100506/drivers/media/IR/rc-map.c
@@ -13,6 +13,7 @@
  */
 
 #include <media/ir-core.h>
+#include <linux/delay.h>
 #include <linux/spinlock.h>
 
 /* Used to handle IR raw handler extensions */
