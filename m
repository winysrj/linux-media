Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JSET4-0003fJ-5m
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 17:40:18 +0100
Received: from [10.10.43.100] (e180066193.adsl.alicedsl.de [85.180.66.193])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 5E7FB43E10
	for <linux-dvb@linuxtv.org>; Thu, 21 Feb 2008 17:40:14 +0100 (CET)
Message-ID: <47BDA96B.7080700@okg-computer.de>
Date: Thu, 21 Feb 2008 17:40:11 +0100
From: =?ISO-8859-15?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Need Help with PCTV 452e (USB DVB-S2 device with
	STB0899)
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

Hi!

After two defective devices I got now a working one from pinnacle 
support (I tested it in Windows and it works fine).

But under Linux I could not get a positive scan or channel-lock. Could 
please anyone tell me what I am doing wrong? I read the list and 
searched the list archive and did everything described here, but my 
device isn't working.

I followed the instructions of the wiki about this device:

hg clone http://www.jusst.de/hg/multiproto
wget -O pctv452e.patch http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080125/b9e1d749/attachment-0001.patch
cd multiproto
patch -p1 < ../pctv452e.patch
make ; # there might be a few warnings.
cd v4l
insmod dvb-core.ko
insmod dvb-pll.ko
insmod stb6100.ko verbose=0
insmod stb0899.ko verbose=0
insmod lnbp22.ko
insmod dvb-usb.ko
insmod dvb-usb-pctv452e.ko
# in case some insmod complains about unresolved symbols: 
modprobe firmware_class


I can compile multiproto and install the modules. The device ist 
recognized when plugged in:

syslog tells this:

Feb 21 17:01:42 dev kernel: usb 3-5: new high speed USB device using 
ehci_hcd and address 5
Feb 21 17:01:42 dev kernel: usb 3-5: configuration #1 chosen from 1 choice
Feb 21 17:01:42 dev kernel: dvb-usb: found a 'PCTV HDTV USB' in warm state.
Feb 21 17:01:42 dev kernel: pctv452e_power_ctrl: 1
Feb 21 17:01:42 dev kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Feb 21 17:01:42 dev kernel: DVB: registering new adapter (PCTV HDTV USB)
Feb 21 17:01:42 dev kernel: pctv452e_frontend_attach Enter
Feb 21 17:01:42 dev kernel: stb0899_write_regs [0xf1b6]: 02
Feb 21 17:01:42 dev kernel: stb0899_write_regs [0xf1c2]: 00
Feb 21 17:01:42 dev kernel: stb0899_write_regs [0xf1c3]: 00
Feb 21 17:01:42 dev kernel: stb0899_write_regs [0xf141]: 02
Feb 21 17:01:42 dev kernel: _stb0899_read_reg: Reg=[0xf000], data=81
Feb 21 17:01:42 dev kernel: stb0899_get_dev_id: ID reg=[0x81]
Feb 21 17:01:42 dev kernel: stb0899_get_dev_id: Device ID=[8], Release=[1]
Feb 21 17:01:42 dev kernel: _stb0899_read_s2reg Device=[0xf3fc], Base 
address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
Feb 21 17:01:43 dev kernel: _stb0899_read_s2reg Device=[0xf3fc], Base 
address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
Feb 21 17:01:43 dev kernel: stb0899_get_dev_id: Demodulator Core 
ID=[DMD1], Version=[1]
Feb 21 17:01:43 dev kernel: _stb0899_read_s2reg Device=[0xfafc], Base 
address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
Feb 21 17:01:43 dev kernel: _stb0899_read_s2reg Device=[0xfafc], Base 
address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
Feb 21 17:01:43 dev kernel: stb0899_get_dev_id: FEC Core ID=[FEC1], 
Version=[1]
Feb 21 17:01:43 dev kernel: stb0899_attach: Attaching STB0899
Feb 21 17:01:43 dev kernel: lnbp22_set_voltage: 2 (18V=1 13V=0)
Feb 21 17:01:43 dev kernel: lnbp22_set_voltage: 0x60)
Feb 21 17:01:43 dev kernel: pctv452e_frontend_attach Leave Ok
Feb 21 17:01:43 dev kernel: DVB: registering frontend 0 (STB0899 
Multistandard)...
Feb 21 17:01:43 dev kernel: pctv452e_tuner_attach Enter
Feb 21 17:01:43 dev kernel: stb6100_attach: Attaching STB6100
Feb 21 17:01:43 dev kernel: pctv452e_tuner_attach Leave
Feb 21 17:01:43 dev kernel: input: IR-receiver inside an USB DVB 
receiver as /class/input/input4
Feb 21 17:01:43 dev kernel: dvb-usb: schedule remote query interval to 
100 msecs.
Feb 21 17:01:43 dev kernel: pctv452e_power_ctrl: 0
Feb 21 17:01:43 dev kernel: dvb-usb: PCTV HDTV USB successfully 
initialized and connected.

I downloaded the dvb-apps:
hg clone http://linuxtv.org/hg/dvb-apps

I downloaded the patched scan:
wget http://jusst.de/manu/scan.tar.bz2

I downloaded the patched szap:
wget http://abraham.manu.googlepages.com/szap.c

I updated version.h and frontend.h in the include path with the version 
of multiproto. Everything compiles fine, but finally nothing works.

When I scan for channels, this is the output after some time:

scanning dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 22000000
----------------------------------> Using 'STB0899 Multistandard' DVB-S
Tune to frequency 12551500
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
Tune to frequency 12551500
DVB-S IF freq is 1951500
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.


In the syslog I got this entry several times:

Feb 21 17:06:15 dev kernel: _stb0899_read_reg: Reg=[0xf41b], data=ee
Feb 21 17:06:15 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 21 17:06:15 dev kernel: stb0899_search_carrier: Derot Freq=0, mclk=1510
Feb 21 17:06:15 dev kernel: _stb0899_read_reg: Reg=[0xf41b], data=ee
Feb 21 17:06:15 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 21 17:06:15 dev kernel: _stb0899_read_reg: Reg=[0xf43a], data=08
Feb 21 17:06:15 dev kernel: stb0899_check_carrier: --------------------> 
STB0899_DSTATUS=[0x08]
Feb 21 17:06:15 dev kernel: stb0899_check_carrier: -------------> 
NOCARRIER !

So what can I do to make things work? What am I doing wrong since other 
people here report successfull working devices?
I have several lines of this in the syslog:

Feb 21 17:06:56 dev kernel: lnbp22_set_voltage: 2 (18V=1 13V=0)

Is this OK or ist this an error (set_voltage 2)?? If 0=13V and 1=18V 
what is 2??

Jens

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
