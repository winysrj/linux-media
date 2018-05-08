Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:44807 "EHLO
        homiemail-a116.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755966AbeEHVU1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 17:20:27 -0400
From: Brad Love <brad@nextdimension.cc>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mspieth@digivation.com.au
Cc: Brad Love <brad@nextdimension.cc>
Subject: [PATCH 4/5] cx23885: Expand registers in dma tsport reg dump
Date: Tue,  8 May 2018 16:20:19 -0500
Message-Id: <1525814420-25243-5-git-send-email-brad@nextdimension.cc>
In-Reply-To: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
References: <1525814420-25243-1-git-send-email-brad@nextdimension.cc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Include some additional useful registers in the output.

Signed-off-by: Brad Love <brad@nextdimension.cc>
---
 drivers/media/pci/cx23885/cx23885-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 20a1fd2..1150160 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1369,6 +1369,18 @@ static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
 		port->reg_ts_clk_en, cx_read(port->reg_ts_clk_en));
 	dprintk(1, "%s() ts_int_msk(0x%08X)     0x%08x\n", __func__,
 		port->reg_ts_int_msk, cx_read(port->reg_ts_int_msk));
+	dprintk(1, "%s() ts_int_status(0x%08X)  0x%08x\n", __func__,
+		port->reg_ts_int_stat, cx_read(port->reg_ts_int_stat));
+	dprintk(1, "%s() PCI_INT_STAT           0x%08X\n", __func__,
+		cx_read(PCI_INT_STAT));
+	dprintk(1, "%s() VID_B_INT_MSTAT        0x%08X\n", __func__,
+		cx_read(VID_B_INT_MSTAT));
+	dprintk(1, "%s() VID_B_INT_SSTAT        0x%08X\n", __func__,
+		cx_read(VID_B_INT_SSTAT));
+	dprintk(1, "%s() VID_C_INT_MSTAT        0x%08X\n", __func__,
+		cx_read(VID_C_INT_MSTAT));
+	dprintk(1, "%s() VID_C_INT_SSTAT        0x%08X\n", __func__,
+		cx_read(VID_C_INT_SSTAT));
 }
 
 int cx23885_start_dma(struct cx23885_tsport *port,
-- 
2.7.4
