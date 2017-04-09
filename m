Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35470 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752627AbdDITiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:52 -0400
Received: by mail-wm0-f68.google.com with SMTP id d79so6410945wmi.2
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:51 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 16/19] [media] ddbridge: board control setup, ts quirk flags
Date: Sun,  9 Apr 2017 21:38:25 +0200
Message-Id: <20170409193828.18458-17-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This is a backport of the board control setup from the vendor provided
dddvb driver package, which does additional device initialisation based
on the board_control device info values. Also backports the TS quirk
flags which is used to control setup and usage of the tuner modules
soldered on the bridge cards (e.g. CineCTv7, CineS2 V7, MaxA8 and the
likes).

Functionality originates from ddbridge vendor driver. Permission for
reuse and kernel inclusion was formally granted by Ralph Metzler
<rjkm@metzlerbros.de>.

Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 13 +++++++++++++
 drivers/media/pci/ddbridge/ddbridge-regs.h |  4 ++++
 drivers/media/pci/ddbridge/ddbridge.h      | 10 ++++++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 12f5aa3..6b49fa9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1763,6 +1763,19 @@ static int ddb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ddbwritel(0xfff0f, INTERRUPT_ENABLE);
 	ddbwritel(0, MSI1_ENABLE);
 
+	/* board control */
+	if (dev->info->board_control) {
+		ddbwritel(0, DDB_LINK_TAG(0) | BOARD_CONTROL);
+		msleep(100);
+		ddbwritel(dev->info->board_control_2,
+			DDB_LINK_TAG(0) | BOARD_CONTROL);
+		usleep_range(2000, 3000);
+		ddbwritel(dev->info->board_control_2
+			| dev->info->board_control,
+			DDB_LINK_TAG(0) | BOARD_CONTROL);
+		usleep_range(2000, 3000);
+	}
+
 	if (ddb_i2c_init(dev) < 0)
 		goto fail1;
 	ddb_ports_init(dev);
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index 6ae8103..98cebb9 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -34,6 +34,10 @@
 
 /* ------------------------------------------------------------------------- */
 
+#define BOARD_CONTROL    0x30
+
+/* ------------------------------------------------------------------------- */
+
 /* Interrupt controller                                     */
 /* How many MSI's are available depends on HW (Min 2 max 8) */
 /* How many are usable also depends on Host platform        */
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 0898f60..734e18e 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -43,6 +43,10 @@
 #define DDB_MAX_PORT    4
 #define DDB_MAX_INPUT   8
 #define DDB_MAX_OUTPUT  4
+#define DDB_MAX_LINK    4
+#define DDB_LINK_SHIFT 28
+
+#define DDB_LINK_TAG(_x) (_x << DDB_LINK_SHIFT)
 
 struct ddb_info {
 	int   type;
@@ -51,6 +55,12 @@ struct ddb_info {
 	char *name;
 	int   port_num;
 	u32   port_type[DDB_MAX_PORT];
+	u32   board_control;
+	u32   board_control_2;
+	u8    ts_quirks;
+#define TS_QUIRK_SERIAL   1
+#define TS_QUIRK_REVERSED 2
+#define TS_QUIRK_ALT_OSC  8
 };
 
 /* DMA_SIZE MUST be divisible by 188 and 128 !!! */
-- 
2.10.2
