Return-path: <linux-media-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:36994 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934474AbeGJQS5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 12:18:57 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-media@vger.kernel.org
Cc: tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2nd REPOST 4/5] media: tm6000: use irqsave() in USB's complete callback
Date: Tue, 10 Jul 2018 18:18:32 +0200
Message-Id: <20180710161833.2435-5-bigeasy@linutronix.de>
In-Reply-To: <20180710161833.2435-1-bigeasy@linutronix.de>
References: <20180710161833.2435-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB completion callback does not disable interrupts while acquiring
the lock. We want to remove the local_irq_disable() invocation from
__usb_hcd_giveback_urb() and therefore it is required for the callback
handler to disable the interrupts while acquiring the lock.
The callback may be invoked either in IRQ or BH context depending on the
USB host controller.
Use the _irqsave() variant of the locking primitives.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/media/usb/tm6000/tm6000-video.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm=
6000/tm6000-video.c
index 96055de6e8ce..7d268f2404e1 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -419,6 +419,7 @@ static void tm6000_irq_callback(struct urb *urb)
 {
 	struct tm6000_dmaqueue  *dma_q =3D urb->context;
 	struct tm6000_core *dev =3D container_of(dma_q, struct tm6000_core, vidq);
+	unsigned long flags;
 	int i;
=20
 	switch (urb->status) {
@@ -436,9 +437,9 @@ static void tm6000_irq_callback(struct urb *urb)
 		break;
 	}
=20
-	spin_lock(&dev->slock);
+	spin_lock_irqsave(&dev->slock, flags);
 	tm6000_isoc_copy(urb);
-	spin_unlock(&dev->slock);
+	spin_unlock_irqrestore(&dev->slock, flags);
=20
 	/* Reset urb buffers */
 	for (i =3D 0; i < urb->number_of_packets; i++) {
--=20
2.18.0
