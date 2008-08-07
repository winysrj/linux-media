Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web36101.mail.mud.yahoo.com ([66.163.179.215])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <knueffle@yahoo.com>) id 1KR4ye-0004Xl-8E
	for linux-dvb@linuxtv.org; Thu, 07 Aug 2008 14:52:26 +0200
Date: Thu, 7 Aug 2008 05:51:46 -0700 (PDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <227547.48274.qm@web36101.mail.mud.yahoo.com>
Subject: [linux-dvb] help with dvbstream network streaming
Reply-To: knueffle@yahoo.com
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

Hi people,

I have a dvb-s card, I got it working finally in ubuntu :) (more information about my hardware at the end of the mail, in case it is needed). I have been looking around for a good dvbstream tutorial, but haven't really found one, also the man page does not seem to be complete. I would like to stream from my some the machine with the dvb-s card to clients in the network and maybe also on the internet. 

I don't get how to specify the command I have tried several things, e.g.:
dvbstream -f 11567 -p v -s 22000 -D 0 -i 192.168.2.23 -r 1237

-f is the frequency in what? hz, mhz, ghz??
-p polarization, ok that's clear either horizontal or vertical
-s symbolrate also not clear on that, 
-D inidcated which LNB to use, no problem here
-i to what ip to send the stream?
-r the port on to send the stream

and what about 22khz tone how can i specify in dvbstream to turn it on or off

Here what I get when I execute the command above:

dvbstream -f 11567 -p v -s 22000 -D 0
dvbstream v0.6 - (C) Dave Chapman 2001-2004
Released under the GPL.
Latest version available from http://www.linuxstb.org/
Tuning to 11567 Hz
Using DVB card "ST STV0299 DVB-S", freq=11567
tuning DVB-S to Freq: 1817000, Pol:V Srate=22000000, 22kHz tone=off, LNB: 0
Setting only tone OFF and voltage 13V
DISEQC SETTING SUCCEDED
Getting frontend status
Not able to lock to the signal on the given frequency
dvbstream will stop after -1 seconds (71582788 minutes)
Using 224.0.1.2:5004:2
version=2
Streaming 0 streams

Why isn't it able to lock to the signal? I can watch the station on kaffeine or mplayer or xine...

I also don't understand the channels.conf file syntax completly, if someon could explain that as well, e.g.:

ARTE:11567:v:1:22000:167:136:9019     (same as the dvbstream command above)

channelname:frequency:polarization:???:symbolrate:???:???:????

I guess one is for the audio pid and one for video pid, but which ones and what about the other 2 remaining entries?

Also can I stream just one channel or more at the same time?

And I was wondering about my CI module, it is connected to the dvb-s card, can I check somehow that it is recognized and working? I don't have yet a cam or card...

OK that's it would be happy about some help or pointers to some tutorials or something, thx in advance,

from here on it's just hardware info about my machine...
thx jody :)



dvb-s card, Technotrend Premium S-2300 "modded", which is identical to Hauppauge Nexus-S 2.3, but with additional Features:
http://www.dvbshop.net/product_info.php/info/p59_Technotrend-Premium-S-2300--modded--incl--remote.html 

CI-module for that card

ubuntu hardy 2.6.24-19-generic kernel
mainboard GeForce705VT-M5

ls /dev/dvb/adapter0/
audio0     ca0        demux0     dvr0       frontend0  net0       osd0       video0

lspci
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

lspci -v
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at febffc00 (32-bit, non-prefetchable) [size=512]
lspci -nn
01:04.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 11)
01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)

lsmod | egrep dvb
dvb_ttpci             103752  0 
dvb_core               81404  2 stv0299,dvb_ttpci
saa7146_vv             51072  1 dvb_ttpci
saa7146                20488  2 dvb_ttpci,saa7146_vv
ttpci_eeprom            3456  1 dvb_ttpci
i2c_core               24832  8 lnbp21,stv0299,bttv,i2c_algo_bit,tveeprom,dvb_ttpci,ttpci_eeprom,nvidia

lspci
00:00.0 Host bridge: nVidia Corporation Unknown device 07c3 (rev a2)
00:00.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a2)
00:01.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.2 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.3 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.4 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.5 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.6 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:02.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:03.0 ISA bridge: nVidia Corporation Unknown device 07d7 (rev a2)
00:03.1 SMBus: nVidia Corporation Unknown device 07d8 (rev a1)
00:03.2 RAM memory: nVidia Corporation Unknown device 07d9 (rev a1)
00:03.4 RAM memory: nVidia Corporation Unknown device 07c8 (rev a1)
00:04.0 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1)
00:04.1 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1)
00:08.0 IDE interface: nVidia Corporation Unknown device 056c (rev a1)
00:09.0 Audio device: nVidia Corporation MCP73 High Definition Audio (rev a1)
00:0a.0 PCI bridge: nVidia Corporation Unknown device 056d (rev a1)
00:0b.0 PCI bridge: nVidia Corporation Unknown device 056e (rev a1)
00:0c.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1)
00:0d.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1)
00:0e.0 IDE interface: nVidia Corporation Unknown device 07f0 (rev a2)
00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
00:10.0 VGA compatible controller: nVidia Corporation GeForce 7050/nForce 610i (rev a2)
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)


