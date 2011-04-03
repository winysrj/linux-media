Return-path: <mchehab@pedra>
Received: from smtp21.services.sfr.fr ([93.17.128.4]:1944 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1DCOwC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2011 10:52:02 -0400
Received: from smtp21.services.sfr.fr (msfrf2108 [10.18.25.22])
	by msfrf2115.sfr.fr (SMTP Server) with ESMTP id 14E067000667
	for <linux-media@vger.kernel.org>; Sun,  3 Apr 2011 16:51:58 +0200 (CEST)
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2108.sfr.fr (SMTP Server) with ESMTP id 1A6F87000099
	for <linux-media@vger.kernel.org>; Sun,  3 Apr 2011 16:48:55 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (188.181.87-79.rev.gaoland.net [79.87.181.188])
	by msfrf2108.sfr.fr (SMTP Server) with SMTP id 70CF57000096
	for <linux-media@vger.kernel.org>; Sun,  3 Apr 2011 16:48:54 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [79.87.181.188] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sun, 03 Apr 2011 16:48:50 +0200
Subject: Re: Hauppauge Nova-S remote control broken in 2.6.38
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <4D98834D.70705@redhat.com>
References: <1301830909.1709.32.camel@gagarin>  <4D98834D.70705@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 16:48:49 +0200
Message-ID: <1301842129.1709.39.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-04-03 at 11:25 -0300, Mauro Carvalho Chehab wrote:
> Em 03-04-2011 08:41, Lawrence Rust escreveu:
> > I just installed a new 2.6.38.2 kernel and found that the remote control
> > on my Hauppauge Nova-S plus is no longer working. dmesg shows that
> > everything initialised OK:
> > 
> > [    8.002874] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
> > [    8.100260] IR NEC protocol handler initialized
> > [    8.132843] tveeprom 1-0050: Hauppauge model 92001, rev C1B1, serial# 2700305
> > [    8.132853] tveeprom 1-0050: MAC address is 00:0d:fe:29:34:11
> > [    8.132858] tveeprom 1-0050: tuner model is Conexant_CX24109 (idx 111, type 4)
> > [    8.132864] tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
> > [    8.132870] tveeprom 1-0050: audio processor is CX883 (idx 32)
> > [    8.132875] tveeprom 1-0050: decoder processor is CX883 (idx 22)
> > [    8.132879] tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
> > [    8.132884] cx88[0]: hauppauge eeprom: model=92001
> > [    8.229173] IR RC5(x) protocol handler initialized
> > [    8.261811] Registered IR keymap rc-hauppauge-new
> > [    8.272593] input: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:0b.2/rc/rc0/input3
> > [    8.275331] IR RC6 protocol handler initialized
> > [    8.278600] rc0: cx88 IR (Hauppauge Nova-S-Plus  as /devices/pci0000:00/0000:00:0b.2/rc/rc0
> > [    8.510290] lirc_dev: IR Remote Control driver registered, major 251 
> > [    8.581417] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
> > [    8.581427] IR LIRC bridge handler initialized
> > 
> > cat /proc/bus/input/devices
> > ...
> > I: Bus=0001 Vendor=0070 Product=9202 Version=0001
> > N: Name="cx88 IR (Hauppauge Nova-S-Plus "
> > P: Phys=pci-0000:00:0b.2/ir0
> > S: Sysfs=/devices/pci0000:00/0000:00:0b.2/rc/rc0/input3
> > 
> > But if I try to receive input events I see nothing:
> > 
> > sudo evtest /dev/input/event3
> > Input driver version is 1.0.1
> > Input device ID: bus 0x1 vendor 0x70 product 0x9202 version 0x1
> > Input device name: "cx88 IR (Hauppauge Nova-S-Plus "
> > Supported events:
> > ...
> > 
> > If I enable debug output:
> > 
> > echo >/sys/module/rc_core/parameters/debug 2
> > 
> > and press a key, dmesg shows:
> > 
> > [  481.765937] ir_raw_event_set_idle: leave idle mode
> > [  481.765948] ir_raw_event_store: sample: (01000us pulse)
> > [  481.765970] ir_rc5_decode: RC5(x) decode started at state 0 (1000us pulse)
> > [  481.765975] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
> > [  481.765981] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
> > [  481.765986] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
> > [  481.765995] ir_lirc_decode: delivering 1000us pulse to lirc_dev
> > [  481.773939] ir_raw_event_store: sample: (00750us space)
> > [  481.773946] ir_raw_event_store: sample: (01000us pulse)
> > [  481.773950] ir_raw_event_store: sample: (00750us space)
> > [  481.773954] ir_raw_event_store: sample: (01000us pulse)
> > [  481.773958] ir_raw_event_store: sample: (01000us space)
> > [  481.773961] ir_raw_event_store: sample: (00750us pulse)
> > [  481.773965] ir_raw_event_store: sample: (01000us space)
> > [  481.773969] ir_raw_event_store: sample: (00750us pulse)
> > [  481.773973] ir_raw_event_store: sample: (01000us space)
> > [  481.774007] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
> > [  481.774013] ir_rc6_decode: RC6 decode started at state 0 (750us space)
> > [  481.774018] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
> > [  481.774025] ir_lirc_decode: delivering 750us space to lirc_dev
> > [  481.774030] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
> > [  481.774035] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
> > [  481.774039] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
> > [  481.774043] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
> > [  481.774047] ir_lirc_decode: delivering 1000us pulse to lirc_dev
> > [  481.774051] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
> > [  481.774055] ir_rc6_decode: RC6 decode started at state 0 (750us space)
> > [  481.774059] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
> > [  481.774063] ir_lirc_decode: delivering 750us space to lirc_dev
> > 
> > So it looks like decoding is failing.  I see that there have been
> > extensive changes to the RC system from 2.6.37 and it appears that
> > something broke in the transition.  Any suggestions on where the problem
> > might be?
> 
> Hmm...the above sequence seems incomplete to me. That's why the decoder
> failed: there aren't enough pulse/space codes there to be translated.
> Maybe your remote batteries are weak.

OK, I truncated the log - I didn't believe the remainder was relevant.
Here's the full output frpm a single press of the 'one' key:

[ 5988.381430] ir_raw_event_set_idle: leave idle mode
[ 5988.381443] ir_raw_event_store: sample: (01000us pulse)
[ 5988.381448] ir_raw_event_store: sample: (00750us space)
[ 5988.381452] ir_raw_event_store: sample: (00676us pulse)
[ 5988.381456] ir_raw_event_store: sample: (00926us space)
[ 5988.381460] ir_raw_event_store: sample: (00750us pulse)
[ 5988.381464] ir_raw_event_store: sample: (01000us space)
[ 5988.381493] ir_rc5_decode: RC5(x) decode started at state 0 (1000us pulse)
[ 5988.381498] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.381504] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.381509] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.381520] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.381525] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.381530] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.381534] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.381538] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.381542] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.381547] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.381551] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.381555] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.381559] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.381563] ir_rc5_decode: RC5(x) decode started at state 1 (926us space)
[ 5988.381568] ir_rc6_decode: RC6 decode started at state 0 (926us space)
[ 5988.381572] ir_rc6_decode: RC6 decode failed at state 0 (926us space)
[ 5988.381576] ir_lirc_decode: delivering 926us space to lirc_dev
[ 5988.381580] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.381584] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.381588] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.381592] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.381596] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.381601] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.381605] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.381609] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.381613] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.389445] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389454] ir_raw_event_store: sample: (01000us space)
[ 5988.389458] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389462] ir_raw_event_store: sample: (01000us space)
[ 5988.389466] ir_raw_event_store: sample: (00676us pulse)
[ 5988.389470] ir_raw_event_store: sample: (01000us space)
[ 5988.389473] ir_raw_event_store: sample: (00750us pulse)
[ 5988.389477] ir_raw_event_store: sample: (01000us space)
[ 5988.389512] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.389517] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.389523] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.389528] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.389536] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.389542] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.389546] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.389550] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.389554] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.389559] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.389563] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.389567] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.389571] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.389575] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.389579] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.389583] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.389588] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.389591] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.389596] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.389600] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.389604] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.389608] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.389612] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.389616] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.389621] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.389625] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.389629] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.389633] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.389637] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.389642] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.389646] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.389650] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.389654] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.389658] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.389662] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.389666] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.397435] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397444] ir_raw_event_store: sample: (01000us space)
[ 5988.397448] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397452] ir_raw_event_store: sample: (01000us space)
[ 5988.397455] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397459] ir_raw_event_store: sample: (01000us space)
[ 5988.397463] ir_raw_event_store: sample: (00750us pulse)
[ 5988.397467] ir_raw_event_store: sample: (00926us space)
[ 5988.397505] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.397510] ir_rc5_decode: RC5(x) decode started at state 3 (0us pulse)
[ 5988.397516] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.397521] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.397528] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.397533] ir_rc5_decode: RC5(x) decode started at state 3 (1000us space)
[ 5988.397538] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.397542] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.397546] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.397550] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.397554] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.397559] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.397563] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.397567] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.397571] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.397575] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.397579] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.397583] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.397587] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.397591] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.397596] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.397600] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.397604] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.397608] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.397612] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.397616] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.397620] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.397624] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.397628] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.397633] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.397637] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.397641] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.397645] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.397649] ir_rc5_decode: RC5(x) decode started at state 1 (926us space)
[ 5988.397653] ir_rc6_decode: RC6 decode started at state 0 (926us space)
[ 5988.397657] ir_rc6_decode: RC6 decode failed at state 0 (926us space)
[ 5988.397661] ir_lirc_decode: delivering 926us space to lirc_dev
[ 5988.405444] ir_raw_event_store: sample: (00750us pulse)
[ 5988.405484] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.405489] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.405496] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.405501] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.405508] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.493438] ir_raw_event_store: sample: (05498us space)
[ 5988.493447] ir_raw_event_store: sample: (00750us pulse)
[ 5988.493451] ir_raw_event_store: sample: (01000us space)
[ 5988.493455] ir_raw_event_store: sample: (00676us pulse)
[ 5988.493458] ir_raw_event_store: sample: (00676us space)
[ 5988.493462] ir_raw_event_store: sample: (00750us pulse)
[ 5988.493494] ir_rc5_decode: RC5(x) decode started at state 1 (5498us space)
[ 5988.493499] ir_rc5_decode: RC5(x) decode failed at state 1 (5498us space)
[ 5988.493506] ir_rc6_decode: RC6 decode started at state 0 (5498us space)
[ 5988.493510] ir_rc6_decode: RC6 decode failed at state 0 (5498us space)
[ 5988.493518] ir_lirc_decode: delivering 5498us space to lirc_dev
[ 5988.493524] ir_rc5_decode: RC5(x) decode started at state 0 (750us pulse)
[ 5988.493529] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.493533] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.493537] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.493541] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.493545] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.493549] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.493553] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.493557] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.493562] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.493566] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.493570] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.493574] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.493578] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.493582] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.493587] ir_rc6_decode: RC6 decode started at state 0 (676us space)
[ 5988.493591] ir_rc6_decode: RC6 decode failed at state 0 (676us space)
[ 5988.493594] ir_lirc_decode: delivering 676us space to lirc_dev
[ 5988.493599] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.493603] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.493607] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.493611] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.493615] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.501437] ir_raw_event_store: sample: (01000us space)
[ 5988.501445] ir_raw_event_store: sample: (01000us pulse)
[ 5988.501449] ir_raw_event_store: sample: (00750us space)
[ 5988.501453] ir_raw_event_store: sample: (01000us pulse)
[ 5988.501457] ir_raw_event_store: sample: (00750us space)
[ 5988.501461] ir_raw_event_store: sample: (00676us pulse)
[ 5988.501465] ir_raw_event_store: sample: (01000us space)
[ 5988.501469] ir_raw_event_store: sample: (00750us pulse)
[ 5988.501504] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.501511] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.501516] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.501524] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.501529] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.501534] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.501538] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.501542] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.501547] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.501551] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.501555] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.501559] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.501563] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.501568] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.501572] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.501576] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.501581] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.501585] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.501589] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.501593] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.501597] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.501601] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.501606] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.501610] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.501614] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.501618] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.501622] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.501627] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.501631] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.501635] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.501639] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.501643] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.501648] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.501652] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.501656] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.501660] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.509445] ir_raw_event_store: sample: (01000us space)
[ 5988.509454] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509458] ir_raw_event_store: sample: (00750us space)
[ 5988.509462] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509465] ir_raw_event_store: sample: (00750us space)
[ 5988.509469] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509473] ir_raw_event_store: sample: (00750us space)
[ 5988.509476] ir_raw_event_store: sample: (01000us pulse)
[ 5988.509507] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.509514] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.509519] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.509526] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.509533] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509537] ir_rc5_decode: RC5(x) decode started at state 3 (111us pulse)
[ 5988.509541] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.509546] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.509550] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.509554] ir_rc5_decode: RC5(x) decode started at state 3 (750us space)
[ 5988.509558] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509562] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.509566] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.509570] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.509575] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509579] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.509583] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.509587] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.509591] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.509596] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509600] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.509604] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.509608] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.509612] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509617] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.509621] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.509625] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.509629] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.509633] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.509637] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.509641] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.509645] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.509650] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.509654] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.509658] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.509662] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.509666] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.517448] ir_raw_event_store: sample: (00676us space)
[ 5988.517457] ir_raw_event_store: sample: (00750us pulse)
[ 5988.517491] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.517498] ir_rc6_decode: RC6 decode started at state 0 (676us space)
[ 5988.517503] ir_rc6_decode: RC6 decode failed at state 0 (676us space)
[ 5988.517510] ir_lirc_decode: delivering 676us space to lirc_dev
[ 5988.517516] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.517520] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.517524] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.517528] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.517532] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.605435] ir_raw_event_store: sample: (05498us space)
[ 5988.605443] ir_raw_event_store: sample: (00750us pulse)
[ 5988.605447] ir_raw_event_store: sample: (01000us space)
[ 5988.605451] ir_raw_event_store: sample: (00676us pulse)
[ 5988.605455] ir_raw_event_store: sample: (00676us space)
[ 5988.605480] ir_rc5_decode: RC5(x) decode started at state 1 (5498us space)
[ 5988.605486] ir_rc5_decode: RC5(x) decode failed at state 1 (5498us space)
[ 5988.605492] ir_rc6_decode: RC6 decode started at state 0 (5498us space)
[ 5988.605496] ir_rc6_decode: RC6 decode failed at state 0 (5498us space)
[ 5988.605504] ir_lirc_decode: delivering 5498us space to lirc_dev
[ 5988.605510] ir_rc5_decode: RC5(x) decode started at state 0 (750us pulse)
[ 5988.605514] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.605518] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.605522] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.605526] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.605531] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.605535] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.605539] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.605543] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.605547] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.605552] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.605556] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.605560] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.605564] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.605568] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.605572] ir_rc6_decode: RC6 decode started at state 0 (676us space)
[ 5988.605577] ir_rc6_decode: RC6 decode failed at state 0 (676us space)
[ 5988.605580] ir_lirc_decode: delivering 676us space to lirc_dev
[ 5988.613439] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613447] ir_raw_event_store: sample: (00750us space)
[ 5988.613451] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613455] ir_raw_event_store: sample: (00750us space)
[ 5988.613458] ir_raw_event_store: sample: (01000us pulse)
[ 5988.613462] ir_raw_event_store: sample: (01000us space)
[ 5988.613466] ir_raw_event_store: sample: (00676us pulse)
[ 5988.613469] ir_raw_event_store: sample: (00750us space)
[ 5988.613496] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.613502] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.613509] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.613514] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.613521] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.613527] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.613532] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.613536] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.613540] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.613544] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.613548] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.613553] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.613557] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.613560] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.613565] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.613569] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.613573] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.613577] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.613581] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.613585] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.613589] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.613594] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.613597] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.613602] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.613606] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.613610] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.613614] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.613618] ir_rc5_decode: RC5(x) decode started at state 2 (676us pulse)
[ 5988.613622] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.613626] ir_rc6_decode: RC6 decode started at state 0 (676us pulse)
[ 5988.613630] ir_rc6_decode: RC6 decode failed at state 0 (676us pulse)
[ 5988.613634] ir_lirc_decode: delivering 676us pulse to lirc_dev
[ 5988.613639] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.613643] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.613647] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.613651] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.621441] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621449] ir_raw_event_store: sample: (00750us space)
[ 5988.621453] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621457] ir_raw_event_store: sample: (00750us space)
[ 5988.621460] ir_raw_event_store: sample: (01000us pulse)
[ 5988.621464] ir_raw_event_store: sample: (01000us space)
[ 5988.621468] ir_raw_event_store: sample: (00750us pulse)
[ 5988.621471] ir_raw_event_store: sample: (01000us space)
[ 5988.621475] ir_raw_event_store: sample: (00750us pulse)
[ 5988.621514] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.621520] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.621526] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.621531] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.621539] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.621544] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.621549] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.621553] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.621557] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.621561] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.621566] ir_rc5_decode: RC5(x) decode started at state 3 (111us pulse)
[ 5988.621570] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.621574] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.621578] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.621582] ir_rc5_decode: RC5(x) decode started at state 3 (750us space)
[ 5988.621587] ir_rc5_decode: RC5(x) decode started at state 1 (750us space)
[ 5988.621591] ir_rc6_decode: RC6 decode started at state 0 (750us space)
[ 5988.621595] ir_rc6_decode: RC6 decode failed at state 0 (750us space)
[ 5988.621599] ir_lirc_decode: delivering 750us space to lirc_dev
[ 5988.621603] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.621607] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.621612] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.621616] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.621620] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.621624] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.621628] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.621632] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.621636] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.621640] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.621645] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.621649] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.621653] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.621657] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.621661] ir_rc5_decode: RC5(x) decode started at state 1 (1000us space)
[ 5988.621665] ir_rc6_decode: RC6 decode started at state 0 (1000us space)
[ 5988.621669] ir_rc6_decode: RC6 decode failed at state 0 (1000us space)
[ 5988.621673] ir_lirc_decode: delivering 1000us space to lirc_dev
[ 5988.621678] ir_rc5_decode: RC5(x) decode started at state 2 (750us pulse)
[ 5988.621682] ir_rc5_decode: RC5(x) decode started at state 1 (0us pulse)
[ 5988.621686] ir_rc6_decode: RC6 decode started at state 0 (750us pulse)
[ 5988.621690] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[ 5988.621694] ir_lirc_decode: delivering 750us pulse to lirc_dev
[ 5988.629449] ir_raw_event_store: sample: (00676us space)
[ 5988.629457] ir_raw_event_store: sample: (01000us pulse)
[ 5988.629491] ir_rc5_decode: RC5(x) decode started at state 1 (676us space)
[ 5988.629498] ir_rc6_decode: RC6 decode started at state 0 (676us space)
[ 5988.629503] ir_rc6_decode: RC6 decode failed at state 0 (676us space)
[ 5988.629511] ir_lirc_decode: delivering 676us space to lirc_dev
[ 5988.629516] ir_rc5_decode: RC5(x) decode started at state 2 (1000us pulse)
[ 5988.629521] ir_rc5_decode: RC5(x) decode started at state 1 (111us pulse)
[ 5988.629525] ir_rc6_decode: RC6 decode started at state 0 (1000us pulse)
[ 5988.629529] ir_rc6_decode: RC6 decode failed at state 0 (1000us pulse)
[ 5988.629533] ir_lirc_decode: delivering 1000us pulse to lirc_dev
[ 5988.789433] ir_raw_event_set_idle: enter idle mode
[ 5988.789446] ir_raw_event_store: sample: (10057us space)
[ 5988.789475] ir_rc5_decode: RC5(x) decode started at state 1 (10057us space)
[ 5988.789480] ir_rc5_decode: RC5(x) decode failed at state 1 (10057us space)
[ 5988.789486] ir_rc6_decode: RC6 decode started at state 0 (10057us space)
[ 5988.789491] ir_rc6_decode: RC6 decode failed at state 0 (10057us space)

Does this help point a finger?

-- 
Lawrence


