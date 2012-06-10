Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2FJAAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jun 2012 20:00:22 -0400
Date: Sun, 10 Jun 2012 08:00:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: [PATCH] pms: fix build error in pms_probe()
Message-ID: <20120610000019.GA7801@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

If possible, I'd prefer folding this patch into commit 8173090acb33
("v4l: fix compiler warnings"), which introduced the build error.
Thank you!

drivers/media/video/pms.c: In function ‘pms_probe’:
drivers/media/video/pms.c:1047:2: error: implicit declaration of function ‘kzalloc’ [-Werror=implicit-function-declaration]
drivers/media/video/pms.c:1116:2: error: implicit declaration of function ‘kfree’ [-Werror=implicit-function-declaration]

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/media/video/pms.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index af2d908..77f9c92 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -26,6 +26,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
-- 
1.7.10

