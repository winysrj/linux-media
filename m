Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57060 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751797AbeDKMDs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 08:03:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Daniel Scheller <d.scheller.oss@gmail.com>
Subject: [PATCH] media: ddbridge: better handle optional spin locks at the code
Date: Wed, 11 Apr 2018 08:03:37 -0400
Message-Id: <5156a3b987ae3698ff4c650a6395997f93ba093e.1523448215.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, ddbridge produces 4 warnings on sparse:
	drivers/media/pci/ddbridge/ddbridge-core.c:495:9: warning: context imbalance in 'ddb_output_start' - different lock contexts for basic block
	drivers/media/pci/ddbridge/ddbridge-core.c:510:9: warning: context imbalance in 'ddb_output_stop' - different lock contexts for basic block
	drivers/media/pci/ddbridge/ddbridge-core.c:525:9: warning: context imbalance in 'ddb_input_stop' - different lock contexts for basic block
	drivers/media/pci/ddbridge/ddbridge-core.c:560:9: warning: context imbalance in 'ddb_input_start' - different lock contexts for basic block

Those are all false positives, but they result from the fact that
there could potentially have some troubles at the locking schema,
because the lock depends on a var (output->dma).

I discussed that in priv with Sparse author and with the current
maintainer. Both believe that sparse is doing the right thing, and
that the proper fix would be to change the code to make it clearer
that, when spin_lock_irq() is called, spin_unlock_irq() will be
also called.

That help not only static analyzers to better understand the code,
but also humans that could need to take a look at the code.

It was also pointed that gcc would likely be smart enough to
optimize the code and produce the same result. I double
checked: indeed, the size of the driver didn't change after
this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ddbridge/ddbridge-core.c | 43 ++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 4a2819d3e225..080e2189ca7f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -458,13 +458,12 @@ static void calc_con(struct ddb_output *output, u32 *con, u32 *con2, u32 flags)
 	*con2 = (nco << 16) | gap;
 }
 
-static void ddb_output_start(struct ddb_output *output)
+static void __ddb_output_start(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
 	u32 con = 0x11c, con2 = 0;
 
 	if (output->dma) {
-		spin_lock_irq(&output->dma->lock);
 		output->dma->cbuf = 0;
 		output->dma->coff = 0;
 		output->dma->stat = 0;
@@ -492,9 +491,18 @@ static void ddb_output_start(struct ddb_output *output)
 
 	ddbwritel(dev, con | 1, TS_CONTROL(output));
 
-	if (output->dma) {
+	if (output->dma)
 		output->dma->running = 1;
+}
+
+static void ddb_output_start(struct ddb_output *output)
+{
+	if (output->dma) {
+		spin_lock_irq(&output->dma->lock);
+		__ddb_output_start(output);
 		spin_unlock_irq(&output->dma->lock);
+	} else {
+		__ddb_output_start(output);
 	}
 }
 
@@ -502,15 +510,13 @@ static void ddb_output_stop(struct ddb_output *output)
 {
 	struct ddb *dev = output->port->dev;
 
-	if (output->dma)
-		spin_lock_irq(&output->dma->lock);
-
-	ddbwritel(dev, 0, TS_CONTROL(output));
-
 	if (output->dma) {
+		spin_lock_irq(&output->dma->lock);
 		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(output->dma));
 		output->dma->running = 0;
 		spin_unlock_irq(&output->dma->lock);
+	} else {
+		ddbwritel(dev, 0, TS_CONTROL(output));
 	}
 }
 
@@ -519,22 +525,21 @@ static void ddb_input_stop(struct ddb_input *input)
 	struct ddb *dev = input->port->dev;
 	u32 tag = DDB_LINK_TAG(input->port->lnr);
 
-	if (input->dma)
-		spin_lock_irq(&input->dma->lock);
-	ddbwritel(dev, 0, tag | TS_CONTROL(input));
 	if (input->dma) {
+		spin_lock_irq(&input->dma->lock);
 		ddbwritel(dev, 0, DMA_BUFFER_CONTROL(input->dma));
 		input->dma->running = 0;
 		spin_unlock_irq(&input->dma->lock);
+	} else {
+		ddbwritel(dev, 0, tag | TS_CONTROL(input));
 	}
 }
 
-static void ddb_input_start(struct ddb_input *input)
+static void __ddb_input_start(struct ddb_input *input)
 {
 	struct ddb *dev = input->port->dev;
 
 	if (input->dma) {
-		spin_lock_irq(&input->dma->lock);
 		input->dma->cbuf = 0;
 		input->dma->coff = 0;
 		input->dma->stat = 0;
@@ -557,9 +562,19 @@ static void ddb_input_start(struct ddb_input *input)
 	if (input->port->type == DDB_TUNER_DUMMY)
 		ddbwritel(dev, 0x000fff01, TS_CONTROL2(input));
 
-	if (input->dma) {
+	if (input->dma)
 		input->dma->running = 1;
+}
+
+static void ddb_input_start(struct ddb_input *input)
+{
+
+	if (input->dma) {
+		spin_lock_irq(&input->dma->lock);
+		__ddb_input_start(input);
 		spin_unlock_irq(&input->dma->lock);
+	} else {
+		__ddb_input_start(input);
 	}
 }
 
-- 
2.14.3
