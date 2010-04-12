Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:50703 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0DLUIf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 16:08:35 -0400
Message-ID: <4BC37DB2.3070107@pobox.com>
Date: Mon, 12 Apr 2010 16:08:18 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>
 <1267493641.4035.17.camel@palomino.walls.org> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
 <1270961760.5365.14.camel@palomino.walls.org>
 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
 <1271012464.24325.34.camel@palomino.walls.org>
In-Reply-To: <1271012464.24325.34.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/10 03:01 PM, Andy Walls wrote:
>
> I would be interested in hearing how frequent these patches show "forced
> audio standard" for you:
..

The MythTV box here has many tuners, most of which are not used every power-up.
But mythbackend _always_ initializes all tuners, and pre-tunes them to their startup channel
each time the system boots up to record/play something.

So.. in the logs from the other night, there are some "fallback" messages.
But since the HVR1600 was not actually used to record anything,
I don't know for sure if the audio fallback actually "worked",
other than that v4l-ctl reported non-muted audio afterwards.

The abridged syslog is below.
Something I find interesting, is that it reported having to
fallback twice on this boot (once during the initial anti-stutter tune,
and again when mythbackend started up).

I wonder if this means that once the audio bug is present,
it remains present until the next time the driver is loaded/unloaded.

Which matches previous observations.
The fallback (hopefully) works around this, but there's still a bug
somewhere that is preventing the audio from working without the fallback.

Cheers

Mark Lord

* * * *

