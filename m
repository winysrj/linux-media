Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36169 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbdHLL4k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Aug 2017 07:56:40 -0400
Received: by mail-wm0-f68.google.com with SMTP id d40so9166132wma.3
        for <linux-media@vger.kernel.org>; Sat, 12 Aug 2017 04:56:40 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH v4 06/11] [media] ddbridge: fix possible buffer overflow in ddb_ports_init()
Date: Sat, 12 Aug 2017 13:55:57 +0200
Message-Id: <20170812115602.18124-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170812115602.18124-1-d.scheller.oss@gmail.com>
References: <20170812115602.18124-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Report from smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:2659 ddb_ports_init() error: buffer overflow 'dev->port' 32 <= u32max

Fix by making sure "p" is greater than zero before checking for
"dev->port[].type == DDB_CI_EXTERNAL_XO2".

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 759a53e82252..5df942f4e388 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2551,7 +2551,7 @@ void ddb_ports_init(struct ddb *dev)
 			port->dvb[0].adap = &dev->adap[2 * p];
 			port->dvb[1].adap = &dev->adap[2 * p + 1];
 
-			if ((port->class == DDB_PORT_NONE) && i &&
+			if ((port->class == DDB_PORT_NONE) && i && p &&
 			    dev->port[p - 1].type == DDB_CI_EXTERNAL_XO2) {
 				port->class = DDB_PORT_CI;
 				port->type = DDB_CI_EXTERNAL_XO2_B;
-- 
2.13.0
