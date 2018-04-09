Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44037 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753328AbeDIQsM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:12 -0400
Received: by mail-wr0-f196.google.com with SMTP id u46so10240650wrc.11
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:12 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 18/19] [media] ddbridge: recognize and attach the MaxSX8 cards
Date: Mon,  9 Apr 2018 18:47:51 +0200
Message-Id: <20180409164752.641-19-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add needed logic into dvb_input_attach(), ddb_port_probe() and
ddb_ports_init() to initialize and support these new cards.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 59e137516003..4a2819d3e225 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1574,6 +1574,10 @@ static int dvb_input_attach(struct ddb_input *input)
 		if (demod_attach_dummy(input) < 0)
 			goto err_detach;
 		break;
+	case DDB_TUNER_MCI:
+		if (ddb_fe_attach_mci(input) < 0)
+			goto err_detach;
+		break;
 	default:
 		return 0;
 	}
@@ -1869,6 +1873,16 @@ static void ddb_port_probe(struct ddb_port *port)
 		return;
 	}
 
+	if (dev->link[l].info->type == DDB_OCTOPUS_MCI) {
+		if (port->nr >= dev->link[l].info->mci)
+			return;
+		port->name = "DUAL MCI";
+		port->type_name = "MCI";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_MCI;
+		return;
+	}
+
 	if (port->nr > 1 && dev->link[l].info->type == DDB_OCTOPUS_CI) {
 		port->name = "CI internal";
 		port->type_name = "INTERNAL";
@@ -2411,6 +2425,7 @@ void ddb_ports_init(struct ddb *dev)
 				break;
 			case DDB_OCTOPUS_MAX:
 			case DDB_OCTOPUS_MAX_CT:
+			case DDB_OCTOPUS_MCI:
 				ddb_input_init(port, 2 * i, 0, 2 * p);
 				ddb_input_init(port, 2 * i + 1, 1, 2 * p + 1);
 				break;
-- 
2.16.1
