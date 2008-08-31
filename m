Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jackden@gmail.com>) id 1KZfUx-0007Tw-Dq
	for linux-dvb@linuxtv.org; Sun, 31 Aug 2008 07:29:19 +0200
Received: by ti-out-0910.google.com with SMTP id w7so886268tib.13
	for <linux-dvb@linuxtv.org>; Sat, 30 Aug 2008 22:29:08 -0700 (PDT)
Message-ID: <ede8a03f0808302229o7a490306hcbb57181f3f01394@mail.gmail.com>
Date: Sun, 31 Aug 2008 13:29:08 +0800
From: jackden <jackden@gmail.com>
To: stev391@email.com, linux-dvb@linuxtv.org
In-Reply-To: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080830012407.BCB0247808F@ws1-5.us4.outblaze.com>
Subject: Re: [linux-dvb] Compro VideoMate E650 hybrid PCIe DVB-T and analog
	TV/FM capture card
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

2008/8/30  <stev391@email.com>:
>
--snip--
>>
>> Tom
>
> Tom,
> (Jackden please try first patch and provide feedback, if that doesn't work for your card, then
> try this and provide feedback)
>
> The second dmesg (with debugging) didn't show me what I was looking for, but from past
> experience I will try something else.  I was looking for some dma errors from the cx23885
> driver, these usually occured while streaming is being attempted.
>
> Attached to this email is another patch.  The difference between the first one and the second
> one is that I load an extra module (cx25840), which normally is not required for DVB as it is
> part of the analog side of this card.  This does NOT mean analog will be supported.
>
> As of today the main v4l-dvb can be used with this patch and this means that the cx23885-leadtek
> tree will soon disappear. So step 2 above has been modified to: "Check out the latest v4l-dvb
> source".
>
> Other then that step 4 has a different file name for the patch.
>
> Steps that need to be completed are: 2, 3, 4, 5, 7, 9, 10 & 11. (As you have completed the
> missing steps already).
>
> If the patch works, please do not stop communicating, as I have to perform one more patch to
> prove that cx25840 is required and my assumptions are correct. Once this is completed I will
> send it to Steven Toth for inclusion in his test tree. This will need to be tested by you again,
> and if all is working well after a week or more it will be included into the main tree.
>
> Regards,
> Stephen
>
>
> --
> Nothing says Labor Day like 500hp of American muscle
> Visit OnCars.com today.
>
>

Stephen,
   I tried first patch. dmesg output no error, but scan channels have
