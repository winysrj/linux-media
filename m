Return-path: <mchehab@pedra>
Received: from smtprelay01.ispgateway.de ([80.67.29.23]:47339 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1D0Srx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 14:47:53 -0400
Date: Wed, 27 Apr 2011 20:47:25 +0200
From: Heiko Baums <lists@baums-on-web.de>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: "mailing list: lirc" <lirc-list@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Terratec Cinergy 1400 DVB-T RC not working anymore
Message-ID: <20110427204725.2923ac99@darkstar>
In-Reply-To: <1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com>
References: <20110423005412.12978e29@darkstar>
	<20110424163530.2bc1b365@darkstar>
	<BCCEA9F4-16D7-4E63-B32C-15217AA094F3@wilsonet.com>
	<20110425201835.0fbb84ee@darkstar>
	<A4226E90-09BE-45FE-AEEF-0EA7E9414B4B@wilsonet.com>
	<20110425230658.22551665@darkstar>
	<59898A0D-573E-46E9-A3B7-9054B24E69DF@wilsonet.com>
	<20110427151621.5ac73e12@darkstar>
	<1FB1ED64-0EEC-4E15-8178-D2CCCA915B1D@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am Wed, 27 Apr 2011 14:28:41 -0400
schrieb Jarod Wilson <jarod@wilsonet.com>:

> Moving this over to linux-media, this stuff is all rc-core and is
> more of what I meant should be discussed over here/there. :)

> Hrm, ok, so *something* is resulting in scancodes... This is progress!
> (I think...) :)

I'm not too optimistic. ;-)

> > This is one line of the ir-keytable -t output:
> > 1303909988.799949: event MSC: scancode = 4eb02
> 
> With rc-core debugging, there ought to be a line in all that dmesg
> spew that contains that scancode, which would also give us the
> protocol decoder that came up with that scancode. Based on the
> default protocol listed for your board and the length of the
> scancode, I'd guess that it is NEC Extended, but it could also be
> RC-5X or maybe Sony...

This is what dmesg says:

