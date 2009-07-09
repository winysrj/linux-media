Return-path: <linux-media-owner@vger.kernel.org>
Received: from basement.romerikebb.no ([217.212.249.2]:57887 "HELO
	basement.romerikebb.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754022AbZGIVa6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 17:30:58 -0400
Message-Id: <BB609B4F-4DAB-4CA3-9AFE-C0C51EF6FDFD@henes.no>
From: =?ISO-8859-1?Q?Johan_Hen=E6s?= <johan@henes.no>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Technotrend C-2300 problem getting channel lock
Date: Thu, 9 Jul 2009 23:24:15 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi !

Recently I have bought three TechnoTrend C-2300 for use in my Mythtv-
system. Everything seemed to go smooth, but for a major share of the
channels I have problems getting a channel lock. (Or if I do on some
of them, I get a "distorted" image with lots of "bit errors"....

Using the latest firmware for Linux : dvb-ttpci-01.fw-2622...

After poking around the Internet I found that QAM 128 has been a
problem for TechnoTrend cards, and the funny thing is that my cable-
provider is using QAM 128 for all channels (including the ones that
works very well).

As I experience problems with most of my channels I still thought
maybe this would be the problem. I haven't seen posts on the issue for
quite a while and realizing that the latest firmware available for
these cards is dated 2005, I wondered where I can find an updated
version or if anyone has a solution to my problem........

Best regards,

johan

----



$ lspci -vvv:

02:09.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend DVB-C  
for  iTV
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-   
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-   
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=512]

02:0c.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend DVB-C  
for  iTV
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-   
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-   
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at feaff400 (32-bit, non-prefetchable) [size=512]

02:0d.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Octal/Technotrend DVB-C  
for  iTV
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-   
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-   
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at feaff000 (32-bit, non-prefetchable) [size=512]


Syslog :

Jul  9 19:18:48 xxxxxxx kernel: [   53.409368] saa7146: register   
extension 'dvb'.
Jul  9 19:18:48 xxxxxxx kernel: [   53.409449] ACPI: PCI Interrupt   
0000:02:09.0[A] -> GSI 21 (level, low) -> IRQ 21
Jul  9 19:18:48 xxxxxxx kernel: [   53.409492] saa7146: found saa7146   
@ mem e09a6c00 (revision 1, irq 21) (0x13c2,0x000a).
Jul  9 19:18:48 xxxxxxx kernel: [   55.952909] DVB: registering new   
adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
Jul  9 19:18:48 xxxxxxx kernel: [   56.013623] adapter has MAC addr =   
00:d0:5c:03:93:c2
Jul  9 19:18:48 xxxxxxx kernel: [   56.244761] dvb-ttpci: gpioirq   
unknown type=0 len=0
Jul  9 19:18:48 xxxxxxx kernel: [   56.282309] dvb-ttpci: info @ card   
0: firm f0240009, rtsl b0250018, vid 71010068, app80002622
Jul  9 19:18:48 xxxxxxx kernel: [   56.282313] dvb-ttpci: firmware @   
card 0 supports CI link layer interface
Jul  9 19:18:48 xxxxxxx kernel: [   56.621915] dvb-ttpci: DVB-C  
analog  module @ card 0 detected, initializing MSP3415
Jul  9 19:18:48 xxxxxxx kernel: [   56.733924] dvb_ttpci: saa7113 not   
accessible.
Jul  9 19:18:48 xxxxxxx kernel: [   56.831850] saa7146_vv: saa7146   
(0): registered device video0 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   56.831878] saa7146_vv: saa7146   
(0): registered device vbi0 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   56.897464] DVB: registering   
frontend 0 (ST STV0297 DVB-C)...
Jul  9 19:18:48 xxxxxxx kernel: [   56.897637] input: DVB on-card IR   
receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:09.0/input/input6
Jul  9 19:18:48 xxxxxxx kernel: [   56.951177] dvb-ttpci: found   
av7110-0.

