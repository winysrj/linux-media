Return-path: <mchehab@gaivota>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51419 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ADSBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 13:01:35 -0500
Message-ID: <4D235E24.3050405@kolumbus.fi>
Date: Tue, 04 Jan 2011 19:51:32 +0200
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hendrik Skarpeid <skarp@online.no>, stoth@kernellabs.com,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Summary of the pending patches up to Dec, 31 (26 patches)
References: <4D1DCF6A.2090505@redhat.com>
In-Reply-To: <4D1DCF6A.2090505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Dear Developers,

Happy New Year.

I'll try to describe my patches so that they would be more understandable.
First comment is for all dvb_dmx_swfilter() and dvb_dmx_swfilter_204() users: please test the performance improvement.
The second comment is mostly to convince Manu Abraham, but the concept might be useful for others too. Please read.

31.12.2010 14:41, Mauro Carvalho Chehab wrote:
> Dear Developers,
> 
> 		== Need more tests/acks from DVB users == 
> 
> Aug, 7 2010: Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function  http://patchwork.kernel.org/patch/118147  Marko Ristola <marko.ristola@kolumbus.fi>

This patch affects equally for both dvb_dmx_swfilter() and dvb_dmx_swfilter_204().
The resulting performance and functionality is similar with dvb_dmx_swfilter_packets().
dvb_dmx_swfilter(_204)() have robustness checks. Devices without such need
can still use dvb_dmx_swfilter_packets().

My performance patch helps especially with high volume 256-QAM TS streams containing for example HDTV
content by removing one unnecessary stream copy.
With "perf top", dvb_dmx_swfilter_204()'s CPU consumption reduced in the following way:

Without the patch dvb_dmx_swfilter_204() and dvb_dmx_swfilter_packet() took about equal amounts of CPU.
With the patch dvb_dmx_swfilter_204()'s CPU consumption went into 1/5 or 1/10 of the original (resulting minor CPU consumption).
dvb_dmx_swfilter_packet()'s CPU time was about as before.

Test environment was Fedora with VDR streaming HDTV into network.
I have tested the patch thoroughly (see for example https://patchwork.kernel.org/patch/108274).

The patch assumes that dvb_dmx_swfilter_packet() can eat data stream fast enough so that
the DVB card's DMA engine will not replace buffer content underneath of dvb_dmx_swfilter_204().

It would be helpful if someone using dvb_dmx_swfilter() could try the patch too: maybe nobody has tried it.
The benefit would be, that dvb_dmx_swfilter() is almost equally fast as the existing blatantly fast dvb_dmx_swfilter_packets() :)

> 
> ************************************************************************
> * I want to see people testing the above patch, as it seems to improve *
> * DVB performance by avoiding data copy.                               *
> ************************************************************************
> 
> 		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 
> 
> Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
> Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
> Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>

16Kb TS stream improvement: What do you think about this, Manu Abraham?

If high volume TS stream (256-QAM) with 50Mbits/s generates one interrupt
once per 4096 bytes, you have a problem.
Mantis driver copies 4096 bytes with one interrupt, into dvb_core's 128K buffer.
VDR reads data in big pieces (as much data as you get).
Network layer receives data in about 100K - 300K pieces from VDR.

So I think that it is unnecessary to interrupt other processes once per 4096 bytes, for 56Mbit/s streams.
With 16K / interrupt you reduce the number of interrupts into one quarter, without affecting VDR at all,
lessening unnecessary interrupts and giving CPU time to other processes.

The CPU might have some other things to do without wanting to get interrupted once per  (displaying HDTV, delivering HDTV stream to network). Mantis/Hopper kernel driver must process the whole high volume TS stream, although it might deliver only one radio channel forward.

I saw glitches with HDTV (followed by stream halt) even though the Mantis DVB card only delivered the data into the local network via VDR.
I don't have such single CPU computer anymore though.

16K comes from the fact that it is not good to try to overload dvb_core's 128K buffer. 3/4 of the interrupts are gone.
DVB driver does at least twice the number of interrupts compared to VDR reading the stream:
dvb_core's buffer is never empty when VDR asks more data.

Best regards,
Marko Ristola
