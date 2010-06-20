Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:33832 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab0FTBZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 21:25:21 -0400
Received: from [93.211.65.10] (helo=db1ras.afulinux.de)
	by smtprelay04.ispgateway.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <andi@afulinux.de>)
	id 1OQ9CQ-0000PM-Pf
	for linux-media@vger.kernel.org; Sun, 20 Jun 2010 03:19:51 +0200
Received: from localhost.afulinux.de ([127.0.0.1] helo=localhost)
	by db1ras.afulinux.de with esmtp (Exim 4.69)
	(envelope-from <andi@afulinux.de>)
	id 1OQ9CQ-0002wr-DB
	for linux-media@vger.kernel.org; Sun, 20 Jun 2010 03:19:50 +0200
From: Andreas Stempfhuber <andi@afulinux.de>
To: linux-media@vger.kernel.org
Subject: WinTV-NOVA HD-S2 unable to load firmware since register 0x20 is allways 0x00
Date: Sun, 20 Jun 2010 03:11:46 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201006200311.46367.andi@afulinux.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I bought a brandnew Hauppauge WinTV-NOVA HD-S2 which does not load the 
firmware since the value of register 0x20 is allways 0x00. After changing the 
cx24116 driver to not check register 0x20, the firmware is loaded and the 
card works as expected (DVB-S, audio and remote control). Below are a few 
details and the changes I made.

Any ideas why this is required for my card?

This is the card (lspci -vvv):

03:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and 
Audio Decoder (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e3000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [44] Vital Product Data <?>
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx8800
        Kernel modules: cx8800

03:00.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio 
Decoder [Audio Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88_audio
        Kernel modules: cx88-alsa

03:00.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio 
Decoder [MPEG Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: cx88-mpeg driver manager
        Kernel modules: cx8802

03:00.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio 
Decoder [IR Port] (rev 05)
        Subsystem: Hauppauge computer works Inc. Device 6906
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


This is logged by the kernel during boot:

Linux video capture interface: v2.00
cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 
[card=69,autodetected], frontend(s): 1
cx88[0]: TV tuner type -1, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
cx2388x alsa driver version 0.0.7 loaded
tveeprom 1-0050: Hauppauge model 69100, rev B4C3, serial# 7083032
tveeprom 1-0050: MAC address is f7b6fd4d
tveeprom 1-0050: tuner model is Conexant CX24118A (idx 123, type 4)
tveeprom 1-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 1-0050: audio processor is None (idx 0)
tveeprom 1-0050: decoder processor is CX880 (idx 20)
tveeprom 1-0050: has no radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=69100
input: cx88 IR (Hauppauge WinTV-HVR400 as /class/input/input5
Creating IR device irrcv0
cx88[0]/0: found at 0000:03:00.0, rev: 5, irq: 20, latency: 32, mmio: 
0xe3000000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt 0000:03:00.2[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]/2: found at 0000:03:00.2, rev: 5, irq: 20, latency: 32, mmio: 
0xe5000000
ACPI: PCI Interrupt 0000:03:00.1[A] -> GSI 20 (level, low) -> IRQ 20
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6906, board: Hauppauge WinTV-HVR4000(Lite) DVB-S/S2 
[card=69]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 19
DVB: registering new adapter (cx88[0])
DVB: registering adapter 0 frontend 0 (Conexant CX24116/CX24118)...


The following happens when I use the 
command "scan /usr/share/dvb/dvb-s/Astra-19.2E". As you can see register 0x20 
has the value 0x00. Regarding to the cx24116 source code I assume this should 
be normally only the case when the firmware is already loaded. But there is 
and was no firmware loaded into my card as the scan command is the very first 
DVB command I execute.

Because register 0x20 has the value 0x00 it never loads the firmware and hence 
I cannot use the card:

[  137.488208] cx24116: cx24116_initfe()
[  137.488208] cx24116: cx24116_writereg: write reg 0xe0, value 0x00
[  137.488208] cx24116: cx24116_writereg: write reg 0xe1, value 0x00
[  137.488208] cx24116: cx24116_writereg: write reg 0xea, value 0x00
[  137.488690] cx24116: cx24116_cmd_execute()
[  137.488690] cx24116: cx24116_firmware_ondemand()
[  137.489281] cx24116: read reg 0x20, value 0x00
[  137.489283] cx24116: cx24116_cmd_execute: 0x00 == 0x36
[  137.489284] cx24116: cx24116_writereg: write reg 0x00, value 0x36
[  137.489765] cx24116: cx24116_cmd_execute: 0x01 == 0x00
[  137.489767] cx24116: cx24116_writereg: write reg 0x01, value 0x00
[  137.490247] cx24116: cx24116_writereg: write reg 0x1f, value 0x01
[  137.491375] cx24116: read reg 0x1f, value 0x01
[...]
[  138.588200] cx24116_cmd_execute() Firmware not responding
[  138.664193] cx24116: cx24116_set_tone(1)
[  138.664849] cx24116: read reg 0xbc, value 0x00
[  138.664851] cx24116: cx24116_wait_for_lnb() qstatus = 0x00
[  138.665500] cx24116: read reg 0xbc, value 0x00
[...]
[  139.156936] cx24116: cx24116_wait_for_lnb(): LNB not ready
[  139.208929] cx24116: cx24116_set_frontend()
[  139.208929] cx24116: cx24116_set_frontend: DVB-S delivery system selected
[  139.208929] cx24116: cx24116_set_inversion(2)
[  139.208929] cx24116: cx24116_set_fec(0x00,0x05)
[  139.208929] cx24116: cx24116_lookup_fecmod(0x00,0x05)
[  139.208929] cx24116: cx24116_set_fec() mask/val = 0x20/0x31
[  139.208929] cx24116: cx24116_set_symbolrate(22000000)
[  139.208929] cx24116: cx24116_set_symbolrate() symbol_rate = 22000000
[  139.208929] cx24116: cx24116_set_frontend:   delsys      = 5
[  139.208929] cx24116: cx24116_set_frontend:   modulation  = 0
[  139.208929] cx24116: cx24116_set_frontend:   frequency   = 1951500
[  139.208929] cx24116: cx24116_set_frontend:   pilot       = 0 (val = 0x00)
[  139.208929] cx24116: cx24116_set_frontend:   retune      = 1
[  139.208929] cx24116: cx24116_set_frontend:   rolloff     = 0 (val = 0x02)
[  139.208929] cx24116: cx24116_set_frontend:   symbol_rate = 22000000
[  139.208929] cx24116: cx24116_set_frontend:   FEC         = 5 (mask/val = 
0x20/0x31)
[  139.208929] cx24116: cx24116_set_frontend:   Inversion   = 2 (val = 0x0c)
[  139.208929] cx24116: cx24116_cmd_execute()
[  139.208929] cx24116: cx24116_firmware_ondemand()
[  139.208929] cx24116: read reg 0x20, value 0x00


I have changed the following to get the firmware loaded:

--- linux/drivers/media/dvb/frontends/cx24116.c.orig    2010-05-18 
14:50:03.000000000 +0200
+++ linux/drivers/media/dvb/frontends/cx24116.c 2010-06-20 01:30:10.000000000 
+0200
@@ -482,7 +482,7 @@

        dprintk("%s()\n", __func__);

-       if (cx24116_readreg(state, 0x20) > 0) {
+//     if (cx24116_readreg(state, 0x20) > 0) {

                if (state->skip_fw_load)
                        return 0;
@@ -516,8 +516,8 @@
                        ret == 0 ? "complete" : "failed");

                /* Ensure firmware is always loaded if required */
-               state->skip_fw_load = 0;
-       }
+//             state->skip_fw_load = 0;
+//     }

        return ret;
 }


This removes the check against register 0x20. Since the firmware is then 
loaded on every command I have also removed the "state->skip_fw_load = 0". 
This is a quick hack and has probably drawbacks, but it works for me. After 
this changes the first DVB command loads the firmware and the card works as 
expected:

[  159.522909] cx24116_firmware_ondemand: Waiting for firmware upload 
(dvb-fe-cx24116.fw)...
[  159.522909] firmware: requesting dvb-fe-cx24116.fw
[  159.556998] cx24116_firmware_ondemand: Waiting for firmware upload(2)...
[  164.525282] cx24116_load_firmware: FW version 1.26.90.0
[  164.525320] cx24116_firmware_ondemand: Firmware upload complete


The patch is for v4l-dvb-20100130, I use it together with Kernel 2.6.26 from 
Debian Lenny. I have also tried Kernel 2.6.32 from backports.org but the 
issue is exactly the same. Also the cx24116.c source of kernel 2.6.35-rc3 and 
the latest version from the v4l-dvb HG repository contains the check for 
register 0x20 so I assume it still can't work with my card.

I however do not fully understand the source that I have changed. I assume 
that register 0x20 is normally unequal 0x00 when no firmware is loaded and 
changes to 0x00 when a firmware is loaded. The question is then how do I 
check this properly on my card where register 0x20 is allways 0x00 
independently if a firmware is loaded or not?

Any idea why my card behave differently? Is it a new hardware revision or some 
kind of a buggy card?

Thanks,

Andi
