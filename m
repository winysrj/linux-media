Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab1DDMnr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2011 08:43:47 -0400
Message-ID: <4D99BCFD.6090300@redhat.com>
Date: Mon, 04 Apr 2011 09:43:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Lawrence Rust <lawrence@softsystem.co.uk>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge Nova-S remote control broken in 2.6.38
References: <1301830909.1709.32.camel@gagarin>  <4D98834D.70705@redhat.com> <1301842129.1709.39.camel@gagarin>
In-Reply-To: <1301842129.1709.39.camel@gagarin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 03-04-2011 11:48, Lawrence Rust escreveu:
> On Sun, 2011-04-03 at 11:25 -0300, Mauro Carvalho Chehab wrote:
>> > Em 03-04-2011 08:41, Lawrence Rust escreveu:
>>> > > I just installed a new 2.6.38.2 kernel and found that the remote control
>>> > > on my Hauppauge Nova-S plus is no longer working. 

The most interesting part is this one:

[ 5988.381443] ir_raw_event_store: sample: (01000us pulse)
[ 5988.381448] ir_raw_event_store: sample: (00750us space)
[ 5988.381452] ir_raw_event_store: sample: (00676us pulse)
[ 5988.381456] ir_raw_event_store: sample: (00926us space)
[ 5988.381460] ir_raw_event_store: sample: (00750us pulse)
[ 5988.381464] ir_raw_event_store: sample: (01000us space)
[ 5988.389445] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389454] ir_raw_event_store: sample: (01000us space)
[ 5988.389458] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389462] ir_raw_event_store: sample: (01000us space)
[ 5988.389466] ir_raw_event_store: sample: (00676us pulse)
[ 5988.389470] ir_raw_event_store: sample: (01000us space)
[ 5988.389473] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389477] ir_raw_event_store: sample: (01000us space)
[ 5988.397435] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397444] ir_raw_event_store: sample: (01000us space)
[ 5988.397448] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397452] ir_raw_event_store: sample: (01000us space)
[ 5988.397455] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397459] ir_raw_event_store: sample: (01000us space)
[ 5988.397463] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397467] ir_raw_event_store: sample: (00926us space)
[ 5988.405444] ir_raw_event_store: sample: (00750us pulse)

[ 5988.493438] ir_raw_event_store: sample: (05498us space)
[ 5988.493447] ir_raw_event_store: sample: (00750us pulse)
[ 5988.493451] ir_raw_event_store: sample: (01000us space)
[ 5988.493455] ir_raw_event_store: sample: (00676us pulse)
[ 5988.493458] ir_raw_event_store: sample: (00676us space)
[ 5988.493462] ir_raw_event_store: sample: (00750us pulse)
[ 5988.501437] ir_raw_event_store: sample: (01000us space)
[ 5988.501445] ir_raw_event_store: sample: (01000us pulse)
[ 5988.501449] ir_raw_event_store: sample: (00750us space)
[ 5988.501453] ir_raw_event_store: sample: (01000us pulse)
[ 5988.501457] ir_raw_event_store: sample: (00750us space)
[ 5988.501461] ir_raw_event_store: sample: (00676us pulse)
[ 5988.501465] ir_raw_event_store: sample: (01000us space)
[ 5988.501469] ir_raw_event_store: sample: (00750us pulse)
[ 5988.509445] ir_raw_event_store: sample: (01000us space)
[ 5988.509454] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509458] ir_raw_event_store: sample: (00750us space)
[ 5988.509462] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509465] ir_raw_event_store: sample: (00750us space)
[ 5988.509469] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509473] ir_raw_event_store: sample: (00750us space)
[ 5988.509476] ir_raw_event_store: sample: (01000us pulse)
[ 5988.517448] ir_raw_event_store: sample: (00676us space)
[ 5988.517457] ir_raw_event_store: sample: (00750us pulse)

[ 5988.605435] ir_raw_event_store: sample: (05498us space)
[ 5988.605443] ir_raw_event_store: sample: (00750us pulse)
[ 5988.605447] ir_raw_event_store: sample: (01000us space)
[ 5988.605451] ir_raw_event_store: sample: (00676us pulse)
[ 5988.605455] ir_raw_event_store: sample: (00676us space)
[ 5988.613439] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613447] ir_raw_event_store: sample: (00750us space)
[ 5988.613451] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613455] ir_raw_event_store: sample: (00750us space)
[ 5988.613458] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613462] ir_raw_event_store: sample: (01000us space)
[ 5988.613466] ir_raw_event_store: sample: (00676us pulse)
[ 5988.613469] ir_raw_event_store: sample: (00750us space)
[ 5988.621441] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621449] ir_raw_event_store: sample: (00750us space)
[ 5988.621453] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621457] ir_raw_event_store: sample: (00750us space)
[ 5988.621460] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621464] ir_raw_event_store: sample: (01000us space)
[ 5988.621468] ir_raw_event_store: sample: (00750us pulse)
[ 5988.621471] ir_raw_event_store: sample: (01000us space)
[ 5988.621475] ir_raw_event_store: sample: (00750us pulse)
[ 5988.629449] ir_raw_event_store: sample: (00676us space)
[ 5988.629457] ir_raw_event_store: sample: (01000us pulse)
[ 5988.789446] ir_raw_event_store: sample: (10057us space)

