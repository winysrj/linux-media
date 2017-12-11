Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41273 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbdLKRUL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 12:20:11 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>
Subject: [PATCH] media: ddbridge: shut up a new warning
Date: Mon, 11 Dec 2017 12:20:06 -0500
Message-Id: <afb9a9b43e0a1f45ec9fa1dd76d2f7a7ae7c8f89.1513012803.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/ddbridge/ddbridge-ci.c:321:5: warning: no previous prototype for 'ddb_ci_attach' [-Wmissing-prototypes]
 int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
     ^~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index 457c711aaced..a4fd747763a0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -20,6 +20,7 @@
 
 #include "ddbridge.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-ci.h"
 #include "ddbridge-io.h"
 #include "ddbridge-i2c.h"
 
-- 
2.14.3
