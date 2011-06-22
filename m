Return-path: <mchehab@pedra>
Received: from smtprelay05.ispgateway.de ([80.67.31.100]:46893 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1FVHfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 03:35:34 -0400
Date: Wed, 22 Jun 2011 09:29:05 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110622092905.436fb896@darkstar>
In-Reply-To: <8706FD7A-A020-4357-867E-BF6FBA818C3B@wilsonet.com>
References: <20110423005412.12978e29@darkstar>
	<20110424163530.2bc1b365@darkstar>
	<BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com>
	<20110425201835.0fbb84ee@darkstar>
	<A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com>
	<20110425230658.22551665@darkstar>
	<59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com>
	<20110427151621.5ac73e12@darkstar>
	<1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com>
	<20110427204725.2923ac99@darkstar>
	<91CD2A5E-418A-4217-8D9F-1B29FC9DD24D@wilsonet.com>
	<20110427222855.2e3a3a4d@darkstar>
	<63E3BF90-BF19-43E3-B8DD-6D6F4896F2E7@wilsonet.com>
	<BANLkTik+gYRfhDBy9JWgvo+GWJk5Uz7RMQ@mail.gmail.com>
	<14961B2E-36D9-4CD2-87E7-629F115055F2@wilsonet.com>
	<20110503222149.1ce726d9@darkstar>
	<8706FD7A-A020-4357-867E-BF6FBA818C3B@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Wed, 25 May 2011 16:41:35 -0400
schrieb Jarod Wilson <jarod@wilsonet.com>:

> So... I have the card finally up and running in a test rig, but I
> don't yet have the necessary IR receiver cable. A glance at
> cx88-input.c and the default key table for the 800i gives some clues
> as to what is wrong though -- this is another case where the cx88
> driver was only passing along the last byte of the remote's scancode,
> after the raw IR was decoded in cx88's private decoder. Now, we
> should be delivering the raw IR to the generic in-kernel IR decoders,
> which are then going to be passing along full scancodes for lookup
> table matching.
> 
> If someone with the 800i (and/or the Terratec card) can load rc-core
> with debug=2, and provide dmesg output after punching a few buttons,
> it might be possible to get this squared away even before I have the
> necessary receiver cable. :)

Sorry for the long delay.

Did you made any progress in the meantime?

I tried pressing some buttons of the IR for my Terratec Cinergy 1400
DVB-T with kernel 2.6.39.1 and with all possible protocols disabled,
with all protocols enabled and with only nec enabled, but I still get
only a very few reactions (scancodes) randomly and sporadically, not
replicable.

Please, tell me, if you need more infos or tests.

This is the dmesg output at boot time:

