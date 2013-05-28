Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52931 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3E1SkF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 14:40:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1UhOoV-0003CU-PO
	for linux-media@vger.kernel.org; Tue, 28 May 2013 20:40:03 +0200
Received: from p54BD24E2.dip0.t-ipconnect.de ([84.189.36.226])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 20:40:03 +0200
Received: from debian by p54BD24E2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 20:40:03 +0200
To: linux-media@vger.kernel.org
From: Martin Kittel <debian@martin-kittel.de>
Subject: cx88 dvb initialization fails
Date: Tue, 28 May 2013 18:34:18 +0000 (UTC)
Message-ID: <loom.20130528T202204-25@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

with Debian kernel 3.2 I had the rare problem that dvb on my  Hauppauge
WinTV-HVR1300 was not always initialized properly on boot. After an upgrade
to Debian kernel 3.8 and then for testing reasons to vanilla 3.9.4 I can
reproduce this problem on every boot. This is from my dmesg output for
vanilla 3.9.4 with debug for the cx88* modules enabled:

[    6.329655] hda_intel: Disabling MSI
[    6.329773] snd_hda_intel 0000:00:07.0: setting latency timer to 64
[    6.811772] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[    6.814199] cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300
DVB-T/Hybrid MPEG Encoder [card=56,autodetected], frontend(s): 1
[    6.814273] cx88[0]: TV tuner type 63, Radio tuner type -1
[    6.833393] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[    6.934169] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000
tuner
[    6.999507] tda9887 2-0043: creating new instance
[    6.999570] tda9887 2-0043: tda988[5/6/7] found
[    7.000465] tuner 2-0043: Tuner 74 found with type(s) Radio TV.
[    7.004727] tuner 2-0061: Tuner -1 found with type(s) Radio TV.
[    7.043558] tveeprom 2-0050: Hauppauge model 96019, rev D6D3, serial# 3106328
[    7.043609] tveeprom 2-0050: MAC address is 00:0d:fe:2f:66:18
[    7.043657] tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133,
type 78)
[    7.043717] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    7.043777] tveeprom 2-0050: audio processor is CX882 (idx 33)
[    7.043824] tveeprom 2-0050: decoder processor is CX882 (idx 25)
[    7.043872] tveeprom 2-0050: has radio, has IR receiver, has IR transmitter
[    7.043919] cx88[0]: hauppauge eeprom: model=96019
[    7.068691] tuner-simple 2-0061: creating new instance
[    7.068744] tuner-simple 2-0061: type set to 78 (Philips FMD1216MEX MK3
Hybrid Tuner)
[    7.074643] cx88[0]/2: cx2388x 8802 Driver Manager
[    7.075297] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
[    7.075388] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 17, latency:
64, mmio: 0xfa000000
[    7.076348] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 17, latency:
64, mmio: 0xfc000000
[    7.134043] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[    7.134101] cx88/2: registering cx8802 driver, type: dvb access: shared
[    7.134154] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[    7.134221] cx88[0]/2-dvb: cx8802_dvb_probe
[    7.134228] cx88[0]/2-dvb:  ->being probed by Card=56 Name=cx88[0], PCI 01:07
[    7.134232] cx88[0]/2: cx2388x based DVB/ATSC card
[    7.134280] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.147301] i2c i2c-2: sendbytes: NAK bailout.
[    7.147380] cx22702_readreg: error (reg == 0x1f, ret == -5)
[    7.147429] cx88[0]/2: frontend initialization failed
[    7.147477] cx88[0]/2: dvb_register failed (err = -22)
[    7.147523] cx88[0]/2: cx8802 probe failed, err = -22
[    7.158710] wm8775 2-001b: chip found @ 0x36 (cx88[0])
[    7.174150] cx88[0]/0: registered device video0 [v4l2]
[    7.174332] cx88[0]/0: registered device vbi0
[    7.174477] cx88[0]/0: registered device radio0
[    7.202891] cx2388x blackbird driver version 0.0.9 loaded
[    7.202949] cx88/2: registering cx8802 driver, type: blackbird access: shared
[    7.203002] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[    7.203143] cx88[0]/2: cx23416 based mpeg encoder (blackbird reference
design)
[    7.203421] cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
or corrupted
...
[    9.680686] cx88[0]/2-bb: Firmware upload successful.
[    9.689682] cx88[0]/2-bb: Firmware version is 0x02060039
[    9.705095] cx88[0]/2: registered device video1 [mpeg]
[    9.709579] cx88[0]/2-mpeg: cx8802_request_acquire() Post acquire GPIO=ef9e
[    9.715684] cx88[0]/2-mpeg: cx8802_cancel_buffers
[    9.715687] cx88[0]/2-mpeg: cx8802_stop_dma
[    9.715697] cx88[0]/2-mpeg: cx8802_request_release() Post release GPIO=ef9e
[   11.194791] Adding 979928k swap on /dev/sdb6.  Priority:-1 extents:1
across:979928k 
...
[   12.012055] Registered IR keymap rc-hauppauge
[   12.012300] input: i2c IR (cx88 Hauppauge XVR remo as
/devices/virtual/rc/rc0/input12
[   12.012505] rc0: i2c IR (cx88 Hauppauge XVR remo as /devices/virtual/rc/rc0
[   12.012551] ir-kbd-i2c: i2c IR (cx88 Hauppauge XVR remo detected at
i2c-2/2-0071/ir0 [cx88[0]]
...

After booting, if I remove the modules via 
 modprobe -r cx88_blackbird cx88_dvb cx88_alsa cx88_vp3054_i2c cx22702 
and reinsert them using
 modprobe  cx8802
initialization is running fine and dvb is available:

[  478.523553] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.9 loaded
[  478.525947] cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 DVB
-T/Hybrid MPEG Encoder [card=56,autodetected], frontend(s): 1
[  478.526021] cx88[0]: TV tuner type 63, Radio tuner type -1
[  478.646200] cx88[0]: i2c init: enabling analog demod on HVR1300/3000/4000
tuner
[  478.657713] tda9887 2-0043: creating new instance
[  478.657771] tda9887 2-0043: tda988[5/6/7] found
[  478.658624] tuner 2-0043: Tuner 74 found with type(s) Radio TV.
[  478.664518] tuner 2-0061: Tuner -1 found with type(s) Radio TV.
[  478.703370] tveeprom 2-0050: Hauppauge model 96019, rev D6D3, serial# 3106328
[  478.703422] tveeprom 2-0050: MAC address is 00:0d:fe:2f:66:18
[  478.703470] tveeprom 2-0050: tuner model is Philips FMD1216MEX (idx 133,
type 78)
[  478.703529] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[  478.703590] tveeprom 2-0050: audio processor is CX882 (idx 33)
[  478.703637] tveeprom 2-0050: decoder processor is CX882 (idx 25)
[  478.703684] tveeprom 2-0050: has radio, has IR receiver, has IR transmitter
[  478.703732] cx88[0]: hauppauge eeprom: model=96019
[  478.706772] tuner-simple 2-0061: creating new instance
[  478.706820] tuner-simple 2-0061: type set to 78 (Philips FMD1216MEX MK3
Hybrid Tuner)
[  478.712720] Registered IR keymap rc-hauppauge
[  478.713022] input: i2c IR (cx88 Hauppauge XVR remo as
/devices/virtual/rc/rc1/input13
[  478.714504] rc1: i2c IR (cx88 Hauppauge XVR remo as /devices/virtual/rc/rc1
[  478.714566] ir-kbd-i2c: i2c IR (cx88 Hauppauge XVR remo detected at
i2c-2/2-0071/ir0 [cx88[0]]
[  478.714681] cx88[0]/2: cx2388x 8802 Driver Manager
[  478.714911] cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 17, latency:
64, mmio: 0xfa000000
[  478.725707] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[  478.725767] cx88/2: registering cx8802 driver, type: dvb access: shared
[  478.725818] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[  478.725878] cx88[0]/2-dvb: cx8802_dvb_probe
[  478.725884] cx88[0]/2-dvb:  ->being probed by Card=56 Name=cx88[0], PCI 01:07
[  478.725889] cx88[0]/2: cx2388x based DVB/ATSC card
[  478.725934] cx8802_alloc_frontends() allocating 1 frontend(s)
[  478.731736] cx22702_i2c_gate_ctrl(1)
[  478.733386] cx22702_i2c_gate_ctrl(0)
[  478.734600] tuner-simple 2-0061: attaching existing instance
[  478.734650] tuner-simple 2-0061: couldn't set type to 63. Using 78
(Philips FMD1216MEX MK3 Hybrid Tuner) instead
[  478.734712] cx22702_i2c_gate_ctrl(1)
[  478.737634] cx22702_i2c_gate_ctrl(0)
[  478.738851] DVB: registering new adapter (cx88[0])
[  478.738907] cx88-mpeg driver manager 0000:01:07.2: DVB: registering
adapter 0 frontend 0 (Conexant CX22702 DVB-T)...
[  478.748769] cx88/0: cx2388x v4l2 driver version 0.0.9 loaded
[  478.749079] cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 17, latency:
64, mmio: 0xfc000000
[  478.755747] wm8775 2-001b: chip found @ 0x36 (cx88[0])
[  478.762421] cx22702_i2c_gate_ctrl(1)
[  478.766057] cx22702_i2c_gate_ctrl(0)
[  478.767274] cx22702_i2c_gate_ctrl(1)
[  478.769973] cx22702_i2c_gate_ctrl(0)
[  478.771176] cx22702_i2c_gate_ctrl(1)
[  478.773864] cx22702_i2c_gate_ctrl(0)
[  478.775063] cx22702_i2c_gate_ctrl(1)
[  478.777756] cx22702_i2c_gate_ctrl(0)
[  478.778965] cx22702_i2c_gate_ctrl(1)
[  478.781656] cx22702_i2c_gate_ctrl(0)
[  478.783002] cx88[0]/0: registered device video0 [v4l2]
[  478.783199] cx88[0]/0: registered device vbi0
[  478.783338] cx88[0]/0: registered device radio0
[  478.789012] cx2388x blackbird driver version 0.0.9 loaded
[  478.789071] cx88/2: registering cx8802 driver, type: blackbird access: shared
[  478.789123] cx88[0]/2: subsystem: 0070:9601, board: Hauppauge
WinTV-HVR1300 DVB-T/Hybrid MPEG Encoder [card=56]
[  478.789273] cx88[0]/2: cx23416 based mpeg encoder (blackbird reference
design)
[  478.789550] cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
or corrupted
[  481.211550] cx88[0]/2-bb: ERROR: Firmware load failed (checksum mismatch).
[  481.211753] cx22702_i2c_gate_ctrl(1)
[  481.215291] cx22702_i2c_gate_ctrl(0)
[  481.216484] cx22702_i2c_gate_ctrl(1)
[  481.220486] cx22702_i2c_gate_ctrl(0)
[  481.221674] cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
or corrupted
[  481.221764] cx88[0]/2: registered device video1 [mpeg]
[  481.221814] cx22702_i2c_gate_ctrl(1)
[  481.224437] cx22702_i2c_gate_ctrl(0)
[  481.225628] cx22702_i2c_gate_ctrl(1)
[  481.229153] cx22702_i2c_gate_ctrl(0)
[  481.230419] cx22702_i2c_gate_ctrl(1)
[  481.233605] cx22702_i2c_gate_ctrl(0)
[  481.234836] cx22702_i2c_gate_ctrl(1)
[  481.237604] cx22702_i2c_gate_ctrl(0)
[  481.241821] cx88[0]/2-mpeg: cx8802_request_acquire() Post acquire GPIO=ef9e
[  481.241842] cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized
or corrupted
[  483.658039] cx88[0]/2-bb: ERROR: Firmware load failed (checksum mismatch).
[  483.658114] cx88[0]/2-mpeg: cx8802_request_release() Post release GPIO=ef9e

The main difference I can spot is that in the fail case I always see:
[    7.147301] i2c i2c-2: sendbytes: NAK bailout.
[    7.147380] cx22702_readreg: error (reg == 0x1f, ret == -5)

Does anyone have an idea what could be going wrong? Suggestions/patches are
very welcome.

Thanks a lot for your help,

Martin.

