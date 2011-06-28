Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53854 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab1F1Ngi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 09:36:38 -0400
Received: by qwk3 with SMTP id 3so102269qwk.19
        for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 06:36:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: john@vetsurgeon.org.uk
Date: Tue, 28 Jun 2011 14:36:37 +0100
Message-ID: <BANLkTikkO1Dh00HsMTqrA52gAiqa8tSc-Q@mail.gmail.com>
Subject: Help getting TechniSat SkyStar HD2 working in Ubuntu 10.10
From: John Taylor <john@vetsurgeon.org.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm having problems with this card- I can get it to scan DVB-S and
DVB-S2 using scan-s2, and can get it to tune to DVB-S channels, but I
cannot szap to DVB-S2 channels

szap2 -p -t 2 "BBC HD" reports error ioctl DVBFE_SET_DELSYS failed:
Operation not supported

I have tried the latest s2-liplianin and v4l-dvb mantis drivers but no joy

Can anyone help?

John

output lspci -vv
01:08.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV
PCI Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: Device 1ae4:0003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f5fff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis
 lspci -vvn
01:08.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f5fff000 (32-bit, prefetchable) [size=4K]
	Kernel driver in use: Mantis

dmesg:
[  161.580721] Mantis 0000:01:08.0: PCI INT A -> Link[LNKA] -> GSI 18
(level, low) -> IRQ 18
[  161.582113] DVB: registering new adapter (Mantis DVB adapter)
[  162.471365] stb0899_attach: Attaching STB0899
[  162.471375] stb6100_attach: Attaching STB6100
[  162.471593] LNBx2x attached on addr=8
[  162.471601] DVB: registering adapter 1 frontend 0 (STB0899 Multistandard)...
