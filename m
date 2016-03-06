Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33372 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcCFNjv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Takeshi Yoshimura <yos@sslab.ics.keio.ac.jp>
Subject: [PATCH 2/6] [media] ddcore: avoid endless loop if readl() fails
Date: Sun,  6 Mar 2016 10:39:18 -0300
Message-Id: <821b14b0c9c6afc57548c66c6944b101883c345e.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/pci/ddbridge/ddbridge-core.c:1351 flashio() warn: this loop depends on readl() succeeding
	drivers/media/pci/ddbridge/ddbridge-core.c:1371 flashio() warn: this loop depends on readl() succeeding

Let the loop be interrupted too if something really bad happens
and readl() fails.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 6e995ef8c37e..4b85dd0cac3f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1339,6 +1339,7 @@ static irqreturn_t irq_handler(int irq, void *dev_id)
 static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 {
 	u32 data, shift;
+	int val;
 
 	if (wlen > 4)
 		ddbwritel(1, SPI_CONTROL);
@@ -1348,8 +1349,9 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 		wbuf += 4;
 		wlen -= 4;
 		ddbwritel(data, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
-			;
+		do {
+			val = ddbreadl(SPI_CONTROL);
+		} while (val >= 0 && val & 0x0004);
 	}
 
 	if (rlen)
@@ -1368,8 +1370,9 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	if (shift)
 		data <<= shift;
 	ddbwritel(data, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
-		;
+	do {
+		val = ddbreadl(SPI_CONTROL);
+	} while (val >= 0 && val & 0x0004);
 
 	if (!rlen) {
 		ddbwritel(0, SPI_CONTROL);
@@ -1380,8 +1383,9 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 
 	while (rlen > 4) {
 		ddbwritel(0xffffffff, SPI_DATA);
-		while (ddbreadl(SPI_CONTROL) & 0x0004)
-			;
+		do {
+			val = ddbreadl(SPI_CONTROL);
+		} while (val >= 0 && val & 0x0004);
 		data = ddbreadl(SPI_DATA);
 		*(u32 *) rbuf = swab32(data);
 		rbuf += 4;
@@ -1389,8 +1393,9 @@ static int flashio(struct ddb *dev, u8 *wbuf, u32 wlen, u8 *rbuf, u32 rlen)
 	}
 	ddbwritel(0x0003 | ((rlen << (8 + 3)) & 0x1F00), SPI_CONTROL);
 	ddbwritel(0xffffffff, SPI_DATA);
-	while (ddbreadl(SPI_CONTROL) & 0x0004)
-		;
+	do {
+		val = ddbreadl(SPI_CONTROL);
+	} while (val >= 0 && val & 0x0004);
 
 	data = ddbreadl(SPI_DATA);
 	ddbwritel(0, SPI_CONTROL);
-- 
2.5.0

