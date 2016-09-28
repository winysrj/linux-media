Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50207 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754411AbcI1VX4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:56 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 34/35] media: ti-vpe: csc: Add debug support for multi-instance
Date: Wed, 28 Sep 2016 16:23:53 -0500
Message-ID: <20160928212353.27850-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there might be more then one instance it is better to
show the base address when dumping registers to help
with debugging.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/csc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index 9fc6f70adeeb..44b8465cf101 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -97,6 +97,8 @@ void csc_dump_regs(struct csc_data *csc)
 #define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
 	ioread32(csc->base + CSC_##r))
 
+	dev_dbg(dev, "CSC Registers @ %pa:\n", &csc->res->start);
+
 	DUMPREG(CSC00);
 	DUMPREG(CSC01);
 	DUMPREG(CSC02);
-- 
2.9.0

