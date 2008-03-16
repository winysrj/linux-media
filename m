Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1Jat3D-0006QC-S9
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 14:37:25 +0100
Received: by fk-out-0910.google.com with SMTP id z22so6290122fkz.1
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 06:37:20 -0700 (PDT)
Message-Id: <B08CC605-5061-42F5-9D9E-A5294BE1363D@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <235E220E-C575-467D-85AB-181C2BEF9669@gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 16 Mar 2008 14:37:12 +0100
References: <235E220E-C575-467D-85AB-181C2BEF9669@gmail.com>
Subject: [linux-dvb] Update: Nova-S-Plus scan ERROR: Initial Tuning Failed
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

I've pasted my dmesg file here:


Relevant output (at least I think):

[   30.969526] Linux video capture interface: v2.00
[   31.099442] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   31.099494] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level,  
low) -> IRQ 20
[   31.099571] cx88[0]: subsystem: 0070:9202, board: Hauppauge Nova-S- 
Plus DVB-S [card=37,autodetected]
[   31.099574] cx88[0]: TV tuner type 4, Radio tuner type -1
[   31.143430] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6  
loaded
[   31.253459] tveeprom 0-0050: Hauppauge model 92001, rev C1B1,  
serial# 798818
[   31.253464] tveeprom 0-0050: MAC address is 00-0D-FE-0C-30-62
[   31.253467] tveeprom 0-0050: tuner model is Conexant_CX24109 (idx  
111, type 4)
[   31.253470] tveeprom 0-0050: TV standards ATSC/DVB Digital (eeprom  
0x80)
[   31.253473] tveeprom 0-0050: audio processor is CX883 (idx 32)
[   31.253475] tveeprom 0-0050: decoder processor is CX883 (idx 22)
[   31.253477] tveeprom 0-0050: has no radio, has IR receiver, has no  
IR transmitter
[   31.253480] cx88[0]: hauppauge eeprom: model=92001
[   31.253546] input: cx88 IR (Hauppauge Nova-S-Plus  as /class/input/ 
input5
[   31.253578] cx88[0]/0: found at 0000:04:00.0, rev: 5, irq: 20,  
latency: 32, mmio: 0xe5000000
[   31.253618] cx88[0]/0: registered device video0 [v4l2]
[   31.253642] cx88[0]/0: registered device vbi0
[   31.253773] cx88[0]/2: cx2388x 8802 Driver Manager

[   31.752309] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   31.752314] cx88/2: registering cx8802 driver, type: dvb access:  
shared
[   31.752318] cx88[0]/2: subsystem: 0070:9202, board: Hauppauge Nova- 
S-Plus DVB-S [card=37]
[   31.752321] cx88[0]/2: cx2388x based DVB/ATSC card
[   31.923778] DVB: registering new adapter (cx88[0])
[   31.923784] DVB: registering frontend 0 (Conexant CX24123/CX24109)...
[   32.086409] cx2388x alsa driver version 0.0.6 loaded
[   32.086466] ACPI: PCI Interrupt 0000:04:00.1[A] -> GSI 20 (level,  
low) -> IRQ 20
[   32.086493] cx88[0]/1: CX88x/0: ALSA support for cx2388x boards

Using drivers I got using

hg clone http://linuxtv.org/hg/v4l-dvb
cd v4l-dvb
make
make install
reboot

Timothy







On 15 Mar 2008, at 23:42, Timothy Parez wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi,
>
> The output of lspci -vvv on my computer looks like this:
>
> 04:00.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI  
> Video and Audio Decoder (rev 05)
> 	Subsystem: Hauppauge computer works Inc. Nova-S-Plus DVB-S
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [44] Vital Product Data
> 	Capabilities: [4c] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 04:00.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
> Audio Decoder [Audio Port] (rev 05)
> 	Subsystem: Hauppauge computer works Inc. Unknown device 9202
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [4c] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 04:00.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
> Audio Decoder [MPEG Port] (rev 05)
> 	Subsystem: Hauppauge computer works Inc. Unknown device 9202
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at e7000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [4c] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 04:00.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and  
> Audio Decoder [IR Port] (rev 05)
> 	Subsystem: Hauppauge computer works Inc. Unknown device 9202
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
> Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-  
> <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 7
> 	Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [4c] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA  
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> I installed v4l and now have a /dev/dvb/adapter0 directory
> demux0  dvr0  frontend0  net0
>
> I should note that the items in that directory are colored yellow  
> with black background (perhaps this is indicating something related  
> to the problem?
>
> When I use scan I get this
>
> scan -a 0 /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
> scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12551500 V 22000000 5
> >>> tune to: 12551:v:0:22000
> WARNING: >>> tuning failed!!!
> >>> tune to: 12551:v:0:22000 (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
>
>
> If I connect the cable to a decoder + tv I get all the channels and  
> perfect image.
> I'm using a dual / twin LNB. Dual for Astra 19.2 E and 23.5 E with 2  
> connectors.
>
> I did get it to work on my previous computer.
>
>
> Any ideas?
>
> Timothy.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
>
> iD8DBQFH3FDS+j5y+etesF8RAldeAKDeRHdC3YqDZNBze975O5peeRjILgCeNQqV
> CukiOWQomn8Ctkn2ErrQMI4=
> =QbCX
> -----END PGP SIGNATURE-----

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH3SKI+j5y+etesF8RAs81AJ9cgrz0EWHHKyIaZ2jK+tFODi6uvACg5EHU
ibXpbC1Mz449RwxxuvUv4M8=
=DBQx
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
