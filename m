Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47451 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaIQSJK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Sep 2014 14:09:10 -0400
Received: by mail-pd0-f180.google.com with SMTP id ft15so2549461pdb.11
        for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 11:09:04 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 17 Sep 2014 20:09:04 +0200
Message-ID: <CAG_g8w7aooGZ3uOuEHrsgXECGo+ohg9hoB7eQ=-1qWNeqR=zLg@mail.gmail.com>
Subject: Call Trace usb_hcd_irq TeVii DVB-S2 S650
From: crow <crow@linux.org.ba>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
With the kernel 3.16.2-1-ARCH i am unable to watch DVB using my TeVii
DVB-S2 S650 and VDR. After reboot it works for like a 5 minutes and
then i get this Call Trace. I tried to get most information and also
did tested with adding the irqpool to kernel boot option (second Call
Trace) but it did not help that much.

without irqpool:
[ 1974.492218] irq 23: nobody cared (try booting with the "irqpoll" option)
[ 1974.492234] CPU: 0 PID: 465 Comm: kdvb-ad-0-fe-0 Tainted: P
  O  3.16.2-1-ARCH #1
[ 1974.492239] Hardware name: Point of View ION-MB330-1/ION-MB330-1,
BIOS 080015  07/29/2009
[ 1974.492244]  0000000000000000 0000000017e85ee0 ffff88005fc03d28
ffffffff8152afec
[ 1974.492253]  ffff88005ca49600 ffff88005fc03d50 ffffffff810d0292
ffff88005ca49600
[ 1974.492260]  0000000000000000 0000000000000017 ffff88005fc03d88
ffffffff810d0647
[ 1974.492268] Call Trace:
[ 1974.492273]  <IRQ>  [<ffffffff8152afec>] dump_stack+0x4d/0x6f
[ 1974.492296]  [<ffffffff810d0292>] __report_bad_irq+0x32/0xd0
[ 1974.492304]  [<ffffffff810d0647>] note_interrupt+0x257/0x2a0
[ 1974.492313]  [<ffffffff810cdb9e>] handle_irq_event_percpu+0xae/0x1f0
[ 1974.492320]  [<ffffffff810cdd1d>] handle_irq_event+0x3d/0x60
[ 1974.492328]  [<ffffffff810d1271>] handle_fasteoi_irq+0x81/0x170
[ 1974.492338]  [<ffffffff8101717e>] handle_irq+0x1e/0x40
[ 1974.492345]  [<ffffffff8153382d>] do_IRQ+0x4d/0xe0
[ 1974.492354]  [<ffffffff815317ed>] common_interrupt+0x6d/0x6d
[ 1974.492592]  [<ffffffffa089bf40>] ? _nv013453rm+0x30/0x30 [nvidia]
[ 1974.492604]  [<ffffffff8107365b>] ? __do_softirq+0x8b/0x2e0
[ 1974.492612]  [<ffffffff81073a06>] irq_exit+0x86/0xb0
[ 1974.492619]  [<ffffffff81533836>] do_IRQ+0x56/0xe0
[ 1974.492627]  [<ffffffff815317ed>] common_interrupt+0x6d/0x6d
[ 1974.492630]  <EOI>  [<ffffffffa0355495>] ? dw210x_op_rw+0x115/0x170
[dvb_usb_dw2102]
[ 1974.492649]  [<ffffffff8101e296>] ? native_read_tsc+0x6/0x20
[ 1974.492658]  [<ffffffff812ad703>] delay_tsc+0x43/0xc0
[ 1974.492665]  [<ffffffff812ad5ff>] __delay+0xf/0x20
[ 1974.492672]  [<ffffffff812ad63e>] __const_udelay+0x2e/0x30
[ 1974.492680]  [<ffffffffa03570da>] dw2104_i2c_transfer+0x25a/0x408
[dvb_usb_dw2102]
[ 1974.492688]  [<ffffffff8101e8d5>] ? native_sched_clock+0x35/0xb0
[ 1974.492697]  [<ffffffff810ae74d>] ? enqueue_task_fair+0x10d/0x5b0
[ 1974.492705]  [<ffffffff810a6234>] ? sched_clock_cpu+0x54/0xe0
[ 1974.492728]  [<ffffffffa0161c7d>] __i2c_transfer+0x6d/0x270 [i2c_core]
[ 1974.492740]  [<ffffffffa0162836>] i2c_transfer+0x56/0xc0 [i2c_core]
[ 1974.492749]  [<ffffffffa03850df>] cx24116_readreg+0x8f/0x100 [cx24116]
[ 1974.492757]  [<ffffffffa0385280>] cx24116_read_status+0x20/0x80 [cx24116]
[ 1974.492765]  [<ffffffffa0387058>] cx24116_tune+0x38/0xfe0 [cx24116]
[ 1974.492777]  [<ffffffffa02f98bf>] dvb_frontend_thread+0x4cf/0x750 [dvb_core]
[ 1974.492785]  [<ffffffff810b6b30>] ? __wake_up_sync+0x20/0x20
[ 1974.492796]  [<ffffffffa02f93f0>] ?
dvb_frontend_should_wakeup.isra.2+0x80/0x80 [dvb_core]
[ 1974.492804]  [<ffffffff81091cea>] kthread+0xea/0x100
[ 1974.492813]  [<ffffffff811c0000>] ? vfs_truncate+0x130/0x1a0
[ 1974.492821]  [<ffffffff81091c00>] ? kthread_create_on_node+0x1b0/0x1b0
[ 1974.492829]  [<ffffffff81530cbc>] ret_from_fork+0x7c/0xb0
[ 1974.492836]  [<ffffffff81091c00>] ? kthread_create_on_node+0x1b0/0x1b0
[ 1974.492842] handlers:
[ 1974.492867] [<ffffffffa002db60>] usb_hcd_irq [usbcore]
[ 1974.492872] Disabling IRQ #23