[   12.241118] Linux media interface: v0.10
[   12.250204] Linux video capture interface: v2.00
...
[   12.519431] IR NEC protocol handler initialized
[   12.524054] IR RC5(x) protocol handler initialized
[   12.592137] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[   12.593962] IR RC6 protocol handler initialized
[   12.595577] cx8800 0000:03:06.0: PCI INT A -> GSI 20 (level, low) ->
IRQ 20
[   12.596848] cx88[0]: subsystem: 153b:1166, board: TerraTec Cinergy
1400 DVB-T [card=30,autodetected], frontend(s): 1
[   12.596850] cx88[0]: TV tuner type 4, Radio tuner type 0
[   12.601482] IR JVC protocol handler initialized
[   12.605605] input: ImPS/2 Logitech Wheel Mouse
as /devices/platform/i8042/serio1/input/input3
[   12.628496] IR Sony protocol handler initialized
[   12.631017] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8
loaded
[   12.635389] lirc_dev: IR Remote Control driver registered, major 251 
[   12.636775] IR LIRC bridge handler initialized
[   12.786685] Registered IR keymap rc-cinergy-1400
[   12.786721] ir_create_table: Allocated space for 64 keycode entries
(512 bytes)
[   12.786723] ir_setkeytable: Allocated space for 64 keycode entries
(512 bytes)
[   12.786726] ir_update_mapping: #0: New scan 0x0001 with key 0x0074
[   12.786728] ir_update_mapping: #1: New scan 0x0002 with key 0x0002
[   12.786730] ir_update_mapping: #2: New scan 0x0003 with key 0x0003
[   12.786732] ir_update_mapping: #3: New scan 0x0004 with key 0x0004
[   12.786733] ir_update_mapping: #4: New scan 0x0005 with key 0x0005
[   12.786735] ir_update_mapping: #5: New scan 0x0006 with key 0x0006
[   12.786736] ir_update_mapping: #6: New scan 0x0007 with key 0x0007
[   12.786738] ir_update_mapping: #7: New scan 0x0008 with key 0x0008
[   12.786740] ir_update_mapping: #8: New scan 0x0009 with key 0x0009
[   12.786742] ir_update_mapping: #9: New scan 0x000a with key 0x000a
[   12.786743] ir_update_mapping: #10: New scan 0x000c with key 0x000b
[   12.786745] ir_update_mapping: #10: New scan 0x000b with key 0x0189
[   12.786747] ir_update_mapping: #12: New scan 0x000d with key 0x00ad
[   12.786749] ir_update_mapping: #13: New scan 0x000e with key 0x0161
[   12.786750] ir_update_mapping: #14: New scan 0x000f with key 0x016d
[   12.786752] ir_update_mapping: #15: New scan 0x0010 with key 0x0067
[   12.786754] ir_update_mapping: #16: New scan 0x0011 with key 0x0069
[   12.786755] ir_update_mapping: #17: New scan 0x0012 with key 0x0160
[   12.786757] ir_update_mapping: #18: New scan 0x0013 with key 0x006a
[   12.786759] ir_update_mapping: #19: New scan 0x0014 with key 0x006c
[   12.786760] ir_update_mapping: #20: New scan 0x0015 with key 0x0184
[   12.786762] ir_update_mapping: #21: New scan 0x0016 with key 0x0166
[   12.786764] ir_update_mapping: #22: New scan 0x0017 with key 0x018e
[   12.786766] ir_update_mapping: #23: New scan 0x0018 with key 0x018f
[   12.786767] ir_update_mapping: #24: New scan 0x0019 with key 0x0190
[   12.786769] ir_update_mapping: #25: New scan 0x001a with key 0x0191
[   12.786771] ir_update_mapping: #26: New scan 0x001b with key 0x0192
[   12.786773] ir_update_mapping: #27: New scan 0x001c with key 0x0073
[   12.786774] ir_update_mapping: #28: New scan 0x001d with key 0x0071
[   12.786776] ir_update_mapping: #29: New scan 0x001e with key 0x0072
[   12.786778] ir_update_mapping: #30: New scan 0x001f with key 0x0193
[   12.786779] ir_update_mapping: #31: New scan 0x0040 with key 0x0077
[   12.786781] ir_update_mapping: #32: New scan 0x004c with key 0x00cf
[   12.786783] ir_update_mapping: #33: New scan 0x0058 with key 0x00a7
[   12.786785] ir_update_mapping: #33: New scan 0x0054 with key 0x019c
[   12.786786] ir_update_mapping: #32: New scan 0x0048 with key 0x0080
[   12.786788] ir_update_mapping: #36: New scan 0x005c with key 0x0197
[   12.786835] input: cx88 IR (TerraTec Cinergy 1400
as /devices/pci0000:00/0000:00:14.4/0000:03:06.0/rc/rc0/input4
[   12.786887] rc0: cx88 IR (TerraTec Cinergy 1400
as /devices/pci0000:00/0000:00:14.4/0000:03:06.0/rc/rc0
[   12.786958] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx)
registered at minor = 0
[   12.786961] rc_register_device: Registered rc0 (driver: cx88xx,
remote: rc-cinergy-1400, mode raw)
[   12.786968] cx88[0]/0: found at 0000:03:06.0, rev: 5, irq: 20,
latency: 32, mmio: 0xfb000000
[   12.787079] cx88[0]/0: registered device video0 [v4l2]
[   12.787108] cx88[0]/0: registered device vbi0
[   12.787491] cx88[0]/2: cx2388x 8802 Driver Manager
[   12.787504] cx88-mpeg driver manager 0000:03:06.2: PCI INT A -> GSI
20 (level, low) -> IRQ 20
[   12.787514] cx88[0]/2: found at 0000:03:06.2, rev: 5, irq: 20,
latency: 32, mmio: 0xfa000000
[   12.802856] ir_raw_event_set_idle: enter idle mode
[   12.802860] ir_raw_event_store: sample: (16000us space)
[   12.802867] ir_nec_decode: NEC decode started at state 0 (16000us
space)
[   12.802869] ir_nec_decode: NEC decode failed at state 0 (16000us
space)
[   12.802871] ir_rc5_decode: RC5(x) decode started at state 0 (16000us
space)
[   12.802873] ir_rc5_decode: RC5(x) decode failed at state 0 (16000us
space)
[   12.802875] ir_rc6_decode: RC6 decode started at state 0 (16000us
space)
[   12.802877] ir_rc6_decode: RC6 decode failed at state 0 (16000us
space)
[   12.802879] ir_jvc_decode: JVC decode started at state 0 (16000us
space)
[   12.802880] ir_jvc_decode: JVC decode failed at state 0 (16000us
space)
[   12.802882] ir_sony_decode: Sony decode started at state 0 (16000us
space)
[   12.802884] ir_sony_decode: Sony decode failed at state 0 (16000us
space)
[   12.859003] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[   12.859006] cx88/2: registering cx8802 driver, type: dvb access:
shared
[   12.859008] cx88[0]/2: subsystem: 153b:1166, board: TerraTec Cinergy
1400 DVB-T [card=30]
[   12.859011] cx88[0]/2: cx2388x based DVB/ATSC card
[   12.859013] cx8802_alloc_frontends() allocating 1 frontend(s)
[   12.998971] DVB: registering new adapter (cx88[0])
[   12.998976] DVB: registering adapter 0 frontend 0 (Conexant CX22702
DVB-T)...
[   13.160499] show_protocols: allowed - 0x4000001f, enabled -
0xffffffffffffffff
[   13.196696] ir_update_mapping: #0: Deleting scan 0x0001
[   13.196700] ir_update_mapping: #0: Deleting scan 0x0002
[   13.196702] ir_update_mapping: #0: Deleting scan 0x0003
[   13.196704] ir_update_mapping: #0: Deleting scan 0x0004
[   13.196706] ir_update_mapping: #0: Deleting scan 0x0005
[   13.196707] ir_update_mapping: #0: Deleting scan 0x0006
[   13.196709] ir_update_mapping: #0: Deleting scan 0x0007
[   13.196711] ir_update_mapping: #0: Deleting scan 0x0008
[   13.196713] ir_update_mapping: #0: Deleting scan 0x0009
[   13.196715] ir_update_mapping: #0: Deleting scan 0x000a
[   13.196717] ir_update_mapping: #0: Deleting scan 0x000b
[   13.196719] ir_update_mapping: #0: Deleting scan 0x000c
[   13.196720] ir_update_mapping: #0: Deleting scan 0x000d
[   13.196722] ir_update_mapping: #0: Deleting scan 0x000e
[   13.196724] ir_update_mapping: #0: Deleting scan 0x000f
[   13.196726] ir_update_mapping: #0: Deleting scan 0x0010
[   13.196727] ir_resize_table: Shrinking table to 256 bytes
[   13.196730] ir_update_mapping: #0: Deleting scan 0x0011
[   13.196732] ir_update_mapping: #0: Deleting scan 0x0012
[   13.196734] ir_update_mapping: #0: Deleting scan 0x0013
[   13.196736] ir_update_mapping: #0: Deleting scan 0x0014
[   13.196738] ir_update_mapping: #0: Deleting scan 0x0015
[   13.196739] ir_update_mapping: #0: Deleting scan 0x0016
[   13.196741] ir_update_mapping: #0: Deleting scan 0x0017
[   13.196743] ir_update_mapping: #0: Deleting scan 0x0018
[   13.196745] ir_update_mapping: #0: Deleting scan 0x0019
[   13.196747] ir_update_mapping: #0: Deleting scan 0x001a
[   13.196749] ir_update_mapping: #0: Deleting scan 0x001b
[   13.196751] ir_update_mapping: #0: Deleting scan 0x001c
[   13.196753] ir_update_mapping: #0: Deleting scan 0x001d
[   13.196755] ir_update_mapping: #0: Deleting scan 0x001e
[   13.196757] ir_update_mapping: #0: Deleting scan 0x001f
[   13.196759] ir_update_mapping: #0: Deleting scan 0x0040
[   13.196761] ir_update_mapping: #0: Deleting scan 0x0048
[   13.196763] ir_update_mapping: #0: Deleting scan 0x004c
[   13.196764] ir_update_mapping: #0: Deleting scan 0x0054
[   13.196766] ir_update_mapping: #0: Deleting scan 0x0058
[   13.196768] ir_update_mapping: #0: Deleting scan 0x005c
[   13.196775] ir_update_mapping: #0: New scan 0x0001 with key 0x0074
[   13.196777] ir_update_mapping: #1: New scan 0x0002 with key 0x0002
[   13.196779] ir_update_mapping: #2: New scan 0x0003 with key 0x0003
[   13.196782] ir_update_mapping: #3: New scan 0x0004 with key 0x0004
[   13.196784] ir_update_mapping: #4: New scan 0x0005 with key 0x0005
[   13.196786] ir_update_mapping: #5: New scan 0x0006 with key 0x0006
[   13.196789] ir_update_mapping: #6: New scan 0x0007 with key 0x0007
[   13.196791] ir_update_mapping: #7: New scan 0x0008 with key 0x0008
[   13.196793] ir_update_mapping: #8: New scan 0x0009 with key 0x0009
[   13.196795] ir_update_mapping: #9: New scan 0x000a with key 0x000a
[   13.196798] ir_update_mapping: #10: New scan 0x000c with key 0x000b
[   13.196800] ir_update_mapping: #10: New scan 0x000b with key 0x0189
[   13.196803] ir_update_mapping: #12: New scan 0x000d with key 0x00ad
[   13.196805] ir_update_mapping: #13: New scan 0x000e with key 0x0161
[   13.196807] ir_update_mapping: #14: New scan 0x000f with key 0x016d
[   13.196809] ir_update_mapping: #15: New scan 0x0010 with key 0x0067
[   13.196811] ir_update_mapping: #16: New scan 0x0011 with key 0x0069
[   13.196814] ir_update_mapping: #17: New scan 0x0012 with key 0x0160
[   13.196816] ir_update_mapping: #18: New scan 0x0013 with key 0x006a
[   13.196819] ir_update_mapping: #19: New scan 0x0014 with key 0x006c
[   13.196821] ir_update_mapping: #20: New scan 0x0015 with key 0x0184
[   13.196823] ir_update_mapping: #21: New scan 0x0016 with key 0x0166
[   13.196825] ir_update_mapping: #22: New scan 0x0017 with key 0x018e
[   13.196828] ir_update_mapping: #23: New scan 0x0018 with key 0x018f
[   13.196830] ir_update_mapping: #24: New scan 0x0019 with key 0x0190
[   13.196833] ir_update_mapping: #25: New scan 0x001a with key 0x0191
[   13.196835] ir_update_mapping: #26: New scan 0x001b with key 0x0192
[   13.196837] ir_update_mapping: #27: New scan 0x001c with key 0x0073
[   13.196839] ir_update_mapping: #28: New scan 0x001d with key 0x0071
[   13.196842] ir_update_mapping: #29: New scan 0x001e with key 0x0072
[   13.196844] ir_update_mapping: #30: New scan 0x001f with key 0x0193
[   13.196847] ir_update_mapping: #31: New scan 0x0040 with key 0x0077
[   13.196849] ir_resize_table: Growing table to 512 bytes
[   13.196851] ir_update_mapping: #32: New scan 0x004c with key 0x00cf
[   13.196853] ir_update_mapping: #33: New scan 0x0058 with key 0x00a7
[   13.196855] ir_update_mapping: #33: New scan 0x0054 with key 0x019c
[   13.196858] ir_update_mapping: #32: New scan 0x0048 with key 0x0080
[   13.196860] ir_update_mapping: #36: New scan 0x005c with key 0x0197
[   13.196914] store_protocols: Current protocol(s): 0x0
...
[   19.771595] ir_raw_event_set_idle: leave idle mode
[   19.771599] ir_raw_event_store: sample: (00250us pulse)
[   19.787595] ir_raw_event_set_idle: enter idle mode
[   19.787596] ir_raw_event_store: sample: (17000us space)
...
[   48.334641] ir_raw_event_set_idle: leave idle mode
[   48.334652] ir_raw_event_store: sample: (00250us pulse)
[   48.342636] ir_raw_event_set_idle: enter idle mode
[   48.342642] ir_raw_event_store: sample: (12250us space)

This is dmesg after pressing button 1 with all protocols disabled:

[  194.670465] ir_raw_event_set_idle: leave idle mode
[  194.678462] ir_raw_event_store: sample: (09250us pulse)
[  194.686470] ir_raw_event_store: sample: (04500us space)
[  194.686477] ir_raw_event_store: sample: (00500us pulse)
[  194.686483] ir_raw_event_store: sample: (00500us space)
[  194.686487] ir_raw_event_store: sample: (00750us pulse)
[  194.686492] ir_raw_event_store: sample: (00500us space)
[  194.686496] ir_raw_event_store: sample: (00500us pulse)
[  194.686501] ir_raw_event_store: sample: (01750us space)
[  194.694473] ir_raw_event_store: sample: (00500us pulse)
[  194.694481] ir_raw_event_store: sample: (00500us space)
[  194.694486] ir_raw_event_store: sample: (00750us pulse)
[  194.694490] ir_raw_event_store: sample: (00500us space)
[  194.694494] ir_raw_event_store: sample: (00500us pulse)
[  194.694499] ir_raw_event_store: sample: (00500us space)
[  194.694503] ir_raw_event_store: sample: (00750us pulse)
[  194.694507] ir_raw_event_store: sample: (00500us space)
[  194.694511] ir_raw_event_store: sample: (00500us pulse)
[  194.694515] ir_raw_event_store: sample: (00500us space)
[  194.694520] ir_raw_event_store: sample: (00750us pulse)
[  194.694524] ir_raw_event_store: sample: (01500us space)
[  194.702467] ir_raw_event_store: sample: (00750us pulse)
[  194.702473] ir_raw_event_store: sample: (01500us space)
[  194.702477] ir_raw_event_store: sample: (00750us pulse)
[  194.702481] ir_raw_event_store: sample: (00500us space)
[  194.702486] ir_raw_event_store: sample: (00500us pulse)
[  194.702490] ir_raw_event_store: sample: (01750us space)
[  194.702494] ir_raw_event_store: sample: (00750us pulse)
[  194.702498] ir_raw_event_store: sample: (00250us space)
[  194.702503] ir_raw_event_store: sample: (00750us pulse)
[  194.710467] ir_raw_event_store: sample: (01500us space)
[  194.710471] ir_raw_event_store: sample: (00750us pulse)
[  194.710476] ir_raw_event_store: sample: (01500us space)
[  194.710480] ir_raw_event_store: sample: (00750us pulse)
[  194.710485] ir_raw_event_store: sample: (01500us space)
[  194.710490] ir_raw_event_store: sample: (00750us pulse)
[  194.710494] ir_raw_event_store: sample: (00500us space)
[  194.710499] ir_raw_event_store: sample: (00750us pulse)
[  194.718466] ir_raw_event_store: sample: (01500us space)
[  194.718472] ir_raw_event_store: sample: (00750us pulse)
[  194.718476] ir_raw_event_store: sample: (00250us space)
[  194.718481] ir_raw_event_store: sample: (00750us pulse)
[  194.718485] ir_raw_event_store: sample: (00500us space)
[  194.718489] ir_raw_event_store: sample: (00750us pulse)
[  194.718494] ir_raw_event_store: sample: (00500us space)
[  194.718498] ir_raw_event_store: sample: (00500us pulse)
[  194.718502] ir_raw_event_store: sample: (00500us space)
[  194.718507] ir_raw_event_store: sample: (00750us pulse)
[  194.718511] ir_raw_event_store: sample: (00500us space)
[  194.718516] ir_raw_event_store: sample: (00500us pulse)
[  194.718520] ir_raw_event_store: sample: (00500us space)
[  194.726468] ir_raw_event_store: sample: (00750us pulse)
[  194.726473] ir_raw_event_store: sample: (01500us space)
[  194.726477] ir_raw_event_store: sample: (00750us pulse)
[  194.726481] ir_raw_event_store: sample: (00500us space)
[  194.726486] ir_raw_event_store: sample: (00500us pulse)
[  194.726490] ir_raw_event_store: sample: (01750us space)
[  194.726494] ir_raw_event_store: sample: (00500us pulse)
[  194.726499] ir_raw_event_store: sample: (01750us space)
[  194.726503] ir_raw_event_store: sample: (00500us pulse)
[  194.734470] ir_raw_event_store: sample: (01750us space)
[  194.734475] ir_raw_event_store: sample: (00500us pulse)
[  194.734479] ir_raw_event_store: sample: (01750us space)
[  194.734483] ir_raw_event_store: sample: (00500us pulse)
[  194.734488] ir_raw_event_store: sample: (01750us space)
[  194.734492] ir_raw_event_store: sample: (00500us pulse)
[  194.742468] ir_raw_event_store: sample: (01750us space)
[  194.742473] ir_raw_event_store: sample: (00500us pulse)
[  194.750471] ir_raw_event_set_idle: enter idle mode
[  194.750476] ir_raw_event_store: sample: (15250us space)
[  194.782476] ir_raw_event_set_idle: leave idle mode
[  194.790480] ir_raw_event_store: sample: (09250us pulse)
[  194.790487] ir_raw_event_store: sample: (02250us space)
[  194.790492] ir_raw_event_store: sample: (00500us pulse)
[  194.798481] ir_raw_event_set_idle: enter idle mode
[  194.798491] ir_raw_event_store: sample: (10250us space)
[  194.886488] ir_raw_event_set_idle: leave idle mode
[  194.894495] ir_raw_event_store: sample: (09250us pulse)
[  194.902489] ir_raw_event_store: sample: (02000us space)
[  194.902494] ir_raw_event_store: sample: (00750us pulse)
[  194.910486] ir_raw_event_set_idle: enter idle mode
[  194.910491] ir_raw_event_store: sample: (14000us space)
[  194.998503] ir_raw_event_set_idle: leave idle mode
[  195.006498] ir_raw_event_store: sample: (09250us pulse)
[  195.006503] ir_raw_event_store: sample: (02000us space)
[  195.006508] ir_raw_event_store: sample: (00750us pulse)
[  195.022498] ir_raw_event_set_idle: enter idle mode
[  195.022504] ir_raw_event_store: sample: (17750us space)

This is dmesg after pressing button 1 with all protocols enabled:

[  234.634837] ir_raw_event_set_idle: leave idle mode
[  234.642834] ir_raw_event_store: sample: (09000us pulse)
[  234.642854] ir_nec_decode: NEC decode started at state 0 (9000us
pulse)
[  234.642861] ir_rc5_decode: RC5(x) decode started at state 0 (9000us
pulse)
[  234.642866] ir_rc5_decode: RC5(x) decode started at state 1 (8111us
pulse)
[  234.642872] ir_rc5_decode: RC5(x) decode failed at state 1 (8111us
pulse)
[  234.642878] ir_rc6_decode: RC6 decode started at state 0 (9000us
pulse)
[  234.642883] ir_rc6_decode: RC6 decode failed at state 0 (9000us
pulse)
[  234.642889] ir_jvc_decode: JVC decode started at state 0 (9000us
pulse)
[  234.642894] ir_jvc_decode: JVC decode failed at state 0 (9000us
pulse)
[  234.642900] ir_sony_decode: Sony decode started at state 0 (9000us
pulse)
[  234.642905] ir_sony_decode: Sony decode failed at state 0 (9000us
pulse)
[  234.642913] ir_lirc_decode: delivering 9000us pulse to lirc_dev
[  234.650836] ir_raw_event_store: sample: (04500us space)
[  234.650841] ir_raw_event_store: sample: (00750us pulse)
[  234.650846] ir_raw_event_store: sample: (00250us space)
[  234.650850] ir_raw_event_store: sample: (00750us pulse)
[  234.650855] ir_raw_event_store: sample: (00500us space)
[  234.650859] ir_raw_event_store: sample: (00750us pulse)
[  234.650864] ir_raw_event_store: sample: (01500us space)
[  234.650882] ir_nec_decode: NEC decode started at state 1 (4500us
space)
[  234.650888] ir_rc5_decode: RC5(x) decode started at state 0 (4500us
space)
[  234.650893] ir_rc5_decode: RC5(x) decode failed at state 0 (4500us
space)
[  234.650899] ir_rc6_decode: RC6 decode started at state 0 (4500us
space)
[  234.650904] ir_rc6_decode: RC6 decode failed at state 0 (4500us
space)
[  234.650909] ir_jvc_decode: JVC decode started at state 0 (4500us
space)
[  234.650914] ir_jvc_decode: JVC decode failed at state 0 (4500us
space)
[  234.650920] ir_sony_decode: Sony decode started at state 0 (4500us
space)
[  234.650925] ir_sony_decode: Sony decode failed at state 0 (4500us
space)
[  234.650930] ir_lirc_decode: delivering 4500us space to lirc_dev
[  234.650936] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  234.650941] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.650946] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.650951] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.650956] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.650962] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.650967] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.650972] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.650977] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.650981] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.650987] ir_nec_decode: NEC decode started at state 3 (250us
space)
[  234.650993] ir_nec_decode: NEC decode failed at state 3 (250us space)
[  234.650998] ir_rc5_decode: RC5(x) decode failed at state 1 (250us
space)
[  234.651003] ir_rc6_decode: RC6 decode started at state 0 (250us
space)
[  234.651007] ir_rc6_decode: RC6 decode failed at state 0 (250us space)
[  234.651012] ir_jvc_decode: JVC decode failed at state 0 (250us space)
[  234.651018] ir_sony_decode: Sony decode failed at state 0 (250us
space)
[  234.651022] ir_lirc_decode: delivering 250us space to lirc_dev
[  234.651028] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.651033] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.651038] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.651043] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.651048] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.651052] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.651057] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.651062] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.651068] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.651073] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.651077] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.651083] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.651088] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.651093] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.651098] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.651103] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.651108] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.651113] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.651118] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.651123] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.651127] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.651133] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.651138] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.651143] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.651148] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.651153] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.651158] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.651163] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.651168] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.651173] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.651178] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.651182] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.651188] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.651193] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.651198] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.651203] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.651208] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.651213] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.651218] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.651223] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.651228] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.651233] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.651237] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.658835] ir_raw_event_store: sample: (00750us pulse)
[  234.658840] ir_raw_event_store: sample: (00500us space)
[  234.658844] ir_raw_event_store: sample: (00500us pulse)
[  234.658849] ir_raw_event_store: sample: (00500us space)
[  234.658853] ir_raw_event_store: sample: (00750us pulse)
[  234.658857] ir_raw_event_store: sample: (00500us space)
[  234.658862] ir_raw_event_store: sample: (00500us pulse)
[  234.658866] ir_raw_event_store: sample: (00500us space)
[  234.658870] ir_raw_event_store: sample: (00750us pulse)
[  234.658875] ir_raw_event_store: sample: (00500us space)
[  234.658879] ir_raw_event_store: sample: (00500us pulse)
[  234.658884] ir_raw_event_store: sample: (01750us space)
[  234.658888] ir_raw_event_store: sample: (00500us pulse)
[  234.658904] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.658909] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.658914] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.658919] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.658924] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.658929] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.658934] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.658939] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.658944] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.658949] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.658954] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.658960] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.658965] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.658970] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.658975] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.658980] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.658985] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.658990] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.658995] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.659000] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.659004] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.659010] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.659015] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.659020] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.659025] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659030] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.659035] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.659039] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.659044] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.659049] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.659054] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.659059] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.659065] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.659069] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.659074] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.659079] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.659084] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.659089] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.659094] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.659099] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.659104] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.659109] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.659115] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.659119] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.659124] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.659129] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659134] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.659139] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.659144] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.659149] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.659154] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.659159] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.659164] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.659169] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.659174] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.659179] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.659184] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.659189] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.659194] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.659199] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.659204] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.659209] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.659213] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.659219] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.659224] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.659229] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.659233] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659239] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.659243] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.659248] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.659253] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.659258] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.659263] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.659268] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.659273] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.659278] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.659283] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.659288] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.659293] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.659298] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.659303] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.659309] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.659314] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.659319] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.659324] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.659329] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.659334] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.659339] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659344] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.659349] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.659354] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.659359] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.659364] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.659369] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.659373] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.659379] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.659384] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.659389] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.659394] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.659399] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.659403] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.659408] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.659413] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.659418] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.659423] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.659429] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.659434] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.659439] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.659444] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659449] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.659453] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.659459] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.659464] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.659469] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.659474] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.659479] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.659484] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.659489] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.659494] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.659499] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.659504] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.659509] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.659514] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.659519] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.659524] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.659529] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.659534] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.659539] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.659545] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.659550] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.659554] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.659559] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.659564] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.659570] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.659575] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.659580] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.659585] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.659590] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.666833] ir_raw_event_store: sample: (01750us space)
[  234.666838] ir_raw_event_store: sample: (00500us pulse)
[  234.666843] ir_raw_event_store: sample: (00500us space)
[  234.666847] ir_raw_event_store: sample: (00750us pulse)
[  234.666852] ir_raw_event_store: sample: (01500us space)
[  234.666857] ir_raw_event_store: sample: (00750us pulse)
[  234.666861] ir_raw_event_store: sample: (00500us space)
[  234.666866] ir_raw_event_store: sample: (00500us pulse)
[  234.666899] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.666908] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.666915] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.666920] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.666926] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.666932] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.666937] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.666943] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.666949] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.666954] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.666960] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.666967] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.666972] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.666977] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.666982] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.666987] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.666992] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.666998] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.667003] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.667008] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.667013] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.667017] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.667023] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.667028] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.667033] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.667038] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.667043] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.667048] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.667053] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.667058] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.667063] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.667068] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.667074] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.667078] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.667083] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.667089] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.667094] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.667099] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.667104] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.667109] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.667114] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.667119] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.667124] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.667130] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.667135] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.667139] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.667145] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.667150] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.667155] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.667160] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.667165] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.667170] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.667175] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.667181] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.667186] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.667191] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.667196] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.667201] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.667206] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.667211] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.667216] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.667221] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.667226] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.667231] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.667235] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.667241] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.667246] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.667251] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.667256] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.667261] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.667266] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.667271] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.667276] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.667281] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.667286] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.667292] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.667297] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.667302] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.667307] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.667312] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.667317] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.667322] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.667326] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.667331] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.667336] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.667341] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.674838] ir_raw_event_store: sample: (01750us space)
[  234.674844] ir_raw_event_store: sample: (00500us pulse)
[  234.674849] ir_raw_event_store: sample: (01750us space)
[  234.674854] ir_raw_event_store: sample: (00500us pulse)
[  234.674859] ir_raw_event_store: sample: (01750us space)
[  234.674864] ir_raw_event_store: sample: (00500us pulse)
[  234.674868] ir_raw_event_store: sample: (00500us space)
[  234.674873] ir_raw_event_store: sample: (00750us pulse)
[  234.674891] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.674897] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.674902] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.674907] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.674912] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.674918] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.674923] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.674928] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.674933] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.674938] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.674943] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.674950] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.674954] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.674959] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.674964] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.674969] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.674974] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.674979] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.674984] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.674989] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.674994] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.674999] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.675004] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.675009] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.675014] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.675019] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.675024] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.675029] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.675034] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.675039] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.675044] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.675049] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.675054] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.675059] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.675064] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.675069] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.675074] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.675079] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.675084] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.675089] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.675094] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.675099] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.675104] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.675109] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.675114] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.675119] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.675124] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.675129] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.675134] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.675139] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.675145] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.675150] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.675155] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.675160] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.675165] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.675170] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.675175] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.675180] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.675185] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.675190] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.675195] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.675200] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.675205] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.675210] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.675215] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.675219] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.675225] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.675230] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.675235] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.675240] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.675245] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.675250] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.675255] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.675260] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.675265] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.675269] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.675275] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.675280] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.675285] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.675290] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.675295] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.675299] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.675304] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.675309] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.675314] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.675319] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.675324] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.682839] ir_raw_event_store: sample: (01500us space)
[  234.682844] ir_raw_event_store: sample: (00750us pulse)
[  234.682848] ir_raw_event_store: sample: (00500us space)
[  234.682853] ir_raw_event_store: sample: (00500us pulse)
[  234.682857] ir_raw_event_store: sample: (00500us space)
[  234.682861] ir_raw_event_store: sample: (00750us pulse)
[  234.682866] ir_raw_event_store: sample: (00500us space)
[  234.682870] ir_raw_event_store: sample: (00500us pulse)
[  234.682874] ir_raw_event_store: sample: (00500us space)
[  234.682879] ir_raw_event_store: sample: (00750us pulse)
[  234.682883] ir_raw_event_store: sample: (00500us space)
[  234.682887] ir_raw_event_store: sample: (00500us pulse)
[  234.682892] ir_raw_event_store: sample: (00500us space)
[  234.682896] ir_raw_event_store: sample: (00750us pulse)
[  234.682912] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.682917] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.682922] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.682927] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.682932] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.682938] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.682943] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.682948] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.682953] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.682958] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.682963] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.682969] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.682974] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.682979] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.682984] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.682989] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.682994] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.682999] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.683004] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.683009] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.683014] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.683019] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.683024] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683029] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683034] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683039] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683044] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683049] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683054] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683060] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683065] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683069] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683075] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.683080] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.683085] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.683090] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683095] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.683100] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.683105] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.683109] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.683114] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.683119] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.683124] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.683130] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683134] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683139] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683145] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683149] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683154] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683159] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683164] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683169] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683174] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683179] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.683184] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.683189] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.683194] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683199] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.683204] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.683210] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.683215] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.683220] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.683224] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.683229] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.683235] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683240] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683245] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683250] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683255] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683260] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683265] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683270] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683275] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683279] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683285] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.683290] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.683295] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.683300] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683304] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.683309] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.683337] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.683342] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.683347] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.683352] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.683357] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.683363] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683368] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683373] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683378] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683383] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683391] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683400] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683408] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683418] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683426] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683435] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.683444] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.683453] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.683462] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683471] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.683479] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.683488] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.683496] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.683505] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.683514] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.683522] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.683532] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683540] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683549] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683559] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683567] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683576] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683585] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683593] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683602] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683610] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683620] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.683629] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.683637] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.683646] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683655] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.683664] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.683673] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.683681] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.683690] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.683699] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.683708] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.683718] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.683726] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.683735] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.683744] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.683752] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.683761] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.683770] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.683779] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.683788] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.683797] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.683806] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.683815] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.683824] ir_rc5_decode: RC5(x) decode started at state 2 (750us
pulse)
[  234.683833] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.683842] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.683850] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.683859] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.683868] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.683877] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.683886] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.683894] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.690837] ir_raw_event_store: sample: (01500us space)
[  234.690841] ir_raw_event_store: sample: (00750us pulse)
[  234.690846] ir_raw_event_store: sample: (00500us space)
[  234.690850] ir_raw_event_store: sample: (00500us pulse)
[  234.690855] ir_raw_event_store: sample: (01750us space)
[  234.690859] ir_raw_event_store: sample: (00500us pulse)
[  234.690864] ir_raw_event_store: sample: (01750us space)
[  234.690869] ir_raw_event_store: sample: (00500us pulse)
[  234.690883] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.690889] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.690894] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.690899] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.690904] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.690909] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.690914] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.690919] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.690924] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.690929] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.690934] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.690939] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.690944] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.690949] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.690954] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.690959] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.690964] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.690969] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.690974] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.690979] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.690984] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.690989] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.690994] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  234.690999] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  234.691004] ir_rc5_decode: RC5(x) decode started at state 1 (500us
space)
[  234.691009] ir_rc6_decode: RC6 decode started at state 0 (500us
space)
[  234.691014] ir_rc6_decode: RC6 decode failed at state 0 (500us space)
[  234.691019] ir_jvc_decode: JVC decode started at state 0 (500us
space)
[  234.691024] ir_jvc_decode: JVC decode failed at state 0 (500us space)
[  234.691030] ir_sony_decode: Sony decode started at state 0 (500us
space)
[  234.691035] ir_sony_decode: Sony decode failed at state 0 (500us
space)
[  234.691039] ir_lirc_decode: delivering 500us space to lirc_dev
[  234.691045] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.691050] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.691055] ir_rc5_decode: RC5(x) decode started at state 2 (500us
pulse)
[  234.691060] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.691066] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.691070] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.691076] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.691081] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.691086] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.691091] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.691096] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.691102] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.691107] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.691112] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.691117] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.691122] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.691128] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.691133] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.691138] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.691143] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.691148] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.691153] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.691159] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.691164] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.691169] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.691174] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.691179] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.691184] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.691189] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.691195] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.691199] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.691205] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.691210] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.691216] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.691221] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.691226] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.691231] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.691236] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.691241] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.691246] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.691251] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.691256] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.691261] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.691266] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.691272] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.691277] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.691282] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.691287] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.691293] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.691298] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.691303] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.691308] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.691313] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.691318] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.691323] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.698850] ir_raw_event_store: sample: (01750us space)
[  234.698858] ir_raw_event_store: sample: (00500us pulse)
[  234.698863] ir_raw_event_store: sample: (01750us space)
[  234.698867] ir_raw_event_store: sample: (00750us pulse)
[  234.698872] ir_raw_event_store: sample: (01500us space)
[  234.698876] ir_raw_event_store: sample: (00750us pulse)
[  234.698880] ir_raw_event_store: sample: (01500us space)
[  234.698900] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.698905] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.698912] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.698917] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.698923] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.698928] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.698933] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.698939] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.698945] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.698950] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.698956] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.698962] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  234.698967] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  234.698972] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.698977] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.698982] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.698988] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.698993] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.698998] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.699003] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.699008] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.699013] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.699018] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  234.699023] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  234.699028] ir_rc5_decode: RC5(x) decode started at state 1 (1750us
space)
[  234.699034] ir_rc5_decode: RC5(x) decode failed at state 1 (1750us
space)
[  234.699039] ir_rc6_decode: RC6 decode started at state 0 (1750us
space)
[  234.699044] ir_rc6_decode: RC6 decode failed at state 0 (1750us
space)
[  234.699049] ir_jvc_decode: JVC decode started at state 0 (1750us
space)
[  234.699054] ir_jvc_decode: JVC decode failed at state 0 (1750us
space)
[  234.699059] ir_sony_decode: Sony decode started at state 0 (1750us
space)
[  234.699064] ir_sony_decode: Sony decode failed at state 0 (1750us
space)
[  234.699068] ir_lirc_decode: delivering 1750us space to lirc_dev
[  234.699074] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.699079] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.699084] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.699089] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.699093] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.699098] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.699103] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.699108] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.699113] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.699118] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.699123] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.699128] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.699133] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.699138] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.699143] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.699148] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.699153] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.699158] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.699163] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.699168] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.699173] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.699178] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.699184] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.699188] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.699193] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.699198] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.699203] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.699208] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.699213] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.699218] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.699223] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.699228] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.699232] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.699238] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  234.699243] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  234.699248] ir_rc5_decode: RC5(x) decode started at state 1 (1500us
space)
[  234.699253] ir_rc5_decode: RC5(x) decode failed at state 1 (1500us
space)
[  234.699258] ir_rc6_decode: RC6 decode started at state 0 (1500us
space)
[  234.699263] ir_rc6_decode: RC6 decode failed at state 0 (1500us
space)
[  234.699267] ir_jvc_decode: JVC decode started at state 0 (1500us
space)
[  234.699272] ir_jvc_decode: JVC decode failed at state 0 (1500us
space)
[  234.699277] ir_sony_decode: Sony decode started at state 0 (1500us
space)
[  234.699282] ir_sony_decode: Sony decode failed at state 0 (1500us
space)
[  234.699287] ir_lirc_decode: delivering 1500us space to lirc_dev
[  234.706842] ir_raw_event_store: sample: (00750us pulse)
[  234.706858] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  234.706864] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  234.706869] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.706874] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.706879] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.706885] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.706890] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.706895] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.706900] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.706905] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.706910] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.714840] ir_raw_event_set_idle: enter idle mode
[  234.714845] ir_raw_event_store: sample: (15500us space)
[  234.714859] ir_nec_decode: NEC decode started at state 0 (15500us
space)
[  234.714864] ir_nec_decode: NEC decode failed at state 0 (15500us
space)
[  234.714869] ir_rc5_decode: RC5(x) decode started at state 1 (15500us
space)
[  234.714874] ir_rc5_decode: RC5(x) decode failed at state 1 (15500us
space)
[  234.714879] ir_rc6_decode: RC6 decode started at state 0 (15500us
space)
[  234.714884] ir_rc6_decode: RC6 decode failed at state 0 (15500us
space)
[  234.714890] ir_jvc_decode: JVC decode started at state 0 (15500us
space)
[  234.714895] ir_jvc_decode: JVC decode failed at state 0 (15500us
space)
[  234.714900] ir_sony_decode: Sony decode started at state 0 (15500us
space)
[  234.714905] ir_sony_decode: Sony decode failed at state 0 (15500us
space)
[  234.746845] ir_raw_event_set_idle: leave idle mode
[  234.754852] ir_raw_event_store: sample: (09000us pulse)
[  234.754858] ir_raw_event_store: sample: (02250us space)
[  234.754863] ir_raw_event_store: sample: (00750us pulse)
[  234.754883] ir_nec_decode: NEC decode started at state 0 (9000us
pulse)
[  234.754889] ir_rc5_decode: RC5(x) decode started at state 0 (9000us
pulse)
[  234.754894] ir_rc5_decode: RC5(x) decode started at state 1 (8111us
pulse)
[  234.754899] ir_rc5_decode: RC5(x) decode failed at state 1 (8111us
pulse)
[  234.754904] ir_rc6_decode: RC6 decode started at state 0 (9000us
pulse)
[  234.754910] ir_rc6_decode: RC6 decode failed at state 0 (9000us
pulse)
[  234.754915] ir_jvc_decode: JVC decode started at state 0 (9000us
pulse)
[  234.754920] ir_jvc_decode: JVC decode failed at state 0 (9000us
pulse)
[  234.754926] ir_sony_decode: Sony decode started at state 0 (9000us
pulse)
[  234.754932] ir_sony_decode: Sony decode failed at state 0 (9000us
pulse)
[  234.754939] ir_lirc_decode: delivering 9000us pulse to lirc_dev
[  234.754944] ir_nec_decode: NEC decode started at state 1 (2250us
space)
[  234.754949] ir_nec_decode: Discarding last key repeat: event after
key up
[  234.754954] ir_rc5_decode: RC5(x) decode started at state 0 (2250us
space)
[  234.754959] ir_rc5_decode: RC5(x) decode failed at state 0 (2250us
space)
[  234.754964] ir_rc6_decode: RC6 decode started at state 0 (2250us
space)
[  234.754969] ir_rc6_decode: RC6 decode failed at state 0 (2250us
space)
[  234.754974] ir_jvc_decode: JVC decode started at state 0 (2250us
space)
[  234.754979] ir_jvc_decode: JVC decode failed at state 0 (2250us
space)
[  234.754984] ir_sony_decode: Sony decode started at state 0 (2250us
space)
[  234.754989] ir_sony_decode: Sony decode failed at state 0 (2250us
space)
[  234.754994] ir_lirc_decode: delivering 2250us space to lirc_dev
[  234.755000] ir_nec_decode: NEC decode started at state 1 (750us
pulse)
[  234.755005] ir_nec_decode: NEC decode failed at state 1 (750us pulse)
[  234.755009] ir_rc5_decode: RC5(x) decode started at state 0 (750us
pulse)
[  234.755014] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.755019] ir_rc6_decode: RC6 decode started at state 0 (750us
pulse)
[  234.755025] ir_rc6_decode: RC6 decode failed at state 0 (750us pulse)
[  234.755030] ir_jvc_decode: JVC decode started at state 0 (750us
pulse)
[  234.755035] ir_jvc_decode: JVC decode failed at state 0 (750us pulse)
[  234.755040] ir_sony_decode: Sony decode started at state 0 (750us
pulse)
[  234.755045] ir_sony_decode: Sony decode failed at state 0 (750us
pulse)
[  234.755050] ir_lirc_decode: delivering 750us pulse to lirc_dev
[  234.762854] ir_raw_event_set_idle: enter idle mode
[  234.762865] ir_raw_event_store: sample: (10500us space)
[  234.762888] ir_nec_decode: NEC decode started at state 0 (10500us
space)
[  234.762894] ir_nec_decode: NEC decode failed at state 0 (10500us
space)
[  234.762900] ir_rc5_decode: RC5(x) decode started at state 1 (10500us
space)
[  234.762905] ir_rc5_decode: RC5(x) decode failed at state 1 (10500us
space)
[  234.762911] ir_rc6_decode: RC6 decode started at state 0 (10500us
space)
[  234.762916] ir_rc6_decode: RC6 decode failed at state 0 (10500us
space)
[  234.762922] ir_jvc_decode: JVC decode started at state 0 (10500us
space)
[  234.762927] ir_jvc_decode: JVC decode failed at state 0 (10500us
space)
[  234.762933] ir_sony_decode: Sony decode started at state 0 (10500us
space)
[  234.762938] ir_sony_decode: Sony decode failed at state 0 (10500us
space)
[  234.850860] ir_raw_event_set_idle: leave idle mode
[  234.858857] ir_raw_event_store: sample: (09000us pulse)
[  234.858876] ir_nec_decode: NEC decode started at state 0 (9000us
pulse)
[  234.858882] ir_rc5_decode: RC5(x) decode started at state 0 (9000us
pulse)
[  234.858888] ir_rc5_decode: RC5(x) decode started at state 1 (8111us
pulse)
[  234.858893] ir_rc5_decode: RC5(x) decode failed at state 1 (8111us
pulse)
[  234.858899] ir_rc6_decode: RC6 decode started at state 0 (9000us
pulse)
[  234.858904] ir_rc6_decode: RC6 decode failed at state 0 (9000us
pulse)
[  234.858910] ir_jvc_decode: JVC decode started at state 0 (9000us
pulse)
[  234.858916] ir_jvc_decode: JVC decode failed at state 0 (9000us
pulse)
[  234.858922] ir_sony_decode: Sony decode started at state 0 (9000us
pulse)
[  234.858927] ir_sony_decode: Sony decode failed at state 0 (9000us
pulse)
[  234.858934] ir_lirc_decode: delivering 9000us pulse to lirc_dev
[  234.866866] ir_raw_event_store: sample: (02250us space)
[  234.866874] ir_raw_event_store: sample: (00500us pulse)
[  234.866892] ir_nec_decode: NEC decode started at state 1 (2250us
space)
[  234.866897] ir_nec_decode: Discarding last key repeat: event after
key up
[  234.866903] ir_rc5_decode: RC5(x) decode started at state 0 (2250us
space)
[  234.866908] ir_rc5_decode: RC5(x) decode failed at state 0 (2250us
space)
[  234.866914] ir_rc6_decode: RC6 decode started at state 0 (2250us
space)
[  234.866919] ir_rc6_decode: RC6 decode failed at state 0 (2250us
space)
[  234.866925] ir_jvc_decode: JVC decode started at state 0 (2250us
space)
[  234.866930] ir_jvc_decode: JVC decode failed at state 0 (2250us
space)
[  234.866936] ir_sony_decode: Sony decode started at state 0 (2250us
space)
[  234.866941] ir_sony_decode: Sony decode failed at state 0 (2250us
space)
[  234.866947] ir_lirc_decode: delivering 2250us space to lirc_dev
[  234.866953] ir_nec_decode: NEC decode started at state 1 (500us
pulse)
[  234.866958] ir_nec_decode: NEC decode failed at state 1 (500us pulse)
[  234.866963] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.866968] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.866973] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.866978] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.866983] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.866988] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.866993] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.866998] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.867003] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.874861] ir_raw_event_set_idle: enter idle mode
[  234.874869] ir_raw_event_store: sample: (14500us space)
[  234.874888] ir_nec_decode: NEC decode started at state 0 (14500us
space)
[  234.874893] ir_nec_decode: NEC decode failed at state 0 (14500us
space)
[  234.874898] ir_rc5_decode: RC5(x) decode started at state 1 (14500us
space)
[  234.874904] ir_rc5_decode: RC5(x) decode failed at state 1 (14500us
space)
[  234.874909] ir_rc6_decode: RC6 decode started at state 0 (14500us
space)
[  234.874915] ir_rc6_decode: RC6 decode failed at state 0 (14500us
space)
[  234.874920] ir_jvc_decode: JVC decode started at state 0 (14500us
space)
[  234.874926] ir_jvc_decode: JVC decode failed at state 0 (14500us
space)
[  234.874931] ir_sony_decode: Sony decode started at state 0 (14500us
space)
[  234.874936] ir_sony_decode: Sony decode failed at state 0 (14500us
space)
[  234.962877] ir_raw_event_set_idle: leave idle mode
[  234.970876] ir_raw_event_store: sample: (09250us pulse)
[  234.970884] ir_raw_event_store: sample: (02250us space)
[  234.970890] ir_raw_event_store: sample: (00500us pulse)
[  234.970930] ir_nec_decode: NEC decode started at state 0 (9250us
pulse)
[  234.970941] ir_rc5_decode: RC5(x) decode started at state 0 (9250us
pulse)
[  234.970947] ir_rc5_decode: RC5(x) decode started at state 1 (8361us
pulse)
[  234.970953] ir_rc5_decode: RC5(x) decode failed at state 1 (8361us
pulse)
[  234.970958] ir_rc6_decode: RC6 decode started at state 0 (9250us
pulse)
[  234.970964] ir_rc6_decode: RC6 decode failed at state 0 (9250us
pulse)
[  234.970969] ir_jvc_decode: JVC decode started at state 0 (9250us
pulse)
[  234.970974] ir_jvc_decode: JVC decode failed at state 0 (9250us
pulse)
[  234.970980] ir_sony_decode: Sony decode started at state 0 (9250us
pulse)
[  234.970985] ir_sony_decode: Sony decode failed at state 0 (9250us
pulse)
[  234.970993] ir_lirc_decode: delivering 9250us pulse to lirc_dev
[  234.970999] ir_nec_decode: NEC decode started at state 1 (2250us
space)
[  234.971003] ir_nec_decode: Discarding last key repeat: event after
key up
[  234.971009] ir_rc5_decode: RC5(x) decode started at state 0 (2250us
space)
[  234.971014] ir_rc5_decode: RC5(x) decode failed at state 0 (2250us
space)
[  234.971019] ir_rc6_decode: RC6 decode started at state 0 (2250us
space)
[  234.971023] ir_rc6_decode: RC6 decode failed at state 0 (2250us
space)
[  234.971029] ir_jvc_decode: JVC decode started at state 0 (2250us
space)
[  234.971033] ir_jvc_decode: JVC decode failed at state 0 (2250us
space)
[  234.971038] ir_sony_decode: Sony decode started at state 0 (2250us
space)
[  234.971043] ir_sony_decode: Sony decode failed at state 0 (2250us
space)
[  234.971048] ir_lirc_decode: delivering 2250us space to lirc_dev
[  234.971054] ir_nec_decode: NEC decode started at state 1 (500us
pulse)
[  234.971059] ir_nec_decode: NEC decode failed at state 1 (500us pulse)
[  234.971064] ir_rc5_decode: RC5(x) decode started at state 0 (500us
pulse)
[  234.971069] ir_rc5_decode: RC5(x) decode started at state 1 (0us
pulse)
[  234.971074] ir_rc6_decode: RC6 decode started at state 0 (500us
pulse)
[  234.971079] ir_rc6_decode: RC6 decode failed at state 0 (500us pulse)
[  234.971084] ir_jvc_decode: JVC decode started at state 0 (500us
pulse)
[  234.971089] ir_jvc_decode: JVC decode failed at state 0 (500us pulse)
[  234.971094] ir_sony_decode: Sony decode started at state 0 (500us
pulse)
[  234.971099] ir_sony_decode: Sony decode failed at state 0 (500us
pulse)
[  234.971103] ir_lirc_decode: delivering 500us pulse to lirc_dev
[  234.978878] ir_raw_event_set_idle: enter idle mode
[  234.978886] ir_raw_event_store: sample: (10250us space)
[  234.978910] ir_nec_decode: NEC decode started at state 0 (10250us
space)
[  234.978916] ir_nec_decode: NEC decode failed at state 0 (10250us
space)
[  234.978922] ir_rc5_decode: RC5(x) decode started at state 1 (10250us
space)
[  234.978927] ir_rc5_decode: RC5(x) decode failed at state 1 (10250us
space)
[  234.978933] ir_rc6_decode: RC6 decode started at state 0 (10250us
space)
[  234.978938] ir_rc6_decode: RC6 decode failed at state 0 (10250us
space)
[  234.978944] ir_jvc_decode: JVC decode started at state 0 (10250us
space)
[  234.978949] ir_jvc_decode: JVC decode failed at state 0 (10250us
space)
[  234.978955] ir_sony_decode: Sony decode started at state 0 (10250us
space)
[  234.978961] ir_sony_decode: Sony decode failed at state 0 (10250us
space)

