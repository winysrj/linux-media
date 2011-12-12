Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:48484 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab1LLLTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 06:19:12 -0500
Message-ID: <4EE5E0BE.4060300@kolumbus.fi>
Date: Mon, 12 Dec 2011 13:08:46 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Ninja <Ninja15@gmx.de>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Mantis CAM not SMP safe / Activating CAM on Technisat Skystar
 HD2 (DVB-S2)
References: <4EC052CE.1080002@gmx.de> <4EE2A06D.7070901@gmx.de>
In-Reply-To: <4EE2A06D.7070901@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/10/2011 01:57 AM, Ninja wrote:
> Hi,
>
> has anyone an idea how the SMP problems could be fixed?

You could turn on Mantis Kernel module's debug messages.
It could tell you the emitted interrupts.

One risky thing with the Interrupt handler code is that
MANTIS_GPIF_STATUS is cleared, even though IRQ0 isn't active yet.
This could lead to a rare starvation of the wait queue you described.
I supplied a patch below. Does it help?

> I did some further investigation. When comparing the number of interrupts with all cores enabled and the interrupts with only one core enabled it seems like only the IRQ0 changed, the other IRQs and the total number stays quite the same:
>
> 4 Cores:
> All IRQ/sec: 493
> Masked IRQ/sec: 400
> Unknown IRQ/sec: 0
> DMA/sec: 400
> IRQ-0/sec: 143
> IRQ-1/sec: 0
> OCERR/sec: 0
> PABRT/sec: 0
> RIPRR/sec: 0
> PPERR/sec: 0
> FTRGT/sec: 0
> RISCI/sec: 258
> RACK/sec: 0
>
> 1 Core:
> All IRQ/sec: 518
> Masked IRQ/sec: 504
> Unknown IRQ/sec: 0
> DMA/sec: 504
> IRQ-0/sec: 246
> IRQ-1/sec: 0
> OCERR/sec: 0
> PABRT/sec: 0
> RIPRR/sec: 0
> PPERR/sec: 0
> FTRGT/sec: 0
> RISCI/sec: 258
> RACK/sec: 0
>
> So, where might be the problem?
Turning on Mantis debug messages, might tell the difference between these interrupts.

....
> I hope somebody can help, because I think we are very close to a fully functional CAM here.
> I ran out of things to test to get closer to the solution :(
> Btw: Is there any documentation available for the mantis PCI bridge?
Not that I know.

>
> Manuel
>
>
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


Regards,
Marko Ristola

----------------------- PATCH ------------------------------
Mantis/Hopper: Check and clear GPIF status bits only when IRQ0 bit is active.

Signed-off-by: Marko Ristola <Marko.Ristola@kolumbus.fi>

diff --git a/drivers/media/dvb/mantis/hopper_cards.c b/drivers/media/dvb/mantis/hopper_cards.c
index 71622f6..c2084e9 100644
--- a/drivers/media/dvb/mantis/hopper_cards.c
+++ b/drivers/media/dvb/mantis/hopper_cards.c
@@ -84,15 +84,6 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
  	if (!(stat & mask))
  		return IRQ_NONE;
  
-	rst_mask  = MANTIS_GPIF_WRACK  |
-		    MANTIS_GPIF_OTHERR |
-		    MANTIS_SBUF_WSTO   |
-		    MANTIS_GPIF_EXTIRQ;
-
-	rst_stat  = mmread(MANTIS_GPIF_STATUS);
-	rst_stat &= rst_mask;
-	mmwrite(rst_stat, MANTIS_GPIF_STATUS);
-
  	mantis->mantis_int_stat = stat;
  	mantis->mantis_int_mask = mask;
  	dprintk(MANTIS_DEBUG, 0, "\n-- Stat=<%02x> Mask=<%02x> --", stat, mask);
@@ -101,6 +92,16 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
  	}
  	if (stat & MANTIS_INT_IRQ0) {
  		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			    MANTIS_GPIF_OTHERR |
+			    MANTIS_SBUF_WSTO   |
+			    MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		rst_stat &= rst_mask;
+		mmwrite(rst_stat, MANTIS_GPIF_STATUS);
+
  		mantis->gpif_status = rst_stat;
  		wake_up(&ca->hif_write_wq);
  		schedule_work(&ca->hif_evm_work);
diff --git a/drivers/media/dvb/mantis/mantis_cards.c b/drivers/media/dvb/mantis/mantis_cards.c
index c2bb90b..109a5fb 100644
--- a/drivers/media/dvb/mantis/mantis_cards.c
+++ b/drivers/media/dvb/mantis/mantis_cards.c
@@ -92,15 +92,6 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
  	if (!(stat & mask))
  		return IRQ_NONE;
  
-	rst_mask  = MANTIS_GPIF_WRACK  |
-		    MANTIS_GPIF_OTHERR |
-		    MANTIS_SBUF_WSTO   |
-		    MANTIS_GPIF_EXTIRQ;
-
-	rst_stat  = mmread(MANTIS_GPIF_STATUS);
-	rst_stat &= rst_mask;
-	mmwrite(rst_stat, MANTIS_GPIF_STATUS);
-
  	mantis->mantis_int_stat = stat;
  	mantis->mantis_int_mask = mask;
  	dprintk(MANTIS_DEBUG, 0, "\n-- Stat=<%02x> Mask=<%02x> --", stat, mask);
@@ -109,6 +100,15 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
  	}
  	if (stat & MANTIS_INT_IRQ0) {
  		dprintk(MANTIS_DEBUG, 0, "<%s>", label[1]);
+		rst_mask  = MANTIS_GPIF_WRACK  |
+			    MANTIS_GPIF_OTHERR |
+			    MANTIS_SBUF_WSTO   |
+			    MANTIS_GPIF_EXTIRQ;
+
+		rst_stat  = mmread(MANTIS_GPIF_STATUS);
+		rst_stat &= rst_mask;
+		mmwrite(rst_stat, MANTIS_GPIF_STATUS);
+
  		mantis->gpif_status = rst_stat;
  		wake_up(&ca->hif_write_wq);
  		schedule_work(&ca->hif_evm_work);
