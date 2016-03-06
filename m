Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbcCFNjv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Mar 2016 08:39:51 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
	Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Subject: [PATCH 4/6] [media] st-rc: prevent a endless loop
Date: Sun,  6 Mar 2016 10:39:20 -0300
Message-Id: <087329695244e466f0c2d9a3a58e10ad399cd674.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
In-Reply-To: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
References: <076989c7736719982a1bc9557d7db072910d8efe.1457271549.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As warned by smatch:
	drivers/media/rc/st_rc.c:110 st_rc_rx_interrupt() warn: this loop depends on readl() succeeding

as readl() might fail, with likely means some unrecovered error,
let's loop only if it succeeds.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/rc/st_rc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/st_rc.c b/drivers/media/rc/st_rc.c
index 1fa0c9d1c508..151bfe2aea55 100644
--- a/drivers/media/rc/st_rc.c
+++ b/drivers/media/rc/st_rc.c
@@ -99,7 +99,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
 	unsigned int symbol, mark = 0;
 	struct st_rc_device *dev = data;
 	int last_symbol = 0;
-	u32 status;
+	int status;
 	DEFINE_IR_RAW_EVENT(ev);
 
 	if (dev->irq_wake)
@@ -107,7 +107,7 @@ static irqreturn_t st_rc_rx_interrupt(int irq, void *data)
 
 	status  = readl(dev->rx_base + IRB_RX_STATUS);
 
-	while (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW)) {
+	while (status > 0 && (status & (IRB_FIFO_NOT_EMPTY | IRB_OVERFLOW))) {
 		u32 int_status = readl(dev->rx_base + IRB_RX_INT_STATUS);
 		if (unlikely(int_status & IRB_RX_OVERRUN_INT)) {
 			/* discard the entire collection in case of errors!  */
-- 
2.5.0

