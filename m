Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443AbbC2NlI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 09:41:08 -0400
Date: Sun, 29 Mar 2015 15:41:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?us-ascii?B?PT9VVEYtOD9xP0RhdmlkPTIwSD1DMz1BNHJkZW1hbj89?=
	<david@hardeman.nu>, linux-media@vger.kernel.org
Subject: [PATCH 46/86] media/fintek: use uapi/linux/pci_ids.h directly
Message-ID: <1427635734-24786-47-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
use the new header directly so we can drop
the wrapper in include/linux/pci_ids.h.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/media/rc/fintek-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index b516757..4ef500f 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -33,7 +33,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <media/rc-core.h>
-#include <linux/pci_ids.h>
+#include <uapi/linux/pci_ids.h>
 
 #include "fintek-cir.h"
 
-- 
MST

