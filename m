Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54452 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab1KQC3M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 21:29:12 -0500
Received: by eye27 with SMTP id 27so1282025eye.19
        for <linux-media@vger.kernel.org>; Wed, 16 Nov 2011 18:29:11 -0800 (PST)
Date: Thu, 17 Nov 2011 12:29:04 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: Stefan Ringel <stefan.ringel@arcor.de>, linux-media@vger.kernel.org
Subject: Re: good programm for FM radio
Message-ID: <20111117122904.3035d63c@glory.local>
In-Reply-To: <4EC3CE52.2000408@arcor.de>
References: <20111115174052.1dee9737@glory.local>
	<4EC3CE52.2000408@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

kradio from Debian Squeeze 0.1.1.1-20061112-4 with KDE 4.4.5 doesn't work.
It wants V4L1 API.

I think the tm6000-alsa has some problem with alsa compatibility.
This log when start gnomeradio with arecord helper

[ 2198.067414] pcm_open start
[ 2198.067417] pcm_open stop
[ 2198.067554] hw_params start
[ 2198.067556] tm6000 #0/1: Allocating buffer
[ 2198.067577] hw_params stop
[ 2198.067622] tm6000 #0/1: starting capture
[ 2198.067624] tm6000 #0/1: Starting audio DMA
[ 2198.070012] ALSA sound/pci/hda/hda_intel.c:1732 azx_pcm_prepare: bufsize=0x10000, format=0x31
[ 2198.070022] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x31
[ 2198.072038] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x31
[ 2198.074015] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x31
[ 2198.076015] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x31
[ 2198.078014] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x31
[ 2200.298157] tm6000: open called (dev=radio0)
[ 2201.380947] vidioc_s_frequency
[ 2208.067017] ALSA sound/core/pcm_lib.c:1805 capture write error (DMA or IRQ trouble?)
[ 2208.067512] tm6000 #0/1: stopping capture
[ 2208.067514] tm6000 #0/1: Stopping audio DMA
[ 2208.108146] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x2
[ 2208.108152] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x3
[ 2208.108157] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x4
[ 2208.108162] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x5
[ 2208.108167] ALSA sound/pci/hda/hda_codec.c:1463 hda_codec_cleanup_stream: NID=0x6
[ 2223.847895] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 2223.853650] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[ 2223.859394] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

This log when start watch TV via mplayer

[  526.160673] tm6000: open called (dev=video0)
[  530.279059] vidioc_s_frequency
[  530.952893] pcm_open start
[  530.952896] pcm_open stop
[  530.953019] hw_params start
[  530.953022] tm6000 #0/1: Allocating buffer
[  530.953049] hw_params stop

[  530.953236] hw_params start
[  530.953238] tm6000 #0/1: Allocating buffer
[  530.953240] tm6000 #0/1: Freeing buffer
[  530.953254] hw_params stop
[  530.970871] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  530.976625] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
<snip>
[  531.233367] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)
[  531.239114] tm6000 tm6000_irq_callback :urb resubmit failed (error=-1)

This part is not available when start radio. No start IRQ callback befor start DMA.

[  531.383461] ALSA sound/pci/hda/hda_intel.c:1732 azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  531.383470] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  531.383474] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  531.383477] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  531.383480] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  531.383483] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  531.383496] ALSA sound/pci/hda/hda_intel.c:1732 azx_pcm_prepare: bufsize=0x10000, format=0x4011
[  531.383502] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  531.383505] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  531.383509] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  531.383512] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  531.383515] ALSA sound/pci/hda/hda_codec.c:1400 hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  531.392039] tm6000 #0/1: starting capture
[  531.392042] tm6000 #0/1: Starting audio DMA
[  531.394037] tm6000 #0/1: Copying 180 bytes at f8264000[0] - buf size=48000 x 4
[  531.394057] tm6000 #0/1: Copying 180 bytes at f8264000[45] - buf size=48000 x 4
[  531.394077] tm6000 #0/1: Copying 180 bytes at f8264000[90] - buf size=48000 x 4
[  531.394096] tm6000 #0/1: Copying 180 bytes at f8264000[135] - buf size=48000 x 4
[  531.394114] tm6000 #0/1: Copying 180 bytes at f8264000[180] - buf size=48000 x 4

> Am 15.11.2011 08:40, schrieb Dmitri Belimov:
> > Hi
> >
> > Right now the gnomeradio don't work with tm6000 USB stick. No any
> > audio. I try use this script:
> >
> > #!/bin/sh
> >
> > if [ -f /usr/bin/arecord ]; then
> > arecord -q -D hw:1,0 -r 48000 -c 2 -f S16_LE | aplay -q -&
> > fi
> >
> > if [ -f /usr/bin/gnomeradio ]; then
> > gnomeradio -f 102.6
> > fi
> >
> > pid=`pidof arecord`
> >
> > if [ $pid ]; then
> > kill -9 $pid
> > fi
> >
> > But arecord return input/output error.
> > Anyone know good programm for FM radio worked with v4l2 and alsa??
> > I can't understand tm6000 work with FM radio or not.
> >
> > With my best regards, Dmitry.
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Dmitri, have you test kradio4 (it can v4l2)?
