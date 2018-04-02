Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38959 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbeDBSYp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2018 14:24:45 -0400
Received: by mail-wr0-f195.google.com with SMTP id c24so15021022wrc.6
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2018 11:24:44 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 15/20] [media] ddbridge: support dummy tuners with 125MByte/s dummy data stream
Date: Mon,  2 Apr 2018 20:24:22 +0200
Message-Id: <20180402182427.20918-16-d.scheller.oss@gmail.com>
In-Reply-To: <20180402182427.20918-1-d.scheller.oss@gmail.com>
References: <20180402182427.20918-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The Octopus V3 and Octopus Mini devices support set up of a dummy tuner
mode on port 0 that will deliver a continuous data stream of 125MBytes
per second while raising IRQs and filling the DMA buffers, which comes
handy for some stress, PCIe link and IRQ handling testing. The dummy
frontend is registered using dvb_dummy_fe's QAM dummy frontend. Set
ddbridge.dummy_tuner to 1 to enable this on the supported cards.

Picked up from the upstream dddvb-0.9.33 release.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Kconfig         |  1 +
 drivers/media/pci/ddbridge/ddbridge-core.c | 36 ++++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge.h      |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index a422dde2f34a..16faef265e97 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -14,6 +14,7 @@ config DVB_DDBRIDGE
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_MXL5XX if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_CXD2099 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_DUMMY_FE if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 8907551b02e4..59e137516003 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -54,6 +54,7 @@
 #include "stv6111.h"
 #include "lnbh25.h"
 #include "cxd2099.h"
+#include "dvb_dummy_fe.h"
 
 /****************************************************************************/
 
@@ -105,6 +106,11 @@ module_param(dma_buf_size, int, 0444);
 MODULE_PARM_DESC(dma_buf_size,
 		 "DMA buffer size as multiple of 128*47, possible values: 1-43");
 
+static int dummy_tuner;
+module_param(dummy_tuner, int, 0444);
+MODULE_PARM_DESC(dummy_tuner,
+		 "attach dummy tuner to port 0 on Octopus V3 or Octopus Mini cards");
+
 /****************************************************************************/
 
 static DEFINE_MUTEX(redirect_lock);
@@ -548,6 +554,9 @@ static void ddb_input_start(struct ddb_input *input)
 
 	ddbwritel(dev, 0x09, TS_CONTROL(input));
 
+	if (input->port->type == DDB_TUNER_DUMMY)
+		ddbwritel(dev, 0x000fff01, TS_CONTROL2(input));
+
 	if (input->dma) {
 		input->dma->running = 1;
 		spin_unlock_irq(&input->dma->lock);
@@ -1255,6 +1264,20 @@ static int tuner_attach_stv6111(struct ddb_input *input, int type)
 	return 0;
 }
 
+static int demod_attach_dummy(struct ddb_input *input)
+{
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct device *dev = input->port->dev->dev;
+
+	dvb->fe = dvb_attach(dvb_dummy_fe_qam_attach);
+	if (!dvb->fe) {
+		dev_err(dev, "QAM dummy attach failed!\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
@@ -1547,6 +1570,10 @@ static int dvb_input_attach(struct ddb_input *input)
 		if (tuner_attach_tda18212(input, port->type) < 0)
 			goto err_tuner;
 		break;
+	case DDB_TUNER_DUMMY:
+		if (demod_attach_dummy(input) < 0)
+			goto err_detach;
+		break;
 	default:
 		return 0;
 	}
@@ -1809,6 +1836,15 @@ static void ddb_port_probe(struct ddb_port *port)
 
 	/* Handle missing ports and ports without I2C */
 
+	if (dummy_tuner && !port->nr &&
+	    dev->link[0].ids.device == 0x0005) {
+		port->name = "DUMMY";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_DUMMY;
+		port->type_name = "DUMMY";
+		return;
+	}
+
 	if (port->nr == ts_loop) {
 		port->name = "TS LOOP";
 		port->class = DDB_PORT_LOOP;
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 86db6f19369a..cb69021a3443 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -236,6 +236,7 @@ struct ddb_port {
 	char                   *name;
 	char                   *type_name;
 	u32                     type;
+#define DDB_TUNER_DUMMY          0xffffffff
 #define DDB_TUNER_NONE           0
 #define DDB_TUNER_DVBS_ST        1
 #define DDB_TUNER_DVBS_ST_AA     2
-- 
2.16.1
