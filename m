Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbZC0BEp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 21:04:45 -0400
Received: from 200.220.139.66.nipcable.com ([200.220.139.66] helo=pedra.chehab.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Ln0V1-0005Zj-Or
	for linux-media@vger.kernel.org; Fri, 27 Mar 2009 01:04:44 +0000
Date: Thu, 26 Mar 2009 22:04:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] pluto2: silence spew of card hung up messages
Message-ID: <20090326220439.2d84f9e5@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Forwarded message:

Date: Thu, 26 Mar 2009 20:47:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: [PATCH] pluto2: silence spew of card hung up messages


If the card is ejected on some systems you get a spew of messages as other
shared IRQ devices interrupt between the card eject and the card IRQ
disable.

We don't need to spew them all out

Closes #7472

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/media/dvb/pluto2/pluto2.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)


diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index d101b30..ee89623 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -116,6 +116,7 @@ struct pluto {
 
 	/* irq */
 	unsigned int overflow;
+	unsigned int dead;
 
 	/* dma */
 	dma_addr_t dma_addr;
@@ -336,8 +337,10 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	if (tscr == 0xffffffff) {
-		// FIXME: maybe recover somehow
-		dev_err(&pluto->pdev->dev, "card hung up :(\n");
+		if (pluto->dead == 0)
+			dev_err(&pluto->pdev->dev, "card has hung or been ejected.\n");
+		/* It's dead Jim */
+		pluto->dead = 1;
 		return IRQ_HANDLED;
 	}
 





Cheers,
Mauro
