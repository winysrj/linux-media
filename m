Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:58242 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934040AbcI1VX1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:23:27 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 30/35] media: ti-vpe: scaler: Add debug support for multi-instance
Date: Wed, 28 Sep 2016 16:23:24 -0500
Message-ID: <20160928212324.27670-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since there might be more then one instance it is better to
show the base address when dumping registers to help
with debugging.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/sc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
index 52ce1450362f..e9273b713782 100644
--- a/drivers/media/platform/ti-vpe/sc.c
+++ b/drivers/media/platform/ti-vpe/sc.c
@@ -28,6 +28,8 @@ void sc_dump_regs(struct sc_data *sc)
 #define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
 	ioread32(sc->base + CFG_##r))
 
+	dev_dbg(dev, "SC Registers @ %pa:\n", &sc->res->start);
+
 	DUMPREG(SC0);
 	DUMPREG(SC1);
 	DUMPREG(SC2);
-- 
2.9.0

