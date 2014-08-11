Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.194]:56419 "EHLO kirsi1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbaHKT62 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 15:58:28 -0400
From: Olli Salonen <olli.salonen@iki.fi>
To: olli@cabbala.net
Cc: Olli Salonen <olli.salonen@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 5/6] cx23855: add frontend set voltage function into state
Date: Mon, 11 Aug 2014 22:58:14 +0300
Message-Id: <1407787095-2167-5-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
References: <1407787095-2167-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Setting the LNB voltage requires setting some GPIOs on the cx23885 with some boards before calling the actual set_voltage function in the demod driver. Add a function pointer into state for that case.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/pci/cx23885/cx23885.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 1040b3e..e60ff7f 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -330,6 +330,8 @@ struct cx23885_tsport {
 	struct i2c_client *i2c_client_tuner;
 
 	int (*set_frontend)(struct dvb_frontend *fe);
+	int (*fe_set_voltage)(struct dvb_frontend *fe,
+				fe_sec_voltage_t voltage);
 };
 
 struct cx23885_kernel_ir {
-- 
1.9.1

