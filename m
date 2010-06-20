Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:53899 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab0FTQGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Jun 2010 12:06:20 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh03-2.mail.saunalahti.fi (Postfix) with SMTP id AEEA4EBC24
	for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 19:06:18 +0300 (EEST)
Received: from tammi.koti (a88-114-153-83.elisa-laajakaista.fi [88.114.153.83])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 8F0CEE51A4
	for <linux-media@vger.kernel.org>; Sun, 20 Jun 2010 19:06:17 +0300 (EEST)
Message-ID: <4C1E3C79.60108@kolumbus.fi>
Date: Sun, 20 Jun 2010 19:06:17 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Mantis: append tasklet maintenance for DVB stream delivery
References: <4C1DFD75.3080606@kolumbus.fi> <87vd9dbyng.fsf@nemi.mork.no>
In-Reply-To: <87vd9dbyng.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

20.06.2010 16:51, Bjørn Mork kirjoitti:
> Note that mantis_core_exit() is never called.  Unless I've missed
> something, the drivers/media/dvb/mantis/mantis_core.{h,c} files can
> just be deleted.  They look like some development leftovers?
>
>    
I see. mantis_core.ko kernel module exists though.
Maybe the mantis/Makefile references for mantis_core.c, mantis.c and 
hopper.c are just some leftovers too.

I moved tasklet_enable/disable calls into mantis_dvb.c where almost all 
other tasklet code is located.

So the following reasoning still holds:

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


New reasoning for the patch (same as the one above, but from higher level):
After dvb-core has called mantis-fe->stop_feed(dvbdmxfeed) the last time 
(count to zero),
no data should ever be copied with dvb_dmx_swfilter() by a tasklet: the 
target structure might be in an unusable state.
Caller of mantis_fe->stop_feed() assumes that feeding is stopped after 
stop_feed() has been called, ie. dvb_dmx_swfilter()
isn't running, and won't be called.

There is a risk that dvb_dmx_swfilter() references freed resources 
(memory or spinlocks or ???) causing instabilities.
Thus tasklet_disable(&mantis->tasklet) must be called inside of 
mantis-fe->stop_feed(dvbdmxfeed) when necessary.

Signed-off-by: Marko Ristola <marko.ristola@kolumbus.fi>

Marko

diff --git a/drivers/media/dvb/mantis/mantis_dvb.c 
b/drivers/media/dvb/mantis/mantis_dvb.c
index 99d82ee..a9864f7 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -117,6 +117,7 @@ static int mantis_dvb_start_feed(struct 
dvb_demux_feed *dvbdmxfeed)
      if (mantis->feeds == 1)     {
          dprintk(MANTIS_DEBUG, 1, "mantis start feed & dma");
          mantis_dma_start(mantis);
+        tasklet_enable(&mantis->tasklet);
      }

      return mantis->feeds;
@@ -136,6 +137,7 @@ static int mantis_dvb_stop_feed(struct 
dvb_demux_feed *dvbdmxfeed)
      mantis->feeds--;
      if (mantis->feeds == 0) {
          dprintk(MANTIS_DEBUG, 1, "mantis stop feed and dma");
+        tasklet_disable(&mantis->tasklet);
          mantis_dma_stop(mantis);
      }

@@ -216,6 +218,7 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)

      dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet, 
&mantis->demux.dmx);
      tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long) 
mantis);
+    tasklet_disable(&mantis->tasklet);
      if (mantis->hwconfig) {
          result = config->frontend_init(mantis, mantis->fe);
          if (result < 0) {

