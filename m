Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36941 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752542AbdHTKlW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 06:41:22 -0400
Received: by mail-wr0-f194.google.com with SMTP id z91so13149803wrc.4
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 03:41:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 5/6] [media] ddbridge: const'ify all ddb_info, ddb_regmap et al
Date: Sun, 20 Aug 2017 12:41:13 +0200
Message-Id: <20170820104114.6515-6-d.scheller.oss@gmail.com>
In-Reply-To: <20170820104114.6515-1-d.scheller.oss@gmail.com>
References: <20170820104114.6515-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

All data is accessed RO, so mark everything const. Some vars in several
functions aswell as function signatures also require the const keyword
now, they're also added by this commit.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 14 +++++++-------
 drivers/media/pci/ddbridge/ddbridge-hw.c   | 18 +++++++++---------
 drivers/media/pci/ddbridge/ddbridge-i2c.c  |  5 +++--
 drivers/media/pci/ddbridge/ddbridge.h      | 20 ++++++++++----------
 4 files changed, 29 insertions(+), 28 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 5f6367fee586..a14031ac45cf 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -2439,7 +2439,7 @@ static void output_handler(unsigned long data)
 /****************************************************************************/
 /****************************************************************************/
 
-static struct ddb_regmap *io_regmap(struct ddb_io *io, int link)
+static const struct ddb_regmap *io_regmap(struct ddb_io *io, int link)
 {
 	const struct ddb_info *info;
 
@@ -2457,7 +2457,7 @@ static struct ddb_regmap *io_regmap(struct ddb_io *io, int link)
 static void ddb_dma_init(struct ddb_io *io, int nr, int out)
 {
 	struct ddb_dma *dma;
-	struct ddb_regmap *rm = io_regmap(io, 0);
+	const struct ddb_regmap *rm = io_regmap(io, 0);
 
 	dma = out ? &io->port->dev->odma[nr] : &io->port->dev->idma[nr];
 	io->dma = dma;
@@ -2488,7 +2488,7 @@ static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int anr)
 {
 	struct ddb *dev = port->dev;
 	struct ddb_input *input = &dev->input[anr];
-	struct ddb_regmap *rm;
+	const struct ddb_regmap *rm;
 
 	port->input[pnr] = input;
 	input->nr = nr;
@@ -2500,7 +2500,7 @@ static void ddb_input_init(struct ddb_port *port, int nr, int pnr, int anr)
 		port->lnr, nr, input->regs);
 
 	if (dev->has_dma) {
-		struct ddb_regmap *rm0 = io_regmap(input, 0);
+		const struct ddb_regmap *rm0 = io_regmap(input, 0);
 		u32 base = rm0->irq_base_idma;
 		u32 dma_nr = nr;
 
@@ -2520,7 +2520,7 @@ static void ddb_output_init(struct ddb_port *port, int nr)
 {
 	struct ddb *dev = port->dev;
 	struct ddb_output *output = &dev->output[nr];
-	struct ddb_regmap *rm;
+	const struct ddb_regmap *rm;
 
 	port->output = output;
 	output->nr = nr;
@@ -2533,7 +2533,7 @@ static void ddb_output_init(struct ddb_port *port, int nr)
 		 port->lnr, nr, output->regs);
 
 	if (dev->has_dma) {
-		struct ddb_regmap *rm0 = io_regmap(output, 0);
+		const struct ddb_regmap *rm0 = io_regmap(output, 0);
 		u32 base = rm0->irq_base_odma;
 
 		dev->handler[0][nr + base] = output_handler;
@@ -2576,7 +2576,7 @@ void ddb_ports_init(struct ddb *dev)
 	u32 i, l, p;
 	struct ddb_port *port;
 	const struct ddb_info *info;
-	struct ddb_regmap *rm;
+	const struct ddb_regmap *rm;
 
 	for (p = l = 0; l < DDB_MAX_LINK; l++) {
 		info = dev->link[l].info;
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index 1c25e86c189e..48248bcd59c2 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -21,49 +21,49 @@
 
 /******************************************************************************/
 
-static struct ddb_regset octopus_input = {
+static const struct ddb_regset octopus_input = {
 	.base = 0x200,
 	.num  = 0x08,
 	.size = 0x10,
 };
 
-static struct ddb_regset octopus_output = {
+static const struct ddb_regset octopus_output = {
 	.base = 0x280,
 	.num  = 0x08,
 	.size = 0x10,
 };
 
-static struct ddb_regset octopus_idma = {
+static const struct ddb_regset octopus_idma = {
 	.base = 0x300,
 	.num  = 0x08,
 	.size = 0x10,
 };
 
-static struct ddb_regset octopus_idma_buf = {
+static const struct ddb_regset octopus_idma_buf = {
 	.base = 0x2000,
 	.num  = 0x08,
 	.size = 0x100,
 };
 
-static struct ddb_regset octopus_odma = {
+static const struct ddb_regset octopus_odma = {
 	.base = 0x380,
 	.num  = 0x04,
 	.size = 0x10,
 };
 
-static struct ddb_regset octopus_odma_buf = {
+static const struct ddb_regset octopus_odma_buf = {
 	.base = 0x2800,
 	.num  = 0x04,
 	.size = 0x100,
 };
 
-static struct ddb_regset octopus_i2c = {
+static const struct ddb_regset octopus_i2c = {
 	.base = 0x80,
 	.num  = 0x04,
 	.size = 0x20,
 };
 
-static struct ddb_regset octopus_i2c_buf = {
+static const struct ddb_regset octopus_i2c_buf = {
 	.base = 0x1000,
 	.num  = 0x04,
 	.size = 0x200,
@@ -71,7 +71,7 @@ static struct ddb_regset octopus_i2c_buf = {
 
 /****************************************************************************/
 
-static struct ddb_regmap octopus_map = {
+static const struct ddb_regmap octopus_map = {
 	.irq_base_i2c = 0,
 	.irq_base_idma = 8,
 	.irq_base_odma = 16,
diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
index 3d4fafb5db27..e4d39c3270ae 100644
--- a/drivers/media/pci/ddbridge/ddbridge-i2c.c
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -155,7 +155,8 @@ static void i2c_handler(unsigned long priv)
 }
 
 static int ddb_i2c_add(struct ddb *dev, struct ddb_i2c *i2c,
-		       struct ddb_regmap *regmap, int link, int i, int num)
+		       const struct ddb_regmap *regmap, int link,
+		       int i, int num)
 {
 	struct i2c_adapter *adap;
 
@@ -196,7 +197,7 @@ int ddb_i2c_init(struct ddb *dev)
 	u32 i, j, num = 0, l, base;
 	struct ddb_i2c *i2c;
 	struct i2c_adapter *adap;
-	struct ddb_regmap *regmap;
+	const struct ddb_regmap *regmap;
 
 	for (l = 0; l < DDB_MAX_LINK; l++) {
 		if (!dev->link[l].info)
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index d890400dc1c3..c1a1edfe15aa 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -85,17 +85,17 @@ struct ddb_regmap {
 	u32 irq_base_idma;
 	u32 irq_base_odma;
 
-	struct ddb_regset *i2c;
-	struct ddb_regset *i2c_buf;
-	struct ddb_regset *idma;
-	struct ddb_regset *idma_buf;
-	struct ddb_regset *odma;
-	struct ddb_regset *odma_buf;
+	const struct ddb_regset *i2c;
+	const struct ddb_regset *i2c_buf;
+	const struct ddb_regset *idma;
+	const struct ddb_regset *idma_buf;
+	const struct ddb_regset *odma;
+	const struct ddb_regset *odma_buf;
 
-	struct ddb_regset *input;
-	struct ddb_regset *output;
+	const struct ddb_regset *input;
+	const struct ddb_regset *output;
 
-	struct ddb_regset *channel;
+	const struct ddb_regset *channel;
 };
 
 struct ddb_ids {
@@ -133,7 +133,7 @@ struct ddb_info {
 #define TS_QUIRK_REVERSED 2
 #define TS_QUIRK_ALT_OSC  8
 	u32   tempmon_irq;
-	struct ddb_regmap *regmap;
+	const struct ddb_regmap *regmap;
 };
 
 /* DMA_SIZE MUST be smaller than 256k and
-- 
2.13.0
