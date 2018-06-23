Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38778 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbeFWPg1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Jun 2018 11:36:27 -0400
Received: by mail-wm0-f67.google.com with SMTP id 69-v6so5601477wmf.3
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2018 08:36:26 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org
Subject: [PATCH 08/19] [media] ddbridge: change MCI base ID and define a SX8 ID
Date: Sat, 23 Jun 2018 17:36:04 +0200
Message-Id: <20180623153615.27630-9-d.scheller.oss@gmail.com>
In-Reply-To: <20180623153615.27630-1-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Change the start of the MCI ID range (internally used only) to 48 and
define an ID for the SX8 card type. Use this new ID to handle device
attachment.

This change is done in preparation for support of more MCI based cards.

Picked up from the upstream dddvb GIT.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 4 ++--
 drivers/media/pci/ddbridge/ddbridge.h      | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 408460be00b7..68ea0ffdad2d 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1592,7 +1592,7 @@ static int dvb_input_attach(struct ddb_input *input)
 		if (demod_attach_dummy(input) < 0)
 			goto err_detach;
 		break;
-	case DDB_TUNER_MCI:
+	case DDB_TUNER_MCI_SX8:
 		if (ddb_fe_attach_mci(input) < 0)
 			goto err_detach;
 		break;
@@ -1898,7 +1898,7 @@ static void ddb_port_probe(struct ddb_port *port)
 		port->name = "DUAL MCI";
 		port->type_name = "MCI";
 		port->class = DDB_PORT_TUNER;
-		port->type = DDB_TUNER_MCI;
+		port->type = DDB_TUNER_MCI_SX8;
 		return;
 	}
 
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 9c645bee428a..65bd74d86ed5 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -254,7 +254,6 @@ struct ddb_port {
 #define DDB_CI_EXTERNAL_XO2_B    13
 #define DDB_TUNER_DVBS_STV0910_PR 14
 #define DDB_TUNER_DVBC2T2I_SONY_P 15
-#define DDB_TUNER_MCI            16
 
 #define DDB_TUNER_XO2            32
 #define DDB_TUNER_DVBS_STV0910   (DDB_TUNER_XO2 + 0)
@@ -264,6 +263,9 @@ struct ddb_port {
 #define DDB_TUNER_ATSC_ST        (DDB_TUNER_XO2 + 4)
 #define DDB_TUNER_DVBC2T2I_SONY  (DDB_TUNER_XO2 + 5)
 
+#define DDB_TUNER_MCI            48
+#define DDB_TUNER_MCI_SX8        (DDB_TUNER_MCI + 0)
+
 	struct ddb_input      *input[2];
 	struct ddb_output     *output;
 	struct dvb_ca_en50221 *en;
-- 
2.16.4