This is dmesg after pressing button 1 with only nec protocol enabled:

[  343.918855] ir_raw_event_set_idle: leave idle mode
[  343.926856] ir_raw_event_store: sample: (09250us pulse)
[  343.926875] ir_nec_decode: NEC decode started at state 0 (9250us
pulse)
[  343.934852] ir_raw_event_store: sample: (04250us space)
[  343.934857] ir_raw_event_store: sample: (00750us pulse)
[  343.934862] ir_raw_event_store: sample: (00500us space)
[  343.934867] ir_raw_event_store: sample: (00500us pulse)
[  343.934871] ir_raw_event_store: sample: (00500us space)
[  343.934876] ir_raw_event_store: sample: (00750us pulse)
[  343.934881] ir_raw_event_store: sample: (01500us space)
[  343.934885] ir_raw_event_store: sample: (00750us pulse)
[  343.934890] ir_raw_event_store: sample: (00500us space)
[  343.934895] ir_raw_event_store: sample: (00500us pulse)
[  343.934899] ir_raw_event_store: sample: (00500us space)
[  343.934904] ir_raw_event_store: sample: (00750us pulse)
[  343.934940] ir_nec_decode: NEC decode started at state 1 (4250us
space)
[  343.934953] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.934961] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.934968] ir_nec_decode: NEC decode started at state 2 (500us
pulse)
[  343.934973] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.934979] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.934985] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.934991] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.934996] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.935002] ir_nec_decode: NEC decode started at state 2 (500us
pulse)
[  343.935007] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.935013] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.942862] ir_raw_event_store: sample: (00500us space)
[  343.942871] ir_raw_event_store: sample: (00500us pulse)
[  343.942876] ir_raw_event_store: sample: (00500us space)
[  343.942881] ir_raw_event_store: sample: (00750us pulse)
[  343.942885] ir_raw_event_store: sample: (00500us space)
[  343.942889] ir_raw_event_store: sample: (00750us pulse)
[  343.942894] ir_raw_event_store: sample: (01500us space)
[  343.942898] ir_raw_event_store: sample: (00750us pulse)
[  343.942903] ir_raw_event_store: sample: (01500us space)
[  343.942907] ir_raw_event_store: sample: (00500us pulse)
[  343.942911] ir_raw_event_store: sample: (00500us space)
[  343.942932] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.942940] ir_nec_decode: NEC decode started at state 2 (500us
pulse)
[  343.942946] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.942951] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.942957] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.942962] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.942968] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.942974] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.942980] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.942985] ir_nec_decode: NEC decode started at state 2 (500us
pulse)
[  343.942991] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.950857] ir_raw_event_store: sample: (00750us pulse)
[  343.950863] ir_raw_event_store: sample: (01500us space)
[  343.950867] ir_raw_event_store: sample: (00750us pulse)
[  343.950871] ir_raw_event_store: sample: (00500us space)
[  343.950875] ir_raw_event_store: sample: (00750us pulse)
[  343.950880] ir_raw_event_store: sample: (01500us space)
[  343.950885] ir_raw_event_store: sample: (00750us pulse)
[  343.950889] ir_raw_event_store: sample: (01500us space)
[  343.950902] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.950909] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.950916] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.950921] ir_nec_decode: NEC decode started at state 3 (500us
space)
[  343.950927] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.950933] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.950939] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.950944] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.958856] ir_raw_event_store: sample: (00750us pulse)
[  343.958861] ir_raw_event_store: sample: (01500us space)
[  343.958865] ir_raw_event_store: sample: (00750us pulse)
[  343.958869] ir_raw_event_store: sample: (00250us space)
[  343.958874] ir_raw_event_store: sample: (00750us pulse)
[  343.958878] ir_raw_event_store: sample: (01500us space)
[  343.958883] ir_raw_event_store: sample: (00750us pulse)
[  343.958887] ir_raw_event_store: sample: (00500us space)
[  343.958892] ir_raw_event_store: sample: (00750us pulse)
[  343.958896] ir_raw_event_store: sample: (00500us space)
[  343.958910] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.958916] ir_nec_decode: NEC decode started at state 3 (1500us
space)
[  343.958922] ir_nec_decode: NEC decode started at state 2 (750us
pulse)
[  343.958927] ir_nec_decode: NEC decode started at state 3 (250us
space)
[  343.958932] ir_nec_decode: NEC decode failed at state 3 (250us space)
[  343.958938] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.958943] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.958949] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.958954] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.958959] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.958964] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.958970] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.958975] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.958980] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.958985] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.958991] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.958995] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.966858] ir_raw_event_store: sample: (00500us pulse)
[  343.966863] ir_raw_event_store: sample: (00500us space)
[  343.966867] ir_raw_event_store: sample: (00750us pulse)
[  343.966871] ir_raw_event_store: sample: (00500us space)
[  343.966876] ir_raw_event_store: sample: (00500us pulse)
[  343.966880] ir_raw_event_store: sample: (00500us space)
[  343.966884] ir_raw_event_store: sample: (00750us pulse)
[  343.966889] ir_raw_event_store: sample: (00500us space)
[  343.966893] ir_raw_event_store: sample: (00500us pulse)
[  343.966898] ir_raw_event_store: sample: (01750us space)
[  343.966902] ir_raw_event_store: sample: (00500us pulse)
[  343.966907] ir_raw_event_store: sample: (00500us space)
[  343.966924] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  343.966929] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  343.966935] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.966940] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.966945] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.966950] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.966956] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.966960] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.966966] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  343.966972] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  343.966977] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.966982] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.966988] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.966992] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.966998] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.967003] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.967008] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  343.967013] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  343.967019] ir_nec_decode: NEC decode started at state 0 (1750us
space)
[  343.967024] ir_nec_decode: NEC decode failed at state 0 (1750us
space)
[  343.967029] ir_nec_decode: NEC decode started at state 0 (500us
pulse)
[  343.967034] ir_nec_decode: NEC decode failed at state 0 (500us pulse)
[  343.967040] ir_nec_decode: NEC decode started at state 0 (500us
space)
[  343.967045] ir_nec_decode: NEC decode failed at state 0 (500us space)
[  343.974857] ir_raw_event_store: sample: (00750us pulse)
[  343.974862] ir_raw_event_store: sample: (01500us space)
[  343.974867] ir_raw_event_store: sample: (00750us pulse)
[  343.974871] ir_raw_event_store: sample: (01500us space)
[  343.974876] ir_raw_event_store: sample: (00750us pulse)
[  343.974880] ir_raw_event_store: sample: (01500us space)
[  343.974884] ir_raw_event_store: sample: (00750us pulse)
[  343.974902] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.974907] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.974913] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.974918] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.974924] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.974928] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.974934] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.974939] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.974944] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.974949] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.974955] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.974960] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.974965] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.974970] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.982859] ir_raw_event_store: sample: (01500us space)
[  343.982864] ir_raw_event_store: sample: (00750us pulse)
[  343.982868] ir_raw_event_store: sample: (01500us space)
[  343.982873] ir_raw_event_store: sample: (00750us pulse)
[  343.982877] ir_raw_event_store: sample: (01500us space)
[  343.982882] ir_raw_event_store: sample: (00750us pulse)
[  343.982899] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.982904] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.982910] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.982915] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.982920] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.982925] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.982931] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.982936] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.982941] ir_nec_decode: NEC decode started at state 0 (1500us
space)
[  343.982946] ir_nec_decode: NEC decode failed at state 0 (1500us
space)
[  343.982952] ir_nec_decode: NEC decode started at state 0 (750us
pulse)
[  343.982957] ir_nec_decode: NEC decode failed at state 0 (750us pulse)
[  343.990859] ir_raw_event_set_idle: enter idle mode
[  343.990865] ir_raw_event_store: sample: (10250us space)
[  343.990884] ir_nec_decode: NEC decode started at state 0 (10250us
space)
[  343.990889] ir_nec_decode: NEC decode failed at state 0 (10250us
space)
[  344.022862] ir_raw_event_set_idle: leave idle mode
[  344.038873] ir_raw_event_store: sample: (09250us pulse)
[  344.038881] ir_raw_event_store: sample: (02000us space)
[  344.038886] ir_raw_event_store: sample: (00750us pulse)
[  344.038904] ir_nec_decode: NEC decode started at state 0 (9250us
pulse)
[  344.038912] ir_nec_decode: NEC decode started at state 1 (2000us
space)
[  344.038917] ir_nec_decode: Discarding last key repeat: event after
key up
[  344.038923] ir_nec_decode: NEC decode started at state 1 (750us
pulse)
[  344.038928] ir_nec_decode: NEC decode failed at state 1 (750us pulse)
[  344.046864] ir_raw_event_set_idle: enter idle mode
[  344.046869] ir_raw_event_store: sample: (13250us space)
[  344.046883] ir_nec_decode: NEC decode started at state 0 (13250us
space)
[  344.046888] ir_nec_decode: NEC decode failed at state 0 (13250us
space)
[  344.134878] ir_raw_event_set_idle: leave idle mode
[  344.142884] ir_raw_event_store: sample: (09000us pulse)
[  344.142892] ir_raw_event_store: sample: (02250us space)
[  344.142897] ir_raw_event_store: sample: (00500us pulse)
[  344.142914] ir_nec_decode: NEC decode started at state 0 (9000us
pulse)
[  344.142922] ir_nec_decode: NEC decode started at state 1 (2250us
space)
[  344.142927] ir_nec_decode: Discarding last key repeat: event after
key up
[  344.142932] ir_nec_decode: NEC decode started at state 1 (500us
pulse)
[  344.142937] ir_nec_decode: NEC decode failed at state 1 (500us pulse)
[  344.158879] ir_raw_event_set_idle: enter idle mode
[  344.158888] ir_raw_event_store: sample: (17250us space)
[  344.158902] ir_nec_decode: NEC decode started at state 0 (17250us
space)
[  344.158907] ir_nec_decode: NEC decode failed at state 0 (17250us
space)
[  344.238887] ir_raw_event_set_idle: leave idle mode
[  344.254895] ir_raw_event_store: sample: (09000us pulse)
[  344.254902] ir_raw_event_store: sample: (02250us space)
[  344.254907] ir_raw_event_store: sample: (00750us pulse)
[  344.254923] ir_nec_decode: NEC decode started at state 0 (9000us
pulse)
[  344.254931] ir_nec_decode: NEC decode started at state 1 (2250us
space)
[  344.254936] ir_nec_decode: Discarding last key repeat: event after
key up
[  344.254942] ir_nec_decode: NEC decode started at state 1 (750us
pulse)
[  344.254947] ir_nec_decode: NEC decode failed at state 1 (750us pulse)
[  344.262890] ir_raw_event_set_idle: enter idle mode
[  344.262895] ir_raw_event_store: sample: (12750us space)
[  344.262909] ir_nec_decode: NEC decode started at state 0 (12750us
space)
[  344.262914] ir_nec_decode: NEC decode failed at state 0 (12750us
space)
[  349.039421] ir_raw_event_set_idle: leave idle mode
[  349.039430] ir_raw_event_store: sample: (00250us pulse)
[  349.039448] ir_nec_decode: NEC decode started at state 0 (250us
pulse)
[  349.039454] ir_nec_decode: NEC decode failed at state 0 (250us pulse)
[  349.047418] ir_raw_event_set_idle: enter idle mode
[  349.047424] ir_raw_event_store: sample: (10750us space)
[  349.047441] ir_nec_decode: NEC decode started at state 0 (10750us
space)
[  349.047447] ir_nec_decode: NEC decode failed at state 0 (10750us
space)

Heiko
