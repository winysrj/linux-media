Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail2.ewetel.de ([212.6.122.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <spieluhr@ewetel.net>) id 1LfNo5-0000Ob-N6
	for linux-dvb@linuxtv.org; Fri, 06 Mar 2009 01:21:01 +0100
Received: from [192.168.1.5] (host-091-097-184-242.ewe-ip-backbone.de
	[91.97.184.242])
	by mail2.ewetel.de (8.12.1/8.12.9) with ESMTP id n25LNH9h009881
	for <linux-dvb@linuxtv.org>; Thu, 5 Mar 2009 22:23:21 +0100 (CET)
Message-ID: <49B042C5.7000005@ewetel.net>
Date: Thu, 05 Mar 2009 22:23:17 +0100
From: Hartmut <spieluhr@ewetel.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Not able to view HD-TV via Technisat Skystar HD 2
Reply-To: linux-media@vger.kernel.org
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

Hi,

since 3 days I have a Technisat Skystar HD 2 in my Computer (PCI-card).
OS is Opensuse 11.0 (kernel 2.6.25) without vdr but with Kaffeine as
frontend. I installed the multiproto-mantis driver and got the card
working, so I can watch dvb-s with Kaffeine. But: not dvb-s2! Perhaps I
got the wrong version of scan, but scan works (scan -a 1 -x 0 -t 1
/usr/share/dvb/dvb-s/Astra-19.2E > ~/.szap/channels.conf), but does not
find any s2-channels. I tried some versions of dvb-utils and patches,
but none were done by make and I have no clue, where to get the right
versions of both. I've read about some options which could be given to
the modules, but I don't know which and how, the card starts (only now
by hand) with modprobe mantis and both the STB-modules come up too.
(Attention: there ist a dvb-t-reciever too which makes adapter0, see lsmod))

/sbin/lspci
00:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)

/sbin/lspci -vv
00:09.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: Device 1ae4:0003
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fb000000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

/sbin/lsmod | grep dvb
dvb_pll                27656  1
dvb_usb_nova_t_usb2    25348  0
dvb_usb_dibusb_common    27780  1 dvb_usb_nova_t_usb2
dib3000mc              31368  2 dvb_usb_dibusb_common
dvb_usb                41228  2 dvb_usb_nova_t_usb2,dvb_usb_dibusb_common
dvb_core              117668  3 mantis_core,stv0299,dvb_usb
firmware_class         27776  1 dvb_usb
i2c_core               45344  18
mantis,mantis_core,tda665x,lnbp21,mb86a16,stb6100,tda10021,tda10023,zl10353,stb0899,stv0299,dvb_pll,mt2060,i2c_viapro,nvidia,dib3000mc,dibx000_common,dvb_usb
usbcore               188376  6
usb_storage,dvb_usb_nova_t_usb2,dvb_usb,ehci_hcd,uhci_hcd

dmesg
mantis stop feed and dma
stb6100_set_bandwidth: Bandwidth=61262500
stb6100_get_bandwidth: Bandwidth=62000000
stb6100_get_bandwidth: Bandwidth=62000000
stb6100_set_frequency: Frequency=1236000
stb6100_get_frequency: Frequency=1235988
stb6100_get_bandwidth: Bandwidth=62000000
mantis start feed & dma

What should I try?

Regards,

Spielmops-Hartmut


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
