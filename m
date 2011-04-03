Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:16137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab1DCOZW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Apr 2011 10:25:22 -0400
Message-ID: <4D98834D.70705@redhat.com>
Date: Sun, 03 Apr 2011 11:25:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge Nova-S remote control broken in 2.6.38
References: <1301830909.1709.32.camel@gagarin>
In-Reply-To: <1301830909.1709.32.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-04-2011 08:41, Lawrence Rust escreveu:
> I just installed a new 2.6.38.2 kernel and found that the remote control
> on my Hauppauge Nova-S plus is no longer working. dmesg shows that
> everything initialised OK:
> 
> [    8.002874] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
> [    8.100260] IR NEC protocol handler initialized
> [    8.132843] tveeprom 1-0050: Hauppauge model 92001, rev C1B1, serial# 2700305
> [    8.132853] tveeprom 1-0050: MAC address is 00:0d:fe:29:34:11
> [    8.132858] tveeprom 1-0050: tuner model is Conexant_CX24109 (idx 111, type 4)
> [    8.132864] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
> [    8.132870] tveeprom 1-0050: audio processor is CX883 (idx 32)
> [    8.132875] tveeprom 1-0050: decoder processor is CX883 (idx 22)
> [    8.132879] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
> [    8.132884] cx88[0]: hauppauge eeprom: model=92001
> [    8.229173] IR RC5(x) protocol handler initialized
> [    8.261811] Registered IR keymap rc-hauppauge-new
> [    8.272593] input: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:0b.2/rc/rc0/input3
> [    8.275331] IR RC6 protocol handler initialized
> [    8.278600] rc0: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:0b.2/rc/rc0
> [    8.510290] lirc_dev: IR Remote Control driver registered, major 251 
> [    8.581417] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
> [    8.581427] IR LIRC bridge handler initialized
> 
> cat /proc/bus/input/devices
> ...
> I: Bus=0001 Vendor=0070 Product=9202 Version=0001
> N: Name="cx88 IR (Hauppauge Nova-S-Plus "
> P: Phys=pci-0000:00:0b.2/ir0
> S: Sysfs=/devices/pci0000:00/0000:00:0b.2/rc/rc0/input3
> 
> But if I try to receive input events I see nothing:
> 
> sudo evtest /dev/input/event3
> Input driver version is 1.0.1
> Input device ID: bus 0x1 vendor 0x70 product 0x9202 version 0x1
> Input device name: "cx88 IR (Hauppauge Nova-S-Plus "
> Supported events:
> ...
> 
> If I enable debug output:
> 
> echo >/sys/module/rc_core/parameters/debug 2
> 
> and press a key, dmesg shows:
> 
> [  481.765937] ir_raw_event_set_idle: leave idle mode
> [  481.765948] ir_raw_event_store: sample: (01000us pulse)
> [  481.765970] ir_rc5_decode: RC5(x) decode started at state 0 (1000us pulse)
> [  481.765975] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
> [  481.765981] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
> [  481.765986] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
> [  481.765995] ir_lirc_decode: delivering 1000us pulse to lirc_dev
> [  481.773939] ir_raw_event_store: sample: (00750us space)
> [  481.773946] ir_raw_event_store: sample: (01000us pulse)
> [  481.773950] ir_raw_event_store: sample: (00750us space)
> [  481.773954] ir_raw_event_store: sample: (01000us pulse)
> [  481.773958] ir_raw_event_store: sample: (01000us space)
> [  481.773961] ir_raw_event_store: sample: (00750us pulse)
> [  481.773965] ir_raw_event_store: sample: (01000us space)
> [  481.773969] ir_raw_event_store: sample: (00750us pulse)
> [  481.773973] ir_raw_event_store: sample: (01000us space)
> [  481.774007] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
> [  481.774013] ir_rc6_decode: RC6 decode started at state 0 (750us space)
> [  481.774018] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
> [  481.774025] ir_lirc_decode: delivering 750us space to lirc_dev
> [  481.774030] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
> [  481.774035] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
> [  481.774039] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
> [  481.774043] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
> [  481.774047] ir_lirc_decode: delivering 1000us pulse to lirc_dev
> [  481.774051] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
> [  481.774055] ir_rc6_decode: RC6 decode started at state 0 (750us space)
> [  481.774059] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
> [  481.774063] ir_lirc_decode: delivering 750us space to lirc_dev
> 
> So it looks like decoding is failing.  I see that there have been
> extensive changes to the RC system from 2.6.37 and it appears that
> something broke in the transition.  Any suggestions on where the problem
> might be?

Hmm...the above sequence seems incomplete to me. That's why the decoder
failed: there aren't enough pulse/space codes there to be translated.
Maybe your remote batteries are weak.

Cheers,
Mauro.
 
