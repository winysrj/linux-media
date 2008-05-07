Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47FKaku019192
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 11:20:36 -0400
Received: from brera.quinntek.com.au (218-214-44-165.people.net.au
	[218.214.44.165])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m47FKMTB019616
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 11:20:24 -0400
Received: from quinntekws01 (quinntek-ws01.quinntek.com.au [10.10.156.11])
	by brera.quinntek.com.au (8.13.4/8.12.10/SuSE Linux 0.7) with ESMTP id
	m47FK5vr030797
	for <video4linux-list@redhat.com>; Thu, 8 May 2008 01:20:15 +1000
From: "Fergal Quinn" <fergalq@quinntek.com.au>
To: <video4linux-list@redhat.com>
Date: Thu, 8 May 2008 01:20:45 +1000
Message-ID: <03c501c8b055$ec81fdf0$0b9c0a0a@quinntek.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Dvico FusionHDTV Dual Express difficulties
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

Hi all,

 

I'm having difficulty getting a Dvico FusionHDTV Dual Express card to
function in my SuSE 10.3 system.  I've cloned and installed Chris Pascoe's
test tree, including the firmware upgrade, ie

 

make clean

make rminstall

make release

make

make install

 

When I reboot (cold boot) the machine, it seems to be loading all the
appropriate drivers (I think) and registering the hardware (An extract from
boot.msg is at the bottom of this email).

 

However, there is no message to indicate that the firmware has loaded, and
I'm unsure whether it does load.  (This may not be a problem, of course!).

 

In addition, 'lspci' yields the following:

 

.

.

00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (Internal
gfx)

00:04.0 PCI bridge: ATI Technologies Inc Unknown device 7914

.

.

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge

.

.

02:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev 02)

 

which seems a bit odd - I would have expected a 'Dvico something' rather
than 'Conexant Unknown device'.  (I've no idea what the Unknown device 7914
is either - but may not be relevant).

 

'lsusb' yields nothing either, but I assume that as there's no physical usb
device installed, that this is correct.

 

Finally, a 'dvbscan /usr/share/dvb/dvb-t/au-Sydney_North_Shore' yields the
message 'Unable to query frontend status', which my reading of the mailing
lists indicates a problem communicating with the tuner.

 

Any and all suggestions/assistance would be most appreciated.

 

For the record, I'm running a Gigabyte GA-MA69G-S3H with a SuSE 10.3 x86_64
distribution and AMD/ATI's proprietary Catalyst 8.1 drivers.

 

Regards,

 

Fergal

 

 

 

Boot.msg extract:

 

<6>cx23885 driver version 0.0.1 loaded

<6>ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16

<6>CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV DVB-T Dual
Express [card=5,autodetected]

<4>cx23885[0]: i2c bus 0 registered

<4>cx23885[0]: i2c bus 1 registered

<4>cx23885[0]: i2c bus 2 registered

<6>input: i2c IR (FusionHDTV) as /class/input/input5

<4>ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-1/1-006b/ir0 [cx23885[0]]

<4>cx23885[0]: cx23885 based dvb card

<4>fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies,
Starnberg, GERMANY' taints kernel.

<6>[fglrx] Maximum main memory to use for locked dma buffers: 1404 MBytes.

<6>[fglrx] ASYNCIO init succeed!

<6>[fglrx] PAT is enabled successfully!

<6>[fglrx] module loaded - fglrx 8.45.5 [Feb  1 2008] on minor 0

<6>xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner

<6>DVB: registering new adapter (cx23885[0])

<4>DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...

<4>cx23885[0]: cx23885 based dvb card

<6>xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner

<6>DVB: registering new adapter (cx23885[0])

<4>DVB: registering frontend 1 (Zarlink ZL10353 DVB-T)...

<6>cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio:
0xfd800000

<7>PCI: Setting latency timer of device 0000:02:00.0 to 64

 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