lspci -nn
00:00.0 Host bridge [0600]: nVidia Corporation Unknown device [10de:07c3] (rev a2)
00:00.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cb] (rev a2)
00:01.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cd] (rev a1)
00:01.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07ce] (rev a1)
00:01.2 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cf] (rev a1)
00:01.3 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d0] (rev a1)
00:01.4 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d1] (rev a1)
00:01.5 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d2] (rev a1)
00:01.6 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d3] (rev a1)
00:02.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d6] (rev a1)
00:03.0 ISA bridge [0601]: nVidia Corporation Unknown device [10de:07d7] (rev a2)
00:03.1 SMBus [0c05]: nVidia Corporation Unknown device [10de:07d8] (rev a1)
00:03.2 RAM memory [0500]: nVidia Corporation Unknown device [10de:07d9] (rev a1)
00:03.4 RAM memory [0500]: nVidia Corporation Unknown device [10de:07c8] (rev a1)
00:04.0 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:07fe] (rev a1)
00:04.1 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:056a] (rev a1)
00:08.0 IDE interface [0101]: nVidia Corporation Unknown device [10de:056c] (rev a1)
00:09.0 Audio device [0403]: nVidia Corporation MCP73 High Definition Audio [10de:07fc] (rev a1)
00:0a.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056d] (rev a1)
00:0b.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056e] (rev a1)
00:0c.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0d.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0e.0 IDE interface [0101]: nVidia Corporation Unknown device [10de:07f0] (rev a2)
00:0f.0 Ethernet controller [0200]: nVidia Corporation MCP73 Ethernet [10de:07dc] (rev a2)
00:10.0 VGA compatible controller [0300]: nVidia Corporation GeForce 7050/nForce 610i [10de:07e3] (rev a2)
01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)


sudo lspci -v
00:00.0 Host bridge: nVidia Corporation Unknown device 07c3 (rev a2)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0

00:00.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a2)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0

00:01.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.2 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.3 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.4 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.5 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:01.6 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:02.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:03.0 ISA bridge: nVidia Corporation Unknown device 07d7 (rev a2)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 4f00 [size=256]

00:03.1 SMBus: nVidia Corporation Unknown device 07d8 (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel, IRQ 11
        I/O ports at 4900 [size=64]
        I/O ports at 4d00 [size=64]
        I/O ports at 4e00 [size=64]
        Capabilities: [44] Power Management version 2

00:03.2 RAM memory: nVidia Corporation Unknown device 07d9 (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:03.4 RAM memory: nVidia Corporation Unknown device 07c8 (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: 66MHz, fast devsel

00:04.0 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1) (prog-if 10 [OHCI])
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 18
        Memory at feaff000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:04.1 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1) (prog-if 20 [EHCI])
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 19
        Memory at feafec00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2

00:08.0 IDE interface: nVidia Corporation Unknown device 056c (rev a1) (prog-if 8a [Master SecP PriP])
        Subsystem: Unknown device f019:2145
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        I/O ports at ffa0 [size=16]
        Capabilities: [44] Power Management version 2

00:09.0 Audio device: nVidia Corporation MCP73 High Definition Audio (rev a1)
        Subsystem: Elitegroup Computer Systems Unknown device 2976
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
        Memory at feaf8000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-

00:0a.0 PCI bridge: nVidia Corporation Unknown device 056d (rev a1) (prog-if 01 [Subtractive decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        Memory behind bridge: feb00000-febfffff
        Capabilities: [b8] Subsystem: Elitegroup Computer Systems Unknown device 2145

00:0b.0 PCI bridge: nVidia Corporation Unknown device 056e (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
        Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0c.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
        Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0d.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
        Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0e.0 IDE interface: nVidia Corporation Unknown device 07f0 (rev a2) (prog-if 85 [Master SecO PriO])
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 220
        I/O ports at e480 [size=8]
        I/O ports at e400 [size=4]
        I/O ports at e080 [size=8]
        I/O ports at e000 [size=4]
        I/O ports at dc00 [size=16]
        Memory at feafc000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [44] Power Management version 2
        Capabilities: [8c] #12 [0010]
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+

00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 219
        Memory at feaf7000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at d880 [size=8]
        Memory at feafe800 (32-bit, non-prefetchable) [size=256]
        Memory at feafe400 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+

00:10.0 VGA compatible controller: nVidia Corporation GeForce 7050/nForce 610i (rev a2) (prog-if 00 [VGA controller])
        Subsystem: Elitegroup Computer Systems Unknown device 2145
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Memory at fc000000 (64-bit, non-prefetchable) [size=16M]
        Expansion ROM at feac0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-

01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
        Flags: bus master, medium devsel, latency 64, IRQ 20
        Memory at febffc00 (32-bit, non-prefetchable) [size=512]



      __________________________________________________________________
Instant Messaging, free SMS, sharing photos and more... Try the new Yahoo! Canada Messenger at http://ca.beta.messenger.yahoo.com/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
