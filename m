Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbbC2Nn3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2015 09:43:29 -0400
Date: Sun, 29 Mar 2015 15:43:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?us-ascii?B?PT9VVEYtOD9xP0RhdmlkPTIwSD1DMz1BNHJkZW1hbj89?=
	<david@hardeman.nu>, linux-media@vger.kernel.org
Subject: [PATCH 82/86] media/fintek: drop pci_ids dependency
Message-ID: <1427635734-24786-83-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use any PCI IDs, don't include
the pci_ids.h header.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/media/rc/fintek-cir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 4ef500f..9ca168a 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -33,7 +33,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <media/rc-core.h>
-#include <uapi/linux/pci_ids.h>
 
 #include "fintek-cir.h"
 
-- 
MST

