Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32840 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751469AbdGWSQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Jul 2017 14:16:44 -0400
Received: by mail-wm0-f66.google.com with SMTP id 201so289670wmp.0
        for <linux-media@vger.kernel.org>; Sun, 23 Jul 2017 11:16:43 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: r.scobie@clear.net.nz, jasmin@anw.at, d_spingler@freenet.de,
        Manfred.Knick@t-online.de, rjkm@metzlerbros.de
Subject: [PATCH RESEND 08/14] [media] ddbridge: only register frontends in fe2 if fe is not NULL
Date: Sun, 23 Jul 2017 20:16:24 +0200
Message-Id: <20170723181630.19526-9-d.scheller.oss@gmail.com>
In-Reply-To: <20170723181630.19526-1-d.scheller.oss@gmail.com>
References: <20170723181630.19526-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Smatch reported:

  drivers/media/pci/ddbridge/ddbridge-core.c:1602 dvb_input_attach() error: we previously assumed 'dvb->fe' could be null (see line 1595)

dvb->fe2 will ever only be populated when dvb->fe is set. So only handle
registration of dvb->fe2 when dvb->fe got set beforehand by moving the
registration into the "if (dvb->fe)" conditional.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <r.scobie@clear.net.nz>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Tested-by: Dietmar Spingler <d_spingler@freenet.de>
Tested-by: Manfred Knick <Manfred.Knick@t-online.de>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 72f4cd3de2b8..1e5c420e4717 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1505,23 +1505,25 @@ static int dvb_input_attach(struct ddb_input *input)
 		return 0;
 	}
 	dvb->attached = 0x30;
+
 	if (dvb->fe) {
 		if (dvb_register_frontend(adap, dvb->fe) < 0)
 			return -ENODEV;
+
+		if (dvb->fe2) {
+			if (dvb_register_frontend(adap, dvb->fe2) < 0)
+				return -ENODEV;
+			dvb->fe2->tuner_priv = dvb->fe->tuner_priv;
+			memcpy(&dvb->fe2->ops.tuner_ops,
+			       &dvb->fe->ops.tuner_ops,
+			       sizeof(struct dvb_tuner_ops));
+		}
 	}
-	if (dvb->fe2) {
-		if (dvb_register_frontend(adap, dvb->fe2) < 0)
-			return -ENODEV;
-		dvb->fe2->tuner_priv = dvb->fe->tuner_priv;
-		memcpy(&dvb->fe2->ops.tuner_ops,
-		       &dvb->fe->ops.tuner_ops,
-		       sizeof(struct dvb_tuner_ops));
-	}
+
 	dvb->attached = 0x31;
 	return 0;
 }
 
-
 static int port_has_encti(struct ddb_port *port)
 {
 	struct device *dev = port->dev->dev;
-- 
2.13.0
