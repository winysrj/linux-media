Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68] helo=smtp1.bethere.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett1@onetel.com>) id 1JRBfO-0003kJ-Ub
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 20:28:43 +0100
Message-Id: <B5C85E0A-C606-47A7-8683-C2DBC1C36CE3@onetel.com>
From: Tim Hewett <tghewett1@onetel.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 18 Feb 2008 19:05:03 +0000
Cc: Tim Hewett <tghewett1@onetel.com>
Subject: [linux-dvb] Help with Skystar HD2 (Twinhan VP-1041/Azurewave AD
	SP400 rebadge)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0092523644=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


--===============0092523644==
Content-Type: multipart/alternative; boundary=Apple-Mail-8--431478888


--Apple-Mail-8--431478888
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

I'm trying to get a new Technisat Skystar HD2 working. It looks like  
it is a Twinhan VP-1041/Azurewave AD SP400 rebadge.

The card hardware and satellite feed has been confirmed to work ok  
under Windows using Technisat's software.

I am using the current multiproto DVB drivers, downloaded today. These  
were patched, built and installed successfully as described for the  
Azurewave AD SP400 in the linuxdvb wiki, but the card was not  
recognised on bootup even though it was allocated a DVB adaptor  
number. This appeared in dmesg:

[   57.359723] found a UNKNOWN PCI UNKNOWN device on (01:06.0),
[   57.359802]     Mantis Rev 1 [1ae4:0001], irq: 16, latency: 32
[   57.359858]     memory: 0xe5100000, mmio: 0xffffc200000fc000
[   57.363015]     MAC Address=[00:08:c9:e0:26:92]
[   57.363133] mantis_alloc_buffers (0): DMA=0x1b7a0000  
cpu=0xffff81001b7a0000 size=65536
[   57.363242] mantis_alloc_buffers (0): RISC=0x1ae24000  
cpu=0xffff81001ae24000 size=1000
[   57.363348] DVB: registering new adapter (Mantis dvb adapter)


This is the output of lspci -vvn:

01:06.0 0480: 1822:4e35 (rev 01)
	Subsystem: 1ae4:0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e5100000 (32-bit, prefetchable) [size=4K]

This is the output of lsusb -vv:

01:06.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV  
PCI Bridge Controller [Ver 1.0] (rev 01)
	Subsystem: Unknown device 1ae4:0001
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-  
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-  
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (2000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e5100000 (32-bit, prefetchable) [size=4K]

Note that subsystem IDs 1ae4:0001 are different to those listed in the  
wiki for the Azurewave (1822:0031).

I changed #define MANTIS_VP_1041_DVB_S2	in linux/drivers/media/dvb/ 
mantis/mantis_vp1041.h from 0x0031 to 0x0001, which changed the dmesg  
output on reboot to this:

[   59.546375] found a VP-1041 PCI DVB-S/DVB-S2 device on (01:06.0),
[   59.546456]     Mantis Rev 1 [1ae4:0001], irq: 16, latency: 32
[   59.546512]     memory: 0xe5100000, mmio: 0xffffc200000fc000
[   59.549609]     MAC Address=[00:08:c9:e0:26:92]
[   59.549719] mantis_alloc_buffers (0): DMA=0x1b7b0000  
cpu=0xffff81001b7b0000 size=65536
[   59.549827] mantis_alloc_buffers (0): RISC=0x1af43000  
cpu=0xffff81001af43000 size=1000
[   59.549933] DVB: registering new adapter (Mantis dvb adapter)
[   60.137583] stb0899_attach: Attaching STB0899
[   60.137665] mantis_frontend_init (0): found STB0899 DVB-S/DVB-S2  
frontend @0x68
[   60.152161] stb6100_attach: Attaching STB6100
[   60.168021] DVB: registering frontend 3 (STB0899 Multistandard)...

So that change seemed to cause the card to be recognised.

Then I tried the replacement scan and szap as suggested by the  
Azurewave wiki, but the card will not tune.

So it appears to be almost working, but I'm not sure what tests to try  
or changes to make to see if it will work.
--Apple-Mail-8--431478888
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><font class=3D"Apple-style-span" =
color=3D"#000000"><span class=3D"Apple-style-span" =
style=3D"background-color: transparent;">I'm trying to get a new =
Technisat Skystar HD2 working. It looks like it is a&nbsp;Twinhan =
VP-1041/Azurewave AD SP400 rebadge.</span></font><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;">The =
card hardware and satellite feed has been confirmed to work ok under =
Windows using Technisat's software.</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;">I am =
using the current multiproto DVB drivers, downloaded today. These were =
patched, built and installed successfully as described for the Azurewave =
AD SP400 in the linuxdvb wiki, but the card was not recognised on bootup =
even though it was allocated a DVB adaptor number. This appeared in =
dmesg:</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000"><span class=3D"Apple-style-span" =
style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; line-height: 11px; font: normal normal normal =
10px/normal Courier; "><font class=3D"Apple-style-span" color=3D"#000000" =
face=3D"Helvetica" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"background-color: transparent; font-size: 12px;">[ &nbsp; =
57.359723] found a UNKNOWN PCI UNKNOWN device on =
(01:06.0),</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 57.359802] &nbsp; &nbsp; Mantis =
Rev 1 [1ae4:0001], irq: 16, latency: 32</span></font></div><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; line-height: 11px; font: normal normal normal =
10px/normal Courier; "><font class=3D"Apple-style-span" color=3D"#000000" =
face=3D"Helvetica" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"background-color: transparent; font-size: 12px;">[ &nbsp; =
57.359858] &nbsp; &nbsp; memory: 0xe5100000, mmio: =
0xffffc200000fc000</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 57.363015] &nbsp; &nbsp; MAC =
Address=3D[00:08:c9:e0:26:92]</span></font></div><div style=3D"margin-top:=
 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; =
