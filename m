Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:37745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1EIPJP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 11:09:15 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Cc: Jarod Wilson <jarod@redhat.com>,
	=?UTF-8?q?Juan=20Jes=C3=BAs=20Garc=C3=ADa=20de=20Soria?=
	<skandalfo@gmail.com>
Subject: [PATCH] [media] ite-cir: clean up odd spacing in ite8709 bits
Date: Mon,  9 May 2011 11:09:10 -0400
Message-Id: <1304953750-21910-1-git-send-email-jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

There was some rather odd spacing in a few of the ite8709-specific
functions that made it hard to read those sections of code. This is just
a simple reformatting.

CC: Juan Jesús García de Soria <skandalfo@gmail.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/rc/ite-cir.c |   46 +++++++++++++++++--------------------------
 1 files changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 8488e53..71ba9da 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1250,11 +1250,9 @@ static void it8709_disable(struct ite_dev *dev)
 	ite_dbg("%s called", __func__);
 
 	/* clear out all interrupt enable flags */
-	it8709_wr(dev,
-			    it8709_rr(dev,
-				      IT85_C0IER) & ~(IT85_IEC | IT85_RFOIE |
-						      IT85_RDAIE |
-						      IT85_TLDLIE), IT85_C0IER);
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER) &
+			~(IT85_IEC | IT85_RFOIE | IT85_RDAIE | IT85_TLDLIE),
+		  IT85_C0IER);
 
 	/* disable the receiver */
 	it8709_disable_rx(dev);
@@ -1270,11 +1268,9 @@ static void it8709_init_hardware(struct ite_dev *dev)
 	ite_dbg("%s called", __func__);
 
 	/* disable all the interrupts */
-	it8709_wr(dev,
-			    it8709_rr(dev,
-				      IT85_C0IER) & ~(IT85_IEC | IT85_RFOIE |
-						      IT85_RDAIE |
-						      IT85_TLDLIE), IT85_C0IER);
+	it8709_wr(dev, it8709_rr(dev, IT85_C0IER) &
+			~(IT85_IEC | IT85_RFOIE | IT85_RDAIE | IT85_TLDLIE),
+		  IT85_C0IER);
 
 	/* program the baud rate divisor */
 	it8709_wr(dev, ITE_BAUDRATE_DIVISOR & 0xff, IT85_C0BDLR);
@@ -1282,28 +1278,22 @@ static void it8709_init_hardware(struct ite_dev *dev)
 			IT85_C0BDHR);
 
 	/* program the C0MSTCR register defaults */
-	it8709_wr(dev, (it8709_rr(dev, IT85_C0MSTCR) & ~(IT85_ILSEL |
-								   IT85_ILE
-								   | IT85_FIFOTL
-								   |
-								   IT85_FIFOCLR
-								   |
-								   IT85_RESET))
-			    | IT85_FIFOTL_DEFAULT, IT85_C0MSTCR);
+	it8709_wr(dev, (it8709_rr(dev, IT85_C0MSTCR) &
+			~(IT85_ILSEL | IT85_ILE | IT85_FIFOTL
+			  | IT85_FIFOCLR | IT85_RESET)) | IT85_FIFOTL_DEFAULT,
+		  IT85_C0MSTCR);
 
 	/* program the C0RCR register defaults */
-	it8709_wr(dev,
-			    (it8709_rr(dev, IT85_C0RCR) &
-			     ~(IT85_RXEN | IT85_RDWOS | IT85_RXEND
-			       | IT85_RXACT | IT85_RXDCR)) |
-			    ITE_RXDCR_DEFAULT, IT85_C0RCR);
+	it8709_wr(dev, (it8709_rr(dev, IT85_C0RCR) &
+			~(IT85_RXEN | IT85_RDWOS | IT85_RXEND | IT85_RXACT
+			  | IT85_RXDCR)) | ITE_RXDCR_DEFAULT,
+		  IT85_C0RCR);
 
 	/* program the C0TCR register defaults */
-	it8709_wr(dev, (it8709_rr(dev, IT85_C0TCR)
-				  &~(IT85_TXMPM | IT85_TXMPW))
-			    |IT85_TXRLE | IT85_TXENDF |
-			    IT85_TXMPM_DEFAULT |
-			    IT85_TXMPW_DEFAULT, IT85_C0TCR);
+	it8709_wr(dev, (it8709_rr(dev, IT85_C0TCR) & ~(IT85_TXMPM | IT85_TXMPW))
+			| IT85_TXRLE | IT85_TXENDF | IT85_TXMPM_DEFAULT
+			| IT85_TXMPW_DEFAULT,
+		  IT85_C0TCR);
 
 	/* program the carrier parameters */
 	ite_set_carrier_params(dev);
-- 
1.7.1

