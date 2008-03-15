Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2FB9BCK029822
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 07:09:11 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2FB8dC9021949
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 07:08:40 -0400
Received: by fg-out-1718.google.com with SMTP id e12so3527632fga.7
	for <video4linux-list@redhat.com>; Sat, 15 Mar 2008 04:08:39 -0700 (PDT)
Message-Id: <571365C9-F99B-48EF-99FE-BD8D95502910@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sat, 15 Mar 2008 12:08:32 +0100
Subject: Nova-S-Plus: Warning: >>> tuning failed
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

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

iD8DBQFH264w+j5y+etesF8RAvKvAJ4s8kekufGs15fYneysMoYJphAXuwCfVBmx
NjCJRBV/NnPJLm5rCOk4AWI=
=UW96
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
