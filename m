Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52657 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab0GIMcS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Jul 2010 08:32:18 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OXCkb-0001nz-3D
	for linux-media@vger.kernel.org; Fri, 09 Jul 2010 14:32:17 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:32:17 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 09 Jul 2010 14:32:17 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] Mantis: append tasklet maintenance for DVB stream delivery
Date: Fri, 09 Jul 2010 14:32:06 +0200
Message-ID: <87pqywu989.fsf@nemi.mork.no>
References: <4C1DFD75.3080606@kolumbus.fi> <87vd9dbyng.fsf@nemi.mork.no>
	<4C1E3C79.60108@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marko Ristola <marko.ristola@kolumbus.fi> writes:
> 20.06.2010 16:51, Bjørn Mork kirjoitti:
>> Note that mantis_core_exit() is never called.  Unless I've missed
>> something, the drivers/media/dvb/mantis/mantis_core.{h,c} files can
>> just be deleted.  They look like some development leftovers?
>>
>>    
> I see. mantis_core.ko kernel module exists though.
> Maybe the mantis/Makefile references for mantis_core.c, mantis.c and
> hopper.c are just some leftovers too.
>
> I moved tasklet_enable/disable calls into mantis_dvb.c where almost
> all other tasklet code is located.
>
> So the following reasoning still holds:
>
> 1. dvb_dmxdev_filter_stop() calls mantis_dvb_stop_feed: mantis_dma_stop()
> 2. dvb_dmxdev_filter_stop() calls release_ts_feed() or some other
> filter freeing function.
> 3. tasklet: mantis_dma_xfer calls dvb_dmx_swfilter to copy DMA
> buffer's content into freed memory, accessing freed spinlocks.
> This case might occur while tuning into another frequency.
> Perhaps cdurrhau has found some version from this bug at
> http://www.linuxtv.org/pipermail/linux-dvb/2010-June/032688.html:
>> This is what I get on the remote console via IPMI:
>> 40849.442492] BUG: soft lockup - CPU#2 stuck for 61s! [section
>> handler:4617]
>
>
> New reasoning for the patch (same as the one above, but from higher level):
> After dvb-core has called mantis-fe->stop_feed(dvbdmxfeed) the last
> time (count to zero),
> no data should ever be copied with dvb_dmx_swfilter() by a tasklet:
> the target structure might be in an unusable state.
> Caller of mantis_fe->stop_feed() assumes that feeding is stopped after
> stop_feed() has been called, ie. dvb_dmx_swfilter()
> isn't running, and won't be called.
>
> There is a risk that dvb_dmx_swfilter() references freed resources
> (memory or spinlocks or ???) causing instabilities.
> Thus tasklet_disable(&mantis->tasklet) must be called inside of
> mantis-fe->stop_feed(dvbdmxfeed) when necessary.
>
> Signed-off-by: Marko Ristola <marko.ristola@kolumbus.fi>


Tested-by: Bjørn Mork <bjorn@mork.no>

I have successfully used this patch with a "Terratec Cinergy C PCI HD"
card in a system with a quad-core CPU and one other DVB-C card.  I
believe it does improve stability under these conditions.

Don't know if this helps anyone, but I guess it can't harm in an
environment where there are noone willing to do even an Acked-by...



Bjørn


> diff --git a/drivers/media/dvb/mantis/mantis_dvb.c
> b/drivers/media/dvb/mantis/mantis_dvb.c
> index 99d82ee..a9864f7 100644
> --- a/drivers/media/dvb/mantis/mantis_dvb.c
> +++ b/drivers/media/dvb/mantis/mantis_dvb.c
> @@ -117,6 +117,7 @@ static int mantis_dvb_start_feed(struct
> dvb_demux_feed *dvbdmxfeed)
>      if (mantis->feeds == 1)     {
>          dprintk(MANTIS_DEBUG, 1, "mantis start feed & dma");
>          mantis_dma_start(mantis);
> +        tasklet_enable(&mantis->tasklet);
>      }
>
>      return mantis->feeds;
> @@ -136,6 +137,7 @@ static int mantis_dvb_stop_feed(struct
> dvb_demux_feed *dvbdmxfeed)
>      mantis->feeds--;
>      if (mantis->feeds == 0) {
>          dprintk(MANTIS_DEBUG, 1, "mantis stop feed and dma");
> +        tasklet_disable(&mantis->tasklet);
>          mantis_dma_stop(mantis);
>      }
>
> @@ -216,6 +218,7 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
>
>      dvb_net_init(&mantis->dvb_adapter, &mantis->dvbnet,
> &mantis->demux.dmx);
>      tasklet_init(&mantis->tasklet, mantis_dma_xfer, (unsigned long)
> mantis);
> +    tasklet_disable(&mantis->tasklet);
>      if (mantis->hwconfig) {
>          result = config->frontend_init(mantis, mantis->fe);
>          if (result < 0) {

