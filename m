Return-path: <linux-media-owner@vger.kernel.org>
Received: from ptaff.ca ([192.95.41.205]:53683 "EHLO ptaff.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693AbbEOPMY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 11:12:24 -0400
Received: from nestor.ptaff.ca (modemcable096.167-59-74.mc.videotron.ca [74.59.167.96])
	by ptaff.ca (Postfix) with ESMTPSA id 5CA5214BA001
	for <linux-media@vger.kernel.org>; Fri, 15 May 2015 11:12:23 -0400 (EDT)
Date: Fri, 15 May 2015 11:12:18 -0400
From: Patrice Levesque <video4linux.wayne@ptaff.ca>
To: linux-media@vger.kernel.org
Subject: Re: ATI TV Wonder regression since at least 3.19.6
Message-ID: <20150515151218.GA5466@ptaff.ca>
Reply-To: Patrice Levesque <video4linux.wayne@ptaff.ca>
References: <20150511161203.GG3206@ptaff.ca>
 <55519647.5010007@xs4all.nl>
 <20150514125607.GA3303@ptaff.ca>
 <5554C7BB.3070300@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
In-Reply-To: <5554C7BB.3070300@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--DBIVS5p969aUjpLe
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Hans,


>> Function isn't used; when compiling I get:
> That makes no sense. This function is most definitely used.

Idiot guy here did not follow simple instructions and didn't patch the
right kernel source.  He just did, and function is used.


> Did you start a capturing video first before running dmesg? I want to
> see if capturing video will generate messages in dmesg.

Sending you again my (truncated) dmesg, but here's the annotated salient bi=
t:

Starting video capture first time:
[Fri May 15 11:01:43 2015] restart_video_queue
[Fri May 15 11:01:44 2015] restart_video_queue
[Fri May 15 11:01:55 2015] restart_video_queue
[Fri May 15 11:01:56 2015] restart_video_queue
[Fri May 15 11:01:56 2015] restart_video_queue
[Fri May 15 11:02:00 2015] restart_video_queue
[Fri May 15 11:02:05 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:09 2015] restart_video_queue
Stopping video capture:
[Fri May 15 11:03:26 2015] restart_video_queue
Re-Starting video capture:
[Fri May 15 11:03:40 2015] restart_video_queue
Stopping video capture:
[Fri May 15 11:04:18 2015] restart_video_queue

Changing channels didn't provoke restart_video_queue events.



--=20
=C2=B7 Patrice Levesque
=C2=B7 http://ptaff.ca/
=C2=B7 video4linux.wayne@ptaff.ca
--


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ati_tv_wonder_pro_dmesg.txt"
Content-Transfer-Encoding: quoted-printable

[Fri May 15 10:58:18 2015] bus: 'platform': add device pata_legacy.1
[Fri May 15 10:58:18 2015] device: 'ata8': device_add
[Fri May 15 10:58:18 2015] device: 'ata8': device_add
[Fri May 15 10:58:18 2015] device: 'link8': device_add
[Fri May 15 10:58:18 2015] device: 'link8': device_add
[Fri May 15 10:58:18 2015] device: 'dev8.0': device_add
[Fri May 15 10:58:18 2015] device: 'dev8.0': device_add
[Fri May 15 10:58:18 2015] device: 'dev8.1': device_add
[Fri May 15 10:58:18 2015] device: 'dev8.1': device_add
[Fri May 15 10:58:18 2015] scsi host7: pata_legacy
[Fri May 15 10:58:18 2015] device: 'host7': device_add
[Fri May 15 10:58:18 2015] bus: 'scsi': add device host7
[Fri May 15 10:58:18 2015] device: 'host7': device_add
[Fri May 15 10:58:18 2015] ata8: PATA max PIO4 cmd 0x170 ctl 0x376 irq 15
[Fri May 15 10:58:18 2015] device: 'host7': device_unregister
[Fri May 15 10:58:18 2015] bus: 'scsi': remove device host7
[Fri May 15 10:58:18 2015] bus: 'platform': remove device pata_legacy.1
[Fri May 15 10:58:18 2015] bus: 'pci': add driver r8169
[Fri May 15 10:58:18 2015] bus: 'pci': driver_probe_device: matched device =
0000:03:00.0 with driver r8169
[Fri May 15 10:58:18 2015] bus: 'pci': really_probe: probing driver r8169 w=
ith device 0000:03:00.0
[Fri May 15 10:58:18 2015] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[Fri May 15 10:58:18 2015] r8169 0000:03:00.0: can't disable ASPM; OS doesn=
't have ASPM control
[Fri May 15 10:58:18 2015] device: 'eth0': device_add
[Fri May 15 10:58:18 2015] r8169 0000:03:00.0 eth0: RTL8168f/8111f at 0xf38=
22000, 74:d0:2b:36:44:fe, XID 08000800 IRQ 16
[Fri May 15 10:58:18 2015] r8169 0000:03:00.0 eth0: jumbo features [frames:=
 9200 bytes, tx checksumming: ko]
[Fri May 15 10:58:18 2015] driver: 'r8169': driver_bound: bound to device '=
0000:03:00.0'
[Fri May 15 10:58:18 2015] bus: 'pci': really_probe: bound device 0000:03:0=
0.0 to driver r8169
[Fri May 15 10:58:18 2015] bus: 'pnp': add driver i8042 kbd
[Fri May 15 10:58:18 2015] bus: 'pnp': driver_probe_device: matched device =
00:06 with driver i8042 kbd
[Fri May 15 10:58:18 2015] bus: 'pnp': really_probe: probing driver i8042 k=
bd with device 00:06
[Fri May 15 10:58:18 2015] driver: 'i8042 kbd': driver_bound: bound to devi=
ce '00:06'
[Fri May 15 10:58:18 2015] bus: 'pnp': really_probe: bound device 00:06 to =
driver i8042 kbd
[Fri May 15 10:58:18 2015] bus: 'pnp': add driver i8042 aux
[Fri May 15 10:58:18 2015] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x=
60,0x64 irq 1
[Fri May 15 10:58:18 2015] i8042: PNP: PS/2 appears to have AUX port disabl=
ed, if this is incorrect please boot with i8042.nopnp
[Fri May 15 10:58:18 2015] Registering platform device 'i8042'. Parent at p=
latform
[Fri May 15 10:58:18 2015] device: 'i8042': device_add
[Fri May 15 10:58:18 2015] bus: 'platform': add device i8042
[Fri May 15 10:58:18 2015] bus: 'platform': add driver i8042
[Fri May 15 10:58:18 2015] bus: 'platform': driver_probe_device: matched de=
vice i8042 with driver i8042
[Fri May 15 10:58:18 2015] bus: 'platform': really_probe: probing driver i8=
042 with device i8042
[Fri May 15 10:58:18 2015] serio: i8042 KBD port at 0x60,0x64 irq 1
[Fri May 15 10:58:18 2015] device: 'serio0': device_add
[Fri May 15 10:58:18 2015] bus: 'serio': add device serio0
[Fri May 15 10:58:18 2015] driver: 'i8042': driver_bound: bound to device '=
i8042'
[Fri May 15 10:58:18 2015] bus: 'platform': really_probe: bound device i804=
2 to driver i8042
[Fri May 15 10:58:18 2015] device: 'mice': device_add
[Fri May 15 10:58:18 2015] device: 'psaux': device_add
[Fri May 15 10:58:18 2015] mousedev: PS/2 mouse device common for all mice
[Fri May 15 10:58:18 2015] device: 'event0': device_add
[Fri May 15 10:58:18 2015] device: 'event1': device_add
[Fri May 15 10:58:18 2015] device: 'event2': device_add
[Fri May 15 10:58:18 2015] bus: 'serio': add driver atkbd
[Fri May 15 10:58:18 2015] bus: 'serio': driver_probe_device: matched devic=
e serio0 with driver atkbd
[Fri May 15 10:58:18 2015] bus: 'serio': really_probe: probing driver atkbd=
 with device serio0
[Fri May 15 10:58:18 2015] bus: 'i2c': add driver ir-kbd-i2c
[Fri May 15 10:58:18 2015] device class 'lirc': registering
[Fri May 15 10:58:18 2015] lirc_dev: IR Remote Control driver registered, m=
ajor 252=20
[Fri May 15 10:58:18 2015] IR NEC protocol handler initialized
[Fri May 15 10:58:18 2015] IR RC5(x/sz) protocol handler initialized
[Fri May 15 10:58:18 2015] IR RC6 protocol handler initialized
[Fri May 15 10:58:18 2015] IR JVC protocol handler initialized
[Fri May 15 10:58:18 2015] IR Sony protocol handler initialized
[Fri May 15 10:58:18 2015] IR Sharp protocol handler initialized
[Fri May 15 10:58:18 2015] IR LIRC bridge handler initialized
[Fri May 15 10:58:18 2015] IR XMP protocol handler initialized
[Fri May 15 10:58:18 2015] bus: 'hid': registered
[Fri May 15 10:58:18 2015] device class 'hidraw': registering
[Fri May 15 10:58:18 2015] hidraw: raw HID events driver (C) Jiri Kosina
[Fri May 15 10:58:18 2015] bus: 'hid': add driver hid-generic
[Fri May 15 10:58:18 2015] bus: 'hid': add driver a4tech
[Fri May 15 10:58:18 2015] bus: 'hid': add driver apple
[Fri May 15 10:58:18 2015] bus: 'hid': add driver belkin
[Fri May 15 10:58:18 2015] bus: 'hid': add driver cherry
[Fri May 15 10:58:18 2015] bus: 'hid': add driver chicony
[Fri May 15 10:58:18 2015] bus: 'hid': add driver cypress
[Fri May 15 10:58:18 2015] bus: 'hid': add driver ezkey
[Fri May 15 10:58:18 2015] bus: 'hid': add driver kensington
[Fri May 15 10:58:18 2015] bus: 'hid': add driver logitech
[Fri May 15 10:58:18 2015] bus: 'hid': add driver microsoft
[Fri May 15 10:58:18 2015] bus: 'hid': add driver monterey
[Fri May 15 10:58:18 2015] TCP: cubic registered
[Fri May 15 10:58:18 2015] NET: Registered protocol family 10
[Fri May 15 10:58:18 2015] NET: Registered protocol family 17
[Fri May 15 10:58:18 2015] NET: Registered protocol family 15
[Fri May 15 10:58:18 2015] Key type dns_resolver registered
[Fri May 15 10:58:18 2015] bus: 'machinecheck': registered
[Fri May 15 10:58:18 2015] device: 'machinecheck': device_add
[Fri May 15 10:58:18 2015] device: 'machinecheck0': device_add
[Fri May 15 10:58:18 2015] bus: 'machinecheck': add device machinecheck0
[Fri May 15 10:58:18 2015] device: 'machinecheck1': device_add
[Fri May 15 10:58:18 2015] bus: 'machinecheck': add device machinecheck1
[Fri May 15 10:58:18 2015] device: 'machinecheck2': device_add
[Fri May 15 10:58:18 2015] bus: 'machinecheck': add device machinecheck2
[Fri May 15 10:58:18 2015] device: 'machinecheck3': device_add
[Fri May 15 10:58:18 2015] bus: 'machinecheck': add device machinecheck3
[Fri May 15 10:58:18 2015] device: 'mcelog': device_add
[Fri May 15 10:58:18 2015] Using IPI Shortcut mode
[Fri May 15 10:58:18 2015] device: 'cpu_dma_latency': device_add
[Fri May 15 10:58:18 2015] device: 'network_latency': device_add
[Fri May 15 10:58:18 2015] device: 'network_throughput': device_add
[Fri May 15 10:58:18 2015] device: 'memory_bandwidth': device_add
[Fri May 15 10:58:18 2015] registered taskstats version 1
[Fri May 15 10:58:18 2015] device: 'btrfs-control': device_add
[Fri May 15 10:58:18 2015] Btrfs loaded
[Fri May 15 10:58:18 2015] drivers/rtc/hctosys.c: unable to open rtc device=
 (rtc0)
[Fri May 15 10:58:18 2015] ALSA device list:
[Fri May 15 10:58:18 2015]   No soundcards found.
[Fri May 15 10:58:18 2015] device: 'input3': device_add
[Fri May 15 10:58:18 2015] input: AT Translated Set 2 keyboard as /devices/=
platform/i8042/serio0/input/input3
[Fri May 15 10:58:18 2015] device: 'event3': device_add
[Fri May 15 10:58:18 2015] driver: 'atkbd': driver_bound: bound to device '=
serio0'
[Fri May 15 10:58:18 2015] bus: 'serio': really_probe: bound device serio0 =
to driver atkbd
[Fri May 15 10:58:18 2015] REISERFS (device sdb3): found reiserfs format "3=
=2E6" with standard journal
[Fri May 15 10:58:18 2015] REISERFS (device sdb3): using ordered data mode
[Fri May 15 10:58:18 2015] reiserfs: using flush barriers
[Fri May 15 10:58:18 2015] REISERFS (device sdb3): journal params: device s=
db3, size 8192, journal first block 18, max trans len 1024, max batch 900, =
max commit age 30, max trans age 30
[Fri May 15 10:58:18 2015] REISERFS (device sdb3): checking transaction log=
 (sdb3)
[Fri May 15 10:58:18 2015] REISERFS (device sdb3): Using r5 hash to sort na=
mes
[Fri May 15 10:58:18 2015] VFS: Mounted root (reiserfs filesystem) readonly=
 on device 8:19.
[Fri May 15 10:58:18 2015] devtmpfs: mounted
[Fri May 15 10:58:18 2015] Freeing unused kernel memory: 424K (c1885000 - c=
18ef000)
[Fri May 15 10:58:18 2015] Write protecting the kernel text: 6092k
[Fri May 15 10:58:18 2015] Write protecting the kernel read-only data: 2276k
[Fri May 15 10:58:18 2015] NX-protecting the kernel data: 4148k
[Fri May 15 10:58:19 2015] random: nonblocking pool is initialized
[Fri May 15 10:58:26 2015] systemd-udevd[310]: starting version 216
[Fri May 15 10:58:27 2015] bus: 'pnp': add driver rtc_cmos
[Fri May 15 10:58:27 2015] bus: 'pnp': driver_probe_device: matched device =
00:02 with driver rtc_cmos
[Fri May 15 10:58:27 2015] bus: 'pnp': really_probe: probing driver rtc_cmo=
s with device 00:02
[Fri May 15 10:58:27 2015] rtc_cmos 00:02: RTC can wake from S4
[Fri May 15 10:58:27 2015] device: 'rtc0': device_add
[Fri May 15 10:58:27 2015] rtc_cmos 00:02: rtc core: registered rtc_cmos as=
 rtc0
[Fri May 15 10:58:27 2015] rtc_cmos 00:02: alarms up to one month, y3k, 242=
 bytes nvram, hpet irqs
[Fri May 15 10:58:27 2015] driver: 'rtc_cmos': driver_bound: bound to devic=
e '00:02'
[Fri May 15 10:58:27 2015] bus: 'pnp': really_probe: bound device 00:02 to =
driver rtc_cmos
[Fri May 15 10:58:27 2015] device: 'timer': device_add
[Fri May 15 10:58:27 2015] bus: 'pci': add driver i801_smbus
[Fri May 15 10:58:27 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1f.3 with driver i801_smbus
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: probing driver i801_sm=
bus with device 0000:00:1f.3
[Fri May 15 10:58:27 2015] ACPI Warning: SystemIO range 0x0000f040-0x0000f0=
5f conflicts with OpRegion 0x0000f040-0x0000f04f (\_SB_.PCI0.SBUS.SMBI) (20=
140926/utaddress-258)
[Fri May 15 10:58:27 2015] ACPI: If an ACPI driver is available for this de=
vice, you should use it instead of the native driver
[Fri May 15 10:58:27 2015] i801_smbus: probe of 0000:00:1f.3 rejects match =
-19
[Fri May 15 10:58:27 2015] r8169 0000:03:00.0 enp3s0: renamed from eth0
[Fri May 15 10:58:27 2015] net eth0: renaming to enp3s0
[Fri May 15 10:58:27 2015] systemd-udevd[331]: renamed network interface et=
h0 to enp3s0
[Fri May 15 10:58:27 2015] ACPI: bus type USB registered
[Fri May 15 10:58:27 2015] bus: 'usb': registered
[Fri May 15 10:58:27 2015] bus: 'usb': add driver usbfs
[Fri May 15 10:58:27 2015] usbcore: registered new interface driver usbfs
[Fri May 15 10:58:27 2015] bus: 'usb': add driver hub
[Fri May 15 10:58:27 2015] usbcore: registered new interface driver hub
[Fri May 15 10:58:27 2015] bus: 'usb': add driver usb
[Fri May 15 10:58:27 2015] usbcore: registered new device driver usb
[Fri May 15 10:58:27 2015] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EH=
CI) Driver
[Fri May 15 10:58:27 2015] ehci-pci: EHCI PCI platform driver
[Fri May 15 10:58:27 2015] bus: 'pci': add driver ehci-pci
[Fri May 15 10:58:27 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1a.0 with driver ehci-pci
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: probing driver ehci-pc=
i with device 0000:00:1a.0
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: EHCI Host Controller
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: new USB bus registered, a=
ssigned bus number 1
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: debug port 2
[Fri May 15 10:58:27 2015] bus: 'pci': add driver xhci_hcd
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: cache line size of 64 is =
not supported
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf7818000
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[Fri May 15 10:58:27 2015] usb usb1: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Fri May 15 10:58:27 2015] usb usb1: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Fri May 15 10:58:27 2015] usb usb1: Product: EHCI Host Controller
[Fri May 15 10:58:27 2015] usb usb1: Manufacturer: Linux 3.18.6-gentoo ehci=
_hcd
[Fri May 15 10:58:27 2015] usb usb1: SerialNumber: 0000:00:1a.0
[Fri May 15 10:58:27 2015] device: 'usb1': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device usb1
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
usb1 with driver usb
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb1
[Fri May 15 10:58:27 2015] device: '1-0:1.0': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device 1-0:1.0
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
1-0:1.0 with driver hub
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 1-0:1.0
[Fri May 15 10:58:27 2015] hub 1-0:1.0: USB hub found
[Fri May 15 10:58:27 2015] hub 1-0:1.0: 2 ports detected
[Fri May 15 10:58:27 2015] device: 'usb1-port1': device_add
[Fri May 15 10:58:27 2015] device: 'usb1-port2': device_add
[Fri May 15 10:58:27 2015] driver: 'hub': driver_bound: bound to device '1-=
0:1.0'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device 1-0:1.0 t=
o driver hub
[Fri May 15 10:58:27 2015] device: 'ep_81': device_add
[Fri May 15 10:58:27 2015] driver: 'usb': driver_bound: bound to device 'us=
b1'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device usb1 to d=
river usb
[Fri May 15 10:58:27 2015] device: 'ep_00': device_add
[Fri May 15 10:58:27 2015] driver: 'ehci-pci': driver_bound: bound to devic=
e '0000:00:1a.0'
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: bound device 0000:00:1=
a.0 to driver ehci-pci
[Fri May 15 10:58:27 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1d.0 with driver ehci-pci
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: probing driver ehci-pc=
i with device 0000:00:1d.0
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: EHCI Host Controller
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: new USB bus registered, a=
ssigned bus number 2
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: debug port 2
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: cache line size of 64 is =
not supported
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7817000
[Fri May 15 10:58:27 2015] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[Fri May 15 10:58:27 2015] usb usb2: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Fri May 15 10:58:27 2015] usb usb2: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Fri May 15 10:58:27 2015] usb usb2: Product: EHCI Host Controller
[Fri May 15 10:58:27 2015] usb usb2: Manufacturer: Linux 3.18.6-gentoo ehci=
_hcd
[Fri May 15 10:58:27 2015] usb usb2: SerialNumber: 0000:00:1d.0
[Fri May 15 10:58:27 2015] device: 'usb2': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device usb2
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
usb2 with driver usb
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb2
[Fri May 15 10:58:27 2015] device: '2-0:1.0': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device 2-0:1.0
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
2-0:1.0 with driver hub
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 2-0:1.0
[Fri May 15 10:58:27 2015] hub 2-0:1.0: USB hub found
[Fri May 15 10:58:27 2015] hub 2-0:1.0: 2 ports detected
[Fri May 15 10:58:27 2015] device: 'usb2-port1': device_add
[Fri May 15 10:58:27 2015] device: 'usb2-port2': device_add
[Fri May 15 10:58:27 2015] driver: 'hub': driver_bound: bound to device '2-=
0:1.0'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device 2-0:1.0 t=
o driver hub
[Fri May 15 10:58:27 2015] device: 'ep_81': device_add
[Fri May 15 10:58:27 2015] driver: 'usb': driver_bound: bound to device 'us=
b2'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device usb2 to d=
river usb
[Fri May 15 10:58:27 2015] device: 'ep_00': device_add
[Fri May 15 10:58:27 2015] driver: 'ehci-pci': driver_bound: bound to devic=
e '0000:00:1d.0'
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: bound device 0000:00:1=
d.0 to driver ehci-pci
[Fri May 15 10:58:27 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:14.0 with driver xhci_hcd
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: probing driver xhci_hc=
d with device 0000:00:14.0
[Fri May 15 10:58:27 2015] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Fri May 15 10:58:27 2015] xhci_hcd 0000:00:14.0: new USB bus registered, a=
ssigned bus number 3
[Fri May 15 10:58:27 2015] xhci_hcd 0000:00:14.0: cache line size of 64 is =
not supported
[Fri May 15 10:58:27 2015] usb usb3: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Fri May 15 10:58:27 2015] usb usb3: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Fri May 15 10:58:27 2015] usb usb3: Product: xHCI Host Controller
[Fri May 15 10:58:27 2015] usb usb3: Manufacturer: Linux 3.18.6-gentoo xhci=
-hcd
[Fri May 15 10:58:27 2015] usb usb3: SerialNumber: 0000:00:14.0
[Fri May 15 10:58:27 2015] device: 'usb3': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device usb3
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
usb3 with driver usb
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb3
[Fri May 15 10:58:27 2015] device: '3-0:1.0': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device 3-0:1.0
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
3-0:1.0 with driver hub
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 3-0:1.0
[Fri May 15 10:58:27 2015] hub 3-0:1.0: USB hub found
[Fri May 15 10:58:27 2015] hub 3-0:1.0: 4 ports detected
[Fri May 15 10:58:27 2015] device: 'usb3-port1': device_add
[Fri May 15 10:58:27 2015] device: 'usb3-port2': device_add
[Fri May 15 10:58:27 2015] device: 'usb3-port3': device_add
[Fri May 15 10:58:27 2015] device: 'usb3-port4': device_add
[Fri May 15 10:58:27 2015] driver: 'hub': driver_bound: bound to device '3-=
0:1.0'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device 3-0:1.0 t=
o driver hub
[Fri May 15 10:58:27 2015] device: 'ep_81': device_add
[Fri May 15 10:58:27 2015] driver: 'usb': driver_bound: bound to device 'us=
b3'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device usb3 to d=
river usb
[Fri May 15 10:58:27 2015] device: 'ep_00': device_add
[Fri May 15 10:58:27 2015] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Fri May 15 10:58:27 2015] xhci_hcd 0000:00:14.0: new USB bus registered, a=
ssigned bus number 4
[Fri May 15 10:58:27 2015] usb usb4: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0003
[Fri May 15 10:58:27 2015] usb usb4: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Fri May 15 10:58:27 2015] usb usb4: Product: xHCI Host Controller
[Fri May 15 10:58:27 2015] usb usb4: Manufacturer: Linux 3.18.6-gentoo xhci=
-hcd
[Fri May 15 10:58:27 2015] usb usb4: SerialNumber: 0000:00:14.0
[Fri May 15 10:58:27 2015] device: 'usb4': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device usb4
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
usb4 with driver usb
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb4
[Fri May 15 10:58:27 2015] device: '4-0:1.0': device_add
[Fri May 15 10:58:27 2015] bus: 'usb': add device 4-0:1.0
[Fri May 15 10:58:27 2015] bus: 'usb': driver_probe_device: matched device =
4-0:1.0 with driver hub
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 4-0:1.0
[Fri May 15 10:58:27 2015] hub 4-0:1.0: USB hub found
[Fri May 15 10:58:27 2015] hub 4-0:1.0: 4 ports detected
[Fri May 15 10:58:27 2015] device: 'usb4-port1': device_add
[Fri May 15 10:58:27 2015] device: 'usb4-port2': device_add
[Fri May 15 10:58:27 2015] device: 'usb4-port3': device_add
[Fri May 15 10:58:27 2015] device: 'usb4-port4': device_add
[Fri May 15 10:58:27 2015] driver: 'hub': driver_bound: bound to device '4-=
0:1.0'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device 4-0:1.0 t=
o driver hub
[Fri May 15 10:58:27 2015] device: 'ep_81': device_add
[Fri May 15 10:58:27 2015] driver: 'usb': driver_bound: bound to device 'us=
b4'
[Fri May 15 10:58:27 2015] bus: 'usb': really_probe: bound device usb4 to d=
river usb
[Fri May 15 10:58:27 2015] device: 'ep_00': device_add
[Fri May 15 10:58:27 2015] driver: 'xhci_hcd': driver_bound: bound to devic=
e '0000:00:14.0'
[Fri May 15 10:58:27 2015] bus: 'pci': really_probe: bound device 0000:00:1=
4.0 to driver xhci_hcd
[Fri May 15 10:58:27 2015] bus: 'ac97': registered
[Fri May 15 10:58:28 2015] bus: 'pci': add driver snd_emu10k1
[Fri May 15 10:58:28 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:02.0 with driver snd_emu10k1
[Fri May 15 10:58:28 2015] bus: 'pci': really_probe: probing driver snd_emu=
10k1 with device 0000:05:02.0
[Fri May 15 10:58:28 2015] snd_emu10k1 0000:05:02.0: Installing spdif_bug p=
atch: SB Audigy 2 ZS [SB0350]
[Fri May 15 10:58:28 2015] device: 'card0': device_add
[Fri May 15 10:58:28 2015] device: 'controlC0': device_add
[Fri May 15 10:58:28 2015] device: '0-0:STAC9721,23': device_add
[Fri May 15 10:58:28 2015] bus: 'ac97': add device 0-0:STAC9721,23
[Fri May 15 10:58:28 2015] device: 'pcmC0D0p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D0c': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D1c': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D2p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D2c': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D3p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D4p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC0D4c': device_add
[Fri May 15 10:58:28 2015] device: 'midiC0D0': device_add
[Fri May 15 10:58:28 2015] device: 'midi': device_add
[Fri May 15 10:58:28 2015] device: 'dmmidi': device_add
[Fri May 15 10:58:28 2015] device: 'midiC0D1': device_add
[Fri May 15 10:58:28 2015] device: 'amidi': device_add
[Fri May 15 10:58:28 2015] device: 'admmidi': device_add
[Fri May 15 10:58:28 2015] device: 'hwC0D0': device_add
[Fri May 15 10:58:28 2015] driver: 'snd_emu10k1': driver_bound: bound to de=
vice '0000:05:02.0'
[Fri May 15 10:58:28 2015] bus: 'pci': really_probe: bound device 0000:05:0=
2.0 to driver snd_emu10k1
[Fri May 15 10:58:28 2015] bus: 'platform': add driver pcspkr
[Fri May 15 10:58:28 2015] bus: 'platform': driver_probe_device: matched de=
vice pcspkr with driver pcspkr
[Fri May 15 10:58:28 2015] bus: 'platform': really_probe: probing driver pc=
spkr with device pcspkr
[Fri May 15 10:58:28 2015] device: 'input4': device_add
[Fri May 15 10:58:28 2015] input: PC Speaker as /devices/platform/pcspkr/in=
put/input4
[Fri May 15 10:58:28 2015] device: 'event4': device_add
[Fri May 15 10:58:28 2015] device: 'card3': device_add
[Fri May 15 10:58:28 2015] device: 'controlC3': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC3D0p': device_add
[Fri May 15 10:58:28 2015] driver: 'pcspkr': driver_bound: bound to device =
'pcspkr'
[Fri May 15 10:58:28 2015] bus: 'platform': really_probe: bound device pcsp=
kr to driver pcspkr
[Fri May 15 10:58:28 2015] usb 1-1: new high-speed USB device number 2 usin=
g ehci-pci
[Fri May 15 10:58:28 2015] usb 2-1: new high-speed USB device number 2 usin=
g ehci-pci
[Fri May 15 10:58:28 2015] usb 3-3: new full-speed USB device number 2 usin=
g xhci_hcd
[Fri May 15 10:58:28 2015] bus: 'pci': add driver snd_hda_intel
[Fri May 15 10:58:28 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1b.0 with driver snd_hda_intel
[Fri May 15 10:58:28 2015] bus: 'pci': really_probe: probing driver snd_hda=
_intel with device 0000:00:1b.0
[Fri May 15 10:58:28 2015] driver: 'snd_hda_intel': driver_bound: bound to =
device '0000:00:1b.0'
[Fri May 15 10:58:28 2015] bus: 'pci': really_probe: bound device 0000:00:1=
b.0 to driver snd_hda_intel
[Fri May 15 10:58:28 2015] usb 1-1: New USB device found, idVendor=3D8087, =
idProduct=3D0024
[Fri May 15 10:58:28 2015] usb 1-1: New USB device strings: Mfr=3D0, Produc=
t=3D0, SerialNumber=3D0
[Fri May 15 10:58:28 2015] device: '1-1': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
1-1 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 1-1
[Fri May 15 10:58:28 2015] device: '1-1:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1:1.0
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
1-1:1.0 with driver hub
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 1-1:1.0
[Fri May 15 10:58:28 2015] hub 1-1:1.0: USB hub found
[Fri May 15 10:58:28 2015] hub 1-1:1.0: 6 ports detected
[Fri May 15 10:58:28 2015] device: '1-1-port1': device_add
[Fri May 15 10:58:28 2015] device: '1-1-port2': device_add
[Fri May 15 10:58:28 2015] device: '1-1-port3': device_add
[Fri May 15 10:58:28 2015] device: '1-1-port4': device_add
[Fri May 15 10:58:28 2015] device: '1-1-port5': device_add
[Fri May 15 10:58:28 2015] device: '1-1-port6': device_add
[Fri May 15 10:58:28 2015] driver: 'hub': driver_bound: bound to device '1-=
1:1.0'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 1-1:1.0 t=
o driver hub
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '1-=
1'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 1-1 to dr=
iver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] usb 2-1: New USB device found, idVendor=3D8087, =
idProduct=3D0024
[Fri May 15 10:58:28 2015] usb 2-1: New USB device strings: Mfr=3D0, Produc=
t=3D0, SerialNumber=3D0
[Fri May 15 10:58:28 2015] device: '2-1': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
2-1 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 2-1
[Fri May 15 10:58:28 2015] device: '2-1:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1:1.0
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
2-1:1.0 with driver hub
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 2-1:1.0
[Fri May 15 10:58:28 2015] hub 2-1:1.0: USB hub found
[Fri May 15 10:58:28 2015] hub 2-1:1.0: 8 ports detected
[Fri May 15 10:58:28 2015] device: '2-1-port1': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port2': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port3': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port4': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port5': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port6': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port7': device_add
[Fri May 15 10:58:28 2015] device: '2-1-port8': device_add
[Fri May 15 10:58:28 2015] driver: 'hub': driver_bound: bound to device '2-=
1:1.0'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 2-1:1.0 t=
o driver hub
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '2-=
1'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 2-1 to dr=
iver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] sound hdaudioC5D0: autoconfig: line_outs=3D1 (0x=
14/0x0/0x0/0x0/0x0) type:line
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:    speaker_outs=3D0 (0x0/0x0/=
0x0/0x0/0x0)
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:    hp_outs=3D1 (0x1b/0x0/0x0/=
0x0/0x0)
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:    mono: mono_out=3D0x0
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:    dig-out=3D0x11/0x1e
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:    inputs:
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:      Front Mic=3D0x19
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:      Rear Mic=3D0x18
[Fri May 15 10:58:28 2015] sound hdaudioC5D0:      Line=3D0x1a
[Fri May 15 10:58:28 2015] sound hdaudioC5D3: autoconfig: line_outs=3D0 (0x=
0/0x0/0x0/0x0/0x0) type:line
[Fri May 15 10:58:28 2015] sound hdaudioC5D3:    speaker_outs=3D0 (0x0/0x0/=
0x0/0x0/0x0)
[Fri May 15 10:58:28 2015] sound hdaudioC5D3:    hp_outs=3D0 (0x0/0x0/0x0/0=
x0/0x0)
[Fri May 15 10:58:28 2015] sound hdaudioC5D3:    mono: mono_out=3D0x0
[Fri May 15 10:58:28 2015] sound hdaudioC5D3:    dig-out=3D0x7/0x0
[Fri May 15 10:58:28 2015] sound hdaudioC5D3:    inputs:
[Fri May 15 10:58:28 2015] device: 'card5': device_add
[Fri May 15 10:58:28 2015] device: 'controlC5': device_add
[Fri May 15 10:58:28 2015] device: 'hdaudioC5D0': device_add
[Fri May 15 10:58:28 2015] device: 'hdaudioC5D3': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC5D0p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC5D0c': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC5D1p': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC5D2c': device_add
[Fri May 15 10:58:28 2015] device: 'pcmC5D3p': device_add
[Fri May 15 10:58:28 2015] device: 'hwC5D0': device_add
[Fri May 15 10:58:28 2015] device: 'hwC5D3': device_add
[Fri May 15 10:58:28 2015] device: 'input5': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH Front Mic as /devices/pci00=
00:00/0000:00:1b.0/sound/card5/input5
[Fri May 15 10:58:28 2015] device: 'event5': device_add
[Fri May 15 10:58:28 2015] device: 'input6': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH Rear Mic as /devices/pci000=
0:00/0000:00:1b.0/sound/card5/input6
[Fri May 15 10:58:28 2015] device: 'event6': device_add
[Fri May 15 10:58:28 2015] device: 'input7': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH Line as /devices/pci0000:00=
/0000:00:1b.0/sound/card5/input7
[Fri May 15 10:58:28 2015] device: 'event7': device_add
[Fri May 15 10:58:28 2015] device: 'input8': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH Line Out as /devices/pci000=
0:00/0000:00:1b.0/sound/card5/input8
[Fri May 15 10:58:28 2015] device: 'event8': device_add
[Fri May 15 10:58:28 2015] device: 'input9': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH Front Headphone as /devices=
/pci0000:00/0000:00:1b.0/sound/card5/input9
[Fri May 15 10:58:28 2015] device: 'event9': device_add
[Fri May 15 10:58:28 2015] device: 'input10': device_add
[Fri May 15 10:58:28 2015] input: HDA Intel PCH HDMI as /devices/pci0000:00=
/0000:00:1b.0/sound/card5/input10
[Fri May 15 10:58:28 2015] device: 'event10': device_add
[Fri May 15 10:58:28 2015] usb 3-3: New USB device found, idVendor=3D06e1, =
idProduct=3Da155
[Fri May 15 10:58:28 2015] usb 3-3: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D0
[Fri May 15 10:58:28 2015] usb 3-3: Product: ADS InstantFM Music
[Fri May 15 10:58:28 2015] usb 3-3: Manufacturer: ADS TECH
[Fri May 15 10:58:28 2015] device: '3-3': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 3-3
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
3-3 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-3
[Fri May 15 10:58:28 2015] usb 3-3: ep 0x81 - rounding interval to 64 micro=
frames, ep desc says 80 microframes
[Fri May 15 10:58:28 2015] device: '3-3:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 3-3:1.0
[Fri May 15 10:58:28 2015] device: '3-3:1.1': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 3-3:1.1
[Fri May 15 10:58:28 2015] device: '3-3:1.2': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 3-3:1.2
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] device: 'ep_02': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '3-=
3'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 3-3 to dr=
iver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] Registering platform device 'microcode'. Parent =
at platform
[Fri May 15 10:58:28 2015] device: 'microcode': device_add
[Fri May 15 10:58:28 2015] bus: 'platform': add device microcode
[Fri May 15 10:58:28 2015] microcode: CPU0 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded536940
[Fri May 15 10:58:28 2015] bus: 'pci': add driver cx88-mpeg driver manager
[Fri May 15 10:58:28 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.2 with driver cx88-mpeg driver manager
[Fri May 15 10:58:28 2015] bus: 'pci': really_probe: probing driver cx88-mp=
eg driver manager with device 0000:05:01.2
[Fri May 15 10:58:28 2015] cx88[0]: subsystem: 7063:5500, board: pcHDTV HD5=
500 HDTV [card=3D47,autodetected], frontend(s): 1
[Fri May 15 10:58:28 2015] usb 1-1.3: new high-speed USB device number 3 us=
ing ehci-pci
[Fri May 15 10:58:28 2015] usb 2-1.5: new low-speed USB device number 3 usi=
ng ehci-pci
[Fri May 15 10:58:28 2015] usb 1-1.3: New USB device found, idVendor=3D0bda=
, idProduct=3D8176
[Fri May 15 10:58:28 2015] usb 1-1.3: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D3
[Fri May 15 10:58:28 2015] usb 1-1.3: Product: 802.11n WLAN Adapter
[Fri May 15 10:58:28 2015] usb 1-1.3: Manufacturer: Realtek
[Fri May 15 10:58:28 2015] usb 1-1.3: SerialNumber: 00e04c000001
[Fri May 15 10:58:28 2015] device: '1-1.3': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1.3
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
1-1.3 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 1-1.3
[Fri May 15 10:58:28 2015] device: '1-1.3:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1.3:1.0
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] device: 'ep_02': device_add
[Fri May 15 10:58:28 2015] device: 'ep_03': device_add
[Fri May 15 10:58:28 2015] device: 'ep_84': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '1-=
1.3'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 1-1.3 to =
driver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] usb 2-1.5: New USB device found, idVendor=3D046d=
, idProduct=3Dc01b
[Fri May 15 10:58:28 2015] usb 2-1.5: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D0
[Fri May 15 10:58:28 2015] usb 2-1.5: Product: USB-PS/2 Optical Mouse
[Fri May 15 10:58:28 2015] usb 2-1.5: Manufacturer: Logitech
[Fri May 15 10:58:28 2015] device: '2-1.5': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1.5
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
2-1.5 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 2-1.5
[Fri May 15 10:58:28 2015] device: '2-1.5:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1.5:1.0
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '2-=
1.5'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 2-1.5 to =
driver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] device: 'i2c-8': device_add
[Fri May 15 10:58:28 2015] bus: 'i2c': add device i2c-8
[Fri May 15 10:58:28 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Fri May 15 10:58:28 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed536940 data=3Df5670000 size=3D12288
[Fri May 15 10:58:28 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded5=
36940 data=3Df5670000 size=3D12288
[Fri May 15 10:58:28 2015] microcode: CPU0 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] microcode: CPU0 updated to revision 0x1b, date =
=3D 2014-05-29
[Fri May 15 10:58:28 2015] microcode: CPU1 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded536940
[Fri May 15 10:58:28 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Fri May 15 10:58:28 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed536940 data=3Df6681000 size=3D12288
[Fri May 15 10:58:28 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded5=
36940 data=3Df6681000 size=3D12288
[Fri May 15 10:58:28 2015] microcode: CPU1 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] microcode: CPU1 updated to revision 0x1b, date =
=3D 2014-05-29
[Fri May 15 10:58:28 2015] microcode: CPU2 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded536940
[Fri May 15 10:58:28 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Fri May 15 10:58:28 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed536940 data=3Df6689000 size=3D12288
[Fri May 15 10:58:28 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded5=
36940 data=3Df6689000 size=3D12288
[Fri May 15 10:58:28 2015] microcode: CPU2 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] microcode: CPU2 updated to revision 0x1b, date =
=3D 2014-05-29
[Fri May 15 10:58:28 2015] microcode: CPU3 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded536940
[Fri May 15 10:58:28 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Fri May 15 10:58:28 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed536940 data=3Df6691000 size=3D12288
[Fri May 15 10:58:28 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded5=
36940 data=3Df6691000 size=3D12288
[Fri May 15 10:58:28 2015] microcode: CPU3 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Fri May 15 10:58:28 2015] microcode: CPU3 updated to revision 0x1b, date =
=3D 2014-05-29
[Fri May 15 10:58:28 2015] device: 'microcode': device_add
[Fri May 15 10:58:28 2015] microcode: Microcode Update Driver: v2.00 <tigra=
n@aivazian.fsnet.co.uk>, Peter Oruba
[Fri May 15 10:58:28 2015] bus: 'pci': add driver cx88_audio
[Fri May 15 10:58:28 2015] usb 1-1.4: new full-speed USB device number 4 us=
ing ehci-pci
[Fri May 15 10:58:28 2015] usb 2-1.6: new high-speed USB device number 4 us=
ing ehci-pci
[Fri May 15 10:58:28 2015] bus: 'pci': add driver cx8800
[Fri May 15 10:58:28 2015] usb 2-1.6: New USB device found, idVendor=3D04e8=
, idProduct=3D342d
[Fri May 15 10:58:28 2015] usb 2-1.6: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D3
[Fri May 15 10:58:28 2015] usb 2-1.6: Product: SCX-4x28 Series
[Fri May 15 10:58:28 2015] usb 2-1.6: Manufacturer: Samsung Electronics Co.=
, Ltd.
[Fri May 15 10:58:28 2015] usb 2-1.6: SerialNumber: 9H61BAIS500282A
[Fri May 15 10:58:28 2015] device: '2-1.6': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1.6
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
2-1.6 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 2-1.6
[Fri May 15 10:58:28 2015] device: '2-1.6:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1.6:1.0
[Fri May 15 10:58:28 2015] device: 'ep_03': device_add
[Fri May 15 10:58:28 2015] device: 'ep_84': device_add
[Fri May 15 10:58:28 2015] device: '2-1.6:1.1': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 2-1.6:1.1
[Fri May 15 10:58:28 2015] device: 'ep_01': device_add
[Fri May 15 10:58:28 2015] device: 'ep_82': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '2-=
1.6'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 2-1.6 to =
driver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] usb 1-1.4: New USB device found, idVendor=3D0a12=
, idProduct=3D0001
[Fri May 15 10:58:28 2015] usb 1-1.4: New USB device strings: Mfr=3D0, Prod=
uct=3D0, SerialNumber=3D0
[Fri May 15 10:58:28 2015] device: '1-1.4': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1.4
[Fri May 15 10:58:28 2015] bus: 'usb': driver_probe_device: matched device =
1-1.4 with driver usb
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 1-1.4
[Fri May 15 10:58:28 2015] device: '1-1.4:1.0': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1.4:1.0
[Fri May 15 10:58:28 2015] device: 'ep_81': device_add
[Fri May 15 10:58:28 2015] device: 'ep_02': device_add
[Fri May 15 10:58:28 2015] device: 'ep_82': device_add
[Fri May 15 10:58:28 2015] device: '1-1.4:1.1': device_add
[Fri May 15 10:58:28 2015] bus: 'usb': add device 1-1.4:1.1
[Fri May 15 10:58:28 2015] device: 'ep_03': device_add
[Fri May 15 10:58:28 2015] device: 'ep_83': device_add
[Fri May 15 10:58:28 2015] driver: 'usb': driver_bound: bound to device '1-=
1.4'
[Fri May 15 10:58:28 2015] bus: 'usb': really_probe: bound device 1-1.4 to =
driver usb
[Fri May 15 10:58:28 2015] device: 'ep_00': device_add
[Fri May 15 10:58:28 2015] usb 2-1.7: new low-speed USB device number 5 usi=
ng ehci-pci
[Fri May 15 10:58:28 2015] usb 1-1.5: new high-speed USB device number 5 us=
ing ehci-pci
[Fri May 15 10:58:29 2015] usb 2-1.7: New USB device found, idVendor=3D04fc=
, idProduct=3D0538
[Fri May 15 10:58:29 2015] usb 2-1.7: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D0
[Fri May 15 10:58:29 2015] usb 2-1.7: Product: 2.4G wireless optical mouse
[Fri May 15 10:58:29 2015] usb 2-1.7: Manufacturer: MLK
[Fri May 15 10:58:29 2015] device: '2-1.7': device_add
[Fri May 15 10:58:29 2015] bus: 'usb': add device 2-1.7
[Fri May 15 10:58:29 2015] bus: 'usb': driver_probe_device: matched device =
2-1.7 with driver usb
[Fri May 15 10:58:29 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 2-1.7
[Fri May 15 10:58:29 2015] device: '2-1.7:1.0': device_add
[Fri May 15 10:58:29 2015] bus: 'usb': add device 2-1.7:1.0
[Fri May 15 10:58:29 2015] device: 'ep_81': device_add
[Fri May 15 10:58:29 2015] driver: 'usb': driver_bound: bound to device '2-=
1.7'
[Fri May 15 10:58:29 2015] bus: 'usb': really_probe: bound device 2-1.7 to =
driver usb
[Fri May 15 10:58:29 2015] device: 'ep_00': device_add
[Fri May 15 10:58:29 2015] usb 1-1.5: New USB device found, idVendor=3D0bb4=
, idProduct=3D0cae
[Fri May 15 10:58:29 2015] usb 1-1.5: New USB device strings: Mfr=3D2, Prod=
uct=3D3, SerialNumber=3D4
[Fri May 15 10:58:29 2015] usb 1-1.5: Product: MyTouch
[Fri May 15 10:58:29 2015] usb 1-1.5: Manufacturer: HTC
[Fri May 15 10:58:29 2015] usb 1-1.5: SerialNumber: HT179TB01627
[Fri May 15 10:58:29 2015] device: '1-1.5': device_add
[Fri May 15 10:58:29 2015] bus: 'usb': add device 1-1.5
[Fri May 15 10:58:29 2015] bus: 'usb': driver_probe_device: matched device =
1-1.5 with driver usb
[Fri May 15 10:58:29 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 1-1.5
[Fri May 15 10:58:29 2015] device: '1-1.5:1.0': device_add
[Fri May 15 10:58:29 2015] bus: 'usb': add device 1-1.5:1.0
[Fri May 15 10:58:29 2015] device: 'ep_81': device_add
[Fri May 15 10:58:29 2015] device: 'ep_01': device_add
[Fri May 15 10:58:29 2015] device: '1-1.5:1.1': device_add
[Fri May 15 10:58:29 2015] bus: 'usb': add device 1-1.5:1.1
[Fri May 15 10:58:29 2015] device: 'ep_82': device_add
[Fri May 15 10:58:29 2015] device: 'ep_02': device_add
[Fri May 15 10:58:29 2015] driver: 'usb': driver_bound: bound to device '1-=
1.5'
[Fri May 15 10:58:29 2015] bus: 'usb': really_probe: bound device 1-1.5 to =
driver usb
[Fri May 15 10:58:29 2015] device: 'ep_00': device_add
[Fri May 15 10:58:29 2015] bus: 'i2c': add driver tuner
[Fri May 15 10:58:29 2015] device: '8-0043': device_add
[Fri May 15 10:58:29 2015] bus: 'i2c': add device 8-0043
[Fri May 15 10:58:29 2015] bus: 'i2c': driver_probe_device: matched device =
8-0043 with driver tuner
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 8-0043
[Fri May 15 10:58:29 2015] tda9887 8-0043: creating new instance
[Fri May 15 10:58:29 2015] tda9887 8-0043: tda988[5/6/7] found
[Fri May 15 10:58:29 2015] tuner 8-0043: Tuner 74 found with type(s) Radio =
TV.
[Fri May 15 10:58:29 2015] driver: 'tuner': driver_bound: bound to device '=
8-0043'
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: bound device 8-0043 to=
 driver tuner
[Fri May 15 10:58:29 2015] device: '8-0061': device_add
[Fri May 15 10:58:29 2015] bus: 'i2c': add device 8-0061
[Fri May 15 10:58:29 2015] bus: 'i2c': driver_probe_device: matched device =
8-0061 with driver tuner
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 8-0061
[Fri May 15 10:58:29 2015] tuner 8-0061: Tuner -1 found with type(s) Radio =
TV.
[Fri May 15 10:58:29 2015] driver: 'tuner': driver_bound: bound to device '=
8-0061'
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: bound device 8-0061 to=
 driver tuner
[Fri May 15 10:58:29 2015] bus: 'platform': add driver coretemp
[Fri May 15 10:58:29 2015] Registering platform device 'coretemp.0'. Parent=
 at platform
[Fri May 15 10:58:29 2015] device: 'coretemp.0': device_add
[Fri May 15 10:58:29 2015] bus: 'platform': add device coretemp.0
[Fri May 15 10:58:29 2015] bus: 'platform': driver_probe_device: matched de=
vice coretemp.0 with driver coretemp
[Fri May 15 10:58:29 2015] bus: 'platform': really_probe: probing driver co=
retemp with device coretemp.0
[Fri May 15 10:58:29 2015] device: 'hwmon1': device_add
[Fri May 15 10:58:29 2015] driver: 'coretemp': driver_bound: bound to devic=
e 'coretemp.0'
[Fri May 15 10:58:29 2015] bus: 'platform': really_probe: bound device core=
temp.0 to driver coretemp
[Fri May 15 10:58:29 2015] device: 'thermal_zone2': device_add
[Fri May 15 10:58:29 2015] tuner-simple 8-0061: creating new instance
[Fri May 15 10:58:29 2015] tuner-simple 8-0061: type set to 64 (LG TDVS-H06=
xF)
[Fri May 15 10:58:29 2015] Registered IR keymap rc-hauppauge
[Fri May 15 10:58:29 2015] device: 'rc0': device_add
[Fri May 15 10:58:29 2015] device: 'input11': device_add
[Fri May 15 10:58:29 2015] input: cx88 IR (pcHDTV HD5500 HDTV) as /devices/=
pci0000:00/0000:00:1c.5/0000:04:00.0/0000:05:01.2/rc/rc0/input11
[Fri May 15 10:58:29 2015] device: 'event11': device_add
[Fri May 15 10:58:29 2015] rc0: cx88 IR (pcHDTV HD5500 HDTV) as /devices/pc=
i0000:00/0000:00:1c.5/0000:04:00.0/0000:05:01.2/rc/rc0
[Fri May 15 10:58:29 2015] device: 'lirc0': device_add
[Fri May 15 10:58:29 2015] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) =
registered at minor =3D 0
[Fri May 15 10:58:29 2015] cx88[0]/2: cx2388x 8802 Driver Manager
[Fri May 15 10:58:29 2015] cx88[0]/2: found at 0000:05:01.2, rev: 5, irq: 1=
8, latency: 64, mmio: 0xf3000000
[Fri May 15 10:58:29 2015] driver: 'cx88-mpeg driver manager': driver_bound=
: bound to device '0000:05:01.2'
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.2 to driver cx88-mpeg driver manager
[Fri May 15 10:58:29 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.1 with driver cx88_audio
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: probing driver cx88_au=
dio with device 0000:05:01.1
[Fri May 15 10:58:29 2015] cx88[0]/1: CX88x/0: ALSA support for cx2388x boa=
rds
[Fri May 15 10:58:29 2015] device: 'card1': device_add
[Fri May 15 10:58:29 2015] device: 'controlC1': device_add
[Fri May 15 10:58:29 2015] device: 'pcmC1D0c': device_add
[Fri May 15 10:58:29 2015] driver: 'cx88_audio': driver_bound: bound to dev=
ice '0000:05:01.1'
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.1 to driver cx88_audio
[Fri May 15 10:58:29 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:00.0 with driver cx8800
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: probing driver cx8800 =
with device 0000:05:00.0
[Fri May 15 10:58:29 2015] cx88[1]: subsystem: 1002:00f9, board: ATI TV Won=
der Pro [card=3D4,autodetected], frontend(s): 0
[Fri May 15 10:58:29 2015] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[Fri May 15 10:58:29 2015] cx88/2: registering cx8802 driver, type: dvb acc=
ess: shared
[Fri May 15 10:58:29 2015] cx88[0]/2: subsystem: 7063:5500, board: pcHDTV H=
D5500 HDTV [card=3D47]
[Fri May 15 10:58:29 2015] cx88[0]/2: cx2388x based DVB/ATSC card
[Fri May 15 10:58:29 2015] cx8802_alloc_frontends() allocating 1 frontend(s)
[Fri May 15 10:58:29 2015] device: 'i2c-9': device_add
[Fri May 15 10:58:29 2015] bus: 'i2c': add device i2c-9
[Fri May 15 10:58:29 2015] device: '9-0060': device_add
[Fri May 15 10:58:29 2015] bus: 'i2c': add device 9-0060
[Fri May 15 10:58:29 2015] bus: 'i2c': driver_probe_device: matched device =
9-0060 with driver tuner
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 9-0060
[Fri May 15 10:58:29 2015] All bytes are equal. It is not a TEA5767
[Fri May 15 10:58:29 2015] tuner 9-0060: Tuner -1 found with type(s) Radio =
TV.
[Fri May 15 10:58:29 2015] driver: 'tuner': driver_bound: bound to device '=
9-0060'
[Fri May 15 10:58:29 2015] bus: 'i2c': really_probe: bound device 9-0060 to=
 driver tuner
[Fri May 15 10:58:29 2015] tuner-simple 9-0060: creating new instance
[Fri May 15 10:58:29 2015] tuner-simple 9-0060: type set to 44 (Philips 4 i=
n 1 (ATI TV Wonder Pro/Conexant))
[Fri May 15 10:58:29 2015] cx88[1]/0: found at 0000:05:00.0, rev: 5, irq: 1=
7, latency: 64, mmio: 0xf6000000
[Fri May 15 10:58:29 2015] device: 'video0': device_add
[Fri May 15 10:58:29 2015] cx88[1]/0: registered device video0 [v4l2]
[Fri May 15 10:58:29 2015] device: 'vbi0': device_add
[Fri May 15 10:58:29 2015] cx88[1]/0: registered device vbi0
[Fri May 15 10:58:29 2015] driver: 'cx8800': driver_bound: bound to device =
'0000:05:00.0'
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: bound device 0000:05:0=
0.0 to driver cx8800
[Fri May 15 10:58:29 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.0 with driver cx8800
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: probing driver cx8800 =
with device 0000:05:01.0
[Fri May 15 10:58:29 2015] cx88[0]/0: found at 0000:05:01.0, rev: 5, irq: 1=
8, latency: 64, mmio: 0xf5000000
[Fri May 15 10:58:29 2015] nvidia: module license 'NVIDIA' taints kernel.
[Fri May 15 10:58:29 2015] Disabling lock debugging due to kernel taint
[Fri May 15 10:58:29 2015] bus: 'pci': add driver nvidia
[Fri May 15 10:58:29 2015] bus: 'pci': driver_probe_device: matched device =
0000:01:00.0 with driver nvidia
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: probing driver nvidia =
with device 0000:01:00.0
[Fri May 15 10:58:29 2015] nvidia 0000:01:00.0: enabling device (0000 -> 00=
03)
[Fri May 15 10:58:29 2015] vgaarb: device changed decodes: PCI:0000:01:00.0=
,olddecodes=3Dio+mem,decodes=3Dnone:owns=3Dnone
[Fri May 15 10:58:29 2015] driver: 'nvidia': driver_bound: bound to device =
'0000:01:00.0'
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: bound device 0000:01:0=
0.0 to driver nvidia
[Fri May 15 10:58:29 2015] device: 'card1': device_add
[Fri May 15 10:58:29 2015] [drm] Initialized nvidia-drm 0.0.0 20150116 for =
0000:01:00.0 on minor 1
[Fri May 15 10:58:29 2015] NVRM: loading NVIDIA UNIX x86 Kernel Module  340=
=2E76  Thu Jan 22 11:21:06 PST 2015
[Fri May 15 10:58:29 2015] tuner-simple 8-0061: attaching existing instance
[Fri May 15 10:58:29 2015] tuner-simple 8-0061: type set to 64 (LG TDVS-H06=
xF)
[Fri May 15 10:58:29 2015] tda9887 8-0043: attaching existing instance
[Fri May 15 10:58:29 2015] DVB: registering new adapter (cx88[0])
[Fri May 15 10:58:29 2015] cx88-mpeg driver manager 0000:05:01.2: DVB: regi=
stering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[Fri May 15 10:58:29 2015] device: 'dvb0.frontend0': device_add
[Fri May 15 10:58:29 2015] device: 'dvb0.demux0': device_add
[Fri May 15 10:58:29 2015] device: 'dvb0.dvr0': device_add
[Fri May 15 10:58:29 2015] device: 'dvb0.net0': device_add
[Fri May 15 10:58:29 2015] device: 'video1': device_add
[Fri May 15 10:58:29 2015] cx88[0]/0: registered device video1 [v4l2]
[Fri May 15 10:58:29 2015] device: 'vbi1': device_add
[Fri May 15 10:58:29 2015] cx88[0]/0: registered device vbi1
[Fri May 15 10:58:29 2015] driver: 'cx8800': driver_bound: bound to device =
'0000:05:01.0'
[Fri May 15 10:58:29 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.0 to driver cx8800
[Fri May 15 10:58:30 2015] bus: 'usb': add driver usblp
[Fri May 15 10:58:30 2015] bus: 'usb': driver_probe_device: matched device =
2-1.6:1.1 with driver usblp
[Fri May 15 10:58:30 2015] bus: 'usb': really_probe: probing driver usblp w=
ith device 2-1.6:1.1
[Fri May 15 10:58:30 2015] device class 'usbmisc': registering
[Fri May 15 10:58:30 2015] device: 'lp0': device_add
[Fri May 15 10:58:30 2015] usblp 2-1.6:1.1: usblp0: USB Bidirectional print=
er dev 4 if 1 alt 0 proto 2 vid 0x04E8 pid 0x342D
[Fri May 15 10:58:30 2015] driver: 'usblp': driver_bound: bound to device '=
2-1.6:1.1'
[Fri May 15 10:58:30 2015] bus: 'usb': really_probe: bound device 2-1.6:1.1=
 to driver usblp
[Fri May 15 10:58:30 2015] usbcore: registered new interface driver usblp
[Fri May 15 10:58:30 2015] bus: 'acpi': add driver NVIDIA ACPI Video Driver
[Fri May 15 10:58:30 2015] Bluetooth: Core ver 2.19
[Fri May 15 10:58:30 2015] device class 'bluetooth': registering
[Fri May 15 10:58:30 2015] NET: Registered protocol family 31
[Fri May 15 10:58:30 2015] Bluetooth: HCI device and connection manager ini=
tialized
[Fri May 15 10:58:30 2015] Bluetooth: HCI socket layer initialized
[Fri May 15 10:58:30 2015] Bluetooth: L2CAP socket layer initialized
[Fri May 15 10:58:30 2015] Bluetooth: SCO socket layer initialized
[Fri May 15 10:58:30 2015] bus: 'usb': add driver btusb
[Fri May 15 10:58:30 2015] bus: 'usb': driver_probe_device: matched device =
1-1.4:1.0 with driver btusb
[Fri May 15 10:58:30 2015] bus: 'usb': really_probe: probing driver btusb w=
ith device 1-1.4:1.0
[Fri May 15 10:58:30 2015] driver: 'btusb': driver_bound: bound to device '=
1-1.4:1.1'
[Fri May 15 10:58:30 2015] device: 'hci0': device_add
[Fri May 15 10:58:30 2015] driver: 'btusb': driver_bound: bound to device '=
1-1.4:1.0'
[Fri May 15 10:58:30 2015] bus: 'usb': really_probe: bound device 1-1.4:1.0=
 to driver btusb
[Fri May 15 10:58:30 2015] usbcore: registered new interface driver btusb
[Fri May 15 10:58:31 2015] device: 'i2c-10': device_add
[Fri May 15 10:58:31 2015] bus: 'i2c': add device i2c-10
[Fri May 15 10:58:31 2015] device: 'i2c-11': device_add
[Fri May 15 10:58:31 2015] bus: 'i2c': add device i2c-11
[Fri May 15 10:58:31 2015] device: 'i2c-12': device_add
[Fri May 15 10:58:31 2015] bus: 'i2c': add device i2c-12
[Fri May 15 10:58:31 2015] bus: 'acpi': remove driver NVIDIA ACPI Video Dri=
ver
[Fri May 15 10:58:31 2015] driver: 'NVIDIA ACPI Video Driver': driver_relea=
se
[Fri May 15 10:58:31 2015] bus: 'usb': add driver usbhid
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
3-3:1.2 with driver usbhid
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver usbhid =
with device 3-3:1.2
[Fri May 15 10:58:31 2015] usbhid: probe of 3-3:1.2 rejects match -19
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
2-1.5:1.0 with driver usbhid
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver usbhid =
with device 2-1.5:1.0
[Fri May 15 10:58:31 2015] device: '0003:046D:C01B.0001': device_add
[Fri May 15 10:58:31 2015] bus: 'hid': add device 0003:046D:C01B.0001
[Fri May 15 10:58:31 2015] bus: 'hid': driver_probe_device: matched device =
0003:046D:C01B.0001 with driver hid-generic
[Fri May 15 10:58:31 2015] bus: 'hid': really_probe: probing driver hid-gen=
eric with device 0003:046D:C01B.0001
[Fri May 15 10:58:31 2015] device: 'input13': device_add
[Fri May 15 10:58:31 2015] input: Logitech USB-PS/2 Optical Mouse as /devic=
es/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.5/2-1.5:1.0/0003:046D:C01B.0001/inp=
ut/input13
[Fri May 15 10:58:31 2015] device: 'mouse0': device_add
[Fri May 15 10:58:31 2015] device: 'event12': device_add
[Fri May 15 10:58:31 2015] device: 'hidraw0': device_add
[Fri May 15 10:58:31 2015] hid-generic 0003:046D:C01B.0001: input,hidraw0: =
USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1=
=2E5/input0
[Fri May 15 10:58:31 2015] driver: 'hid-generic': driver_bound: bound to de=
vice '0003:046D:C01B.0001'
[Fri May 15 10:58:31 2015] bus: 'hid': really_probe: bound device 0003:046D=
:C01B.0001 to driver hid-generic
[Fri May 15 10:58:31 2015] driver: 'usbhid': driver_bound: bound to device =
'2-1.5:1.0'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 2-1.5:1.0=
 to driver usbhid
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
2-1.7:1.0 with driver usbhid
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver usbhid =
with device 2-1.7:1.0
[Fri May 15 10:58:31 2015] device: '0003:04FC:0538.0002': device_add
[Fri May 15 10:58:31 2015] bus: 'hid': add device 0003:04FC:0538.0002
[Fri May 15 10:58:31 2015] bus: 'hid': driver_probe_device: matched device =
0003:04FC:0538.0002 with driver hid-generic
[Fri May 15 10:58:31 2015] bus: 'hid': really_probe: probing driver hid-gen=
eric with device 0003:04FC:0538.0002
[Fri May 15 10:58:31 2015] device: 'input14': device_add
[Fri May 15 10:58:31 2015] input: MLK 2.4G wireless optical mouse as /devic=
es/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7:1.0/0003:04FC:0538.0002/inp=
ut/input14
[Fri May 15 10:58:31 2015] device: 'mouse1': device_add
[Fri May 15 10:58:31 2015] device: 'event13': device_add
[Fri May 15 10:58:31 2015] device: 'hiddev0': device_add
[Fri May 15 10:58:31 2015] device: 'hidraw1': device_add
[Fri May 15 10:58:31 2015] hid-generic 0003:04FC:0538.0002: input,hiddev0,h=
idraw1: USB HID v1.10 Mouse [MLK 2.4G wireless optical mouse] on usb-0000:0=
0:1d.0-1.7/input0
[Fri May 15 10:58:31 2015] driver: 'hid-generic': driver_bound: bound to de=
vice '0003:04FC:0538.0002'
[Fri May 15 10:58:31 2015] bus: 'hid': really_probe: bound device 0003:04FC=
:0538.0002 to driver hid-generic
[Fri May 15 10:58:31 2015] driver: 'usbhid': driver_bound: bound to device =
'2-1.7:1.0'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 2-1.7:1.0=
 to driver usbhid
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver usbhid
[Fri May 15 10:58:31 2015] usbhid: USB HID core driver
[Fri May 15 10:58:31 2015] bus: 'usb': add driver radio-si470x
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
3-3:1.2 with driver radio-si470x
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver radio-s=
i470x with device 3-3:1.2
[Fri May 15 10:58:31 2015] radio-si470x 3-3:1.2: DeviceID=3D0xffff ChipID=
=3D0xffff
[Fri May 15 10:58:31 2015] radio-si470x 3-3:1.2: software version 0, hardwa=
re version 7
[Fri May 15 10:58:31 2015] device class 'ieee80211': registering
[Fri May 15 10:58:31 2015] Registering platform device 'regulatory.0'. Pare=
nt at platform
[Fri May 15 10:58:31 2015] device: 'regulatory.0': device_add
[Fri May 15 10:58:31 2015] bus: 'platform': add device regulatory.0
[Fri May 15 10:58:31 2015] cfg80211: Calling CRDA to update world regulator=
y domain
[Fri May 15 10:58:31 2015] device: 'radio0': device_add
[Fri May 15 10:58:31 2015] driver: 'radio-si470x': driver_bound: bound to d=
evice '3-3:1.2'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 3-3:1.2 t=
o driver radio-si470x
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver radio-s=
i470x
[Fri May 15 10:58:31 2015] bus: 'usb': add driver usb-storage
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
1-1.5:1.0 with driver usb-storage
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver usb-sto=
rage with device 1-1.5:1.0
[Fri May 15 10:58:31 2015] usb-storage 1-1.5:1.0: USB Mass Storage device d=
etected
[Fri May 15 10:58:31 2015] scsi host8: usb-storage 1-1.5:1.0
[Fri May 15 10:58:31 2015] device: 'host8': device_add
[Fri May 15 10:58:31 2015] bus: 'scsi': add device host8
[Fri May 15 10:58:31 2015] device: 'host8': device_add
[Fri May 15 10:58:31 2015] driver: 'usb-storage': driver_bound: bound to de=
vice '1-1.5:1.0'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 1-1.5:1.0=
 to driver usb-storage
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver usb-sto=
rage
[Fri May 15 10:58:31 2015] bus: 'usb': add driver snd-usb-audio
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
3-3:1.0 with driver snd-usb-audio
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver snd-usb=
-audio with device 3-3:1.0
[Fri May 15 10:58:31 2015] device: 'ep_83': device_add
[Fri May 15 10:58:31 2015] device: 'ep_83': device_unregister
[Fri May 15 10:58:31 2015] driver: 'snd-usb-audio': driver_bound: bound to =
device '3-3:1.1'
[Fri May 15 10:58:31 2015] device: 'card2': device_add
[Fri May 15 10:58:31 2015] device: 'controlC2': device_add
[Fri May 15 10:58:31 2015] device: 'pcmC2D0c': device_add
[Fri May 15 10:58:31 2015] driver: 'snd-usb-audio': driver_bound: bound to =
device '3-3:1.0'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 3-3:1.0 t=
o driver snd-usb-audio
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver snd-usb=
-audio
[Fri May 15 10:58:31 2015] bus: 'usb': add driver uas
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver uas
[Fri May 15 10:58:31 2015] bus: 'usb': add driver rtl8192cu
[Fri May 15 10:58:31 2015] bus: 'usb': driver_probe_device: matched device =
1-1.3:1.0 with driver rtl8192cu
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: probing driver rtl8192=
cu with device 1-1.3:1.0
[Fri May 15 10:58:31 2015] rtl8192cu: Chip version 0x10
[Fri May 15 10:58:31 2015] rtl8192cu: MAC address: e8:4e:06:00:66:62
[Fri May 15 10:58:31 2015] rtl8192cu: Board Type 0
[Fri May 15 10:58:31 2015] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[Fri May 15 10:58:31 2015] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_=
TMSC.bin
[Fri May 15 10:58:31 2015] device: 'phy0': device_add
[Fri May 15 10:58:31 2015] __allocate_fw_buf: fw-rtlwifi/rtl8192cufw_TMSC.b=
in buf=3Ded536040
[Fri May 15 10:58:31 2015] usb 1-1.3: Direct firmware load for rtlwifi/rtl8=
192cufw_TMSC.bin failed with error -2
[Fri May 15 10:58:31 2015] __fw_free_buf: fw-rtlwifi/rtl8192cufw_TMSC.bin b=
uf=3Ded536040 data=3D  (null) size=3D0
[Fri May 15 10:58:31 2015] __allocate_fw_buf: fw-rtlwifi/rtl8192cufw.bin bu=
f=3Ded536040
[Fri May 15 10:58:31 2015] usb 1-1.3: firmware: direct-loading firmware rtl=
wifi/rtl8192cufw.bin
[Fri May 15 10:58:31 2015] fw_set_page_data: fw-rtlwifi/rtl8192cufw.bin buf=
=3Ded536040 data=3Df489d000 size=3D16014
[Fri May 15 10:58:31 2015] rtlwifi: Loading alternative firmware rtlwifi/rt=
l8192cufw.bin
[Fri May 15 10:58:31 2015] __fw_free_buf: fw-rtlwifi/rtl8192cufw.bin buf=3D=
ed536040 data=3Df489d000 size=3D16014
[Fri May 15 10:58:31 2015] ieee80211 phy0: Selected rate control algorithm =
'rtl_rc'
[Fri May 15 10:58:31 2015] device: 'wlan0': device_add
[Fri May 15 10:58:31 2015] driver: 'rtl8192cu': driver_bound: bound to devi=
ce '1-1.3:1.0'
[Fri May 15 10:58:31 2015] bus: 'usb': really_probe: bound device 1-1.3:1.0=
 to driver rtl8192cu
[Fri May 15 10:58:31 2015] usbcore: registered new interface driver rtl8192=
cu
[Fri May 15 10:58:31 2015] rtl8192cu 1-1.3:1.0 wlp0s26u1u3: renamed from wl=
an0
[Fri May 15 10:58:31 2015] net wlan0: renaming to wlp0s26u1u3
[Fri May 15 10:58:31 2015] systemd-udevd[329]: renamed network interface wl=
an0 to wlp0s26u1u3
[Fri May 15 10:58:32 2015] cfg80211: World regulatory domain updated:
[Fri May 15 10:58:32 2015] cfg80211:  DFS Master region: unset
[Fri May 15 10:58:32 2015] cfg80211:   (start_freq - end_freq @ bandwidth),=
 (max_antenna_gain, max_eirp), (dfs_cac_time)
[Fri May 15 10:58:32 2015] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Fri May 15 10:58:32 2015] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Fri May 15 10:58:32 2015] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Fri May 15 10:58:32 2015] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 K=
Hz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[Fri May 15 10:58:32 2015] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 K=
Hz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[Fri May 15 10:58:32 2015] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 =
KHz), (N/A, 2000 mBm), (0 s)
[Fri May 15 10:58:32 2015] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Fri May 15 10:58:32 2015] cfg80211:   (57240000 KHz - 63720000 KHz @ 21600=
00 KHz), (N/A, 0 mBm), (N/A)
[Fri May 15 10:58:32 2015] scsi 8:0:0:0: Direct-Access     Linux    File-CD=
 Gadget   0000 PQ: 0 ANSI: 2
[Fri May 15 10:58:32 2015] device: 'target8:0:0': device_add
[Fri May 15 10:58:32 2015] bus: 'scsi': add device target8:0:0
[Fri May 15 10:58:32 2015] device: '8:0:0:0': device_add
[Fri May 15 10:58:32 2015] bus: 'scsi': add device 8:0:0:0
[Fri May 15 10:58:32 2015] bus: 'scsi': driver_probe_device: matched device=
 8:0:0:0 with driver sd
[Fri May 15 10:58:32 2015] bus: 'scsi': really_probe: probing driver sd wit=
h device 8:0:0:0
[Fri May 15 10:58:32 2015] device: '8:0:0:0': device_add
[Fri May 15 10:58:32 2015] driver: 'sd': driver_bound: bound to device '8:0=
:0:0'
[Fri May 15 10:58:32 2015] bus: 'scsi': really_probe: bound device 8:0:0:0 =
to driver sd
[Fri May 15 10:58:32 2015] device: '8:0:0:0': device_add
[Fri May 15 10:58:32 2015] device: 'sg6': device_add
[Fri May 15 10:58:32 2015] sd 8:0:0:0: Attached scsi generic sg6 type 0
[Fri May 15 10:58:32 2015] device: '8:0:0:0': device_add
[Fri May 15 10:58:32 2015] device: '8:80': device_add
[Fri May 15 10:58:32 2015] device: 'sdf': device_add
[Fri May 15 10:58:32 2015] sd 8:0:0:0: [sdf] Attached SCSI removable disk
[Fri May 15 10:58:58 2015] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 a=
ction 0x6 frozen
[Fri May 15 10:58:58 2015] sr 0:0:0:0: CDB:=20
[Fri May 15 10:58:58 2015] Get event status notification: 4a 01 00 00 10 00=
 00 00 08 00
[Fri May 15 10:58:58 2015] ata1.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0=
 tag 24 pio 16392 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[Fri May 15 10:58:58 2015] ata1.00: status: { DRDY }
[Fri May 15 10:58:58 2015] ata1: hard resetting link
[Fri May 15 10:58:59 2015] ata1: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 300)
[Fri May 15 10:58:59 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Fri May 15 10:58:59 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Fri May 15 10:58:59 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Fri May 15 10:58:59 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Fri May 15 10:58:59 2015] ata1.00: configured for UDMA/66
[Fri May 15 10:58:59 2015] ata1: EH complete
[Fri May 15 10:59:00 2015] device: 'device-mapper': device_add
[Fri May 15 10:59:00 2015] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) =
initialised: dm-devel@redhat.com
[Fri May 15 10:59:01 2015] reiserfs: enabling write barrier flush mode
[Fri May 15 10:59:01 2015] Adding 1004056k swap on /dev/sdb2.  Priority:1 e=
xtents:1 across:1004056k FS
[Fri May 15 10:59:01 2015] EXT4-fs (sdd1): acl option not supported
[Fri May 15 10:59:01 2015] EXT4-fs (sdd1): mounted filesystem with ordered =
data mode. Opts: acl,user_xattr
[Fri May 15 10:59:01 2015] EXT4-fs (sdd2): acl option not supported
[Fri May 15 10:59:01 2015] EXT4-fs (sdd2): mounted filesystem with ordered =
data mode. Opts: acl,user_xattr
[Fri May 15 10:59:02 2015] device: 'vcs2': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa2': device_add
[Fri May 15 10:59:02 2015] device: 'vcs3': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa3': device_add
[Fri May 15 10:59:02 2015] device: 'vcs4': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa4': device_add
[Fri May 15 10:59:02 2015] device: 'vcs5': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa5': device_add
[Fri May 15 10:59:02 2015] device: 'vcs6': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa6': device_add
[Fri May 15 10:59:02 2015] device: 'vcs7': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa7': device_add
[Fri May 15 10:59:02 2015] device: 'vcs8': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa8': device_add
[Fri May 15 10:59:02 2015] device: 'vcs9': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa9': device_add
[Fri May 15 10:59:02 2015] device: 'vcs10': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa10': device_add
[Fri May 15 10:59:02 2015] device: 'vcs11': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa11': device_add
[Fri May 15 10:59:02 2015] device: 'vcs12': device_add
[Fri May 15 10:59:02 2015] device: 'vcsa12': device_add
[Fri May 15 10:59:06 2015] __allocate_fw_buf: fw-rtl_nic/rtl8168f-1.fw buf=
=3Ded914cc0
[Fri May 15 10:59:06 2015] r8169 0000:03:00.0: Direct firmware load for rtl=
_nic/rtl8168f-1.fw failed with error -2
[Fri May 15 10:59:06 2015] __fw_free_buf: fw-rtl_nic/rtl8168f-1.fw buf=3Ded=
914cc0 data=3D  (null) size=3D0
[Fri May 15 10:59:06 2015] r8169 0000:03:00.0 enp3s0: unable to load firmwa=
re patch rtl_nic/rtl8168f-1.fw (-2)
[Fri May 15 10:59:06 2015] r8169 0000:03:00.0 enp3s0: link down
[Fri May 15 10:59:06 2015] IPv6: ADDRCONF(NETDEV_UP): enp3s0: link is not r=
eady
[Fri May 15 10:59:06 2015] r8169 0000:03:00.0 enp3s0: link down
[Fri May 15 10:59:08 2015] r8169 0000:03:00.0 enp3s0: link up
[Fri May 15 10:59:08 2015] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link beco=
mes ready
[Fri May 15 10:59:10 2015] device: 'autofs': device_add
[Fri May 15 10:59:17 2015] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[Fri May 15 10:59:17 2015] Bluetooth: BNEP socket layer initialized
[Fri May 15 10:59:21 2015] bus: 'platform': add driver nct6775
[Fri May 15 10:59:21 2015] nct6775: Found NCT6779D or compatible chip at 0x=
2e:0x290
[Fri May 15 10:59:21 2015] Registering platform device 'nct6775.656'. Paren=
t at platform
[Fri May 15 10:59:21 2015] device: 'nct6775.656': device_add
[Fri May 15 10:59:21 2015] bus: 'platform': add device nct6775.656
[Fri May 15 10:59:21 2015] bus: 'platform': driver_probe_device: matched de=
vice nct6775.656 with driver nct6775
[Fri May 15 10:59:21 2015] bus: 'platform': really_probe: probing driver nc=
t6775 with device nct6775.656
[Fri May 15 10:59:21 2015] device: 'hwmon2': device_add
[Fri May 15 10:59:21 2015] driver: 'nct6775': driver_bound: bound to device=
 'nct6775.656'
[Fri May 15 10:59:21 2015] bus: 'platform': really_probe: bound device nct6=
775.656 to driver nct6775
[Fri May 15 10:59:21 2015] device: 'microcode': device_unregister
[Fri May 15 10:59:21 2015] device: 'microcode': device_create_release
[Fri May 15 10:59:21 2015] bus: 'platform': remove device microcode
[Fri May 15 10:59:21 2015] microcode: Microcode Update Driver: v2.00 remove=
d.
[Fri May 15 11:01:43 2015] restart_video_queue
[Fri May 15 11:01:44 2015] restart_video_queue
[Fri May 15 11:01:55 2015] restart_video_queue
[Fri May 15 11:01:56 2015] restart_video_queue
[Fri May 15 11:01:56 2015] restart_video_queue
[Fri May 15 11:02:00 2015] restart_video_queue
[Fri May 15 11:02:05 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:06 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:07 2015] restart_video_queue
[Fri May 15 11:02:09 2015] restart_video_queue
[Fri May 15 11:03:26 2015] restart_video_queue
[Fri May 15 11:03:40 2015] restart_video_queue
[Fri May 15 11:04:18 2015] restart_video_queue

--uAKRQypu60I7Lcqm--

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVVgzSAAoJEPFsbcakB4r7jTUH/RErwN4G/DO3X1WXABKXPpvl
rCz4wFxv6/N9zU9OVrTQuouGAufQ8ZpR9+C4TLWkADrkrL7hxSU++t16qvIh8hJs
0dRWuwxtO5w24aoJ8+0IFHflw6y1eVP8xPF7c7bs+R6AY0N/3R9v5LEoSNJ5J35p
MADKhWetPeKSiRj3uNuEKZSaaxmYBvoWK2lUVdJDvGXDtk9nViRtSb04v2Uozbuz
Ok3DnDXXgkr2peNk8N98NVVBHWGJtTgcWuHt/ebSGDGNJhLDN5HrY6l2L16JkRHi
OHZt4FkFRgF0oaW9WzVuqe8X01G6lUEb8ylp1wCefZHNPIPDIlwBc+8iZvdowDw=
=XQyY
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