It seems that you hit 3 keycodes here. The decoders will try to detect the event format,
according with the protocol timings (see http://www.sbprojects.com/knowledge/ir/rc5.htm).
Both RC-5 and RC-6 use Manchester codes (http://en.wikipedia.org/wiki/Manchester_code).

If the IR were following the RC5 timings, you would be seen a sequence of 21 events for
each keycode, some with about 889 us and the others with about 1778 us (1778us = 889 x 2).

The decoders are a bit tolerant with timing shifts, but your remote has a high timing shift
when compared with the specs. Also, the long events should have twice the duration of the
short events.

To be worse, if we took the middle keystroke:

[ 5988.493438] ir_raw_event_store: sample: (05498us space)
[ 5988.493447] ir_raw_event_store: sample: (00750us pulse)
	Bit 1 - Start of the frame
[ 5988.493451] ir_raw_event_store: sample: (01000us space)
[ 5988.493455] ir_raw_event_store: sample: (00676us pulse)
	Should be a bit 1, also part of the start of frame, but it seems mangled
[ 5988.493458] ir_raw_event_store: sample: (00676us space)
[ 5988.493462] ir_raw_event_store: sample: (00750us pulse)
	Should be a bit 0, but it is mangled
[ 5988.501437] ir_raw_event_store: sample: (01000us space)
[ 5988.501445] ir_raw_event_store: sample: (01000us pulse)
	1st data bit
[ 5988.501449] ir_raw_event_store: sample: (00750us space)
[ 5988.501453] ir_raw_event_store: sample: (01000us pulse)
	2nd data bit
[ 5988.501457] ir_raw_event_store: sample: (00750us space)
[ 5988.501461] ir_raw_event_store: sample: (00676us pulse)
	3rd data bit

[ 5988.501465] ir_raw_event_store: sample: (01000us space)
[ 5988.501469] ir_raw_event_store: sample: (00750us pulse)
	4th data bit

[ 5988.509445] ir_raw_event_store: sample: (01000us space)
[ 5988.509454] ir_raw_event_store: sample: (01000us pulse)
	5th data bit

[ 5988.509458] ir_raw_event_store: sample: (00750us space)
[ 5988.509462] ir_raw_event_store: sample: (01000us pulse)
	6th data bit

[ 5988.509465] ir_raw_event_store: sample: (00750us space)
[ 5988.509469] ir_raw_event_store: sample: (01000us pulse)
	7th data bit

[ 5988.509473] ir_raw_event_store: sample: (00750us space)
[ 5988.509476] ir_raw_event_store: sample: (01000us pulse)
	8th data bit

[ 5988.517448] ir_raw_event_store: sample: (00676us space)
[ 5988.517457] ir_raw_event_store: sample: (00750us pulse)
	9th data bit

[ 5988.605435] ir_raw_event_store: sample: (05498us space)

There are just 12 bits there, being 3 control bits and 9 data
ones. That's not enough for the decoders to recognize this as
a RC-5 code.

The other 2 keystrokes are equally mangled.

If you look at the RC-5 state machine for the second keystroke:

[ 5988.493499] ir_rc5_decode: RC5(x) decode failed at state 1 (5498us space)
	(this event resets the state machine to start receiving a new sequence)

[ 5988.493524] ir_rc5_decode: RC5(x) decode started at state 0 (750us pulse)
[ 5988.493529] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.493545] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.493562] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.493566] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.493582] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.493599] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.493603] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.501504] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.501529] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.501534] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.501551] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.501568] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.501572] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.501589] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.501606] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.501610] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.501627] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.501643] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.501648] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.509507] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.509533] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509537] ir_rc5_decode: RC5(x) decode started at state 3 (111us pulse)
[ 5988.509554] ir_rc5_decode: RC5(x) decode started at state 3 (750us space)
[ 5988.509558] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509575] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509579] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.509596] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509612] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509617] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.509633] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509650] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509654] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.517491] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.517516] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.517520] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.605480] ir_rc5_decode: RC5(x) decode started at state 1 (5498us space)
[ 5988.605486] ir_rc5_decode: RC5(x) decode failed at state 1 (5498us space)

The RC-5 decoder has accepted the timings for your remote. It only failed when it
detected less bits than required for a RC-5 protocol.

I have here 3 different Remote Controllers produced by Hauppauge (the black one,
the grey/gold one and the grey one). All of them are properly decoded by the
RC-5 software decoder inside the kernel.

My first bet is that your remote is broken (or needs to replace the batteries).

If you are using a new pair of batteries, and are you sure that the remote works
fine, then my next bet is that cx88_ir_irq(), at cx88-input.c is doing something
wrong, or it is loosing events. The Nova-S seems to be programmed to sample the
GPIO16 pin at 4 kHz rate, and generate interrupts reporting it (I think it will
generate one IRQ on every 4000/32 Hz - although I didn't double-checked the cx23883
datasheet to be sure). If your system has lots of pending tasks, you
may eventually loose events, and the net result is the above: you'll get
only half of the samples for a given keystroke.

You should try to compile your kernel with CONFIG_HZ = 1000, and test the remote
controller without any other load, to double check it. You may also try to play with
ir_samplerate modprobe parameter, to change the sample rate from 4kHz to another
rate, between 1-16 kHz. The higher value, the higher will be the IRQ load, so, you
may try to decrease it to 3 or 2, in order to test if all bits will be catched. A rate
of 1 kHz is probably not enough for the RC-5 protocol.

If none of the above fixes it, I would take a look at ir_raw_event_store_with_filter().





Cheers,
Mauro.




