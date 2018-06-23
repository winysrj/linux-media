Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38001 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751471AbeFWPgX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:23 -0400
Received: by mail-wr0-f193.google.com with SMTP id e18-v6so9427741wrs.5
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:23 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 04/19] [media] ddbridge: evaluate the actual link when setting up the dummy tuner
Date: Sat, 23 Jun 2018 17:36:00 +0200
Message-Id: <20180623153615.27630-5-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Devices supporting dummy tuner operation can exist on any link, not only
on link 0, so fix this accordingly.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 3f83415b06c7..55eb151f329e 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1859,7 +1859,7 @@ static void ddb_port_probe(struct ddb_port *port)
 	/* Handle missing ports and ports without I2C */
 
 	if (dummy_tuner && !port->nr &&
-	    dev->link[0].ids.device == 0x0005) {
+	    dev->link[l].ids.device == 0x0005) {
 		port->name = "DUMMY";
 		port->class = DDB_PORT_TUNER;
 		port->type = DDB_TUNER_DUMMY;
-- 
2.16.4
