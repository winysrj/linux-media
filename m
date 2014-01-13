Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaAMVgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jan 2014 16:36:19 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/7] [media] tea575x: Fix build with ARCH=c6x
Date: Mon, 13 Jan 2014 16:32:38 -0200
Message-Id: <1389637958-3884-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
References: <1389637958-3884-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In file included from /devel/v4l/temp/include/asm-generic/page.h:23:0,
                 from /devel/v4l/temp/arch/c6x/include/asm/page.h:9,
                 from /devel/v4l/temp/include/asm-generic/io.h:14,
                 from arch/c6x/include/generated/asm/io.h:1,
                 from /devel/v4l/temp/drivers/media/radio/tea575x.c:23:
/devel/v4l/temp/arch/c6x/include/asm/setup.h:17:27: error: unknown type name ‘phys_addr_t’
 extern int c6x_add_memory(phys_addr_t start, unsigned long size);

It seems that, on such arch, the includes from asm/ should be
after the ones from linux/.

The proper fix would be to patch the arch files, but, as
this fix is trivial, apply it. Also, we generally put the
asm includes after the linux ones, anyway.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/radio/tea575x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index cef06981b7c9..7c14060a40b8 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -20,12 +20,12 @@
  *
  */
 
-#include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <asm/io.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
-- 
1.8.3.1

