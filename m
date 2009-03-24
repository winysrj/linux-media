Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n2OAxu2q018082
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 06:59:56 -0400
Received: from www.etchedpixels.co.uk (earthlight.etchedpixels.co.uk
	[81.2.110.250])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n2OAxceH021373
	for <video4linux-list@redhat.com>; Tue, 24 Mar 2009 06:59:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 24 Mar 2009 11:00:39 +0000
Message-ID: <20090324105251.9763.24193.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: 
Subject: [PATCH] pluto2: silence spew of card hung up messages
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

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
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
