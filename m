Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m42Cxgod012448
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:59:42 -0400
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m42CxKp3016792
	for <video4linux-list@redhat.com>; Fri, 2 May 2008 08:59:21 -0400
Message-ID: <481B1027.1040002@linuxtv.org>
Date: Fri, 02 May 2008 08:59:19 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Steven Toth <stoth@hauppauge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: cx18-0: ioremap failed,
	perhaps increasing __VMALLOC_RESERVE in page.h
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

I had this issue before dtv support was properly added to the cx18 driver.

With digital working fine, the issue had disappeared.

Now, using cx18 in the master branch, whose dtv side is crippled due to
lack of the mxl driver, the error is back.

The cx18 driver can be loaded on my system once.  If I unload it, then I
get this every time I try to modprobe it again.

First, this is what it looks like the first time -- this is OK.

[   45.515441] Linux video capture interface: v2.00
[   45.840402] cx18:  Start initialization, version 1.0.0
[   45.840478] cx18-0: Initializing card #0
[   45.840484] cx18-0: Autodetected Hauppauge card
[   45.840510] ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 19 (level,
low) -> IRQ 17
[   45.840769] cx18-0: cx23418 revision 01010000 (B)
[   45.977540] tveeprom 1-0050: Hauppauge model 74041, rev C6B2, serial#
899541
[   45.977547] tveeprom 1-0050: MAC address is 00-0D-FE-0D-B9-D5
[   45.977551] tveeprom 1-0050: tuner model is TCL M2523_5N_E (idx 112,
type 50)
[   45.977555] tveeprom 1-0050: TV standards NTSC(M) (eeprom 0x08)
[   45.977559] tveeprom 1-0050: audio processor is CX23418 (idx 38)
[   45.977562] tveeprom 1-0050: decoder processor is CX23418 (idx 31)
[   45.977566] tveeprom 1-0050: has no radio, has IR receiver, has IR
transmitter
[   45.977570] cx18-0: Autodetected Hauppauge HVR-1600
[   45.977574] cx18-0: DVB & VBI are not yet supported
[   46.186774] tuner 2-0061: chip found @ 0xc2 (cx18 i2c driver #0-1)
[   46.186834] cs5345 1-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
[   46.188571] cx18-0: Disabled encoder IDX device
[   46.188639] cx18-0: Registered device video0 for encoder MPEG (2 MB)
[   46.188688] cx18-0: Registered device video32 for encoder YUV (2 MB)
[   46.188737] cx18-0: Registered device video24 for encoder PCM audio
(1 MB)
[   46.318804] Driver 'sr' needs updating - please use bus_type methods
[   46.333007] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   46.333014] Uniform CD-ROM driver Revision: 3.20
[   46.333143] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   46.461691] tuner-simple 2-0061: creating new instance
[   46.461697] tuner-simple 2-0061: type set to 50 (TCL 2002N)
[   46.740100] parport_pc 00:0a: reported by Plug and Play ACPI
[   46.740140] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   48.183476] cx18-0: loaded v4l-cx23418-apu.fw firmware V00120000
(141200 bytes)
[   48.283518] cx18-0: loaded v4l-cx23418-cpu.fw firmware (174716 bytes)
[   48.289808] cx18-0: FW version: 0.0.71.0 (Release 2006/12/29)
[   48.850871] cx18-0: loaded v4l-cx23418-dig.fw firmware (16382 bytes)
[   48.852862] cx18-0: Initialized card #0: Hauppauge HVR-1600
[   48.852938] ACPI: PCI Interrupt 0000:00:14.5[B] -> GSI 17 (level,
low) -> IRQ 16
[   48.853583] cx18:  End initialization

...but after unloading it once:

[ 2132.526778] tuner-simple 2-0061: destroying instance
[ 2132.531551] ACPI: PCI interrupt for device 0000:02:07.0 disabled
[ 2132.531562] cx18-0: Removed Hauppauge HVR-1600, card #0


every time I try to load cx18 again, I get this:


[ 2198.627071] Linux video capture interface: v2.00
[ 2198.644995] cx18:  Start initialization, version 1.0.0
[ 2198.645061] cx18-0: Initializing card #0
[ 2198.645065] cx18-0: Autodetected Hauppauge card
[ 2198.645092] ACPI: PCI Interrupt 0000:02:07.0[A] -> GSI 19 (level,
low) -> IRQ 17
[ 2198.645115] allocation failed: out of vmalloc space - use
vmalloc=<size> to increase size.
[ 2198.645119] cx18-0: ioremap failed, perhaps increasing
__VMALLOC_RESERVE in page.h
[ 2198.645124] cx18-0: or disabling CONFIG_HIGHMEM4G into the kernel
would help
[ 2198.645130] cx18-0: Error -12 on initialization
[ 2198.645184] cx18: probe of 0000:02:07.0 failed with error -12
[ 2198.645202] cx18:  End initialization
[ 2236.317472] Linux video capture interface: v2.00
[ 2236.344161] cx18:  Start initialization, version 1.0.0
[ 2236.344232] cx18-0: Initializing card #0
[ 2236.344236] cx18-0: Autodetected Hauppauge card
[ 2236.344265] allocation failed: out of vmalloc space - use
vmalloc=<size> to increase size.
[ 2236.344269] cx18-0: ioremap failed, perhaps increasing
__VMALLOC_RESERVE in page.h
[ 2236.344273] cx18-0: or disabling CONFIG_HIGHMEM4G into the kernel
would help
[ 2236.344278] cx18-0: Error -12 on initialization
[ 2236.344287] cx18: probe of 0000:02:07.0 failed with error -12
[ 2236.344304] cx18:  End initialization


-Mike


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