with irqpool in kernel boot option:
[  553.046862] irq 23: nobody cared (try booting with the "irqpoll" option)
[  553.046881] CPU: 0 PID: 547 Comm: receiver on dev Tainted: P
   O  3.16.2-1-ARCH #1
[  553.046887] Hardware name: Point of View ION-MB330-1/ION-MB330-1,
BIOS 080015  07/29/2009
[  553.046893]  0000000000000000 000000001aab2dd1 ffff88005fc03e60
ffffffff8152afec
[  553.046902]  ffff88005ca49600 ffff88005fc03e88 ffffffff810d0292
ffff88005ca49600
[  553.046909]  0000000000000000 0000000000000017 ffff88005fc03ec0
ffffffff810d0647
[  553.046917] Call Trace:
[  553.046923]  <IRQ>  [<ffffffff8152afec>] dump_stack+0x4d/0x6f
[  553.046951]  [<ffffffff810d0292>] __report_bad_irq+0x32/0xd0
[  553.046960]  [<ffffffff810d0647>] note_interrupt+0x257/0x2a0
[  553.046968]  [<ffffffff810cdb9e>] handle_irq_event_percpu+0xae/0x1f0
[  553.046976]  [<ffffffff810cdd1d>] handle_irq_event+0x3d/0x60
[  553.046984]  [<ffffffff810d1271>] handle_fasteoi_irq+0x81/0x170
[  553.046996]  [<ffffffff8101717e>] handle_irq+0x1e/0x40
[  553.047004]  [<ffffffff8153382d>] do_IRQ+0x4d/0xe0
[  553.047013]  [<ffffffff815317ed>] common_interrupt+0x6d/0x6d
[  553.047016]  <EOI>  [<ffffffff81530d69>] ? system_call_fastpath+0x16/0x1b
[  553.047026] handlers:
[  553.047080] [<ffffffffa002db60>] usb_hcd_irq [usbcore]
[  553.047085] Disabling IRQ #23

$ sudo lspci -v | grep IRQ

        Flags: 66MHz, fast devsel, IRQ 10
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 40
        Flags: bus master, fast devsel, latency 0, IRQ 42
        Flags: bus master, fast devsel, latency 0, IRQ 41
$


00:04.0 USB controller: NVIDIA Corporation MCP79 OHCI USB 1.1
Controller (rev b1) (prog-if 10 [OHCI])
        Subsystem: NVIDIA Corporation Apple iMac 9,1
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
        Memory at fae7f000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

$ lspci|grep USB
00:04.0 USB controller: NVIDIA Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:04.1 USB controller: NVIDIA Corporation MCP79 EHCI USB 2.0
Controller (rev b1)
00:06.0 USB controller: NVIDIA Corporation MCP79 OHCI USB 1.1
Controller (rev b1)
00:06.1 USB controller: NVIDIA Corporation MCP79 EHCI USB 2.0
Controller (rev b1)
$

00:04.0 USB controller: NVIDIA Corporation MCP79 OHCI USB 1.1
Controller (rev b1) (prog-if 10 [OHCI])
        Subsystem: NVIDIA Corporation Apple iMac 9,1
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
        Memory at fae7f000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
        Kernel driver in use: ohci-pci
        Kernel modules: ohci_pci

