Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33665 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbdF3Uva (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 16:51:30 -0400
Received: by mail-wm0-f66.google.com with SMTP id j85so9870917wmj.0
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 13:51:29 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Subject: [PATCH v2 09/10] [media] ddbridge: stv0910 single demod mode module option
Date: Fri, 30 Jun 2017 22:51:05 +0200
Message-Id: <20170630205106.1268-10-d.scheller.oss@gmail.com>
In-Reply-To: <20170630205106.1268-1-d.scheller.oss@gmail.com>
References: <20170630205106.1268-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Adds a stv0910_single modparm which, when set, configures the stv0910 to
run in single demodulator mode, currently intended for high bit rate
testing.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index b3fc6a875279..e762396730db 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -53,6 +53,10 @@ static int xo2_speed = 2;
 module_param(xo2_speed, int, 0444);
 MODULE_PARM_DESC(xo2_speed, "default transfer speed for xo2 based duoflex, 0=55,1=75,2=90,3=104 MBit/s, default=2, use attribute to change for individual cards");
 
+static int stv0910_single;
+module_param(stv0910_single, int, 0444);
+MODULE_PARM_DESC(stv0910_single, "use stv0910 cards as single demods");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 /* MSI had problems with lost interrupts, fixed but needs testing */
@@ -942,6 +946,9 @@ static int demod_attach_stv0910(struct ddb_input *input, int type)
 	struct stv0910_cfg cfg = stv0910_p;
 	struct lnbh25_config lnbcfg = lnbh25_cfg;
 
+	if (stv0910_single)
+		cfg.single = 1;
+
 	if (type)
 		cfg.parallel = 2;
 	input->fe = dvb_attach(stv0910_attach, i2c, &cfg, (input->nr & 1));
-- 
2.13.0