some problem.
dmesg:
[   38.839807] Linux video capture interface: v2.00
[   38.875775] cx23885 driver version 0.0.1 loaded
[   38.875840] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC2] ->
GSI 17 (level, low) -> IRQ 20
[   38.875862] CORE cx23885[0]: subsystem: 185b:e800, board: Compro
VideoMate E650 [card=13,autodetected]
[   39.143579] Linux agpgart interface v0.102
[   39.250631] uvcvideo: disagrees about version of symbol v4l_compat_ioctl32
[   39.250636] uvcvideo: Unknown symbol v4l_compat_ioctl32
[   39.250903] uvcvideo: disagrees about version of symbol video_devdata
[   39.250905] uvcvideo: Unknown symbol video_devdata
[   39.251192] uvcvideo: disagrees about version of symbol
video_unregister_device
[   39.251195] uvcvideo: Unknown symbol video_unregister_device
[   39.251283] uvcvideo: disagrees about version of symbol video_device_alloc
[   39.251285] uvcvideo: Unknown symbol video_device_alloc
[   39.251346] uvcvideo: disagrees about version of symbol video_register_device
[   39.251348] uvcvideo: Unknown symbol video_register_device
[   39.251517] uvcvideo: disagrees about version of symbol video_usercopy
[   39.251519] uvcvideo: Unknown symbol video_usercopy
[   39.251544] uvcvideo: disagrees about version of symbol video_device_release
[   39.251546] uvcvideo: Unknown symbol video_device_release
[   39.328432] usbcore: registered new interface driver snd-usb-audio
[   39.448206] fglrx: module license 'Proprietary. (C) 2002 - ATI
Technologies, Starnberg, GERMANY' taints kernel.
[   39.543655] [fglrx]   vendor: 1002 device: 9589 count: 1
[   39.543701] [fglrx] ioport: bar 4, base 0xac00, size: 0x100
[   39.543708] [fglrx] Maximum main memory to use for locked dma
buffers: 2896 MBytes.
[   39.543858] [fglrx] PAT is enabled successfully!
[   39.543883] [fglrx] module loaded - fglrx 8.51.3 [Jul  3 2008] with 1 minors
[   39.859126] input: PC Speaker as /devices/platform/pcspkr/input/input7
[   39.863929] cx23885[0]: i2c bus 0 registered
[   39.864036] cx23885[0]: i2c bus 1 registered
[   39.864839] cx23885[0]: i2c bus 2 registered
[   40.053164] cx23885[0]: cx23885 based dvb card
[   40.286064] xc2028 3-0061: creating new instance
[   40.286068] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[   40.286073] DVB: registering new adapter (cx23885[0])
[   40.286076] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   40.286274] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   40.286281] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 20,
latency: 0, mmio: 0xfdc00000
[   40.286286] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   40.286691] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[   40.286699] ACPI: PCI Interrupt 0000:05:00.1[B] -> Link [APC4] ->
GSI 19 (level, low) -> IRQ 22
[   40.286716] PCI: Setting latency timer of device 0000:05:00.1 to 64
[   42.716115] lp: driver loaded but no devices found
[   42.934521] Adding 1992052k swap on /dev/sda1.  Priority:-1
extents:1 across:1992052k
[   42.935589] Adding 2000084k swap on /dev/sdb1.  Priority:-2
extents:1 across:2000084k
[   43.497918] EXT3 FS on sdb2, internal journal
[   44.325281] kjournald starting.  Commit interval 5 seconds
[   44.331665] EXT3 FS on sda2, internal journal
[   44.331669] EXT3-fs: mounted filesystem with ordered data mode.
[   44.354790] kjournald starting.  Commit interval 5 seconds
[   44.355877] EXT3 FS on sda3, internal journal
[   44.355880] EXT3-fs: mounted filesystem with ordered data mode.
[   45.046411] ip_tables: (C) 2000-2006 Netfilter Core Team
[   45.574577] No dock devices found.
[   46.009935] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+
processors (1 cpu cores) (version 2.20.00)
[   46.009966] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xc
[   46.009968] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xe
[   46.009970] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   48.730549] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[   48.730554] apm: overridden by ACPI.
[   49.078261] ppdev: user-space parallel port driver
[   49.644805] audit(1220149807.092:2): type=1503
operation="inode_permission" requested_mask="a::" denied_mask="a::"
name="/dev/tty" pid=5537 profile="/usr/sbin/cupsd" namespace="default"
[  100.006374] Marking TSC unstable due to: cpufreq changes.
[  100.026755] Time: acpi_pm clocksource has been installed.
[  100.268256] Clocksource tsc unstable (delta = -131156631 ns)
[  100.441186] NET: Registered protocol family 10
[  100.442026] lo: Disabled Privacy Extensions
[  102.339539] eth0: no link during initialization.
[  102.341443] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  104.687212] Bluetooth: Core ver 2.11
[  104.688329] NET: Registered protocol family 31
[  104.688337] Bluetooth: HCI device and connection manager initialized
[  104.688344] Bluetooth: HCI socket layer initialized
[  104.773233] Bluetooth: L2CAP ver 2.9
[  104.773242] Bluetooth: L2CAP socket layer initialized
[  104.873602] Bluetooth: RFCOMM socket layer initialized
[  104.873625] Bluetooth: RFCOMM TTY layer initialized
[  104.873629] Bluetooth: RFCOMM ver 1.8
[  106.832903] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[  106.832921] ACPI: PCI Interrupt 0000:05:00.0[A] -> Link [APC3] ->
GSI 18 (level, low) -> IRQ 23
[   54.155504] [fglrx] Reserved FB block: Shared offset:0, size:1000000
[   54.155510] [fglrx] Reserved FB block: Unshared offset:ff7f000, size:80000
[   74.864318] EXT2-fs warning: mounting unchecked fs, running e2fsck
is recommended

scan:
scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/tw-Taipei > ~/channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/tw-Taipei
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 533000000 2 1 9 1 1 2 0
initial transponder 545000000 2 2 9 1 1 2 0
initial transponder 557000000 2 2 9 1 1 3 0
initial transponder 581000000 2 2 9 1 1 3 0
initial transponder 593000000 2 2 9 1 1 3 0
>>> tune to: 533000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_1_2:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 533000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_1_2:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 545000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 545000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 557000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 557000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 581000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 581000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 593000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 593000000:INVERSION_AUTO:BANDWIDTH_6_MHZ:FEC_2_3:FEC_AUTO:QAM_16:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_4:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

----=Jackden in Google=----
--=Jackden@Gmail.com=--

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
