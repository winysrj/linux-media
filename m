Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45200 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752517AbdLQPk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:40:57 -0500
Received: by mail-wr0-f195.google.com with SMTP id h1so11890557wre.12
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:57 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 3/8] [media] ddbridge: deduplicate calls to dvb_ca_en50221_init()
Date: Sun, 17 Dec 2017 16:40:44 +0100
Message-Id: <20171217154049.1125-4-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

All CI types do dvb_ca_en50221_init() with the same arguments. Move this
call after the switch-case to remove the repetition in every case block.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index a4fd747763a0..8dfbc3bbd86d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -327,8 +327,6 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
 		if (!port->en)
 			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap,
-				    port->en, 0, 1);
 		break;
 
 	case DDB_CI_EXTERNAL_XO2:
@@ -336,15 +334,15 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 		ci_xo2_attach(port);
 		if (!port->en)
 			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
 		break;
 
 	case DDB_CI_INTERNAL:
 		ci_attach(port);
 		if (!port->en)
 			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
 		break;
 	}
+
+	dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
 	return 0;
 }
-- 
2.13.6
