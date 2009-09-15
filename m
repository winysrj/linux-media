Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:53581 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909AbZIOFm5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 01:42:57 -0400
Subject: Re: Audio drop on saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: David Liontooth <lionteeth@cogweb.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4AAF232F.9060204@cogweb.net>
References: <4AAEFEC9.3080405@cogweb.net>
	 <20090915000841.56c24dd6@pedra.chehab.org>  <4AAF11EC.3040800@cogweb.net>
	 <1252988501.3250.62.camel@pc07.localdom.local>
	 <4AAF232F.9060204@cogweb.net>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 07:36:40 +0200
Message-Id: <1252993000.3250.97.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 14.09.2009, 22:16 -0700 schrieb David Liontooth:
> hermann pitton wrote:
> > Am Montag, den 14.09.2009, 21:02 -0700 schrieb David Liontooth:
> >   
> >> <snip>
> >> We've been using saa7135 cards for several years with relatively few 
> >> incidents, but they occasionally drop audio.
> >> I've been unable to find any pattern in the audio drops, so I haven't 
> >> reported it -- I have no way to reproduce the error, but it happens 
> >> regularly, affecting between 3 and 5% of recordings. Audio will 
> >> sometimes drop in the middle of a recording and then resume, or else 
> >> work fine on the next recording.
> >>     
> >
> > Hi Dave,
> >
> > hmm, losing audio on three to five percent of the recordings is a lot!
> >
> > When we started to talk to each other, we had only saa7134 PAL/SECAM
> > devices over here.
> >
> > That has changed a lot, but still no System-M here.
> >
> > The kernel thread detecting audio on saa7133/35/31e behaves different
> > from the one on saa7134.
> >
> > But if you let it run with audio_debug=1, you should have something in
> > the logs when losing the audio. The kernel audio detection thread must
> > have been started without success or id find the right thing again. I
> > would assume caused by a weaker signal in between.
> >
> > Do you know about the insmod option audio_ddep?
> >
> > It is pretty hidden and I almost must look it up myself in the code.
> >
> > Cheers,
> > Hermann
> >
> >   
> OK, I'll try running with audio_debug=1. Could you clarify what you mean 
> by "The kernel audio detection thread must have been started without 
> success or id find the right thing again"? An audio drop can be 
> initiated at any point in the recording. A weak signal is a good guess, 
> but I've never noticed a correlation with video quality.

You said audio sometimes recovers, than the kernel thread did detect it
again, else failed on the pilots.

> I didn't know about audio_ddep -- what does it do? I'm not seeing it in 
> modinfo.

Oh, are you sure?

depends:        videobuf-core,videobuf-dma-sg,ir-common,i2c-core,videodev,tveeprom,v4l2-common
vermagic:       2.6.30.1 SMP preempt mod_unload
parm:           disable_ir:disable infrared remote support (int)
parm:           ir_debug:enable debug messages [IR] (int)
parm:           pinnacle_remote:Specify Pinnacle PCTV remote: 0=coloured, 1=grey (defaults to 0) (int)
parm:           ir_rc5_remote_gap:int
parm:           ir_rc5_key_timeout:int
parm:           repeat_delay:delay before key repeat started (int)
parm:           repeat_period:repeat period between keypresses when key is down (int)
parm:           disable_other_ir:disable full codes of alternative remotes from other manufacturers (int)
parm:           video_debug:enable debug messages [video] (int)
parm:           gbuffers:number of capture buffers, range 2-32 (int)
parm:           noninterlaced:capture non interlaced video (int)
parm:           secam:force SECAM variant, either DK,L or Lc (string)
parm:           vbi_debug:enable debug messages [vbi] (int)
parm:           vbibufs:number of vbi buffers, range 2-32 (int)
parm:           audio_debug:enable debug messages [tv audio] (int)
parm:           audio_ddep:audio ddep overwrite (int)
................^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
parm:           audio_clock_override:int
parm:           audio_clock_tweak:Audio clock tick fine tuning for cards with audio crystal that's slightly off (range [-1024 .. 1024]) (int)
parm:           ts_debug:enable debug messages [ts] (int)
parm:           tsbufs:number of ts buffers for read/write IO, range 2-32 (int)
parm:           ts_nr_packets:size of a ts buffers (in ts packets) (int)
parm:           i2c_debug:enable debug messages [i2c] (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           irq_debug:enable debug messages [IRQ handler] (int)
parm:           core_debug:enable debug messages [core] (int)
parm:           gpio_tracking:enable debug messages [gpio] (int)
parm:           alsa:enable/disable ALSA DMA sound [dmasound] (int)
parm:           latency:pci latency timer (int)
parm:           no_overlay:allow override overlay default (0 disables, 1 enables) [some VIA/SIS chipsets are known to have problem with overlay] (int)
parm:           video_nr:video device number (array of int)
parm:           vbi_nr:vbi device number (array of int)
parm:           radio_nr:radio device number (array of int)
parm:           tuner:tuner type (array of int)
parm:           card:card type (array of int)


> It would be fantastic to get this problem solved -- we've had to record 
> everything in parallel to avoid loss, and still very occasionally lose 
> sound.

It could also be something else, but that is the point to start.

It stops the kernel audio detection thread and tells him to believe that
only the norm given by insmod should be assumed.

It is some hex in saa7134-audio, don't know it off hand for NTSC.

Wait, i'll look it up. 0x40.

Good Luck,
Hermann




