Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34330 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbdGITmf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:35 -0400
Received: by mail-wr0-f195.google.com with SMTP id k67so20345343wrc.1
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:34 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 09/14] [media] ddbridge: fix possible buffer overflow in ddb_ports_init()
Date: Sun,  9 Jul 2017 21:42:16 +0200
Message-Id: <20170709194221.10255-10-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194221.10255-1-d.scheller.oss@gmail.com>
References: <20170709194221.10255-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Report from smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:2659 ddb_ports_init() error: buffer overflow 'dev->port' 32 <= u32max

Fix by making sure "p" is greater than zero before checking for
"dev->port[].type == DDB_CI_EXTERNAL_XO2".

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index aba53fd27f3e..8981795b0819 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2551,7 +2551,7 @@ void ddb_ports_init(struct ddb *dev)
 			port->dvb[0].adap = &dev->adap[2 * p];
 			port->dvb[1].adap = &dev->adap[2 * p + 1];
 
-			if ((port->class == DDB_PORT_NONE) && i &&
+			if ((port->class == DDB_PORT_NONE) && i && p > 0 &&
 			    dev->port[p - 1].type == DDB_CI_EXTERNAL_XO2) {
 				port->class = DDB_PORT_CI;
 				port->type = DDB_CI_EXTERNAL_XO2_B;
-- 
2.13.0
