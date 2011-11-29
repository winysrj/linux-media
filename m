Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1K2Ltj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 06:49:39 -0500
Message-ID: <4ED4C6CB.1000609@redhat.com>
Date: Tue, 29 Nov 2011 12:49:31 +0100
From: "Fabio M. Di Nitto" <fdinitto@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: "Fabio M. Di Nitto" <fdinitto@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Stefan Ringel <linuxtv@stefanringel.de>,
	Dmitri Belimov <d.belimov@gmail.com>
Subject: Re: HVR-900H dvb-t regression(s)
References: <4ED39D88.507@redhat.com> <4ED3F81F.303@redhat.com>
In-Reply-To: <4ED3F81F.303@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2011 10:07 PM, Mauro Carvalho Chehab wrote:

> Btw, Stefan sent some fixes to the ML. I'll test if the patch solves the
> audio issue with HVR-900H on analog mode.

I just finished testing those ones and they seem to fix my specific issue.

There is still one thing that puzzles me, but maybe it´s just my
misunderstanding on how dvb-t protocol works.

> root@cerberus:~# scan -a 0 /home/fabbione/dk
> scanning /home/fabbione/dk
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 586000000 0 2 9 3 1 3 0
>>>> tune to: 586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> 0x0000 0x0065: pmt_pid 0x0065 DR -- DR1 (running)
> 0x0000 0x00d9: pmt_pid 0x0835 TV 2 -- TV 2 (Lorry) (running)
> 0x0000 0x01a1: pmt_pid 0x0191 DIGI-TV -- Hovedstaden (running)
> 0x0000 0x0066: pmt_pid 0x00c9 DR -- DR2 (running)
> 0x0000 0x006f: pmt_pid 0x0068 DR -- DR Synstolkning (running)
> 0x0000 0x0051: pmt_pid 0x0051 DIGI-TV -- OAD MUX1 (running)
> Network Name 'Mux1 kbhv-glx'
>>>> tune to: 730000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
> WARNING: filter timeout pid 0x0011
> WARNING: filter timeout pid 0x0000
> WARNING: filter timeout pid 0x0010
> dumping lists (6 services)
> OAD MUX1:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:0:0:81
> DR1:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:111:121:101
> DR2:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:211:221:102
> DR Synstolkning:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:111:122:111
> TV 2 (Lorry):586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:2111:2121:217
> Hovedstaden:586000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE:411:421:417
> Done.

In my dk file I only specify:

> root@cerberus:~# cat /home/fabbione/dk
> # Denmark, whole country
> # Created from http://www.digi-tv.dk/Indhold_og_tilbud/frekvenser.asp
> # and http://www.digi-tv.dk/Sendenettets_opbygning/
> # T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
> T 586000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE

because for simple testing I don´t need to scan the whole spectrum.

Now, in some versions of the driver, it automatically picks up 730MHz (I
know it´s a good frequency in the area as I get it at my home and shares
the same channels as 586).

What I noticed is that sometimes it tunes and time outs, sometime it
tunes and scan correctly, but with the latest driver from HEAD, it
failed completely to tune with the usual error.
Not sure if this info might be relevant.

As for analog I am not able to even get scantv to find the channel
broadcasted from the VCR. I´ll need to investigate if it´s a problem
with the VCR/tuner/driver etc. (there is no analog broadcast in dk).

So far this is what I get:

> scantv -n PAL-DK -f europe-west -c /dev/video0 -C /dev/null 
> [global]
> freqtab = europe-west
> 
> [defaults]
> input = Television
> norm = PAL-DK
> 
> ioctl: VIDIOC_S_CTRL(id=9963778;value=0): Inappropriate ioctl for device
> ioctl: VIDIOC_S_CTRL(id=9963776;value=0): Inappropriate ioctl for device
> ioctl: VIDIOC_S_CTRL(id=9963779;value=0): Inappropriate ioctl for device
> ioctl: VIDIOC_S_CTRL(id=9963777;value=130): Inappropriate ioctl for device
> scanning channel list europe-west...
> E2   ( 48.25 MHz): ioctl: VIDIOC_S_CTRL(id=9963785;value=1): Inappropriate ioctl for device
> ioctl: VIDIOC_S_CTRL(id=9963785;value=0): Inappropriate ioctl for device
> no station
(repeat the above for every single channel and no channels found)

The result is pretty much the same with or without tm6000-dvb loaded.

Fabio
