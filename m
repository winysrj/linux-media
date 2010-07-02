Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49648 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab0GBJxx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 05:53:53 -0400
Received: by fxm14 with SMTP id 14so2142584fxm.19
        for <linux-media@vger.kernel.org>; Fri, 02 Jul 2010 02:53:52 -0700 (PDT)
Message-ID: <8969BB6B2C01423887D844C6717A13E4@PaulPC>
From: "Paul Koppa" <meistaheinz@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Support for cx24120?
Date: Fri, 2 Jul 2010 11:53:45 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently got an TechniSat SkyStar S2 [13d0:2103] which uses an 
FlexCop2-Bridge, which is supported, but an unsupported? CX24120 Demod.

(This card is rather cheap, 45€ LowProfile incl. IR-Remote, otherwise i'd 
just have sent it back.)

TechniSat provides a Binary Driver
( 
http://www.technisat-daun.de/download/soft/soft_linux-driver_12-2008_6611.zip )
which contains an cx24120 blob (32/64) +Firmware, but requires an Dec2008 
V4L-checkout (
I need a newer rev for my E3C EC168 USB-DVBT-Stick)

Anyway I can get this working? Can I help in any way?

Thanks,

Paul

lspci

Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / 
Technisat SkyStar2 DVB card (rev 02)
        Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / 
Technisat SkyStar2 DVB card
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at feae0000 (32-bit, non-prefetchable) [size=64K]
        Region 1: I/O ports at bc00 [size=32]
        Kernel modules: b2c2-flexcop-pci


dmesg

[   17.355268] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver 
chip loaded successfully
[   17.357454] flexcop-pci: will use the HW PID filter.
[   17.357460] flexcop-pci: card revision 2
[   17.357469] b2c2_flexcop_pci 0000:05:04.0: PCI INT A -> GSI 17 (level, 
low) -> IRQ 17
[   17.391402] DVB: registering new adapter (FlexCop Digital TV device)
[   17.393043] b2c2-flexcop: MAC address = xx:xx:xx:xx:d0:02
[   17.393555] CX24123: wrong demod revision: 84
[   17.628997] mt352_read_register: readreg error (reg=127, ret==-121)
[   17.636769] nxt200x: nxt200x_readbytes: i2c read error (addr 0x0a, err 
== -121)
[   17.636772] Unknown/Unsupported NXT chip: 00 00 00 00 00
[   17.645121] lgdt330x: i2c_read_demod_bytes: addr 0x59 select 0x02 error 
(ret == -121)
[   17.661886] stv0297_readreg: readreg error (reg == 0x80, ret == -121)
[   17.671433] mt312_read: ret == -121
[   17.671508] b2c2-flexcop: no frontend driver found for this B2C2/FlexCop 
adapter
[   17.671805] b2c2_flexcop_pci 0000:05:04.0: PCI INT A disabled

