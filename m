Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55173 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751480AbeBXSzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Feb 2018 13:55:47 -0500
Received: by mail-wm0-f67.google.com with SMTP id z81so10441417wmb.4
        for <linux-media@vger.kernel.org>; Sat, 24 Feb 2018 10:55:46 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH 09/12] [media] ngene: check for CXD2099AR presence before attaching
Date: Sat, 24 Feb 2018 19:55:31 +0100
Message-Id: <20180224185534.13792-10-d.scheller.oss@gmail.com>
In-Reply-To: <20180224185534.13792-1-d.scheller.oss@gmail.com>
References: <20180224185534.13792-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Currently, if there's no CXD2099AR attached to any expansion connector of
the ngene hardware, it will complain with this on every module load:

    cxd2099 1-0040: No CXD2099AR detected at 0x40
    cxd2099: probe of 1-0040 failed with error -5
    ngene 0000:02:00.0: CXD2099AR attach failed

This happens due to the logic assuming such hardware is always there and
blindly tries to attach the cxd2099 I2C driver. Rather add a probe
function (in ngene-cards.c with a prototype in ngene.h) to check for
the existence of such hardware before probing, and don't try further if
no CXD2099 was found.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ngene/ngene-cards.c | 19 +++++++++++++++++++
 drivers/media/pci/ngene/ngene-core.c  | 14 ++++++++++++++
 drivers/media/pci/ngene/ngene.h       |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index dff55c7c9f86..d603d0af703e 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -505,6 +505,25 @@ static int port_has_stv0367(struct i2c_adapter *i2c)
 	return 1;
 }
 
+int ngene_port_has_cxd2099(struct i2c_adapter *i2c, u8 *type)
+{
+	u8 val;
+	u8 probe[4] = { 0xe0, 0x00, 0x00, 0x00 }, data[4];
+	struct i2c_msg msgs[2] = {{ .addr = 0x40,  .flags = 0,
+				    .buf  = probe, .len   = 4 },
+				  { .addr = 0x40,  .flags = I2C_M_RD,
+				    .buf  = data,  .len   = 4 } };
+	val = i2c_transfer(i2c, msgs, 2);
+	if (val != 2)
+		return 0;
+
+	if (data[0] == 0x02 && data[1] == 0x2b && data[3] == 0x43)
+		*type = 2;
+	else
+		*type = 1;
+	return 1;
+}
+
 static int demod_attach_drxk(struct ngene_channel *chan,
 			     struct i2c_adapter *i2c)
 {
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 526d0adfa427..f69a8fc1ec2a 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1589,6 +1589,20 @@ static void cxd_attach(struct ngene *dev)
 		.addr = 0x40,
 		.platform_data = &cxd_cfg,
 	};
+	int ret;
+	u8 type;
+
+	/* check for CXD2099AR presence before attaching */
+	ret = ngene_port_has_cxd2099(&dev->channel[0].i2c_adapter, &type);
+	if (!ret) {
+		dev_dbg(pdev, "No CXD2099AR found\n");
+		return;
+	}
+
+	if (type != 1) {
+		dev_warn(pdev, "CXD2099AR is uninitialized!\n");
+		return;
+	}
 
 	cxd_cfg.en = &ci->en;
 
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 72195f6552b3..66d8eaa28549 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -909,6 +909,9 @@ int ngene_command_gpio_set(struct ngene *dev, u8 select, u8 level);
 void set_transfer(struct ngene_channel *chan, int state);
 void FillTSBuffer(void *Buffer, int Length, u32 Flags);
 
+/* Provided by ngene-cards.c */
+int ngene_port_has_cxd2099(struct i2c_adapter *i2c, u8 *type);
+
 /* Provided by ngene-i2c.c */
 int ngene_i2c_init(struct ngene *dev, int dev_nr);
 
-- 
2.16.1