[   13.916390] Linux video capture interface: v2.00
[   13.928725] IR NEC protocol handler initialized
[   13.933412] cx88/0: cx2388x v4l2 driver version 0.0.8 loaded
[   13.935274] IR RC5(x) protocol handler initialized
[   13.936114] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.8
loaded [   13.936381] cx8800 0000:03:06.0: PCI INT A -> GSI 20 (level,
low) -> IRQ 20 [   13.937649] cx88[0]: subsystem: 153b:1166, board:
TerraTec Cinergy 1400 DVB-T [card=30,autodetected], frontend(s): 1
[   13.937652] cx88[0]: TV tuner type 4, Radio tuner type 0
[   13.978933] IR RC6 protocol handler initialized [   14.121384] IR
JVC protocol handler initialized [   14.149078] IR Sony protocol
handler initialized [   14.161237] lirc_dev: IR Remote Control driver
registered, major 252 [   14.162378] IR LIRC bridge handler initialized
[   14.166886] input: ImPS/2 Logitech Wheel Mouse
as /devices/platform/i8042/serio1/input/input3 [   14.170066]
Registered IR keymap rc-cinergy-1400 [   14.170112] ir_create_table:
Allocated space for 64 keycode entries (512 bytes) [   14.170114]
ir_setkeytable: Allocated space for 64 keycode entries (512 bytes)
[   14.170117] ir_update_mapping: #0: New scan 0x0001 with key 0x0074
[   14.170119] ir_update_mapping: #1: New scan 0x0002 with key 0x0002
[   14.170120] ir_update_mapping: #2: New scan 0x0003 with key 0x0003
[   14.170122] ir_update_mapping: #3: New scan 0x0004 with key 0x0004
[   14.170124] ir_update_mapping: #4: New scan 0x0005 with key 0x0005
[   14.170125] ir_update_mapping: #5: New scan 0x0006 with key 0x0006
[   14.170127] ir_update_mapping: #6: New scan 0x0007 with key 0x0007
[   14.170129] ir_update_mapping: #7: New scan 0x0008 with key 0x0008
[   14.170130] ir_update_mapping: #8: New scan 0x0009 with key 0x0009
[   14.170132] ir_update_mapping: #9: New scan 0x000a with key 0x000a
[   14.170134] ir_update_mapping: #10: New scan 0x000c with key 0x000b
[   14.170136] ir_update_mapping: #10: New scan 0x000b with key 0x0189
[   14.170138] ir_update_mapping: #12: New scan 0x000d with key 0x00ad
[   14.170139] ir_update_mapping: #13: New scan 0x000e with key 0x0161
[   14.170141] ir_update_mapping: #14: New scan 0x000f with key 0x016d
[   14.170143] ir_update_mapping: #15: New scan 0x0010 with key 0x0067
[   14.170145] ir_update_mapping: #16: New scan 0x0011 with key 0x0069
[   14.170146] ir_update_mapping: #17: New scan 0x0012 with key 0x0160
[   14.170148] ir_update_mapping: #18: New scan 0x0013 with key 0x006a
[   14.170150] ir_update_mapping: #19: New scan 0x0014 with key 0x006c
[   14.170151] ir_update_mapping: #20: New scan 0x0015 with key 0x0184
[   14.170153] ir_update_mapping: #21: New scan 0x0016 with key 0x0166
[   14.170155] ir_update_mapping: #22: New scan 0x0017 with key 0x018e
[   14.170157] ir_update_mapping: #23: New scan 0x0018 with key 0x018f
[   14.170158] ir_update_mapping: #24: New scan 0x0019 with key 0x0190
[   14.170160] ir_update_mapping: #25: New scan 0x001a with key 0x0191
[   14.170162] ir_update_mapping: #26: New scan 0x001b with key 0x0192
[   14.170163] ir_update_mapping: #27: New scan 0x001c with key 0x0073
[   14.170165] ir_update_mapping: #28: New scan 0x001d with key 0x0071
[   14.170167] ir_update_mapping: #29: New scan 0x001e with key 0x0072
[   14.170169] ir_update_mapping: #30: New scan 0x001f with key 0x0193
[   14.170170] ir_update_mapping: #31: New scan 0x0040 with key 0x0077
[   14.170172] ir_update_mapping: #32: New scan 0x004c with key 0x00cf
[   14.170174] ir_update_mapping: #33: New scan 0x0058 with key 0x00a7
[   14.170176] ir_update_mapping: #33: New scan 0x0054 with key 0x019c
[   14.170177] ir_update_mapping: #32: New scan 0x0048 with key 0x0080
[   14.170179] ir_update_mapping: #36: New scan 0x005c with key 0x0197
[   14.170221] input: cx88 IR (TerraTec Cinergy 1400
as /devices/pci0000:00/0000:00:14.4/0000:03:06.0/rc/rc0/input4
[   14.170280] rc0: cx88 IR (TerraTec Cinergy 1400
as /devices/pci0000:00/0000:00:14.4/0000:03:06.0/rc/rc0 [   14.171310]
rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) registered at minor = 0
[   14.171314] rc_register_device: Registered rc0 (driver: cx88xx,
remote: rc-cinergy-1400, mode raw) [   14.171322] cx88[0]/0: found at
0000:03:06.0, rev: 5, irq: 20, latency: 32, mmio: 0xfb000000
[   14.171394] cx88[0]/0: registered device video0 [v4l2]
[   14.171425] cx88[0]/0: registered device vbi0 [   14.173495]
cx88[0]/2: cx2388x 8802 Driver Manager [   14.173512] cx88-mpeg driver
manager 0000:03:06.2: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   14.173522] cx88[0]/2: found at 0000:03:06.2, rev: 5, irq: 20,
latency: 32, mmio: 0xfa000000 [   14.186253] ir_nec_decode: NEC decode
failed at state 0 (16000us space) [   14.186257] ir_rc5_decode: RC5(x)
decode failed at state 0 (16000us space) [   14.186260] ir_rc6_decode:
RC6 decode failed at state 0 (16000us space) [   14.186262]
ir_jvc_decode: JVC decode failed at state 0 (16000us space)
[   14.186264] ir_sony_decode: Sony decode failed at state 0 (16000us
space) [   14.249064] cx88/2: cx2388x dvb driver version 0.0.8 loaded
[   14.249067] cx88/2: registering cx8802 driver, type: dvb access:
shared [   14.249070] cx88[0]/2: subsystem: 153b:1166, board: TerraTec
Cinergy 1400 DVB-T [card=30] [   14.249073] cx88[0]/2: cx2388x based
DVB/ATSC card [   14.249074] cx8802_alloc_frontends() allocating 1
frontend(s) [   14.373694] DVB: registering new adapter (cx88[0])
[   14.373699] DVB: registering adapter 0 frontend 0 (Conexant CX22702
DVB-T)... [   14.605781] show_protocols: allowed - 0x4000001f, enabled
- 0xffffffffffffffff [   14.676694] ir_update_mapping: #0: Deleting
scan 0x0001 [   14.676698] ir_update_mapping: #0: Deleting scan 0x0002
[   14.676700] ir_update_mapping: #0: Deleting scan 0x0003
[   14.676702] ir_update_mapping: #0: Deleting scan 0x0004
[   14.676705] ir_update_mapping: #0: Deleting scan 0x0005
[   14.676706] ir_update_mapping: #0: Deleting scan 0x0006
[   14.676709] ir_update_mapping: #0: Deleting scan 0x0007
[   14.676710] ir_update_mapping: #0: Deleting scan 0x0008
[   14.676713] ir_update_mapping: #0: Deleting scan 0x0009
[   14.676715] ir_update_mapping: #0: Deleting scan 0x000a
[   14.676716] ir_update_mapping: #0: Deleting scan 0x000b
[   14.676718] ir_update_mapping: #0: Deleting scan 0x000c
[   14.676720] ir_update_mapping: #0: Deleting scan 0x000d
[   14.676722] ir_update_mapping: #0: Deleting scan 0x000e
[   14.676724] ir_update_mapping: #0: Deleting scan 0x000f
[   14.676726] ir_update_mapping: #0: Deleting scan 0x0010
[   14.676727] ir_resize_table: Shrinking table to 256 bytes
[   14.676730] ir_update_mapping: #0: Deleting scan 0x0011
[   14.676732] ir_update_mapping: #0: Deleting scan 0x0012
[   14.676734] ir_update_mapping: #0: Deleting scan 0x0013
[   14.676735] ir_update_mapping: #0: Deleting scan 0x0014
[   14.676737] ir_update_mapping: #0: Deleting scan 0x0015
[   14.676739] ir_update_mapping: #0: Deleting scan 0x0016
[   14.676741] ir_update_mapping: #0: Deleting scan 0x0017
[   14.676743] ir_update_mapping: #0: Deleting scan 0x0018
[   14.676744] ir_update_mapping: #0: Deleting scan 0x0019
[   14.676746] ir_update_mapping: #0: Deleting scan 0x001a
[   14.676748] ir_update_mapping: #0: Deleting scan 0x001b
[   14.676750] ir_update_mapping: #0: Deleting scan 0x001c
[   14.676752] ir_update_mapping: #0: Deleting scan 0x001d
[   14.676753] ir_update_mapping: #0: Deleting scan 0x001e
[   14.676755] ir_update_mapping: #0: Deleting scan 0x001f
[   14.676757] ir_update_mapping: #0: Deleting scan 0x0040
[   14.676759] ir_update_mapping: #0: Deleting scan 0x0048
[   14.676761] ir_update_mapping: #0: Deleting scan 0x004c
[   14.676762] ir_update_mapping: #0: Deleting scan 0x0054
[   14.676764] ir_update_mapping: #0: Deleting scan 0x0058
[   14.676766] ir_update_mapping: #0: Deleting scan 0x005c
[   14.676772] ir_update_mapping: #0: New scan 0x0001 with key 0x0074
[   14.676774] ir_update_mapping: #1: New scan 0x0002 with key 0x0002
[   14.676777] ir_update_mapping: #2: New scan 0x0003 with key 0x0003
[   14.676779] ir_update_mapping: #3: New scan 0x0004 with key 0x0004
[   14.676781] ir_update_mapping: #4: New scan 0x0005 with key 0x0005
[   14.676783] ir_update_mapping: #5: New scan 0x0006 with key 0x0006
[   14.676786] ir_update_mapping: #6: New scan 0x0007 with key 0x0007
[   14.676788] ir_update_mapping: #7: New scan 0x0008 with key 0x0008
[   14.676790] ir_update_mapping: #8: New scan 0x0009 with key 0x0009
[   14.676792] ir_update_mapping: #9: New scan 0x000a with key 0x000a
[   14.676795] ir_update_mapping: #10: New scan 0x000c with key 0x000b
[   14.676797] ir_update_mapping: #10: New scan 0x000b with key 0x0189
[   14.676799] ir_update_mapping: #12: New scan 0x000d with key 0x00ad
[   14.676802] ir_update_mapping: #13: New scan 0x000e with key 0x0161
[   14.676804] ir_update_mapping: #14: New scan 0x000f with key 0x016d
[   14.676806] ir_update_mapping: #15: New scan 0x0010 with key 0x0067
[   14.676808] ir_update_mapping: #16: New scan 0x0011 with key 0x0069
[   14.676810] ir_update_mapping: #17: New scan 0x0012 with key 0x0160
[   14.676813] ir_update_mapping: #18: New scan 0x0013 with key 0x006a
[   14.676815] ir_update_mapping: #19: New scan 0x0014 with key 0x006c
[   14.676817] ir_update_mapping: #20: New scan 0x0015 with key 0x0184
[   14.676819] ir_update_mapping: #21: New scan 0x0016 with key 0x0166
[   14.676822] ir_update_mapping: #22: New scan 0x0017 with key 0x018e
[   14.676824] ir_update_mapping: #23: New scan 0x0018 with key 0x018f
[   14.676826] ir_update_mapping: #24: New scan 0x0019 with key 0x0190
[   14.676828] ir_update_mapping: #25: New scan 0x001a with key 0x0191
[   14.676830] ir_update_mapping: #26: New scan 0x001b with key 0x0192
[   14.676833] ir_update_mapping: #27: New scan 0x001c with key 0x0073
[   14.676835] ir_update_mapping: #28: New scan 0x001d with key 0x0071
[   14.676837] ir_update_mapping: #29: New scan 0x001e with key 0x0072
[   14.676839] ir_update_mapping: #30: New scan 0x001f with key 0x0193
[   14.676842] ir_update_mapping: #31: New scan 0x0040 with key 0x0077
[   14.676844] ir_resize_table: Growing table to 512 bytes
[   14.676846] ir_update_mapping: #32: New scan 0x004c with key 0x00cf
[   14.676848] ir_update_mapping: #33: New scan 0x0058 with key 0x00a7
[   14.676850] ir_update_mapping: #33: New scan 0x0054 with key 0x019c
[   14.676853] ir_update_mapping: #32: New scan 0x0048 with key 0x0080
[   14.676855] ir_update_mapping: #36: New scan 0x005c with key 0x0197
[   14.676921] store_protocols: Current protocol(s): 0x0

> > I'll ask on the linux-media list.
> 
> This mail I'm replying to was what really what I think needed to go
> there, not the one that started the thread. ;)

Oh, sorry. Too late. ;-)
Must have misunderstood this, but I guess, it can't hurt anyway.

Heiko
