Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:55787 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0FTLha (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 07:37:30 -0400
Message-ID: <4C1DFD75.3080606@kolumbus.fi>
Date: Sun, 20 Jun 2010 14:37:25 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Mantis: append tasklet maintenance for DVB stream delivery
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi

I have a patch that should fix possible memory corruption problems in 
Mantis drivers
with tasklets after DMA transfer has been stopped.
In the patch tasklet is enabled only for DVB stream delivery, at end of 
DVB stream delivery tasklet is disabled again.
The lack of tasklet maintenance might cause problems with following 
schedulings:

1. dvb_dmxdev_filter_stop() calls mantis_dvb_stop_feed: mantis_dma_stop()
2. dvb_dmxdev_filter_stop() calls release_ts_feed() or some other filter 
freeing function.
3. tasklet: mantis_dma_xfer calls dvb_dmx_swfilter to copy DMA buffer's 
content into freed memory, accessing freed spinlocks.
This case might occur while tuning into another frequency.
Perhaps cdurrhau has found some version from this bug at 
http://www.linuxtv.org/pipermail/linux-dvb/2010-June/032688.html:
 > This is what I get on the remote console via IPMI:
 > 40849.442492] BUG: soft lockup - CPU#2 stuck for 61s! [section
 > handler:4617]


The following schedule might also be a problem:
1. mantis_core_exit: mantis_dma_stop()
2. mantis_core_exit: mantis_dma_exit().
3. run tasklet (with another CPU?), accessing memory freed by 
mantis_dma_exit().
This case might occur with rmmod.

The following patch tries to deactivate the tasklet in mantis_dma_stop 
and activate it in mantis_dma_start, thus avoiding these cases.

Marko Ristola


diff --git a/drivers/media/dvb/mantis/mantis_dma.c 
b/drivers/media/dvb/mantis/mantis_dma.c
index 46202a4..cf502a6 100644
--- a/drivers/media/dvb/mantis/mantis_dma.c
+++ b/drivers/media/dvb/mantis/mantis_dma.c
@@ -217,12 +217,14 @@ void mantis_dma_start(struct mantis_pci *mantis)
      mmwrite(MANTIS_FIFO_EN | MANTIS_DCAP_EN
                     | MANTIS_RISC_EN, MANTIS_DMA_CTL);

+    tasklet_enable(&mantis->tasklet);
  }

  void mantis_dma_stop(struct mantis_pci *mantis)
  {
      u32 stat = 0, mask = 0;

+    tasklet_disable(&mantis->tasklet);
      stat = mmread(MANTIS_INT_STAT);
      mask = mmread(MANTIS_INT_MASK);
      dprintk(MANTIS_DEBUG, 1, "Mantis Stop DMA engine");
diff --git a/drivers/media/dvb/mantis/mantis_dvb.c 
b/drivers/media/dvb/mantis/mantis_dvb.c
index 99d82ee..0c29f01 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -216,6 +216,7 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)

      dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet, 
&mantis->demux.dmx);
      tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long) 
mantis);
+    tasklet_disable_nosync(&mantis->tasklet);
      if (mantis->hwconfig) {
          result = config->frontend_init(mantis, mantis->fe);
          if (result < 0) {
