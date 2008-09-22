Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from elasmtp-mealy.atl.sa.earthlink.net ([209.86.89.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jrevans1@earthlink.net>) id 1KhcMr-0008Jo-0M
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 05:45:47 +0200
Received: from [71.116.167.33] (helo=putney)
	by elasmtp-mealy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <jrevans1@earthlink.net>) id 1KhcMH-0003hT-5g
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 23:45:09 -0400
From: "James Evans" <jrevans1@earthlink.net>
To: <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 20:44:53 -0700
Message-ID: <002001c91c65$939d8b60$bad8a220$@net>
MIME-Version: 1.0
Content-Language: en-us
Subject: [linux-dvb] DVICO FusionHDTV5 Express Support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I emailed quite a while ago and have been following the mail list ever since, but I was curious as to what might be the major hurdle
to getting support for the DVICO FusionHDTV5 Express card (http://www.fusionhdtv.co.kr/eng/Products/fusion5express.aspx) .  It
utilizes the CX23885 Chipset and the 5th Gen. LG Tuner, which both seem to be supported, as well as some PCIx interfaced cards.

Following is my current system stats as well as the relevant portion of the 'messages' file:

Gentoo linux kernel 2.6.26-gentoo-r1 x86_64 Dual Core Athlon 4400+
DVICO FusionHDTV5 Express
Air2PC/AirStar 2 ATSC 3rd generation (HD5000)  (x2)

#====================== SNIP =======================================================
Sep 17 02:32:09 localhost Linux video capture interface: v2.00
Sep 17 02:32:09 localhost bttv: driver version 0.9.17 loaded
Sep 17 02:32:09 localhost bttv: using 8 buffers with 2080k (520 pages) each for capture
Sep 17 02:32:09 localhost saa7130/34: v4l2 driver version 0.2.14 loaded
Sep 17 02:32:09 localhost cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
Sep 17 02:32:09 localhost cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
Sep 17 02:32:09 localhost cx2388x alsa driver version 0.0.6 loaded
Sep 17 02:32:09 localhost cx2388x blackbird driver version 0.0.6 loaded
Sep 17 02:32:09 localhost cx88/2: registering cx8802 driver, type: blackbird access: shared
Sep 17 02:32:09 localhost cx88/2: cx2388x dvb driver version 0.0.6 loaded
Sep 17 02:32:09 localhost cx88/2: registering cx8802 driver, type: dvb access: shared
Sep 17 02:32:09 localhost ivtv:  Start initialization, version 1.3.0
Sep 17 02:32:09 localhost ivtv:  End initialization
Sep 17 02:32:09 localhost ivtvfb:  no cards found<6>cx23885 driver version 0.0.1 loaded
Sep 17 02:32:09 localhost ACPI: PCI Interrupt Link [LNEA] enabled at IRQ 19
Sep 17 02:32:09 localhost ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNEA] -> GSI 19 (level, low) -> IRQ 19
Sep 17 02:32:09 localhost CORE cx23885[0]: subsystem: 18ac:d500, board: DViCO FusionHDTV5 Express [card=4,autodetected]
Sep 17 02:32:09 localhost input: i2c IR (FusionHDTV) as /class/input/input2
Sep 17 02:32:09 localhost ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-0/0-006b/ir0 [cx23885[0]]
Sep 17 02:32:09 localhost tvaudio' 0-0041: tda8425 found @ 0x82 (cx23885[0])
Sep 17 02:32:09 localhost tuner' 0-0043: chip found @ 0x86 (cx23885[0])
Sep 17 02:32:09 localhost tda9887 0-0043: creating new instance
Sep 17 02:32:09 localhost tda9887 0-0043: tda988[5/6/7] found
Sep 17 02:32:09 localhost tuner' 0-0061: chip found @ 0xc2 (cx23885[0])
Sep 17 02:32:09 localhost cx23885[0]: i2c bus 0 registered
Sep 17 02:32:09 localhost cx23885[0]: i2c bus 1 registered
Sep 17 02:32:09 localhost tvaudio' 2-004c: tea6420 found @ 0x98 (cx23885[0])
Sep 17 02:32:09 localhost msp3400' 2-0044: MSP164209A-17 found @ 0x88 (cx23885[0])
Sep 17 02:32:09 localhost msp3400' 2-0044: msp3400 mode is manual
Sep 17 02:32:09 localhost cx23885[0]: i2c bus 2 registered
Sep 17 02:32:09 localhost cx23885[0]: cx23885 based dvb card
Sep 17 02:32:09 localhost tuner-simple 0-0061: creating new instance
Sep 17 02:32:09 localhost tuner-simple 0-0061: type set to 64 (LG TDVS-H06xF)
Sep 17 02:32:09 localhost DVB: registering new adapter (cx23885[0])
Sep 17 02:32:09 localhost DVB: registering frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
Sep 17 02:32:09 localhost cx23885_dev_checkrevision() Hardware revision = 0xb0
Sep 17 02:32:09 localhost cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xfa800000
Sep 17 02:32:09 localhost PCI: Setting latency timer of device 0000:02:00.0 to 64
Sep 17 02:32:09 localhost b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded successfully
Sep 17 02:32:09 localhost flexcop-pci: will use the HW PID filter.
Sep 17 02:32:09 localhost flexcop-pci: card revision 2
Sep 17 02:32:09 localhost ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 18
Sep 17 02:32:09 localhost ACPI: PCI Interrupt 0000:04:08.0[A] -> Link [LNKA] -> GSI 18 (level, low) -> IRQ 18
Sep 17 02:32:09 localhost DVB: registering new adapter (FlexCop Digital TV device)
Sep 17 02:32:09 localhost i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost i2c-adapter i2c-5: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost b2c2-flexcop: MAC address = 00:d0:d7:0e:a6:c8
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
Sep 17 02:32:09 localhost CX24123: wrong demod revision: 87
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost mt352_read_register: readreg error (reg=127, ret==-121)
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -121)
Sep 17 02:32:09 localhost Unknown/Unsupported NXT chip: 00 00 00 00 00
Sep 17 02:32:09 localhost tuner-simple 3-0061: creating new instance
Sep 17 02:32:09 localhost tuner-simple 3-0061: type set to 64 (LG TDVS-H06xF)
Sep 17 02:32:09 localhost b2c2-flexcop: found 'LG Electronics LGDT3303 VSB/QAM Frontend' .
Sep 17 02:32:09 localhost DVB: registering frontend 1 (LG Electronics LGDT3303 VSB/QAM Frontend)...
Sep 17 02:32:09 localhost b2c2-flexcop: initialization of 'Air2PC/AirStar 2 ATSC 3rd generation (HD5000)' at the 'PCI' bus
controlled by a 'FlexCopIIb' complete
Sep 17 02:32:09 localhost flexcop-pci: will use the HW PID filter.
Sep 17 02:32:09 localhost flexcop-pci: card revision 2
Sep 17 02:32:09 localhost ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
Sep 17 02:32:09 localhost ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [LNKB] -> GSI 17 (level, low) -> IRQ 17
Sep 17 02:32:09 localhost DVB: registering new adapter (FlexCop Digital TV device)
Sep 17 02:32:09 localhost i2c-adapter i2c-6: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost i2c-adapter i2c-7: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost i2c-adapter i2c-8: SMBus Quick command not supported, can't probe for chips
Sep 17 02:32:09 localhost b2c2-flexcop: MAC address = 00:d0:d7:0e:6c:aa
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost CX24123: cx24123_i2c_readreg: reg=0x0 (error=-121)
Sep 17 02:32:09 localhost CX24123: wrong demod revision: 87
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost mt352_read_register: readreg error (reg=127, ret==-121)
Sep 17 02:32:09 localhost b2c2-flexcop: i2c master_xfer failed
Sep 17 02:32:09 localhost nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err == -121)
Sep 17 02:32:09 localhost Unknown/Unsupported NXT chip: 00 00 00 00 00
Sep 17 02:32:09 localhost tuner-simple 6-0061: creating new instance
Sep 17 02:32:09 localhost tuner-simple 6-0061: type set to 64 (LG TDVS-H06xF)
Sep 17 02:32:09 localhost b2c2-flexcop: found 'LG Electronics LGDT3303 VSB/QAM Frontend' .
Sep 17 02:32:09 localhost DVB: registering frontend 2 (LG Electronics LGDT3303 VSB/QAM Frontend)...
Sep 17 02:32:09 localhost b2c2-flexcop: initialization of 'Air2PC/AirStar 2 ATSC 3rd generation (HD5000)' at the 'PCI' bus
controlled by a 'FlexCopIIb' complete
Sep 17 02:32:09 localhost bt878: AUDIO driver version 0.0.0 loaded
#====================== SNIP =======================================================

Given the above it looks like it is detected properly and I can even find the adapter under /dev/dvb.  The problem I seem to be
having is when it comes to getting it to tune.  I get the following errors:

#====================== BEGIN ======================================================
scanning /usr/share/dvb/atsc/us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 57028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 57028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 63028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 63028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 69028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 69028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 79028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 79028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 85028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 85028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 177028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 177028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 183028615:8VSB
WARNING: >>> tuning failed!!!
#====================== SNIP =======================================================

I figure the problem is really operator error, but I cannot seem to figure it out.  I probably just can't see the forest because of
all those dang trees.

Any help, ideas, suggestions, anything would be greatly appreciated.
Thanks,
--J. Evans



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
