Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44632 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdLQPk6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 10:40:58 -0500
Received: by mail-wr0-f196.google.com with SMTP id w95so1033018wrc.11
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 07:40:58 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: [PATCH 4/8] [media] ddbridge: move CI detach code to ddbridge-ci.c
Date: Sun, 17 Dec 2017 16:40:45 +0100
Message-Id: <20171217154049.1125-5-d.scheller.oss@gmail.com>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Move the CI teardown code to ddbridge-ci.c where everything else related
to CI hardware lives.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 11 +++++++++++
 drivers/media/pci/ddbridge/ddbridge-ci.h   |  1 +
 drivers/media/pci/ddbridge/ddbridge-core.c |  8 +-------
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
index 8dfbc3bbd86d..5828111487b0 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.c
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -346,3 +346,14 @@ int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
 	dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
 	return 0;
 }
+
+void ddb_ci_detach(struct ddb_port *port)
+{
+	if (port->dvb[0].dev)
+		dvb_unregister_device(port->dvb[0].dev);
+	if (port->en) {
+		dvb_ca_en50221_release(port->en);
+		kfree(port->en->data);
+		port->en = NULL;
+	}
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.h b/drivers/media/pci/ddbridge/ddbridge-ci.h
index 3a5d7ffab7b7..35a39182dd83 100644
--- a/drivers/media/pci/ddbridge/ddbridge-ci.h
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.h
@@ -26,5 +26,6 @@
 /******************************************************************************/
 
 int ddb_ci_attach(struct ddb_port *port, u32 bitrate);
+void ddb_ci_detach(struct ddb_port *port);
 
 #endif /* __DDBRIDGE_CI_H__ */
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index a81125d492ff..c2f028152388 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1986,13 +1986,7 @@ void ddb_ports_detach(struct ddb *dev)
 			break;
 		case DDB_PORT_CI:
 		case DDB_PORT_LOOP:
-			if (port->dvb[0].dev)
-				dvb_unregister_device(port->dvb[0].dev);
-			if (port->en) {
-				dvb_ca_en50221_release(port->en);
-				kfree(port->en->data);
-				port->en = NULL;
-			}
+			ddb_ci_detach(port);
 			break;
 		}
 	}
-- 
2.13.6
