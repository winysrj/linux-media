Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40511 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757142AbdLQPlC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:41:02 -0500
Received: by mail-wr0-f196.google.com with SMTP id q9so11927047wre.7
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:41:01 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 8/8] [media] ddbridge: improve ddb_ports_attach() failure handling
Date: Sun, 17 Dec 2017 16:40:49 +0100
Message-Id: <20171217154049.1125-9-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

As all error handling improved quite a bit, don't stop attaching frontends
if one of them failed, since - if other tuner modules are connected to
the PCIe bridge - other hardware may just work, so don't break on a single
port failure, but rather initialise as much as possible. Ie. if there are
issues with a C2T2-equipped PCIe bridge card which has additional DuoFlex
modules connected and the bridge generally works, the DuoFlex tuners can
still work fine.

If all ports failed to initialise where connected hardware was detected on
at first, return -ENODEV though to cause this PCI device to fail and free
all allocated resources. In any case, leave a kernel log warning (or
error, even) if things went wrong.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 940371067346..c7d923e0e21a 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1964,7 +1964,7 @@ static int ddb_port_attach(struct ddb_port *port)
 
 int ddb_ports_attach(struct ddb *dev)
 {
-	int i, ret = 0;
+	int i, numports, err_ports = 0, ret = 0;
 	struct ddb_port *port;
 
 	if (dev->port_num) {
@@ -1974,11 +1974,31 @@ int ddb_ports_attach(struct ddb *dev)
 			return ret;
 		}
 	}
+
+	numports = dev->port_num;
+
 	for (i = 0; i < dev->port_num; i++) {
 		port = &dev->port[i];
-		ret = ddb_port_attach(port);
+		if (port->class != DDB_PORT_NONE) {
+			ret = ddb_port_attach(port);
+			if (ret)
+				err_ports++;
+		} else {
+			numports--;
+		}
 	}
-	return ret;
+
+	if (err_ports) {
+		if (err_ports == numports) {
+			dev_err(dev->dev, "All connected ports failed to initialise!\n");
+			return -ENODEV;
+		}
+
+		dev_warn(dev->dev, "%d of %d connected ports failed to initialise!\n",
+			 err_ports, numports);
+	}
+
+	return 0;
 }
 
 void ddb_ports_detach(struct ddb *dev)
-- 
2.13.6