line-height: 11px; font: normal normal normal 10px/normal Courier; =
"><font class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 57.363133] mantis_alloc_buffers =
(0): DMA=3D0x1b7a0000 cpu=3D0xffff81001b7a0000 =
size=3D65536</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 57.363242] mantis_alloc_buffers =
(0): RISC=3D0x1ae24000 cpu=3D0xffff81001ae24000 =
size=3D1000</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 57.363348] DVB: registering new =
adapter (Mantis dvb adapter)</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;">This =
is the output of lspci -vvn:</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" face=3D"Courier" size=3D"2"><span =
class=3D"Apple-style-span" style=3D"font-size: 10px;"><div =
style=3D"margin-top: 0px; margin-right: 0px; margin-bottom: 0px; =
margin-left: 0px; line-height: 11px; font: normal normal normal =
10px/normal Courier; "><font class=3D"Apple-style-span" color=3D"#000000" =
face=3D"Helvetica" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"background-color: transparent; font-size: 12px;">01:06.0 0480: =
1822:4e35 (rev 01)</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre"><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Subsystem: =
1ae4:0001</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre"><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Control: I/O- Mem+ BusMaster+ SpecCycle- =
MemWINV- VGASnoop- ParErr- Stepping- SERR- =
FastB2B-</span></font></div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; line-height: 11px; font: =
normal normal normal 10px/normal Courier; "><span class=3D"Apple-tab-span"=
 style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Status: Cap- 66MHz- UDF- FastB2B- ParErr- =
DEVSEL=3Dmedium &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- =
&lt;PERR-</span></font></div><div style=3D"margin-top: 0px; =
margin-right: 0px; margin-bottom: 0px; margin-left: 0px; line-height: =
11px; font: normal normal normal 10px/normal Courier; "><span =
class=3D"Apple-tab-span" style=3D"white-space:pre"><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Latency: 32 (2000ns min, 63750ns =
max)</span></font></div><div style=3D"margin-top: 0px; margin-right: =
0px; margin-bottom: 0px; margin-left: 0px; line-height: 11px; font: =
normal normal normal 10px/normal Courier; "><span class=3D"Apple-tab-span"=
 style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Interrupt: pin A routed to IRQ =
