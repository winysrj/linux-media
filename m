Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.ewetel.de ([212.6.122.13]:45393 "EHLO mail1.ewetel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZCFUi1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2009 15:38:27 -0500
Received: from [192.168.1.5] (dyndsl-091-096-011-129.ewe-ip-backbone.de [91.96.11.129])
	by mail1.ewetel.de (8.12.1/8.12.9) with ESMTP id n26H7gJk016874
	for <linux-media@vger.kernel.org>; Fri, 6 Mar 2009 18:07:43 +0100 (CET)
Message-ID: <49B1585E.8060005@ewetel.net>
Date: Fri, 06 Mar 2009 18:07:42 +0100
From: Hartmut <spieluhr@ewetel.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Not able to view HD-TV via Technisat Skystar HD 2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

since 4 days I have a Technisat Skystar HD 2 in my Computer (PCI-card).
OS is Opensuse 11.0 (kernel 2.6.25) without vdr but with Kaffeine as
frontend. I installed the multiproto-mantis driver (via hg clone and so on)
and got the card working, so I can watch dvb-s with Kaffeine. But: not
dvb-s2!

Perhaps I got the wrong version of scan, but scan works (scan -a 1 -x 0 -t 1
/usr/share/dvb/dvb-s/Astra-19.2E > ~/.szap/channels.conf), but does not
find any s2-channels. I tried some versions of dvb-utils and patches,
but none were done by make and I have no clue, where to get the right
versions of both. I've read about some options which could be given to
the modules, but I don't know which and how, the card starts (only now
by hand) with modprobe mantis and both the STB-modules come up too.
(Attention: there ist a dvb-t-reciever too which makes adapter0, see lsmod))

******** /sbin/lspci -vv
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

******** /sbin/lsmod | grep dvb
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

scan can not tune to the following frequencies:
12669, 11707, 11361, 12580, 11914, 11435, 10861, 12522 (all with HD)

Tuning to a "good" transponder:
******** dmesg
mantis stop feed and dma
stb6100_set_bandwidth: Bandwidth=61262500
stb6100_get_bandwidth: Bandwidth=62000000
stb6100_get_bandwidth: Bandwidth=62000000
stb6100_set_frequency: Frequency=1236000
stb6100_get_frequency: Frequency=1235988
stb6100_get_bandwidth: Bandwidth=62000000
mantis start feed & dma

scanning a "bad" transponder:
******** Scan-output
>>> >>> tune to: 12580:v:0:22000
DVB-S IF freq is 1980990
WARNING: >>> tuning failed!!!
>>> >>> tune to: 12580:v:0:22000 (tuning failed)
DVB-S IF freq is 1980990
WARNING: >>> tuning failed!!!
******** tail -f /var/log/messages
Mar  6 17:03:27 Jupiter kernel: mantis stop feed and dma
Mar  6 17:03:29 Jupiter kernel: stb6100_set_bandwidth: Bandwidth=51610000
Mar  6 17:03:29 Jupiter kernel: stb6100_get_bandwidth: Bandwidth=52000000
Mar  6 17:03:29 Jupiter kernel: stb6100_get_bandwidth: Bandwidth=52000000
Mar  6 17:03:30 Jupiter kernel: stb6100_set_frequency: Frequency=1980990
Mar  6 17:03:30 Jupiter kernel: stb6100_get_frequency: Frequency=1980966
Mar  6 17:03:30 Jupiter kernel: stb6100_get_bandwidth: Bandwidth=52000000
+++++++++ plus another 9 times +++++++++
Mar  6 17:04:32 Jupiter kernel: mantis start feed & dma

I inserted Anixe HD by hand into the channels.conf and zapped:

******** szap2 -a 1 -t 2 -r -n 1
reading channels from file '/home/hartmut/.szap/channels.conf'
zapping to 1 'ANIXE HD':
sat 0, frequency = 11914 MHz H, symbolrate 27500000, vpid = 0x05ff, apid
= 0x0603 sid = 0x0084
Delivery system=DVB-S2
using '/dev/dvb/adapter1/frontend0' and '/dev/dvb/adapter1/demux0'

do_tune: API version=3, delivery system = 2
do_tune: Frequency = 1314000, Srate = 27500000
do_tune: Frequency = 1314000, Srate = 27500000

which made the output of dmesg:
mantis stop feed and dma
stb6100_set_bandwidth: Bandwidth=47125000
stb6100_get_bandwidth: Bandwidth=48000000
stb6100_set_frequency: Frequency=1314000
stb6100_get_frequency: Frequency=1314008
(and nothing more)

What should I try? Where should I look for?

Regards,

Hartmut


