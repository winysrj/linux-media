Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SEeirb011694
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:40:44 -0400
Received: from bay0-omc1-s40.bay0.hotmail.com (bay0-omc1-s40.bay0.hotmail.com
	[65.54.246.112])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SEeUnd017295
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:40:30 -0400
Message-ID: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
From: =?Windows-1252?Q?Vicent_Jord=E0?= <vjorda@hotmail.com>
To: <video4linux-list@redhat.com>
Date: Mon, 28 Apr 2008 14:40:24 +0000
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Trying to set up a NPG Real DVB-T PCI Card
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


Hi,

I'm trying to set up a NPG Real DVB-T PCI Card.

I've loaded the v4l drivers and it seems to load correctly.

=====================================================
Apr 28 13:43:51 rud kernel: [   61.822127] cx88[0]: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT [card=63,autodetected]
Apr 28 13:43:51 rud kernel: [   61.822132] cx88[0]: TV tuner type 71, Radio tuner type 0
Apr 28 13:43:51 rud kernel: [   62.141235] tuner' 0-0061: chip found @ 0xc2 (cx88[0])
Apr 28 13:43:51 rud kernel: [   62.177668] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
Apr 28 13:43:51 rud kernel: [   62.177674] cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
Apr 28 13:43:51 rud kernel: [   62.177697] cx88[0]/0: found at 0000:00:08.0, rev: 5, irq: 20, latency: 32, mmio: 0xdc000000
Apr 28 13:43:51 rud kernel: [   62.177806] cx88[0]/0: registered device video0 [v4l2]
Apr 28 13:43:51 rud kernel: [   62.177851] cx88[0]/0: registered device vbi0
Apr 28 13:43:51 rud kernel: [   62.177942] cx88[0]/0: registered device radio0
Apr 28 13:43:51 rud kernel: [   62.217543] xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
Apr 28 13:43:51 rud kernel: [   62.217851] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:51 rud kernel: [   62.416199] xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
Apr 28 13:43:51 rud kernel: [   62.416206] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:51 rud kernel: [   63.586138] xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.
Apr 28 13:43:51 rud kernel: [   63.602221] xc2028 0-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
Apr 28 13:43:51 rud kernel: [   63.687790] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:51 rud kernel: [   63.886136] xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
Apr 28 13:43:51 rud kernel: [   63.886142] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:51 rud kernel: [   65.052053] xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.
Apr 28 13:43:51 rud kernel: [   65.068115] xc2028 0-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
Apr 28 13:43:51 rud kernel: [   65.129754] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:51 rud kernel: [   65.249972] cx88[0]/2: cx2388x 8802 Driver Manager
Apr 28 13:43:51 rud kernel: [   65.250000] ACPI: PCI Interrupt 0000:00:08.2[A] -> GSI 18 (level, low) -> IRQ 20
Apr 28 13:43:51 rud kernel: [   65.250011] cx88[0]/2: found at 0000:00:08.2, rev: 5, irq: 20, latency: 32, mmio: 0xde000000
Apr 28 13:43:51 rud kernel: [   65.251049] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 19 (level, low) -> IRQ 21
Apr 28 13:43:51 rud kernel: [   65.416289] cx88/2: cx2388x dvb driver version 0.0.6 loaded
Apr 28 13:43:51 rud kernel: [   65.416298] cx88/2: registering cx8802 driver, type: dvb access: shared
Apr 28 13:43:51 rud kernel: [   65.416304] cx88[0]/2: subsystem: 14f1:8852, board: Geniatech X8000-MT DVBT [card=63]
Apr 28 13:43:51 rud kernel: [   65.416309] cx88[0]/2: cx2388x based DVB/ATSC card
Apr 28 13:43:51 rud kernel: [   65.521832] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
Apr 28 13:43:51 rud kernel: [   65.521840] cx88[0]/2: xc3028 attached
Apr 28 13:43:51 rud kernel: [   65.522538] DVB: registering new adapter (cx88[0])
Apr 28 13:43:51 rud kernel: [   65.522543] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
Apr 28 13:43:51 rud kernel: [   67.345027] lp0: using parport0 (interrupt-driven).
Apr 28 13:43:51 rud kernel: [   67.460431] Adding 2562328k swap on /dev/sda7.  Priority:-1 extents:1 across:2562328k
Apr 28 13:43:51 rud kernel: [   68.046049] EXT3 FS on sda6, internal journal
Apr 28 13:43:51 rud kernel: [   70.437815] ip_tables: (C) 2000-2006 Netfilter Core Team
Apr 28 13:43:51 rud kernel: [   72.972373] No dock devices found.
Apr 28 13:43:52 rud kernel: [   75.398690] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:52 rud kernel: [   75.597047] xc2028 0-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
Apr 28 13:43:52 rud kernel: [   75.597055] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:53 rud kernel: [   76.755517] xc2028 0-0061: Loading firmware for type=FM (400), id 0000000000000000.
Apr 28 13:43:54 rud kernel: [   76.825247] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:54 rud kernel: [   77.023592] xc2028 0-0061: Loading firmware for type=BASE FM (401), id 0000000000000000.
Apr 28 13:43:54 rud kernel: [   77.023598] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:55 rud kernel: [   78.185507] xc2028 0-0061: Loading firmware for type=FM (400), id 0000000000000000.
Apr 28 13:43:55 rud kernel: [   78.231269] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:43:58 rud kernel: [   81.554905] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Apr 28 13:43:58 rud kernel: [   81.626484] wlan0: changing radio power level to 18 dBm (23)
Apr 28 13:44:01 rud kernel: [   84.551782] ppdev: user-space parallel port driver
Apr 28 13:44:01 rud kernel: [   85.142864] audit(1209383041.971:2): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=5530 profile="/usr/sbin/cupsd" namespace="default"
Apr 28 13:44:02 rud kernel: [   85.291620] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
Apr 28 13:44:02 rud kernel: [   85.291629] apm: overridden by ACPI.
Apr 28 13:44:02 rud kernel: [   85.545130] RPC: Registered udp transport module.
Apr 28 13:44:02 rud kernel: [   85.545139] RPC: Registered tcp transport module.
Apr 28 13:44:02 rud kernel: [   85.615108] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Apr 28 13:44:02 rud kernel: [   85.754526] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Apr 28 13:44:02 rud kernel: [   85.763190] NFSD: starting 90-second grace period
Apr 28 13:51:25 rud kernel: [  527.312442] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:25 rud kernel: [  527.510799] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Apr 28 13:51:25 rud kernel: [  527.510807] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:26 rud kernel: [  528.707901] MTS (4), id 00000000000000f7:
Apr 28 13:51:26 rud kernel: [  528.707916] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
Apr 28 13:51:26 rud kernel: [  528.781628] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:26 rud kernel: [  528.979980] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Apr 28 13:51:26 rud kernel: [  528.979988] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:27 rud kernel: [  530.162012] MTS (4), id 00000000000000f7:
Apr 28 13:51:27 rud kernel: [  530.162028] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
Apr 28 13:51:28 rud kernel: [  530.483974] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:28 rud kernel: [  530.682332] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
Apr 28 13:51:28 rud kernel: [  530.682339] cx88[0]: Calling XC2028/3028 callback
Apr 28 13:51:29 rud kernel: [  531.887588] MTS (4), id 00000000000000f7:
==========================================================================