[    6.080219] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[    6.080504] DVB: registering new adapter (TeVii S650 USB2.0)
[    6.273309] dvb-usb: MAC address: 00:18:bd:5b:ab:4d
[    6.308060] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[    6.308093] snd_hda_intel 0000:00:08.0: Disabling MSI
[    6.390816] dw2102: Attached cx24116!

[    6.390838] usb 2-3: DVB: registering adapter 0 frontend 0
(Conexant CX24116/CX24118)...
[    6.670291] Registered IR keymap rc-tevii-nec
[    6.670780] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-3/rc/rc1/input9
[    6.671942] rc1: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:06.1/usb2/2-3/rc/rc1
[    6.671958] dvb-usb: schedule remote query interval to 150 msecs.
[    6.671975] dvb-usb: TeVii S650 USB2.0 successfully initialized and
connected.
[    6.672138] usbcore: registered new interface driver dw2102
[    7.410907] nvidia: module license 'NVIDIA' taints kernel.
[    7.410926] Disabling lock debugging due to kernel taint
[    7.475519] ACPI: PCI Interrupt Link [LPMU] enabled at IRQ 20
[    7.476205] ACPI: PCI Interrupt Link [SGRU] enabled at IRQ 23

lsusb:

Bus 002 Device 003: ID 9022:d650 TeVii Technology Ltd. DVB-S2 S65
Bus 002 Device 003: ID 9022:d650 TeVii Technology Ltd. DVB-S2 S650
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x9022 TeVii Technology Ltd.
  idProduct          0xd650 DVB-S2 S650
  bcdDevice            0.00
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0002  1x 2 bytes
        bInterval               0


$ uname -a
Linux vdrvdpau 3.16.2-1-ARCH #1 SMP PREEMPT Sat Sep 6 13:12:51 CEST
2014 x86_64 GNU/Linux
$ cat /proc/interrupts |more
           CPU0       CPU1       CPU2       CPU3
  0:         56          0          0          0   IO-APIC-edge      timer
  1:          3          0          0          0   IO-APIC-edge      i8042
  7:          1          0          0          0   IO-APIC-edge
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:          4          0          0          0   IO-APIC-edge      i8042
 20:     464238          0          0          0   IO-APIC-fasteoi
ehci_hcd:usb2
 21:        456          0          0          0   IO-APIC-fasteoi
ohci_hcd:usb4, snd_hda_intel
 22:          2          0          0          0   IO-APIC-fasteoi
ehci_hcd:usb1
 23:      15703          0          0          0   IO-APIC-fasteoi
ohci_hcd:usb3
 40:       8049          0          0          0   PCI-MSI-edge      ahci
 41:        395          0          0          0   PCI-MSI-edge      enp4s0
 42:      15448          0          0          0   PCI-MSI-edge      nvidia
NMI:         30          9         17         10   Non-maskable interrupts
LOC:      62402      26981      17443      27463   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:         30          9         17         10   Performance
monitoring interrupts
IWI:          0          0          1          0   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:        960        999        473        512   Rescheduling interrupts
CAL:        635       2125        552       2398   Function call interrupts
TLB:        428        530        495        475   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          2          2          2          2   Machine check polls
THR:          0          0          0          0   Hypervisor callback
interrupts
ERR:          1
MIS:          0
$ journalctl -p 3
Sep 17 10:35:08 vdrvdpau dhcpcd[322]: if_addaddress6: Operation not supported
Sep 17 10:35:25 vdrvdpau vdr[507]: [507] ERROR: attempt to open OSD
while it is already open - using dummy OSD!
Sep 17 10:35:26 vdrvdpau vdr[507]: [507] ERROR: attempt to open OSD
while it is already open - using dummy OSD!
Sep 17 11:08:05 vdrvdpau kernel: irq 23: nobody cared (try booting
with the "irqpoll" option)
Sep 17 11:08:06 vdrvdpau kernel: handlers:
Sep 17 11:08:06 vdrvdpau kernel: [<ffffffffa002db60>] usb_hcd_irq [usbcore]
Sep 17 11:08:06 vdrvdpau kernel: Disabling IRQ #23
Sep 17 14:43:10 vdrvdpau vdr[507]: [1040] ERROR: lircd connection
broken, trying to reconnect every 3.0 seconds
Sep 17 14:43:10 vdrvdpau vdr[507]: video: fatal i/o error
-- Reboot --
Sep 17 14:43:44 vdrvdpau dhcpcd[326]: if_addaddress6: Operation not supported
Sep 17 14:43:59 vdrvdpau vdr[401]: [401] ERROR: attempt to open OSD
while it is already open - using dummy OSD!
Sep 17 14:43:59 vdrvdpau vdr[401]: [401] ERROR: attempt to open OSD
while it is already open - using dummy OSD!

Regards,
