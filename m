Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34374 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753926AbdFWQho (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 12:37:44 -0400
Received: by mail-wr0-f194.google.com with SMTP id k67so13724906wrc.1
        for <linux-media@vger.kernel.org>; Fri, 23 Jun 2017 09:37:43 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] ddbridge: make (ddb)readl in while-loops fail-safe
Date: Fri, 23 Jun 2017 18:37:40 +0200
Message-Id: <20170623163740.21250-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Reported by smatch:

  drivers/media/pci/ddbridge/ddbridge-core.c:1246 input_tasklet() warn: this loop depends on readl() succeeding
  drivers/media/pci/ddbridge/ddbridge-core.c:1768 flashio() warn: this loop depends on readl() succeeding
  drivers/media/pci/ddbridge/ddbridge-core.c:1788 flashio() warn: this loop depends on readl() succeeding

Fix this by introducing safe_ddbreadl() which will wrap ddbreadl and checks
for all bits set in the return which indicates failure, and return 0 in
that case. Usable as drop-in-replacement in all affected while loops w/o
having to change the logic.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

TODO: fix up the printk if https://patchwork.linuxtv.org/patch/42034/
eventually gets merged.

Assuming that (uint)-1 is really a reserved return value in iomem (as
mentioned, I'm not that much into kernel and io related things) and it
isn't possible to expect 0xffffffff by definition, this should be good.
Quickly tested with four tuners and four streams running in parallel
without issues.

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 9420479bee9a..cf7a6b0532dc 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -114,6 +114,19 @@ static int i2c_write_reg(struct i2c_adapter *adap, u8 adr,
 	return i2c_write(adap, adr, msg, 2);
 }
 
+static inline u32 safe_ddbreadl(struct ddb *dev, u32 adr)
+{
+	u32 val = ddbreadl(adr);
+
+	/* (ddb)readl returns (uint)-1 (all bits set) on failure, catch that */
+	if (val == ~0) {
+		printk(KERN_ERR "ddbreadl failure, adr=%08x\n", adr);
+		return 0;
+	}
+
+	return val;
+}
+
 static int ddb_i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
 {
 	struct ddb *dev = i2c->dev;
@@ -1243,7 +1256,7 @@ static void input_tasklet(unsigned long data)
 		if (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))
 			printk(KERN_ERR "Overflow input %d\n", input->nr);
 		while (input->cbuf != ((input->stat >> 11) & 0x1f)
-		       || (4&ddbreadl(DMA_BUFFER_CONTROL(input->nr)))) {
+		       || (4 & safe_ddbreadl(dev, DMA_BUFFER_CONTROL(input->nr)))) {
 			dvb_dmx_swfilter_packets(&input->demux,
 						 input->vbuf[input->cbuf],
 						 input->dma_buf_size / 188);
@@ -1765,7 +1778,7 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 		wbuf += 4;
 		wlen -= 4;
 		ddbwritel(data, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
+		while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
 			;
 	}
 
@@ -1785,7 +1798,7 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	if (shift)
 		data <<= shift;
 	ddbwritel(data, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
+	while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
 		;
 
 	if (!rlen) {
@@ -1797,7 +1810,7 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 
 	while (rlen > 4) {
 		ddbwritel(0xffffffff, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
+		while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
 			;
 		data = ddbreadl(SPI_DATA);
 		*(u32 *) rbuf = swab32(data);
@@ -1806,7 +1819,7 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	}
 	ddbwritel(0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
 	ddbwritel(0xffffffff, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
+	while (safe_ddbreadl(dev, SPI_CONTROL) & 0x0004)
 		;
 
 	data = ddbreadl(SPI_DATA);
-- 
2.13.0
