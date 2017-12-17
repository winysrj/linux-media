Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44629 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdLQPk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:40:56 -0500
Received: by mail-wr0-f195.google.com with SMTP id w95so1032973wrc.11
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:56 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 2/8] [media] ddbridge: fix resources cleanup for CI hardware
Date: Sun, 17 Dec 2017 16:40:43 +0100
Message-Id: <20171217154049.1125-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Do kfree() on port->en->data instead of port->en. port->en only holds a
ptr to a struct dvb_ca_en50221, which is a member either of a memalloc'ed
struct ddb_ci (DuoFlex CI, Octopus CI Duo) or a struct cxd (CXD2099AR
based Single Flex, allocated by the cxd2099 driver). port->en.data
though holds the ptr to the allocated memory, which must rather be
kfree()'d. Change this accordingly.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index eda004398316..a81125d492ff 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1990,7 +1990,7 @@ void ddb_ports_detach(struct ddb *dev)
 				dvb_unregister_device(port->dvb[0].dev);
 			if (port->en) {
 				dvb_ca_en50221_release(port->en);
-				kfree(port->en);
+				kfree(port->en->data);
 				port->en = NULL;
 			}
 			break;
-- 
2.13.6