Jul  9 19:18:48 xxxxxxx kernel: [   56.951255] saa7146: found saa7146   
@ mem e0a6c400 (revision 1, irq 22) (0x13c2,0x000a).
Jul  9 19:18:48 xxxxxxx kernel: [   56.965145] DVB: registering new   
adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
Jul  9 19:18:48 xxxxxxx kernel: [   57.021978] adapter has MAC addr =  
00:d0:5c:03:95:4d
Jul  9 19:18:48 xxxxxxx kernel: [   57.253096] dvb-ttpci: gpioirq   
unknown type=0 len=0
Jul  9 19:18:48 xxxxxxx kernel: [   57.290649] dvb-ttpci: info @ card   
1: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
Jul  9 19:18:48 xxxxxxx kernel: [   57.290653] dvb-ttpci: firmware @   
card 1 supports CI link layer interface
Jul  9 19:18:48 xxxxxxx kernel: [   57.630258] dvb-ttpci: DVB-C  
analog  module @ card 1 detected, initializing MSP3415
Jul  9 19:18:48 xxxxxxx kernel: [   57.742249] dvb_ttpci: saa7113 not   
accessible.
Jul  9 19:18:48 xxxxxxx kernel: [   57.840242] saa7146_vv: saa7146   
(1): registered device video1 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   57.840271] saa7146_vv: saa7146   
(1): registered device vbi1 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   57.841111] DVB: registering   
frontend 1 (ST STV0297 DVB-C)...
Jul  9 19:18:48 xxxxxxx kernel: [   57.841295] input: DVB on-card IR   
receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:0c.0/input/input7
Jul  9 19:18:48 xxxxxxx kernel: [   57.919590] dvb-ttpci: found   
av7110-1.

Jul  9 19:18:48 xxxxxxx kernel: [   57.919622] ACPI: PCI Interrupt   
0000:02:0d.0[A] -> GSI 21 (level, low) -> IRQ 21
Jul  9 19:18:48 xxxxxxx kernel: [   57.919661] saa7146: found saa7146   
@ mem e0a8e000 (revision 1, irq 21) (0x13c2,0x000a).
Jul  9 19:18:48 xxxxxxx kernel: [   57.934015] DVB: registering new   
adapter (Technotrend/Hauppauge WinTV Nexus-CA rev1.X)
Jul  9 19:18:48 xxxxxxx kernel: [   57.990392] adapter has MAC addr =   
00:d0:5c:03:93:de
Jul  9 19:18:48 xxxxxxx kernel: [   58.221518] dvb-ttpci: gpioirq   
unknown type=0 len=0
Jul  9 19:18:48 xxxxxxx kernel: [   58.259053] dvb-ttpci: info @ card   
2: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
Jul  9 19:18:48 xxxxxxx kernel: [   58.259058] dvb-ttpci: firmware @   
card 2 supports CI link layer interface
Jul  9 19:18:48 xxxxxxx kernel: [   58.598657] dvb-ttpci: DVB-C  
analog  module @ card 2 detected, initializing MSP3415
Jul  9 19:18:48 xxxxxxx kernel: [   58.710702] dvb_ttpci: saa7113 not   
accessible.
Jul  9 19:18:48 xxxxxxx kernel: [   58.808584] saa7146_vv: saa7146   
(2): registered device video2 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   58.808614] saa7146_vv: saa7146   
(2): registered device vbi2 [v4l2]
Jul  9 19:18:48 xxxxxxx kernel: [   58.809458] DVB: registering   
frontend 2 (ST STV0297 DVB-C)...
Jul  9 19:18:48 xxxxxxx kernel: [   58.809643] input: DVB on-card IR   
receiver as /devices/pci0000:00/0000:00:1e.0/0000:02:0d.0/input/input8
Jul  9 19:18:48 xxxxxxx kernel: [   58.878002] dvb-ttpci: found   
av7110-2.