But when I try to scan for channels this error appears in dmesg:

===========================================================================
[ 1581.454350] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1581.454358] cx88[0]: Calling XC2028/3028 callback
[ 1583.451836] MTS (4), id 00000000000000f7:
[ 1583.451853] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[ 1583.499889] xc2028 0-0061: Incorrect readback of firmware version.
[ 1583.915649] cx88[0]: Calling XC2028/3028 callback
[ 1584.114007] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1584.114015] cx88[0]: Calling XC2028/3028 callback
[ 1585.668643] MTS (4), id 00000000000000f7:
[ 1585.668659] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[ 1585.687679] xc2028 0-0061: Incorrect readback of firmware version.
[ 1585.741662] cx88[0]: Calling XC2028/3028 callback
[ 1585.940019] xc2028 0-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1585.940027] cx88[0]: Calling XC2028/3028 callback
[ 1587.165797] MTS (4), id 00000000000000f7:
[ 1587.165812] xc2028 0-0061: Loading firmware for type=MTS (4), id 0000000100000007.
[ 1587.183960] xc2028 0-0061: Incorrect readback of firmware version.
==============================================================================

What can I do to workaroud this problem?

Thanks,
Vicent


_________________________________________________________________
Tecnología, moda, motor, viajes,…suscríbete a nuestros boletines para estar siempre a la última
Guapos y guapas, clips musicales y estrenos de cine. 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
