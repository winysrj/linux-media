Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.155])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1Jaf5L-0004ly-1v
	for linux-dvb@linuxtv.org; Sat, 15 Mar 2008 23:42:40 +0100
Received: by fg-out-1718.google.com with SMTP id 22so3653500fge.25
	for <linux-dvb@linuxtv.org>; Sat, 15 Mar 2008 15:42:35 -0700 (PDT)
Message-Id: <235E220E-C575-467D-85AB-181C2BEF9669@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 15 Mar 2008 23:42:26 +0100
Subject: [linux-dvb] Nova-S-Plus scan ERROR: Initial Tuning Failed
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

The output of lspci -vvv on my computer looks like this:

04:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video  
and Audio Decoder (rev 05)
	Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:00.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
Audio Decoder [Audio Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:00.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e7000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:00.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
Audio Decoder [IR Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Unknown device 9202
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

I installed v4l and now have a /dev/dvb/adapter0 directory
demux0  dvr0  frontend0  net0

I should note that the items in that directory are colored yellow with  
black background (perhaps this is indicating something related to the  
problem?

When I use scan I get this

scan -a 0 /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
 >>> tune to: 12551:v:0:22000
WARNING: >>> tuning failed!!!
 >>> tune to: 12551:v:0:22000 (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


If I connect the cable to a decoder + tv I get all the channels and  
perfect image.
I'm using a dual / twin LNB. Dual for Astra 19.2 E and 23.5 E with 2  
connectors.

I did get it to work on my previous computer.


Any ideas?

Timothy.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH3FDS+j5y+etesF8RAldeAKDeRHdC3YqDZNBze975O5peeRjILgCeNQqV
CukiOWQomn8Ctkn2ErrQMI4=
=QbCX
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
