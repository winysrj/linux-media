Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <harth@arcor.de>) id 1LB5kw-00067q-FP
	for linux-dvb@linuxtv.org; Fri, 12 Dec 2008 12:00:28 +0100
Received: from mail-in-16-z2.arcor-online.net (mail-in-16-z2.arcor-online.net
	[151.189.8.33])
	by mail-in-13.arcor-online.net (Postfix) with ESMTP id 00B3A1E500C
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 11:59:53 +0100 (CET)
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mail-in-16-z2.arcor-online.net (Postfix) with ESMTP id CD4172542C3
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 11:59:52 +0100 (CET)
Received: from webmail14.arcor-online.net (webmail14.arcor-online.net
	[151.189.8.67]) by mail-in-01.arcor-online.net (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 11:59:52 +0100 (CET)
Message-ID: <8790645.1229079592763.JavaMail.ngmail@webmail14.arcor-online.net>
Date: Fri, 12 Dec 2008 11:59:52 +0100 (CET)
From: harth@arcor.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] MSI TV@nywhere Satellite cx88-dvb module problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi to all,

I'm using Ubuntu 8.10 (intrepid) on a AMD64 ...

uname -a
Linux xxxx 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC 2008 x86_64 GNU/=
Linux

My problem is to get my MSI TV@nywhere TV Card running. The issue is, that =
the dvb module cannot be loaded - for whatever =

reason ... :-(

Here is some more detailed information about my system:

###########################################################################=
####
lspci -vv =


03:06.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 P=
CI Video and Audio Decoder (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Device 0023
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: cx8800
	Kernel modules: cx8800

03:06.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Vid=
eo and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Device 0023
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel modules: cx8802

03:06.4 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Vid=
eo and Audio Decoder [IR Port] (rev 05)
	Subsystem: Twinhan Technology Co. Ltd Device 0023
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Steppi=
ng- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=3D16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3col=
d-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
###########################################################################=
####

lsmod | grep cx88

cx88_vp3054_i2c        11392  0 =

cx8802                 26500  0 =

cx8800                 44660  0 =

cx88xx                 83624  2 cx8802,cx8800
ir_common              51716  1 cx88xx
i2c_algo_bit           15364  2 cx88_vp3054_i2c,cx88xx
tveeprom               23428  1 cx88xx
v4l2_common            21888  2 tuner,cx8800
btcx_risc              13448  3 cx8802,cx8800,cx88xx
compat_ioctl32         18176  2 cx8800,gspca_main
videodev               46720  5 tuner,cx8800,cx88xx,gspca_main,compat_ioctl=
32
videobuf_dma_sg        22788  3 cx8802,cx8800,cx88xx
videobuf_core          29956  5 videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_=
dma_sg
i2c_core               36128  7 cx88_vp3054_i2c,tuner,cx88xx,i2c_algo_bit,t=
veeprom,v4l2_common,i2c_piix4
###########################################################################=
####

dmesg | grep cx88

[   12.612388] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   12.613203] cx8800 0000:03:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ=
 21
[   12.614085] cx88[0]: subsystem: 1822:0023, board: MSI TV-@nywhere [card=
=3D13,insmod option]
[   12.614088] cx88[0]: TV tuner type 33, Radio tuner type -1
[   12.616815] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   12.904279] cx88[0]/0: found at 0000:03:06.0, rev: 5, irq: 21, latency: =
64, mmio: 0xfc000000
[   12.905200] cx88[0]/0: registered device video0 [v4l2]
[   12.905268] cx88[0]/0: registered device vbi0
[   12.905504] cx88[0]/2: cx2388x 8802 Driver Manager
[  292.184047] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[  292.184066] cx88/2: registering cx8802 driver, type: dvb access: shared
###########################################################################=
####

I have manually specified the following in /etc/modprobe.d/options

options cx88xx card=3D13

since the card wasn't automatically detected by the system ...

And finally manually loading the dvb modules gives:

modprobe cx88-dvb
FATAL: Error inserting cx88_dvb (/lib/modules/2.6.27-9-generic/kernel/drive=
rs/media/video/cx88/cx88-dvb.ko): No such device

This is strange, since the *.ko is available:

 ls -al /lib/modules/2.6.27-9-generic/kernel/drivers/media/video/cx88

drwxr-xr-x  2 root root   1024 2008-12-01 11:33 .
drwxr-xr-x 22 root root   4096 2008-12-01 11:33 ..
-rw-r--r--  1 root root  69680 2008-11-21 00:31 cx8800.ko
-rw-r--r--  1 root root  42568 2008-11-21 00:31 cx8802.ko
-rw-r--r--  1 root root  33704 2008-11-21 00:31 cx88-alsa.ko
-rw-r--r--  1 root root  42008 2008-11-21 00:31 cx88-blackbird.ko
-rw-r--r--  1 root root  46536 2008-11-21 00:31 cx88-dvb.ko
-rw-r--r--  1 root root  14768 2008-11-21 00:31 cx88-vp3054-i2c.ko
-rw-r--r--  1 root root 121472 2008-11-21 00:31 cx88xx.ko


Any hints how to solve this problem? Seems that my card is not supported ..=
. =


Many thanks in advance
Thorsten

Jetzt komfortabel bei Arcor-Digital TV einsteigen: Mehr Happy Ends, mehr He=
rzschmerz, mehr Fernsehen! Erleben Sie 50 digitale TV Programme und optiona=
l 60 Pay TV Sender, einen elektronischen Programmf=FChrer mit Movie Star Be=
wertungen von TV Movie. Au=DFerdem, aktuelle Filmhits und spannende Dokus i=
n der Arcor-Videothek. Infos unter www.arcor.de/tv

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
