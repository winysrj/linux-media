Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36788 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753416AbeDIQsL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Apr 2018 12:48:11 -0400
Received: by mail-wr0-f195.google.com with SMTP id y55so10273711wry.3
        for <linux-media@vger.kernel.org>; Mon, 09 Apr 2018 09:48:10 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH v2 16/19] [media] ddbridge/max: implement MCI/MaxSX8 attach function
Date: Mon,  9 Apr 2018 18:47:49 +0200
Message-Id: <20180409164752.641-17-d.scheller.oss@gmail.com>
In-Reply-To: <20180409164752.641-1-d.scheller.oss@gmail.com>
References: <20180409164752.641-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Implement frontend attachment as ddb_fe_attach_mci() into the
ddbridge-max module. The MaxSX8 MCI cards are part of the Max card series
and make use of the LNB controller driven by the already existing lnb
functionality, so here's where this code belongs to.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-max.c | 42 +++++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-max.h |  1 +
 2 files changed, 43 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-max.c b/drivers/media/pci/ddbridge/ddbridge-max.c
index dc6b81488746..739e4b444cf4 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.c
+++ b/drivers/media/pci/ddbridge/ddbridge-max.c
@@ -33,6 +33,7 @@
 #include "ddbridge.h"
 #include "ddbridge-regs.h"
 #include "ddbridge-io.h"
+#include "ddbridge-mci.h"
 
 #include "ddbridge-max.h"
 #include "mxl5xx.h"
@@ -452,3 +453,44 @@ int ddb_fe_attach_mxl5xx(struct ddb_input *input)
 	dvb->input = tuner;
 	return 0;
 }
+
+/******************************************************************************/
+/* MAX MCI related functions */
+
+int ddb_fe_attach_mci(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct ddb_port *port = input->port;
+	struct ddb_link *link = &dev->link[port->lnr];
+	int demod, tuner;
+
+	demod = input->nr;
+	tuner = demod & 3;
+	if (fmode == 3)
+		tuner = 0;
+	dvb->fe = ddb_mci_attach(input, 0, demod, &dvb->set_input);
+	if (!dvb->fe) {
+		dev_err(dev->dev, "No MAXSX8 found!\n");
+		return -ENODEV;
+	}
+	if (!dvb->set_input) {
+		dev_err(dev->dev, "No MCI set_input function pointer!\n");
+		return -ENODEV;
+	}
+	if (input->nr < 4) {
+		lnb_command(dev, port->lnr, input->nr, LNB_CMD_INIT);
+		lnb_set_voltage(dev, port->lnr, input->nr, SEC_VOLTAGE_OFF);
+	}
+	ddb_lnb_init_fmode(dev, link, fmode);
+
+	dvb->fe->ops.set_voltage = max_set_voltage;
+	dvb->fe->ops.enable_high_lnb_voltage = max_enable_high_lnb_voltage;
+	dvb->fe->ops.set_tone = max_set_tone;
+	dvb->diseqc_send_master_cmd = dvb->fe->ops.diseqc_send_master_cmd;
+	dvb->fe->ops.diseqc_send_master_cmd = max_send_master_cmd;
+	dvb->fe->ops.diseqc_send_burst = max_send_burst;
+	dvb->fe->sec_priv = input;
+	dvb->input = tuner;
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-max.h b/drivers/media/pci/ddbridge/ddbridge-max.h
index bf8bf38739f6..82efc53baa94 100644
--- a/drivers/media/pci/ddbridge/ddbridge-max.h
+++ b/drivers/media/pci/ddbridge/ddbridge-max.h
@@ -25,5 +25,6 @@
 
 int ddb_lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
 int ddb_fe_attach_mxl5xx(struct ddb_input *input);
+int ddb_fe_attach_mci(struct ddb_input *input);
 
 #endif /* _DDBRIDGE_MAX_H */
-- 
2.16.1
