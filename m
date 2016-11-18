Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:42910 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753736AbcKRXVZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:25 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 34/35] media: ti-vpe: csc: Add debug support for multi-instance
Date: Fri, 18 Nov 2016 17:20:44 -0600
Message-ID: <20161118232045.24665-35-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there might be more then one instance it is better to
show the base address when dumping registers to help
with debugging.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
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

