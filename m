Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JeRyT-0007I0-CE
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 10:31:20 +0100
Message-ID: <47EA17BE.3080409@dsl.pipex.com>
Date: Wed, 26 Mar 2008 09:30:38 +0000
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.81.1206506075.819.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.81.1206506075.819.linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova - t disconnects
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

I've also been experiencing disconnects with my laptop (testing hardy 
before deploying to my main mythbox)  I put the following in as a ubuntu 
bug report as well bu I have a feeling it's a kernel issue...  Happy to 
help with the ongoing fight for stability!

I get the same behaviour on my HP nx6125 laptop with both a nova-t and 
nova-t diversity stick. Either attempting to scan for, or watch dvb 
channels results in the following:

 MT2060: successfully identified (IF1 = 1220)
[ 589.459712] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:13.2/usb3/3-8/input/input16
[ 589.470534] dvb-usb: schedule remote query interval to 150 msecs.
[ 589.470540] dvb-usb: Hauppauge Nova-T Stick successfully initialized 
and connected.
[ 606.300175] hub 3-0:1.0: port 8 disabled by hub (EMI?), re-enabling...
[ 606.300181] usb 3-8: USB disconnect, address 11
[ 606.312990] mt2060 I2C write failed
[ 608.563167] mt2060 I2C write failed
[ 608.563243] mt2060 I2C write failed (len=2)
[ 608.563246] mt2060 I2C write failed (len=6)

This was with the latest mercurial build from v4l-dvb but this doesn't 
seem to fix things and displays the same as the stock kernel modules. 
There were some disconnects with previous ubuntu kernel versions (gutsy 
and previous) but not nearly as frequent as is now happening. Looks like 
it's probabably an upstream issue as I've read of several other 
sufferers even with vanilla kernels. Could be my usb chipset or 
something more generic, lspci is below. Please let me know if I can 
provide any further debug.

david@davslaptop:~$ lspci
00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 01)
00:01.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:04.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:05.0 PCI bridge: ATI Technologies Inc RS480 PCI Bridge
00:13.0 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.1 USB Controller: ATI Technologies Inc IXP SB400 USB Host Controller
00:13.2 USB Controller: ATI Technologies Inc IXP SB400 USB2 Host Controller
00:14.0 SMBus: ATI Technologies Inc IXP SB400 SMBus Controller (rev 11)
00:14.1 IDE interface: ATI Technologies Inc IXP SB400 IDE Controller
00:14.3 ISA bridge: ATI Technologies Inc IXP SB400 PCI-ISA Bridge
00:14.4 PCI bridge: ATI Technologies Inc IXP SB400 PCI-PCI Bridge
00:14.5 Multimedia audio controller: ATI Technologies Inc IXP SB400 
AC'97 Audio Controller (rev 02)
00:14.6 Modem: ATI Technologies Inc SB400 AC'97 Modem Controller (rev 02)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc Radeon XPRESS 
200M 5955 (PCIE)
02:01.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5788 
Gigabit Ethernet (rev 03)
02:02.0 Network controller: Broadcom Corporation BCM4318 [AirForce One 
54g] 802.11g Wireless LAN Controller (rev 02)
02:04.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
02:04.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE 1394 
Host Controller
02:04.3 Mass storage controller: Texas Instruments PCIxx21 Integrated 
FlashMedia Controller
02:04.4 SD Host ...

dh

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