16</span></font></div><div style=3D"margin-top: 0px; margin-right: 0px; =
margin-bottom: 0px; margin-left: 0px; line-height: 11px; font: normal =
normal normal 10px/normal Courier; "><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Region 0: Memory at e5100000 (32-bit, =
prefetchable) [size=3D4K]</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">This is the output of lsusb =
-vv:</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">01:06.0 Multimedia controller: Twinhan =
Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] (rev =
01)</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Subsystem: Unknown device =
1ae4:0001</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Control: I/O- Mem+ BusMaster+ SpecCycle- =
MemWINV- VGASnoop- ParErr- Stepping- SERR- =
FastB2B-</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Status: Cap- 66MHz- UDF- FastB2B- ParErr- =
DEVSEL=3Dmedium &gt;TAbort- &lt;TAbort- &lt;MAbort- &gt;SERR- =
&lt;PERR-</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Latency: 32 (2000ns min, 63750ns =
max)</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Interrupt: pin A routed to IRQ =
16</span></font></div><div><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Region 0: Memory at e5100000 (32-bit, =
prefetchable) [size=3D4K]</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Note that subsystem IDs&nbsp;1ae4:0001 =
are different to those listed in the wiki for the Azurewave =
(1822:0031).</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">I changed&nbsp;#define =
MANTIS_VP_1041_DVB_S2</span></font><span class=3D"Apple-tab-span" =
style=3D"white-space:pre"><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">	</span></font></span><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: =
12px;">in&nbsp;linux/drivers/media/dvb/mantis/mantis_vp1041.h from =
0x0031 to 0x0001, which changed the dmesg output on reboot to =
this:</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 59.546375] found a VP-1041 PCI =
DVB-S/DVB-S2 device on (01:06.0),</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 59.546456] &nbsp; &nbsp; Mantis =
Rev 1 [1ae4:0001], irq: 16, latency: 32</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 59.546512] &nbsp; &nbsp; memory: =
0xe5100000, mmio: 0xffffc200000fc000</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 59.549609] &nbsp; &nbsp; MAC =
Address=3D[00:08:c9:e0:26:92]</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 59.549719] mantis_alloc_buffers =
(0): DMA=3D0x1b7b0000 cpu=3D0xffff81001b7b0000 =
size=3D65536</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">[ &nbsp; 59.549827] mantis_alloc_buffers (0): =
RISC=3D0x1af43000 cpu=3D0xffff81001af43000 =
size=3D1000</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">[ &nbsp; 59.549933] DVB: registering new adapter =
(Mantis dvb adapter)</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 60.137583] stb0899_attach: =
Attaching STB0899&nbsp;</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">[ &nbsp; 60.137665] mantis_frontend_init =
(0): found STB0899 DVB-S/DVB-S2 frontend =
@0x68</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">[ &nbsp; 60.152161] stb6100_attach: Attaching =
STB6100&nbsp;</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;">[ &nbsp; 60.168021] DVB: registering frontend 3 =
(STB0899 Multistandard)...</span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">So that change seemed to cause the card =
to be recognised.</span></font></div><div><font class=3D"Apple-style-span"=
 face=3D"Helvetica" size=3D"3"><span class=3D"Apple-style-span" =
style=3D"font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" color=3D"#000000" face=3D"Helvetica" =
size=3D"3"><span class=3D"Apple-style-span" style=3D"background-color: =
transparent; font-size: 12px;">Then I tried the replacement scan and =
szap as suggested by the Azurewave wiki, but the card will not =
tune.</span></font></div><div><font class=3D"Apple-style-span" =
color=3D"#000000" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"background-color: transparent; =
font-size: 12px;"><br =
class=3D"webkit-block-placeholder"></span></font></div><div><font =
class=3D"Apple-style-span" face=3D"Helvetica" size=3D"3"><span =
class=3D"Apple-style-span" style=3D"font-size: 12px;">So it appears to =
be almost working, but I'm not sure what tests to try or changes to make =
to see if it will work.</span></font></div></div></div>
</span></font></div>
</div></body></html>=

--Apple-Mail-8--431478888--


--===============0092523644==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0092523644==--