Apr 12 03:56:55 duke kernel: cx18:  Start initialization, version 1.4.0
Apr 12 03:56:55 duke kernel: cx18-0: Initializing card 0
Apr 12 03:56:55 duke kernel: cx18-0: Autodetected Hauppauge card
Apr 12 03:56:55 duke kernel: cx18 0000:05:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr 12 03:56:55 duke kernel: cx18-0: Unreasonably low latency timer, setting to 64 (was 2)
Apr 12 03:56:55 duke kernel: cx18-0: cx23418 revision 01010000 (B)
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: Hauppauge model 74551, rev C1A3, serial# 1752579
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: MAC address is 00:0d:fe:1a:be:03
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: tuner model is TCL MFNM05-4 (idx 103, type 43)
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: audio processor is CX23418 (idx 38)
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: decoder processor is CX23418 (idx 31)
Apr 12 03:56:55 duke kernel: tveeprom 1-0050: has radio
Apr 12 03:56:55 duke kernel: cx18-0: Autodetected Hauppauge HVR-1600
Apr 12 03:56:55 duke kernel: cx18-0: Simultaneous Digital and Analog TV capture supported
Apr 12 03:56:55 duke kernel: IRQ 18/cx18-0: IRQF_DISABLED is not guaranteed on shared IRQs
Apr 12 03:56:55 duke kernel: tuner 2-0043: chip found @ 0x86 (cx18 i2c driver #0-1)
Apr 12 03:56:55 duke kernel: tda9887 2-0043: creating new instance
Apr 12 03:56:55 duke kernel: tda9887 2-0043: tda988[5/6/7] found
Apr 12 03:56:55 duke kernel: tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
Apr 12 03:56:55 duke kernel: cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
Apr 12 03:56:55 duke kernel: tuner-simple 2-0061: creating new instance
Apr 12 03:56:55 duke kernel: tuner-simple 2-0061: type set to 43 (Philips NTSC MK3 (FM1236MK3 or FM1236/F))
Apr 12 03:56:55 duke kernel: cx18-0: Registered device video1 for encoder MPEG (64 x 32.00 kB)
Apr 12 03:56:55 duke kernel: DVB: registering new adapter (cx18)
Apr 12 03:56:55 duke kernel: MXL5005S: Attached at address 0x63
Apr 12 03:56:55 duke kernel: DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
Apr 12 03:56:55 duke kernel: cx18-0: DVB Frontend registered
Apr 12 03:56:55 duke kernel: cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
Apr 12 03:56:55 duke kernel: cx18-0: Registered device video33 for encoder YUV (20 x 101.25 kB)
Apr 12 03:56:55 duke kernel: cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
Apr 12 03:56:55 duke kernel: cx18-0: Registered device video25 for encoder PCM audio (256 x 4.00 kB)
Apr 12 03:56:55 duke kernel: cx18-0: Registered device radio1 for encoder radio
Apr 12 03:56:55 duke kernel: cx18-0: Initialized card: Hauppauge HVR-1600
Apr 12 03:56:55 duke kernel: cx18:  End initialization

Apr 12 03:56:58 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
Apr 12 03:56:58 duke kernel: cx18-0: loaded v4l-cx23418-cpu.fw firmware (158332 bytes)
Apr 12 03:56:58 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
Apr 12 03:56:58 duke kernel: cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000 (141200 bytes)
Apr 12 03:56:58 duke kernel: cx18-0: FW version: 0.0.74.0 (Release 2007/03/12)
Apr 12 03:56:58 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-cpu.fw
Apr 12 03:56:59 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-apu.fw
Apr 12 03:56:59 duke kernel: cx18 0000:05:03.0: firmware: requesting v4l-cx23418-dig.fw
Apr 12 03:56:59 duke kernel: cx18-0 843: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
Apr 12 03:56:59 duke kernel: cx18-0 843: verified load of v4l-cx23418-dig.fw firmware (16382 bytes)

Apr 12 03:57:00 duke kernel: ivtv 0000:05:02.0: firmware: requesting v4l-cx2341x-enc.fw
Apr 12 03:57:00 duke kernel: ivtv0: Loaded v4l-cx2341x-enc.fw firmware (376836 bytes)
Apr 12 03:57:00 duke kernel: ivtv0: Encoder revision: 0x02060039

Apr 12 03:57:01 duke logger: /usr/local/bin/enable_hauppauge_remote.sh: reconfiguring driver
Apr 12 03:57:01 duke kernel: cx18_av_aud_detect_work: cx18/hvr1600 audio bug: doing fallback detection      <-------------------
Apr 12 03:57:01 duke kernel: input: i2c IR (Hauppauge) as /class/input/input5
Apr 12 03:57:01 duke kernel: irrcv0: i2c IR (Hauppauge) as /class/irrcv/irrcv0
Apr 12 03:57:01 duke kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c driver #0]
Apr 12 03:57:01 duke logger: /usr/local/bin/enable_hauppauge_remote.sh: waiting for device(s)

Apr 12 03:57:02 duke logger[4238]: /usr/bin/input-kbd -f /usr/local/bin/hauppauge_remote.conf 5
Apr 12 03:57:02 duke logger: /dev/video1: fix_hvr1600_audio.sh: Pre-initializing

Apr 12 03:57:04 duke logger: /dev/video1: fix_hvr1600_audio.sh: HVR1600/cx18 audio ok.
Apr 12 03:57:04 duke nanny.mythbackend[4263]: mythbackend[4265] started

Apr 12 03:57:20 duke /usr/local/bin/antenna_switcher[4828]: Selecting '2C' (hvr1600)
Apr 12 03:57:20 duke /usr/local/bin/antenna_switcher[4828]: writing 0x08 [- - - - 1 - - -]

Apr 12 03:57:22 duke logger: channel_change: /dev/video1: cx18/hvr1600 audio ok.
Apr 12 03:57:22 duke kernel: cx18_av_aud_detect_work: cx18/hvr1600 audio bug: doing fallback detection      <-------------------
Apr 12 03:57:22 duke /usr/local/bin/antenna_switcher[4858]: Selecting '1D' (pvr250)
Apr 12 03:57:22 duke /usr/local/bin/antenna_switcher[4858]: writing 0x0b [- - - - 1 - 1 1]
Apr 12 03:57:23 duke logger: channel_change: /dev/video0: ivtv/pvr250 audio ok.

Apr 12 03:59:31 duke /usr/local/bin/antenna_switcher[5603]: Selecting '1C' (pvr250)
Apr 12 03:59:31 duke /usr/local/bin/antenna_switcher[5603]: writing 0x0a [- - - - 1 - 1 -]
Apr 12 03:59:32 duke logger: channel_change: /dev/video0: ivtv/pvr250 audio ok.
