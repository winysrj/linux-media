Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbC3K7f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 06:59:35 -0400
Date: Mon, 30 Mar 2015 12:59:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?us-ascii?B?PT9VVEYtOD9xP0RhdmlkPTIwSD1DMz1BNHJkZW1hbj89?=
	<david@hardeman.nu>, linux-media@vger.kernel.org
Subject: [PATCH v2 3/6] media/fintek: drop pci_ids dependency
Message-ID: <1427712964-16155-4-git-send-email-mst@redhat.com>
References: <1427712964-16155-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1427712964-16155-1-git-send-email-mst@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver does not use any PCI IDs, don't include
the pci_ids.h header.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/media/rc/fintek-cir.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index b516757..9ca168a 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -33,7 +33,6 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <media/rc-core.h>
-#include <linux/pci_ids.h>
 
 #include "fintek-cir.h"
 
-- 
MST

