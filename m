Return-path: <linux-media-owner@vger.kernel.org>
Received: from ptaff.ca ([192.95.41.205]:36283 "EHLO ptaff.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbbENM4S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 08:56:18 -0400
Received: from nestor.ptaff.ca (modemcable096.167-59-74.mc.videotron.ca [74.59.167.96])
	by ptaff.ca (Postfix) with ESMTPSA id 560246762118
	for <linux-media@vger.kernel.org>; Thu, 14 May 2015 08:56:12 -0400 (EDT)
Date: Thu, 14 May 2015 08:56:08 -0400
From: Patrice Levesque <video4linux.wayne@ptaff.ca>
To: linux-media@vger.kernel.org
Subject: Re: ATI TV Wonder regression since at least 3.19.6
Message-ID: <20150514125607.GA3303@ptaff.ca>
Reply-To: Patrice Levesque <video4linux.wayne@ptaff.ca>
References: <20150511161203.GG3206@ptaff.ca>
 <55519647.5010007@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="aM3YZ0Iwxop3KEKx"
Content-Disposition: inline
In-Reply-To: <55519647.5010007@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--aM3YZ0Iwxop3KEKx
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Hans,


> Can you go back to kernel 3.18 and make a small change to the cx88
> driver: edit drivers/media/pci/cx88/cx88-video.c, search for the
> function restart_video_queue() (around line 469) and add this line:

Function isn't used; when compiling I get:

CC [M]  drivers/media/pci/cx88/cx88-video.o
drivers/media/pci/cx88/cx88-video.c:415:12: warning: =E2=80=98restart_video=
_queue=E2=80=99 defined but not used [-Wunused-function]

I attached my dmesg (truncated, ring buffer must be too small)
nonetheless.


> I'd also like to know the exact model of your board. If the
> 'restart_video_queue' message appears in the kernel log, then I want
> to see if I can find this card on ebay so I can try to reproduce it
> myself.

Part number written on the card is 109-95200-01 - entering that number
into search engines returns me lots of ebay links.

Is there anything else I can send you that can be useful?


Thanks,



--=20
=C2=B7 Patrice Levesque
=C2=B7 http://ptaff.ca/
=C2=B7 video4linux.wayne@ptaff.ca
--


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="ati_tv_wonder_pro-dmesg.txt"
Content-Transfer-Encoding: quoted-printable

[Thu May 14 08:22:04 2015] ALSA device list:
[Thu May 14 08:22:04 2015]   No soundcards found.
[Thu May 14 08:22:04 2015] device: 'input3': device_add
[Thu May 14 08:22:04 2015] input: AT Translated Set 2 keyboard as /devices/=
platform/i8042/serio0/input/input3
[Thu May 14 08:22:04 2015] device: 'event3': device_add
[Thu May 14 08:22:04 2015] driver: 'atkbd': driver_bound: bound to device '=
serio0'
[Thu May 14 08:22:04 2015] bus: 'serio': really_probe: bound device serio0 =
to driver atkbd
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): found reiserfs format "3=
=2E6" with standard journal
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): using ordered data mode
[Thu May 14 08:22:04 2015] reiserfs: using flush barriers
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): journal params: device s=
db3, size 8192, journal first block 18, max trans len 1024, max batch 900, =
max commit age 30, max trans age 30
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): checking transaction log=
 (sdb3)
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): replayed 1 transactions =
in 0 seconds
[Thu May 14 08:22:04 2015] REISERFS (device sdb3): Using r5 hash to sort na=
mes
[Thu May 14 08:22:04 2015] VFS: Mounted root (reiserfs filesystem) readonly=
 on device 8:19.
[Thu May 14 08:22:04 2015] devtmpfs: mounted
[Thu May 14 08:22:04 2015] Freeing unused kernel memory: 424K (c1885000 - c=
18ef000)
[Thu May 14 08:22:04 2015] Write protecting the kernel text: 6092k
[Thu May 14 08:22:04 2015] Write protecting the kernel read-only data: 2276k
[Thu May 14 08:22:04 2015] NX-protecting the kernel data: 4148k
[Thu May 14 08:22:04 2015] random: nonblocking pool is initialized
[Thu May 14 08:22:12 2015] systemd-udevd[309]: starting version 216
[Thu May 14 08:22:13 2015] bus: 'pnp': add driver rtc_cmos
[Thu May 14 08:22:13 2015] bus: 'pnp': driver_probe_device: matched device =
00:02 with driver rtc_cmos
[Thu May 14 08:22:13 2015] bus: 'pnp': really_probe: probing driver rtc_cmo=
s with device 00:02
[Thu May 14 08:22:13 2015] rtc_cmos 00:02: RTC can wake from S4
[Thu May 14 08:22:13 2015] device: 'rtc0': device_add
[Thu May 14 08:22:13 2015] rtc_cmos 00:02: rtc core: registered rtc_cmos as=
 rtc0
[Thu May 14 08:22:13 2015] rtc_cmos 00:02: alarms up to one month, y3k, 242=
 bytes nvram, hpet irqs
[Thu May 14 08:22:13 2015] driver: 'rtc_cmos': driver_bound: bound to devic=
e '00:02'
[Thu May 14 08:22:13 2015] bus: 'pnp': really_probe: bound device 00:02 to =
driver rtc_cmos
[Thu May 14 08:22:13 2015] Registering platform device 'microcode'. Parent =
at platform
[Thu May 14 08:22:13 2015] device: 'microcode': device_add
[Thu May 14 08:22:13 2015] bus: 'platform': add device microcode
[Thu May 14 08:22:13 2015] microcode: CPU0 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded4786c0
[Thu May 14 08:22:13 2015] ACPI: bus type USB registered
[Thu May 14 08:22:13 2015] bus: 'usb': registered
[Thu May 14 08:22:13 2015] bus: 'usb': add driver usbfs
[Thu May 14 08:22:13 2015] usbcore: registered new interface driver usbfs
[Thu May 14 08:22:13 2015] bus: 'usb': add driver hub
[Thu May 14 08:22:13 2015] usbcore: registered new interface driver hub
[Thu May 14 08:22:13 2015] bus: 'usb': add driver usb
[Thu May 14 08:22:13 2015] usbcore: registered new device driver usb
[Thu May 14 08:22:13 2015] r8169 0000:03:00.0 enp3s0: renamed from eth0
[Thu May 14 08:22:13 2015] net eth0: renaming to enp3s0
[Thu May 14 08:22:13 2015] systemd-udevd[340]: renamed network interface et=
h0 to enp3s0
[Thu May 14 08:22:13 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Thu May 14 08:22:13 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed4786c0 data=3Df46d6000 size=3D12288
[Thu May 14 08:22:13 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded4=
786c0 data=3Df46d6000 size=3D12288
[Thu May 14 08:22:13 2015] microcode: CPU0 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] microcode: CPU0 updated to revision 0x1b, date =
=3D 2014-05-29
[Thu May 14 08:22:13 2015] microcode: CPU1 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded4786c0
[Thu May 14 08:22:13 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Thu May 14 08:22:13 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed4786c0 data=3Df46de000 size=3D12288
[Thu May 14 08:22:13 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded4=
786c0 data=3Df46de000 size=3D12288
[Thu May 14 08:22:13 2015] microcode: CPU1 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] microcode: CPU1 updated to revision 0x1b, date =
=3D 2014-05-29
[Thu May 14 08:22:13 2015] microcode: CPU2 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded4786c0
[Thu May 14 08:22:13 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Thu May 14 08:22:13 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed4786c0 data=3Df46e6000 size=3D12288
[Thu May 14 08:22:13 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded4=
786c0 data=3Df46e6000 size=3D12288
[Thu May 14 08:22:13 2015] microcode: CPU2 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] microcode: CPU2 updated to revision 0x1b, date =
=3D 2014-05-29
[Thu May 14 08:22:13 2015] microcode: CPU3 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] __allocate_fw_buf: fw-intel-ucode/06-3a-09 buf=
=3Ded4786c0
[Thu May 14 08:22:13 2015] platform microcode: firmware: direct-loading fir=
mware intel-ucode/06-3a-09
[Thu May 14 08:22:13 2015] fw_set_page_data: fw-intel-ucode/06-3a-09 buf=3D=
ed4786c0 data=3Df46ee000 size=3D12288
[Thu May 14 08:22:13 2015] __fw_free_buf: fw-intel-ucode/06-3a-09 buf=3Ded4=
786c0 data=3Df46ee000 size=3D12288
[Thu May 14 08:22:13 2015] microcode: CPU3 sig=3D0x306a9, pf=3D0x2, revisio=
n=3D0x17
[Thu May 14 08:22:13 2015] microcode: CPU3 updated to revision 0x1b, date =
=3D 2014-05-29
[Thu May 14 08:22:13 2015] device: 'microcode': device_add
[Thu May 14 08:22:13 2015] microcode: Microcode Update Driver: v2.00 <tigra=
n@aivazian.fsnet.co.uk>, Peter Oruba
[Thu May 14 08:22:13 2015] bus: 'pci': add driver i801_smbus
[Thu May 14 08:22:13 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1f.3 with driver i801_smbus
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: probing driver i801_sm=
bus with device 0000:00:1f.3
[Thu May 14 08:22:13 2015] ACPI Warning: SystemIO range 0x0000f040-0x0000f0=
5f conflicts with OpRegion 0x0000f040-0x0000f04f (\_SB_.PCI0.SBUS.SMBI) (20=
140926/utaddress-258)
[Thu May 14 08:22:13 2015] ACPI: If an ACPI driver is available for this de=
vice, you should use it instead of the native driver
[Thu May 14 08:22:13 2015] i801_smbus: probe of 0000:00:1f.3 rejects match =
-19
[Thu May 14 08:22:13 2015] device: 'timer': device_add
[Thu May 14 08:22:13 2015] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EH=
CI) Driver
[Thu May 14 08:22:13 2015] bus: 'pci': add driver xhci_hcd
[Thu May 14 08:22:13 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:14.0 with driver xhci_hcd
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: probing driver xhci_hc=
d with device 0000:00:14.0
[Thu May 14 08:22:13 2015] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Thu May 14 08:22:13 2015] xhci_hcd 0000:00:14.0: new USB bus registered, a=
ssigned bus number 1
[Thu May 14 08:22:13 2015] ehci-pci: EHCI PCI platform driver
[Thu May 14 08:22:13 2015] bus: 'pci': add driver ehci-pci
[Thu May 14 08:22:13 2015] xhci_hcd 0000:00:14.0: cache line size of 64 is =
not supported
[Thu May 14 08:22:13 2015] usb usb1: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Thu May 14 08:22:13 2015] usb usb1: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Thu May 14 08:22:13 2015] usb usb1: Product: xHCI Host Controller
[Thu May 14 08:22:13 2015] usb usb1: Manufacturer: Linux 3.18.6-gentoo xhci=
-hcd
[Thu May 14 08:22:13 2015] usb usb1: SerialNumber: 0000:00:14.0
[Thu May 14 08:22:13 2015] device: 'usb1': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device usb1
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
usb1 with driver usb
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb1
[Thu May 14 08:22:13 2015] device: '1-0:1.0': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device 1-0:1.0
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
1-0:1.0 with driver hub
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 1-0:1.0
[Thu May 14 08:22:13 2015] hub 1-0:1.0: USB hub found
[Thu May 14 08:22:13 2015] hub 1-0:1.0: 4 ports detected
[Thu May 14 08:22:13 2015] device: 'usb1-port1': device_add
[Thu May 14 08:22:13 2015] device: 'usb1-port2': device_add
[Thu May 14 08:22:13 2015] device: 'usb1-port3': device_add
[Thu May 14 08:22:13 2015] device: 'usb1-port4': device_add
[Thu May 14 08:22:13 2015] driver: 'hub': driver_bound: bound to device '1-=
0:1.0'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device 1-0:1.0 t=
o driver hub
[Thu May 14 08:22:13 2015] device: 'ep_81': device_add
[Thu May 14 08:22:13 2015] driver: 'usb': driver_bound: bound to device 'us=
b1'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device usb1 to d=
river usb
[Thu May 14 08:22:13 2015] device: 'ep_00': device_add
[Thu May 14 08:22:13 2015] xhci_hcd 0000:00:14.0: xHCI Host Controller
[Thu May 14 08:22:13 2015] xhci_hcd 0000:00:14.0: new USB bus registered, a=
ssigned bus number 2
[Thu May 14 08:22:13 2015] usb usb2: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0003
[Thu May 14 08:22:13 2015] usb usb2: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Thu May 14 08:22:13 2015] usb usb2: Product: xHCI Host Controller
[Thu May 14 08:22:13 2015] usb usb2: Manufacturer: Linux 3.18.6-gentoo xhci=
-hcd
[Thu May 14 08:22:13 2015] usb usb2: SerialNumber: 0000:00:14.0
[Thu May 14 08:22:13 2015] device: 'usb2': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device usb2
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
usb2 with driver usb
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb2
[Thu May 14 08:22:13 2015] device: '2-0:1.0': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device 2-0:1.0
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
2-0:1.0 with driver hub
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 2-0:1.0
[Thu May 14 08:22:13 2015] hub 2-0:1.0: USB hub found
[Thu May 14 08:22:13 2015] hub 2-0:1.0: 4 ports detected
[Thu May 14 08:22:13 2015] device: 'usb2-port1': device_add
[Thu May 14 08:22:13 2015] device: 'usb2-port2': device_add
[Thu May 14 08:22:13 2015] device: 'usb2-port3': device_add
[Thu May 14 08:22:13 2015] device: 'usb2-port4': device_add
[Thu May 14 08:22:13 2015] driver: 'hub': driver_bound: bound to device '2-=
0:1.0'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device 2-0:1.0 t=
o driver hub
[Thu May 14 08:22:13 2015] device: 'ep_81': device_add
[Thu May 14 08:22:13 2015] driver: 'usb': driver_bound: bound to device 'us=
b2'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device usb2 to d=
river usb
[Thu May 14 08:22:13 2015] device: 'ep_00': device_add
[Thu May 14 08:22:13 2015] driver: 'xhci_hcd': driver_bound: bound to devic=
e '0000:00:14.0'
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: bound device 0000:00:1=
4.0 to driver xhci_hcd
[Thu May 14 08:22:13 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1a.0 with driver ehci-pci
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: probing driver ehci-pc=
i with device 0000:00:1a.0
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: EHCI Host Controller
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: new USB bus registered, a=
ssigned bus number 3
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: debug port 2
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: cache line size of 64 is =
not supported
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: irq 23, io mem 0xf7818000
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[Thu May 14 08:22:13 2015] usb usb3: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Thu May 14 08:22:13 2015] usb usb3: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Thu May 14 08:22:13 2015] usb usb3: Product: EHCI Host Controller
[Thu May 14 08:22:13 2015] usb usb3: Manufacturer: Linux 3.18.6-gentoo ehci=
_hcd
[Thu May 14 08:22:13 2015] usb usb3: SerialNumber: 0000:00:1a.0
[Thu May 14 08:22:13 2015] device: 'usb3': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device usb3
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
usb3 with driver usb
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb3
[Thu May 14 08:22:13 2015] device: '3-0:1.0': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device 3-0:1.0
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
3-0:1.0 with driver hub
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 3-0:1.0
[Thu May 14 08:22:13 2015] hub 3-0:1.0: USB hub found
[Thu May 14 08:22:13 2015] hub 3-0:1.0: 2 ports detected
[Thu May 14 08:22:13 2015] device: 'usb3-port1': device_add
[Thu May 14 08:22:13 2015] device: 'usb3-port2': device_add
[Thu May 14 08:22:13 2015] driver: 'hub': driver_bound: bound to device '3-=
0:1.0'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device 3-0:1.0 t=
o driver hub
[Thu May 14 08:22:13 2015] device: 'ep_81': device_add
[Thu May 14 08:22:13 2015] driver: 'usb': driver_bound: bound to device 'us=
b3'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device usb3 to d=
river usb
[Thu May 14 08:22:13 2015] device: 'ep_00': device_add
[Thu May 14 08:22:13 2015] driver: 'ehci-pci': driver_bound: bound to devic=
e '0000:00:1a.0'
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: bound device 0000:00:1=
a.0 to driver ehci-pci
[Thu May 14 08:22:13 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1d.0 with driver ehci-pci
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: probing driver ehci-pc=
i with device 0000:00:1d.0
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: EHCI Host Controller
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: new USB bus registered, a=
ssigned bus number 4
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: debug port 2
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: cache line size of 64 is =
not supported
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7817000
[Thu May 14 08:22:13 2015] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[Thu May 14 08:22:13 2015] usb usb4: New USB device found, idVendor=3D1d6b,=
 idProduct=3D0002
[Thu May 14 08:22:13 2015] usb usb4: New USB device strings: Mfr=3D3, Produ=
ct=3D2, SerialNumber=3D1
[Thu May 14 08:22:13 2015] usb usb4: Product: EHCI Host Controller
[Thu May 14 08:22:13 2015] usb usb4: Manufacturer: Linux 3.18.6-gentoo ehci=
_hcd
[Thu May 14 08:22:13 2015] usb usb4: SerialNumber: 0000:00:1d.0
[Thu May 14 08:22:13 2015] device: 'usb4': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device usb4
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
usb4 with driver usb
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver usb wit=
h device usb4
[Thu May 14 08:22:13 2015] device: '4-0:1.0': device_add
[Thu May 14 08:22:13 2015] bus: 'usb': add device 4-0:1.0
[Thu May 14 08:22:13 2015] bus: 'usb': driver_probe_device: matched device =
4-0:1.0 with driver hub
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 4-0:1.0
[Thu May 14 08:22:13 2015] hub 4-0:1.0: USB hub found
[Thu May 14 08:22:13 2015] hub 4-0:1.0: 2 ports detected
[Thu May 14 08:22:13 2015] device: 'usb4-port1': device_add
[Thu May 14 08:22:13 2015] device: 'usb4-port2': device_add
[Thu May 14 08:22:13 2015] driver: 'hub': driver_bound: bound to device '4-=
0:1.0'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device 4-0:1.0 t=
o driver hub
[Thu May 14 08:22:13 2015] device: 'ep_81': device_add
[Thu May 14 08:22:13 2015] driver: 'usb': driver_bound: bound to device 'us=
b4'
[Thu May 14 08:22:13 2015] bus: 'usb': really_probe: bound device usb4 to d=
river usb
[Thu May 14 08:22:13 2015] device: 'ep_00': device_add
[Thu May 14 08:22:13 2015] driver: 'ehci-pci': driver_bound: bound to devic=
e '0000:00:1d.0'
[Thu May 14 08:22:13 2015] bus: 'pci': really_probe: bound device 0000:00:1=
d.0 to driver ehci-pci
[Thu May 14 08:22:13 2015] bus: 'platform': add driver pcspkr
[Thu May 14 08:22:13 2015] bus: 'platform': driver_probe_device: matched de=
vice pcspkr with driver pcspkr
[Thu May 14 08:22:13 2015] bus: 'platform': really_probe: probing driver pc=
spkr with device pcspkr
[Thu May 14 08:22:13 2015] device: 'input4': device_add
[Thu May 14 08:22:13 2015] input: PC Speaker as /devices/platform/pcspkr/in=
put/input4
[Thu May 14 08:22:13 2015] device: 'event4': device_add
[Thu May 14 08:22:13 2015] device: 'card3': device_add
[Thu May 14 08:22:13 2015] device: 'controlC3': device_add
[Thu May 14 08:22:13 2015] device: 'pcmC3D0p': device_add
[Thu May 14 08:22:13 2015] driver: 'pcspkr': driver_bound: bound to device =
'pcspkr'
[Thu May 14 08:22:13 2015] bus: 'platform': really_probe: bound device pcsp=
kr to driver pcspkr
[Thu May 14 08:22:13 2015] bus: 'ac97': registered
[Thu May 14 08:22:14 2015] usb 3-1: new high-speed USB device number 2 usin=
g ehci-pci
[Thu May 14 08:22:14 2015] usb 4-1: new high-speed USB device number 2 usin=
g ehci-pci
[Thu May 14 08:22:14 2015] usb 1-3: new full-speed USB device number 2 usin=
g xhci_hcd
[Thu May 14 08:22:14 2015] usb 3-1: New USB device found, idVendor=3D8087, =
idProduct=3D0024
[Thu May 14 08:22:14 2015] usb 3-1: New USB device strings: Mfr=3D0, Produc=
t=3D0, SerialNumber=3D0
[Thu May 14 08:22:14 2015] device: '3-1': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
3-1 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-1
[Thu May 14 08:22:14 2015] device: '3-1:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1:1.0
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
3-1:1.0 with driver hub
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 3-1:1.0
[Thu May 14 08:22:14 2015] hub 3-1:1.0: USB hub found
[Thu May 14 08:22:14 2015] hub 3-1:1.0: 6 ports detected
[Thu May 14 08:22:14 2015] device: '3-1-port1': device_add
[Thu May 14 08:22:14 2015] device: '3-1-port2': device_add
[Thu May 14 08:22:14 2015] device: '3-1-port3': device_add
[Thu May 14 08:22:14 2015] device: '3-1-port4': device_add
[Thu May 14 08:22:14 2015] device: '3-1-port5': device_add
[Thu May 14 08:22:14 2015] device: '3-1-port6': device_add
[Thu May 14 08:22:14 2015] driver: 'hub': driver_bound: bound to device '3-=
1:1.0'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 3-1:1.0 t=
o driver hub
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '3-=
1'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 3-1 to dr=
iver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] usb 4-1: New USB device found, idVendor=3D8087, =
idProduct=3D0024
[Thu May 14 08:22:14 2015] usb 4-1: New USB device strings: Mfr=3D0, Produc=
t=3D0, SerialNumber=3D0
[Thu May 14 08:22:14 2015] device: '4-1': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
4-1 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 4-1
[Thu May 14 08:22:14 2015] device: '4-1:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1:1.0
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
4-1:1.0 with driver hub
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver hub wit=
h device 4-1:1.0
[Thu May 14 08:22:14 2015] hub 4-1:1.0: USB hub found
[Thu May 14 08:22:14 2015] hub 4-1:1.0: 8 ports detected
[Thu May 14 08:22:14 2015] device: '4-1-port1': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port2': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port3': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port4': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port5': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port6': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port7': device_add
[Thu May 14 08:22:14 2015] device: '4-1-port8': device_add
[Thu May 14 08:22:14 2015] driver: 'hub': driver_bound: bound to device '4-=
1:1.0'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 4-1:1.0 t=
o driver hub
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '4-=
1'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 4-1 to dr=
iver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] bus: 'pci': add driver snd_hda_intel
[Thu May 14 08:22:14 2015] bus: 'pci': driver_probe_device: matched device =
0000:00:1b.0 with driver snd_hda_intel
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: probing driver snd_hda=
_intel with device 0000:00:1b.0
[Thu May 14 08:22:14 2015] driver: 'snd_hda_intel': driver_bound: bound to =
device '0000:00:1b.0'
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: bound device 0000:00:1=
b.0 to driver snd_hda_intel
[Thu May 14 08:22:14 2015] bus: 'pci': add driver snd_emu10k1
[Thu May 14 08:22:14 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:02.0 with driver snd_emu10k1
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: probing driver snd_emu=
10k1 with device 0000:05:02.0
[Thu May 14 08:22:14 2015] snd_emu10k1 0000:05:02.0: Installing spdif_bug p=
atch: SB Audigy 2 ZS [SB0350]
[Thu May 14 08:22:14 2015] device: 'card0': device_add
[Thu May 14 08:22:14 2015] device: 'controlC0': device_add
[Thu May 14 08:22:14 2015] device: '0-0:STAC9721,23': device_add
[Thu May 14 08:22:14 2015] bus: 'ac97': add device 0-0:STAC9721,23
[Thu May 14 08:22:14 2015] device: 'pcmC0D0p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D0c': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D1c': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D2p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D2c': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D3p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D4p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC0D4c': device_add
[Thu May 14 08:22:14 2015] device: 'midiC0D0': device_add
[Thu May 14 08:22:14 2015] device: 'midi': device_add
[Thu May 14 08:22:14 2015] device: 'dmmidi': device_add
[Thu May 14 08:22:14 2015] device: 'midiC0D1': device_add
[Thu May 14 08:22:14 2015] device: 'amidi': device_add
[Thu May 14 08:22:14 2015] device: 'admmidi': device_add
[Thu May 14 08:22:14 2015] device: 'hwC0D0': device_add
[Thu May 14 08:22:14 2015] driver: 'snd_emu10k1': driver_bound: bound to de=
vice '0000:05:02.0'
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: bound device 0000:05:0=
2.0 to driver snd_emu10k1
[Thu May 14 08:22:14 2015] bus: 'platform': add driver coretemp
[Thu May 14 08:22:14 2015] Registering platform device 'coretemp.0'. Parent=
 at platform
[Thu May 14 08:22:14 2015] device: 'coretemp.0': device_add
[Thu May 14 08:22:14 2015] bus: 'platform': add device coretemp.0
[Thu May 14 08:22:14 2015] bus: 'platform': driver_probe_device: matched de=
vice coretemp.0 with driver coretemp
[Thu May 14 08:22:14 2015] bus: 'platform': really_probe: probing driver co=
retemp with device coretemp.0
[Thu May 14 08:22:14 2015] device: 'hwmon1': device_add
[Thu May 14 08:22:14 2015] driver: 'coretemp': driver_bound: bound to devic=
e 'coretemp.0'
[Thu May 14 08:22:14 2015] bus: 'platform': really_probe: bound device core=
temp.0 to driver coretemp
[Thu May 14 08:22:14 2015] device: 'thermal_zone2': device_add
[Thu May 14 08:22:14 2015] usb 1-3: New USB device found, idVendor=3D06e1, =
idProduct=3Da155
[Thu May 14 08:22:14 2015] usb 1-3: New USB device strings: Mfr=3D1, Produc=
t=3D2, SerialNumber=3D0
[Thu May 14 08:22:14 2015] usb 1-3: Product: ADS InstantFM Music
[Thu May 14 08:22:14 2015] usb 1-3: Manufacturer: ADS TECH
[Thu May 14 08:22:14 2015] device: '1-3': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 1-3
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
1-3 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 1-3
[Thu May 14 08:22:14 2015] usb 1-3: ep 0x81 - rounding interval to 64 micro=
frames, ep desc says 80 microframes
[Thu May 14 08:22:14 2015] device: '1-3:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 1-3:1.0
[Thu May 14 08:22:14 2015] device: '1-3:1.1': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 1-3:1.1
[Thu May 14 08:22:14 2015] device: '1-3:1.2': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 1-3:1.2
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] device: 'ep_02': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '1-=
3'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 1-3 to dr=
iver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] bus: 'pci': add driver cx88-mpeg driver manager
[Thu May 14 08:22:14 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.2 with driver cx88-mpeg driver manager
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: probing driver cx88-mp=
eg driver manager with device 0000:05:01.2
[Thu May 14 08:22:14 2015] cx88[0]: subsystem: 7063:5500, board: pcHDTV HD5=
500 HDTV [card=3D47,autodetected], frontend(s): 1
[Thu May 14 08:22:14 2015] bus: 'pci': add driver cx88_audio
[Thu May 14 08:22:14 2015] bus: 'pci': add driver cx8800
[Thu May 14 08:22:14 2015] usb 3-1.3: new high-speed USB device number 3 us=
ing ehci-pci
[Thu May 14 08:22:14 2015] usb 4-1.5: new low-speed USB device number 3 usi=
ng ehci-pci
[Thu May 14 08:22:14 2015] device: 'i2c-8': device_add
[Thu May 14 08:22:14 2015] bus: 'i2c': add device i2c-8
[Thu May 14 08:22:14 2015] sound hdaudioC5D0: autoconfig: line_outs=3D1 (0x=
14/0x0/0x0/0x0/0x0) type:line
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:    speaker_outs=3D0 (0x0/0x0/=
0x0/0x0/0x0)
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:    hp_outs=3D1 (0x1b/0x0/0x0/=
0x0/0x0)
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:    mono: mono_out=3D0x0
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:    dig-out=3D0x11/0x1e
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:    inputs:
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:      Front Mic=3D0x19
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:      Rear Mic=3D0x18
[Thu May 14 08:22:14 2015] sound hdaudioC5D0:      Line=3D0x1a
[Thu May 14 08:22:14 2015] sound hdaudioC5D3: autoconfig: line_outs=3D0 (0x=
0/0x0/0x0/0x0/0x0) type:line
[Thu May 14 08:22:14 2015] sound hdaudioC5D3:    speaker_outs=3D0 (0x0/0x0/=
0x0/0x0/0x0)
[Thu May 14 08:22:14 2015] sound hdaudioC5D3:    hp_outs=3D0 (0x0/0x0/0x0/0=
x0/0x0)
[Thu May 14 08:22:14 2015] sound hdaudioC5D3:    mono: mono_out=3D0x0
[Thu May 14 08:22:14 2015] sound hdaudioC5D3:    dig-out=3D0x7/0x0
[Thu May 14 08:22:14 2015] sound hdaudioC5D3:    inputs:
[Thu May 14 08:22:14 2015] device: 'card5': device_add
[Thu May 14 08:22:14 2015] device: 'controlC5': device_add
[Thu May 14 08:22:14 2015] device: 'hdaudioC5D0': device_add
[Thu May 14 08:22:14 2015] device: 'hdaudioC5D3': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC5D0p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC5D0c': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC5D1p': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC5D2c': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC5D3p': device_add
[Thu May 14 08:22:14 2015] device: 'hwC5D0': device_add
[Thu May 14 08:22:14 2015] device: 'hwC5D3': device_add
[Thu May 14 08:22:14 2015] device: 'input5': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH Front Mic as /devices/pci00=
00:00/0000:00:1b.0/sound/card5/input5
[Thu May 14 08:22:14 2015] device: 'event5': device_add
[Thu May 14 08:22:14 2015] device: 'input6': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH Rear Mic as /devices/pci000=
0:00/0000:00:1b.0/sound/card5/input6
[Thu May 14 08:22:14 2015] device: 'event6': device_add
[Thu May 14 08:22:14 2015] device: 'input7': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH Line as /devices/pci0000:00=
/0000:00:1b.0/sound/card5/input7
[Thu May 14 08:22:14 2015] device: 'event7': device_add
[Thu May 14 08:22:14 2015] device: 'input8': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH Line Out as /devices/pci000=
0:00/0000:00:1b.0/sound/card5/input8
[Thu May 14 08:22:14 2015] device: 'event8': device_add
[Thu May 14 08:22:14 2015] device: 'input9': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH Front Headphone as /devices=
/pci0000:00/0000:00:1b.0/sound/card5/input9
[Thu May 14 08:22:14 2015] device: 'event9': device_add
[Thu May 14 08:22:14 2015] device: 'input10': device_add
[Thu May 14 08:22:14 2015] input: HDA Intel PCH HDMI as /devices/pci0000:00=
/0000:00:1b.0/sound/card5/input10
[Thu May 14 08:22:14 2015] device: 'event10': device_add
[Thu May 14 08:22:14 2015] usb 3-1.3: New USB device found, idVendor=3D0bda=
, idProduct=3D8176
[Thu May 14 08:22:14 2015] usb 3-1.3: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D3
[Thu May 14 08:22:14 2015] usb 3-1.3: Product: 802.11n WLAN Adapter
[Thu May 14 08:22:14 2015] usb 3-1.3: Manufacturer: Realtek
[Thu May 14 08:22:14 2015] usb 3-1.3: SerialNumber: 00e04c000001
[Thu May 14 08:22:14 2015] device: '3-1.3': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1.3
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
3-1.3 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-1.3
[Thu May 14 08:22:14 2015] device: '3-1.3:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1.3:1.0
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] device: 'ep_02': device_add
[Thu May 14 08:22:14 2015] device: 'ep_03': device_add
[Thu May 14 08:22:14 2015] device: 'ep_84': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '3-=
1.3'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 3-1.3 to =
driver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] usb 4-1.5: New USB device found, idVendor=3D046d=
, idProduct=3Dc01b
[Thu May 14 08:22:14 2015] usb 4-1.5: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D0
[Thu May 14 08:22:14 2015] usb 4-1.5: Product: USB-PS/2 Optical Mouse
[Thu May 14 08:22:14 2015] usb 4-1.5: Manufacturer: Logitech
[Thu May 14 08:22:14 2015] device: '4-1.5': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1.5
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
4-1.5 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 4-1.5
[Thu May 14 08:22:14 2015] device: '4-1.5:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1.5:1.0
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '4-=
1.5'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 4-1.5 to =
driver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] usb 3-1.4: new full-speed USB device number 4 us=
ing ehci-pci
[Thu May 14 08:22:14 2015] usb 4-1.6: new high-speed USB device number 4 us=
ing ehci-pci
[Thu May 14 08:22:14 2015] bus: 'i2c': add driver tuner
[Thu May 14 08:22:14 2015] device: '8-0043': device_add
[Thu May 14 08:22:14 2015] bus: 'i2c': add device 8-0043
[Thu May 14 08:22:14 2015] bus: 'i2c': driver_probe_device: matched device =
8-0043 with driver tuner
[Thu May 14 08:22:14 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 8-0043
[Thu May 14 08:22:14 2015] tda9887 8-0043: creating new instance
[Thu May 14 08:22:14 2015] tda9887 8-0043: tda988[5/6/7] found
[Thu May 14 08:22:14 2015] tuner 8-0043: Tuner 74 found with type(s) Radio =
TV.
[Thu May 14 08:22:14 2015] driver: 'tuner': driver_bound: bound to device '=
8-0043'
[Thu May 14 08:22:14 2015] bus: 'i2c': really_probe: bound device 8-0043 to=
 driver tuner
[Thu May 14 08:22:14 2015] device: '8-0061': device_add
[Thu May 14 08:22:14 2015] bus: 'i2c': add device 8-0061
[Thu May 14 08:22:14 2015] bus: 'i2c': driver_probe_device: matched device =
8-0061 with driver tuner
[Thu May 14 08:22:14 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 8-0061
[Thu May 14 08:22:14 2015] tuner 8-0061: Tuner -1 found with type(s) Radio =
TV.
[Thu May 14 08:22:14 2015] driver: 'tuner': driver_bound: bound to device '=
8-0061'
[Thu May 14 08:22:14 2015] bus: 'i2c': really_probe: bound device 8-0061 to=
 driver tuner
[Thu May 14 08:22:14 2015] usb 4-1.6: New USB device found, idVendor=3D04e8=
, idProduct=3D342d
[Thu May 14 08:22:14 2015] usb 4-1.6: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D3
[Thu May 14 08:22:14 2015] usb 4-1.6: Product: SCX-4x28 Series
[Thu May 14 08:22:14 2015] usb 4-1.6: Manufacturer: Samsung Electronics Co.=
, Ltd.
[Thu May 14 08:22:14 2015] usb 4-1.6: SerialNumber: 9H61BAIS500282A
[Thu May 14 08:22:14 2015] device: '4-1.6': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1.6
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
4-1.6 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 4-1.6
[Thu May 14 08:22:14 2015] device: '4-1.6:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1.6:1.0
[Thu May 14 08:22:14 2015] device: 'ep_03': device_add
[Thu May 14 08:22:14 2015] device: 'ep_84': device_add
[Thu May 14 08:22:14 2015] device: '4-1.6:1.1': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 4-1.6:1.1
[Thu May 14 08:22:14 2015] device: 'ep_01': device_add
[Thu May 14 08:22:14 2015] device: 'ep_82': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '4-=
1.6'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 4-1.6 to =
driver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] usb 3-1.4: New USB device found, idVendor=3D0a12=
, idProduct=3D0001
[Thu May 14 08:22:14 2015] usb 3-1.4: New USB device strings: Mfr=3D0, Prod=
uct=3D0, SerialNumber=3D0
[Thu May 14 08:22:14 2015] device: '3-1.4': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1.4
[Thu May 14 08:22:14 2015] bus: 'usb': driver_probe_device: matched device =
3-1.4 with driver usb
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-1.4
[Thu May 14 08:22:14 2015] device: '3-1.4:1.0': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1.4:1.0
[Thu May 14 08:22:14 2015] device: 'ep_81': device_add
[Thu May 14 08:22:14 2015] device: 'ep_02': device_add
[Thu May 14 08:22:14 2015] device: 'ep_82': device_add
[Thu May 14 08:22:14 2015] device: '3-1.4:1.1': device_add
[Thu May 14 08:22:14 2015] bus: 'usb': add device 3-1.4:1.1
[Thu May 14 08:22:14 2015] device: 'ep_03': device_add
[Thu May 14 08:22:14 2015] device: 'ep_83': device_add
[Thu May 14 08:22:14 2015] driver: 'usb': driver_bound: bound to device '3-=
1.4'
[Thu May 14 08:22:14 2015] bus: 'usb': really_probe: bound device 3-1.4 to =
driver usb
[Thu May 14 08:22:14 2015] device: 'ep_00': device_add
[Thu May 14 08:22:14 2015] tuner-simple 8-0061: creating new instance
[Thu May 14 08:22:14 2015] tuner-simple 8-0061: type set to 64 (LG TDVS-H06=
xF)
[Thu May 14 08:22:14 2015] Registered IR keymap rc-hauppauge
[Thu May 14 08:22:14 2015] device: 'rc0': device_add
[Thu May 14 08:22:14 2015] device: 'input11': device_add
[Thu May 14 08:22:14 2015] input: cx88 IR (pcHDTV HD5500 HDTV) as /devices/=
pci0000:00/0000:00:1c.5/0000:04:00.0/0000:05:01.2/rc/rc0/input11
[Thu May 14 08:22:14 2015] device: 'event11': device_add
[Thu May 14 08:22:14 2015] rc0: cx88 IR (pcHDTV HD5500 HDTV) as /devices/pc=
i0000:00/0000:00:1c.5/0000:04:00.0/0000:05:01.2/rc/rc0
[Thu May 14 08:22:14 2015] device: 'lirc0': device_add
[Thu May 14 08:22:14 2015] rc rc0: lirc_dev: driver ir-lirc-codec (cx88xx) =
registered at minor =3D 0
[Thu May 14 08:22:14 2015] cx88[0]/2: cx2388x 8802 Driver Manager
[Thu May 14 08:22:14 2015] cx88[0]/2: found at 0000:05:01.2, rev: 5, irq: 1=
8, latency: 64, mmio: 0xf3000000
[Thu May 14 08:22:14 2015] driver: 'cx88-mpeg driver manager': driver_bound=
: bound to device '0000:05:01.2'
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.2 to driver cx88-mpeg driver manager
[Thu May 14 08:22:14 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.1 with driver cx88_audio
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: probing driver cx88_au=
dio with device 0000:05:01.1
[Thu May 14 08:22:14 2015] cx88[0]/1: CX88x/0: ALSA support for cx2388x boa=
rds
[Thu May 14 08:22:14 2015] device: 'card1': device_add
[Thu May 14 08:22:14 2015] device: 'controlC1': device_add
[Thu May 14 08:22:14 2015] device: 'pcmC1D0c': device_add
[Thu May 14 08:22:14 2015] driver: 'cx88_audio': driver_bound: bound to dev=
ice '0000:05:01.1'
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.1 to driver cx88_audio
[Thu May 14 08:22:14 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:00.0 with driver cx8800
[Thu May 14 08:22:14 2015] bus: 'pci': really_probe: probing driver cx8800 =
with device 0000:05:00.0
[Thu May 14 08:22:14 2015] cx88[1]: subsystem: 1002:00f9, board: ATI TV Won=
der Pro [card=3D4,autodetected], frontend(s): 0
[Thu May 14 08:22:14 2015] usb 4-1.7: new low-speed USB device number 5 usi=
ng ehci-pci
[Thu May 14 08:22:14 2015] usb 3-1.5: new high-speed USB device number 5 us=
ing ehci-pci
[Thu May 14 08:22:14 2015] cx88/2: cx2388x dvb driver version 0.0.9 loaded
[Thu May 14 08:22:14 2015] cx88/2: registering cx8802 driver, type: dvb acc=
ess: shared
[Thu May 14 08:22:14 2015] cx88[0]/2: subsystem: 7063:5500, board: pcHDTV H=
D5500 HDTV [card=3D47]
[Thu May 14 08:22:14 2015] cx88[0]/2: cx2388x based DVB/ATSC card
[Thu May 14 08:22:14 2015] cx8802_alloc_frontends() allocating 1 frontend(s)
[Thu May 14 08:22:15 2015] device: 'i2c-9': device_add
[Thu May 14 08:22:15 2015] bus: 'i2c': add device i2c-9
[Thu May 14 08:22:15 2015] device: '9-0060': device_add
[Thu May 14 08:22:15 2015] bus: 'i2c': add device 9-0060
[Thu May 14 08:22:15 2015] bus: 'i2c': driver_probe_device: matched device =
9-0060 with driver tuner
[Thu May 14 08:22:15 2015] bus: 'i2c': really_probe: probing driver tuner w=
ith device 9-0060
[Thu May 14 08:22:15 2015] All bytes are equal. It is not a TEA5767
[Thu May 14 08:22:15 2015] tuner 9-0060: Tuner -1 found with type(s) Radio =
TV.
[Thu May 14 08:22:15 2015] driver: 'tuner': driver_bound: bound to device '=
9-0060'
[Thu May 14 08:22:15 2015] bus: 'i2c': really_probe: bound device 9-0060 to=
 driver tuner
[Thu May 14 08:22:15 2015] usb 4-1.7: New USB device found, idVendor=3D04fc=
, idProduct=3D0538
[Thu May 14 08:22:15 2015] usb 4-1.7: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D0
[Thu May 14 08:22:15 2015] usb 4-1.7: Product: 2.4G wireless optical mouse
[Thu May 14 08:22:15 2015] usb 4-1.7: Manufacturer: MLK
[Thu May 14 08:22:15 2015] device: '4-1.7': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 4-1.7
[Thu May 14 08:22:15 2015] bus: 'usb': driver_probe_device: matched device =
4-1.7 with driver usb
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 4-1.7
[Thu May 14 08:22:15 2015] device: '4-1.7:1.0': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 4-1.7:1.0
[Thu May 14 08:22:15 2015] device: 'ep_81': device_add
[Thu May 14 08:22:15 2015] driver: 'usb': driver_bound: bound to device '4-=
1.7'
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: bound device 4-1.7 to =
driver usb
[Thu May 14 08:22:15 2015] device: 'ep_00': device_add
[Thu May 14 08:22:15 2015] usb 3-1.5: New USB device found, idVendor=3D0bb4=
, idProduct=3D0cae
[Thu May 14 08:22:15 2015] usb 3-1.5: New USB device strings: Mfr=3D2, Prod=
uct=3D3, SerialNumber=3D4
[Thu May 14 08:22:15 2015] usb 3-1.5: Product: MyTouch
[Thu May 14 08:22:15 2015] usb 3-1.5: Manufacturer: HTC
[Thu May 14 08:22:15 2015] usb 3-1.5: SerialNumber: HT179TB01627
[Thu May 14 08:22:15 2015] device: '3-1.5': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 3-1.5
[Thu May 14 08:22:15 2015] bus: 'usb': driver_probe_device: matched device =
3-1.5 with driver usb
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-1.5
[Thu May 14 08:22:15 2015] device: '3-1.5:1.0': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 3-1.5:1.0
[Thu May 14 08:22:15 2015] device: 'ep_81': device_add
[Thu May 14 08:22:15 2015] device: 'ep_01': device_add
[Thu May 14 08:22:15 2015] device: '3-1.5:1.1': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 3-1.5:1.1
[Thu May 14 08:22:15 2015] device: 'ep_82': device_add
[Thu May 14 08:22:15 2015] device: 'ep_02': device_add
[Thu May 14 08:22:15 2015] driver: 'usb': driver_bound: bound to device '3-=
1.5'
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: bound device 3-1.5 to =
driver usb
[Thu May 14 08:22:15 2015] device: 'ep_00': device_add
[Thu May 14 08:22:15 2015] tuner-simple 9-0060: creating new instance
[Thu May 14 08:22:15 2015] tuner-simple 9-0060: type set to 44 (Philips 4 i=
n 1 (ATI TV Wonder Pro/Conexant))
[Thu May 14 08:22:15 2015] cx88[1]/0: found at 0000:05:00.0, rev: 5, irq: 1=
7, latency: 64, mmio: 0xf6000000
[Thu May 14 08:22:15 2015] device: 'video0': device_add
[Thu May 14 08:22:15 2015] cx88[1]/0: registered device video0 [v4l2]
[Thu May 14 08:22:15 2015] device: 'vbi0': device_add
[Thu May 14 08:22:15 2015] cx88[1]/0: registered device vbi0
[Thu May 14 08:22:15 2015] driver: 'cx8800': driver_bound: bound to device =
'0000:05:00.0'
[Thu May 14 08:22:15 2015] bus: 'pci': really_probe: bound device 0000:05:0=
0.0 to driver cx8800
[Thu May 14 08:22:15 2015] bus: 'pci': driver_probe_device: matched device =
0000:05:01.0 with driver cx8800
[Thu May 14 08:22:15 2015] bus: 'pci': really_probe: probing driver cx8800 =
with device 0000:05:01.0
[Thu May 14 08:22:15 2015] cx88[0]/0: found at 0000:05:01.0, rev: 5, irq: 1=
8, latency: 64, mmio: 0xf5000000
[Thu May 14 08:22:15 2015] usb 3-1.6: new high-speed USB device number 6 us=
ing ehci-pci
[Thu May 14 08:22:15 2015] tuner-simple 8-0061: attaching existing instance
[Thu May 14 08:22:15 2015] tuner-simple 8-0061: type set to 64 (LG TDVS-H06=
xF)
[Thu May 14 08:22:15 2015] tda9887 8-0043: attaching existing instance
[Thu May 14 08:22:15 2015] usb 3-1.6: New USB device found, idVendor=3D0951=
, idProduct=3D1666
[Thu May 14 08:22:15 2015] usb 3-1.6: New USB device strings: Mfr=3D1, Prod=
uct=3D2, SerialNumber=3D3
[Thu May 14 08:22:15 2015] usb 3-1.6: Product: DataTraveler 3.0
[Thu May 14 08:22:15 2015] usb 3-1.6: Manufacturer: Kingston
[Thu May 14 08:22:15 2015] usb 3-1.6: SerialNumber: 60A44C42568CBEA119890097
[Thu May 14 08:22:15 2015] device: '3-1.6': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 3-1.6
[Thu May 14 08:22:15 2015] bus: 'usb': driver_probe_device: matched device =
3-1.6 with driver usb
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: probing driver usb wit=
h device 3-1.6
[Thu May 14 08:22:15 2015] device: '3-1.6:1.0': device_add
[Thu May 14 08:22:15 2015] bus: 'usb': add device 3-1.6:1.0
[Thu May 14 08:22:15 2015] device: 'ep_81': device_add
[Thu May 14 08:22:15 2015] device: 'ep_02': device_add
[Thu May 14 08:22:15 2015] driver: 'usb': driver_bound: bound to device '3-=
1.6'
[Thu May 14 08:22:15 2015] bus: 'usb': really_probe: bound device 3-1.6 to =
driver usb
[Thu May 14 08:22:15 2015] device: 'ep_00': device_add
[Thu May 14 08:22:15 2015] DVB: registering new adapter (cx88[0])
[Thu May 14 08:22:15 2015] cx88-mpeg driver manager 0000:05:01.2: DVB: regi=
stering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM Frontend)...
[Thu May 14 08:22:15 2015] device: 'dvb0.frontend0': device_add
[Thu May 14 08:22:15 2015] device: 'dvb0.demux0': device_add
[Thu May 14 08:22:15 2015] device: 'dvb0.dvr0': device_add
[Thu May 14 08:22:15 2015] device: 'dvb0.net0': device_add
[Thu May 14 08:22:15 2015] device: 'video1': device_add
[Thu May 14 08:22:15 2015] cx88[0]/0: registered device video1 [v4l2]
[Thu May 14 08:22:15 2015] device: 'vbi1': device_add
[Thu May 14 08:22:15 2015] cx88[0]/0: registered device vbi1
[Thu May 14 08:22:15 2015] driver: 'cx8800': driver_bound: bound to device =
'0000:05:01.0'
[Thu May 14 08:22:15 2015] bus: 'pci': really_probe: bound device 0000:05:0=
1.0 to driver cx8800
[Thu May 14 08:22:16 2015] bus: 'usb': add driver usblp
[Thu May 14 08:22:16 2015] bus: 'usb': driver_probe_device: matched device =
4-1.6:1.1 with driver usblp
[Thu May 14 08:22:16 2015] bus: 'usb': really_probe: probing driver usblp w=
ith device 4-1.6:1.1
[Thu May 14 08:22:16 2015] device class 'usbmisc': registering
[Thu May 14 08:22:16 2015] device: 'lp0': device_add
[Thu May 14 08:22:16 2015] usblp 4-1.6:1.1: usblp0: USB Bidirectional print=
er dev 4 if 1 alt 0 proto 2 vid 0x04E8 pid 0x342D
[Thu May 14 08:22:16 2015] driver: 'usblp': driver_bound: bound to device '=
4-1.6:1.1'
[Thu May 14 08:22:16 2015] bus: 'usb': really_probe: bound device 4-1.6:1.1=
 to driver usblp
[Thu May 14 08:22:16 2015] usbcore: registered new interface driver usblp
[Thu May 14 08:22:16 2015] nvidia: module license 'NVIDIA' taints kernel.
[Thu May 14 08:22:16 2015] Disabling lock debugging due to kernel taint
[Thu May 14 08:22:16 2015] bus: 'pci': add driver nvidia
[Thu May 14 08:22:16 2015] bus: 'pci': driver_probe_device: matched device =
0000:01:00.0 with driver nvidia
[Thu May 14 08:22:16 2015] bus: 'pci': really_probe: probing driver nvidia =
with device 0000:01:00.0
[Thu May 14 08:22:16 2015] nvidia 0000:01:00.0: enabling device (0000 -> 00=
03)
[Thu May 14 08:22:16 2015] vgaarb: device changed decodes: PCI:0000:01:00.0=
,olddecodes=3Dio+mem,decodes=3Dnone:owns=3Dnone
[Thu May 14 08:22:16 2015] driver: 'nvidia': driver_bound: bound to device =
'0000:01:00.0'
[Thu May 14 08:22:16 2015] bus: 'pci': really_probe: bound device 0000:01:0=
0.0 to driver nvidia
[Thu May 14 08:22:16 2015] device: 'card1': device_add
[Thu May 14 08:22:16 2015] [drm] Initialized nvidia-drm 0.0.0 20150116 for =
0000:01:00.0 on minor 1
[Thu May 14 08:22:16 2015] NVRM: loading NVIDIA UNIX x86 Kernel Module  340=
=2E76  Thu Jan 22 11:21:06 PST 2015
[Thu May 14 08:22:16 2015] Bluetooth: Core ver 2.19
[Thu May 14 08:22:16 2015] device class 'bluetooth': registering
[Thu May 14 08:22:16 2015] NET: Registered protocol family 31
[Thu May 14 08:22:16 2015] Bluetooth: HCI device and connection manager ini=
tialized
[Thu May 14 08:22:16 2015] Bluetooth: HCI socket layer initialized
[Thu May 14 08:22:16 2015] Bluetooth: L2CAP socket layer initialized
[Thu May 14 08:22:16 2015] Bluetooth: SCO socket layer initialized
[Thu May 14 08:22:17 2015] bus: 'usb': add driver btusb
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
3-1.4:1.0 with driver btusb
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver btusb w=
ith device 3-1.4:1.0
[Thu May 14 08:22:17 2015] driver: 'btusb': driver_bound: bound to device '=
3-1.4:1.1'
[Thu May 14 08:22:17 2015] device: 'hci0': device_add
[Thu May 14 08:22:17 2015] driver: 'btusb': driver_bound: bound to device '=
3-1.4:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 3-1.4:1.0=
 to driver btusb
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver btusb
[Thu May 14 08:22:17 2015] bus: 'usb': add driver snd-usb-audio
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
1-3:1.0 with driver snd-usb-audio
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver snd-usb=
-audio with device 1-3:1.0
[Thu May 14 08:22:17 2015] device: 'ep_83': device_add
[Thu May 14 08:22:17 2015] device: 'ep_83': device_unregister
[Thu May 14 08:22:17 2015] driver: 'snd-usb-audio': driver_bound: bound to =
device '1-3:1.1'
[Thu May 14 08:22:17 2015] device: 'card2': device_add
[Thu May 14 08:22:17 2015] device: 'controlC2': device_add
[Thu May 14 08:22:17 2015] device: 'pcmC2D0c': device_add
[Thu May 14 08:22:17 2015] driver: 'snd-usb-audio': driver_bound: bound to =
device '1-3:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 1-3:1.0 t=
o driver snd-usb-audio
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver snd-usb=
-audio
[Thu May 14 08:22:17 2015] bus: 'usb': add driver usb-storage
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
3-1.5:1.0 with driver usb-storage
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver usb-sto=
rage with device 3-1.5:1.0
[Thu May 14 08:22:17 2015] usb-storage 3-1.5:1.0: USB Mass Storage device d=
etected
[Thu May 14 08:22:17 2015] scsi host8: usb-storage 3-1.5:1.0
[Thu May 14 08:22:17 2015] device: 'host8': device_add
[Thu May 14 08:22:17 2015] bus: 'scsi': add device host8
[Thu May 14 08:22:17 2015] device: 'host8': device_add
[Thu May 14 08:22:17 2015] driver: 'usb-storage': driver_bound: bound to de=
vice '3-1.5:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 3-1.5:1.0=
 to driver usb-storage
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
3-1.6:1.0 with driver usb-storage
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver usb-sto=
rage with device 3-1.6:1.0
[Thu May 14 08:22:17 2015] usb-storage 3-1.6:1.0: USB Mass Storage device d=
etected
[Thu May 14 08:22:17 2015] scsi host9: usb-storage 3-1.6:1.0
[Thu May 14 08:22:17 2015] device: 'host9': device_add
[Thu May 14 08:22:17 2015] bus: 'scsi': add device host9
[Thu May 14 08:22:17 2015] device: 'host9': device_add
[Thu May 14 08:22:17 2015] driver: 'usb-storage': driver_bound: bound to de=
vice '3-1.6:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 3-1.6:1.0=
 to driver usb-storage
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver usb-sto=
rage
[Thu May 14 08:22:17 2015] device class 'ieee80211': registering
[Thu May 14 08:22:17 2015] Registering platform device 'regulatory.0'. Pare=
nt at platform
[Thu May 14 08:22:17 2015] device: 'regulatory.0': device_add
[Thu May 14 08:22:17 2015] bus: 'platform': add device regulatory.0
[Thu May 14 08:22:17 2015] cfg80211: Calling CRDA to update world regulator=
y domain
[Thu May 14 08:22:17 2015] bus: 'usb': add driver uas
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver uas
[Thu May 14 08:22:17 2015] bus: 'usb': add driver radio-si470x
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
1-3:1.2 with driver radio-si470x
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver radio-s=
i470x with device 1-3:1.2
[Thu May 14 08:22:17 2015] radio-si470x 1-3:1.2: DeviceID=3D0x1242 ChipID=
=3D0x0a0f
[Thu May 14 08:22:17 2015] radio-si470x 1-3:1.2: software version 0, hardwa=
re version 7
[Thu May 14 08:22:17 2015] bus: 'usb': add driver rtl8192cu
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
3-1.3:1.0 with driver rtl8192cu
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver rtl8192=
cu with device 3-1.3:1.0
[Thu May 14 08:22:17 2015] rtl8192cu: Chip version 0x10
[Thu May 14 08:22:17 2015] bus: 'usb': add driver usbhid
[Thu May 14 08:22:17 2015] rtl8192cu: MAC address: e8:4e:06:00:66:62
[Thu May 14 08:22:17 2015] rtl8192cu: Board Type 0
[Thu May 14 08:22:17 2015] rtl_usb: rx_max_size 15360, rx_urb_num 8, in_ep 1
[Thu May 14 08:22:17 2015] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw_=
TMSC.bin
[Thu May 14 08:22:17 2015] device: 'phy0': device_add
[Thu May 14 08:22:17 2015] __allocate_fw_buf: fw-rtlwifi/rtl8192cufw_TMSC.b=
in buf=3Decd07240
[Thu May 14 08:22:17 2015] usb 3-1.3: Direct firmware load for rtlwifi/rtl8=
192cufw_TMSC.bin failed with error -2
[Thu May 14 08:22:17 2015] __fw_free_buf: fw-rtlwifi/rtl8192cufw_TMSC.bin b=
uf=3Decd07240 data=3D  (null) size=3D0
[Thu May 14 08:22:17 2015] __allocate_fw_buf: fw-rtlwifi/rtl8192cufw.bin bu=
f=3Decd07240
[Thu May 14 08:22:17 2015] device: 'radio0': device_add
[Thu May 14 08:22:17 2015] driver: 'radio-si470x': driver_bound: bound to d=
evice '1-3:1.2'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 1-3:1.2 t=
o driver radio-si470x
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
4-1.5:1.0 with driver usbhid
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver usbhid =
with device 4-1.5:1.0
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver radio-s=
i470x
[Thu May 14 08:22:17 2015] device: '0003:046D:C01B.0001': device_add
[Thu May 14 08:22:17 2015] bus: 'hid': add device 0003:046D:C01B.0001
[Thu May 14 08:22:17 2015] bus: 'hid': driver_probe_device: matched device =
0003:046D:C01B.0001 with driver hid-generic
[Thu May 14 08:22:17 2015] bus: 'hid': really_probe: probing driver hid-gen=
eric with device 0003:046D:C01B.0001
[Thu May 14 08:22:17 2015] device: 'input13': device_add
[Thu May 14 08:22:17 2015] input: Logitech USB-PS/2 Optical Mouse as /devic=
es/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.5/4-1.5:1.0/0003:046D:C01B.0001/inp=
ut/input13
[Thu May 14 08:22:17 2015] device: 'mouse0': device_add
[Thu May 14 08:22:17 2015] device: 'event12': device_add
[Thu May 14 08:22:17 2015] device: 'hidraw0': device_add
[Thu May 14 08:22:17 2015] hid-generic 0003:046D:C01B.0001: input,hidraw0: =
USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1=
=2E5/input0
[Thu May 14 08:22:17 2015] driver: 'hid-generic': driver_bound: bound to de=
vice '0003:046D:C01B.0001'
[Thu May 14 08:22:17 2015] bus: 'hid': really_probe: bound device 0003:046D=
:C01B.0001 to driver hid-generic
[Thu May 14 08:22:17 2015] driver: 'usbhid': driver_bound: bound to device =
'4-1.5:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 4-1.5:1.0=
 to driver usbhid
[Thu May 14 08:22:17 2015] bus: 'usb': driver_probe_device: matched device =
4-1.7:1.0 with driver usbhid
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: probing driver usbhid =
with device 4-1.7:1.0
[Thu May 14 08:22:17 2015] device: '0003:04FC:0538.0002': device_add
[Thu May 14 08:22:17 2015] bus: 'hid': add device 0003:04FC:0538.0002
[Thu May 14 08:22:17 2015] bus: 'hid': driver_probe_device: matched device =
0003:04FC:0538.0002 with driver hid-generic
[Thu May 14 08:22:17 2015] bus: 'hid': really_probe: probing driver hid-gen=
eric with device 0003:04FC:0538.0002
[Thu May 14 08:22:17 2015] device: 'input14': device_add
[Thu May 14 08:22:17 2015] input: MLK 2.4G wireless optical mouse as /devic=
es/pci0000:00/0000:00:1d.0/usb4/4-1/4-1.7/4-1.7:1.0/0003:04FC:0538.0002/inp=
ut/input14
[Thu May 14 08:22:17 2015] device: 'mouse1': device_add
[Thu May 14 08:22:17 2015] device: 'event13': device_add
[Thu May 14 08:22:17 2015] device: 'hiddev0': device_add
[Thu May 14 08:22:17 2015] device: 'hidraw1': device_add
[Thu May 14 08:22:17 2015] hid-generic 0003:04FC:0538.0002: input,hiddev0,h=
idraw1: USB HID v1.10 Mouse [MLK 2.4G wireless optical mouse] on usb-0000:0=
0:1d.0-1.7/input0
[Thu May 14 08:22:17 2015] driver: 'hid-generic': driver_bound: bound to de=
vice '0003:04FC:0538.0002'
[Thu May 14 08:22:17 2015] bus: 'hid': really_probe: bound device 0003:04FC=
:0538.0002 to driver hid-generic
[Thu May 14 08:22:17 2015] driver: 'usbhid': driver_bound: bound to device =
'4-1.7:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 4-1.7:1.0=
 to driver usbhid
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver usbhid
[Thu May 14 08:22:17 2015] usbhid: USB HID core driver
[Thu May 14 08:22:17 2015] usb 3-1.3: firmware: direct-loading firmware rtl=
wifi/rtl8192cufw.bin
[Thu May 14 08:22:17 2015] fw_set_page_data: fw-rtlwifi/rtl8192cufw.bin buf=
=3Decd07240 data=3Df88bd000 size=3D16014
[Thu May 14 08:22:17 2015] rtlwifi: Loading alternative firmware rtlwifi/rt=
l8192cufw.bin
[Thu May 14 08:22:17 2015] __fw_free_buf: fw-rtlwifi/rtl8192cufw.bin buf=3D=
ecd07240 data=3Df88bd000 size=3D16014
[Thu May 14 08:22:17 2015] ieee80211 phy0: Selected rate control algorithm =
'rtl_rc'
[Thu May 14 08:22:17 2015] device: 'wlan0': device_add
[Thu May 14 08:22:17 2015] driver: 'rtl8192cu': driver_bound: bound to devi=
ce '3-1.3:1.0'
[Thu May 14 08:22:17 2015] bus: 'usb': really_probe: bound device 3-1.3:1.0=
 to driver rtl8192cu
[Thu May 14 08:22:17 2015] usbcore: registered new interface driver rtl8192=
cu
[Thu May 14 08:22:17 2015] rtl8192cu 3-1.3:1.0 wlp0s26u1u3: renamed from wl=
an0
[Thu May 14 08:22:17 2015] net wlan0: renaming to wlp0s26u1u3
[Thu May 14 08:22:17 2015] systemd-udevd[329]: renamed network interface wl=
an0 to wlp0s26u1u3
[Thu May 14 08:22:18 2015] bus: 'acpi': add driver NVIDIA ACPI Video Driver
[Thu May 14 08:22:18 2015] cfg80211: World regulatory domain updated:
[Thu May 14 08:22:18 2015] cfg80211:  DFS Master region: unset
[Thu May 14 08:22:18 2015] cfg80211:   (start_freq - end_freq @ bandwidth),=
 (max_antenna_gain, max_eirp), (dfs_cac_time)
[Thu May 14 08:22:18 2015] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Thu May 14 08:22:18 2015] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Thu May 14 08:22:18 2015] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Thu May 14 08:22:18 2015] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 K=
Hz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[Thu May 14 08:22:18 2015] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 K=
Hz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[Thu May 14 08:22:18 2015] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 =
KHz), (N/A, 2000 mBm), (0 s)
[Thu May 14 08:22:18 2015] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 K=
Hz), (N/A, 2000 mBm), (N/A)
[Thu May 14 08:22:18 2015] cfg80211:   (57240000 KHz - 63720000 KHz @ 21600=
00 KHz), (N/A, 0 mBm), (N/A)
[Thu May 14 08:22:18 2015] scsi 8:0:0:0: Direct-Access     Linux    File-CD=
 Gadget   0000 PQ: 0 ANSI: 2
[Thu May 14 08:22:18 2015] scsi 9:0:0:0: Direct-Access     Kingston DataTra=
veler 3.0 PMAP PQ: 0 ANSI: 6
[Thu May 14 08:22:18 2015] device: 'target9:0:0': device_add
[Thu May 14 08:22:18 2015] bus: 'scsi': add device target9:0:0
[Thu May 14 08:22:18 2015] device: '9:0:0:0': device_add
[Thu May 14 08:22:18 2015] bus: 'scsi': add device 9:0:0:0
[Thu May 14 08:22:18 2015] bus: 'scsi': driver_probe_device: matched device=
 9:0:0:0 with driver sd
[Thu May 14 08:22:18 2015] bus: 'scsi': really_probe: probing driver sd wit=
h device 9:0:0:0
[Thu May 14 08:22:18 2015] device: '9:0:0:0': device_add
[Thu May 14 08:22:18 2015] driver: 'sd': driver_bound: bound to device '9:0=
:0:0'
[Thu May 14 08:22:18 2015] bus: 'scsi': really_probe: bound device 9:0:0:0 =
to driver sd
[Thu May 14 08:22:18 2015] device: '9:0:0:0': device_add
[Thu May 14 08:22:18 2015] device: 'sg6': device_add
[Thu May 14 08:22:18 2015] sd 9:0:0:0: Attached scsi generic sg6 type 0
[Thu May 14 08:22:18 2015] device: '9:0:0:0': device_add
[Thu May 14 08:22:18 2015] device: 'target8:0:0': device_add
[Thu May 14 08:22:18 2015] bus: 'scsi': add device target8:0:0
[Thu May 14 08:22:18 2015] device: '8:0:0:0': device_add
[Thu May 14 08:22:18 2015] bus: 'scsi': add device 8:0:0:0
[Thu May 14 08:22:18 2015] bus: 'scsi': driver_probe_device: matched device=
 8:0:0:0 with driver sd
[Thu May 14 08:22:18 2015] bus: 'scsi': really_probe: probing driver sd wit=
h device 8:0:0:0
[Thu May 14 08:22:18 2015] device: '8:0:0:0': device_add
[Thu May 14 08:22:18 2015] driver: 'sd': driver_bound: bound to device '8:0=
:0:0'
[Thu May 14 08:22:18 2015] bus: 'scsi': really_probe: bound device 8:0:0:0 =
to driver sd
[Thu May 14 08:22:18 2015] device: '8:0:0:0': device_add
[Thu May 14 08:22:18 2015] device: 'sg7': device_add
[Thu May 14 08:22:18 2015] sd 8:0:0:0: Attached scsi generic sg7 type 0
[Thu May 14 08:22:18 2015] device: '8:0:0:0': device_add
[Thu May 14 08:22:18 2015] device: '8:96': device_add
[Thu May 14 08:22:18 2015] device: 'sdg': device_add
[Thu May 14 08:22:18 2015] sd 8:0:0:0: [sdg] Attached SCSI removable disk
[Thu May 14 08:22:18 2015] device: 'i2c-10': device_add
[Thu May 14 08:22:18 2015] bus: 'i2c': add device i2c-10
[Thu May 14 08:22:18 2015] device: 'i2c-11': device_add
[Thu May 14 08:22:18 2015] bus: 'i2c': add device i2c-11
[Thu May 14 08:22:18 2015] device: 'i2c-12': device_add
[Thu May 14 08:22:18 2015] bus: 'i2c': add device i2c-12
[Thu May 14 08:22:18 2015] bus: 'acpi': remove driver NVIDIA ACPI Video Dri=
ver
[Thu May 14 08:22:18 2015] driver: 'NVIDIA ACPI Video Driver': driver_relea=
se
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] 61457664 512-byte logical bloc=
ks: (31.4 GB/29.3 GiB)
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] Write Protect is off
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] Mode Sense: 23 00 00 00
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] No Caching mode page found
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] Assuming drive cache: write th=
rough
[Thu May 14 08:22:19 2015] device: '8:80': device_add
[Thu May 14 08:22:19 2015] device: 'sdf': device_add
[Thu May 14 08:22:19 2015]  sdf: sdf1 sdf2 sdf3
[Thu May 14 08:22:19 2015] device: 'sdf1': device_add
[Thu May 14 08:22:19 2015] device: 'sdf2': device_add
[Thu May 14 08:22:19 2015] device: 'sdf3': device_add
[Thu May 14 08:22:19 2015] sd 9:0:0:0: [sdf] Attached SCSI removable disk
[Thu May 14 08:22:44 2015] device: 'device-mapper': device_add
[Thu May 14 08:22:44 2015] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17) =
initialised: dm-devel@redhat.com
[Thu May 14 08:22:44 2015] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 a=
ction 0x6 frozen
[Thu May 14 08:22:44 2015] sr 0:0:0:0: CDB:=20
[Thu May 14 08:22:44 2015] Get event status notification: 4a 01 00 00 10 00=
 00 00 08 00
[Thu May 14 08:22:44 2015] ata1.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0=
 tag 24 pio 16392 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[Thu May 14 08:22:44 2015] ata1.00: status: { DRDY }
[Thu May 14 08:22:44 2015] ata1: hard resetting link
[Thu May 14 08:22:45 2015] ata1: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 300)
[Thu May 14 08:22:45 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:45 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:45 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:45 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:45 2015] ata1.00: configured for UDMA/66
[Thu May 14 08:22:50 2015] ata1.00: qc timeout (cmd 0xa0)
[Thu May 14 08:22:50 2015] ata1.00: TEST_UNIT_READY failed (err_mask=3D0x4)
[Thu May 14 08:22:50 2015] ata1: hard resetting link
[Thu May 14 08:22:50 2015] ata1: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 300)
[Thu May 14 08:22:50 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:50 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:50 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:50 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:50 2015] ata1.00: configured for UDMA/66
[Thu May 14 08:22:55 2015] ata1.00: qc timeout (cmd 0xa0)
[Thu May 14 08:22:55 2015] ata1.00: TEST_UNIT_READY failed (err_mask=3D0x4)
[Thu May 14 08:22:55 2015] ata1: limiting SATA link speed to 1.5 Gbps
[Thu May 14 08:22:55 2015] ata1.00: limiting speed to UDMA/66:PIO3
[Thu May 14 08:22:55 2015] ata1: hard resetting link
[Thu May 14 08:22:55 2015] ata1: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
[Thu May 14 08:22:55 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:55 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:55 2015] ACPI Error: [DSSP] Namespace lookup failure, AE_=
NOT_FOUND (20140926/psargs-359)
[Thu May 14 08:22:55 2015] ACPI Error: Method parse/execution failed [\_SB_=
=2EPCI0.SAT0.SPT0._GTF] (Node ee0303a8), AE_NOT_FOUND (20140926/psparse-536)
[Thu May 14 08:22:55 2015] ata1.00: configured for UDMA/66
[Thu May 14 08:23:00 2015] ata1.00: qc timeout (cmd 0xa0)
[Thu May 14 08:23:00 2015] ata1.00: TEST_UNIT_READY failed (err_mask=3D0x4)
[Thu May 14 08:23:00 2015] ata1.00: disabled
[Thu May 14 08:23:00 2015] ata1: hard resetting link
[Thu May 14 08:23:00 2015] ata1: SATA link up 1.5 Gbps (SStatus 113 SContro=
l 310)
[Thu May 14 08:23:00 2015] ata1: EH complete
[Thu May 14 08:23:01 2015] reiserfs: enabling write barrier flush mode
[Thu May 14 08:23:02 2015] Adding 1004056k swap on /dev/sdb2.  Priority:1 e=
xtents:1 across:1004056k FS
[Thu May 14 08:23:02 2015] EXT2-fs (sdb1): (no)acl options not supported
[Thu May 14 08:23:02 2015] EXT2-fs (sdb1): (no)user_xattr optionsnot suppor=
ted
[Thu May 14 08:23:02 2015] EXT3-fs (sdd1): error: couldn't mount because of=
 unsupported optional features (40)
[Thu May 14 08:23:02 2015] EXT2-fs (sdd1): (no)acl options not supported
[Thu May 14 08:23:02 2015] EXT2-fs (sdd1): (no)user_xattr optionsnot suppor=
ted
[Thu May 14 08:23:02 2015] EXT2-fs (sdd1): error: couldn't mount because of=
 unsupported optional features (40)
[Thu May 14 08:23:02 2015] EXT4-fs (sdd1): acl option not supported
[Thu May 14 08:23:02 2015] EXT4-fs (sdd1): mounted filesystem with ordered =
data mode. Opts: acl,user_xattr
[Thu May 14 08:23:02 2015] EXT3-fs (sdd2): error: couldn't mount because of=
 unsupported optional features (240)
[Thu May 14 08:23:02 2015] EXT2-fs (sdd2): (no)acl options not supported
[Thu May 14 08:23:02 2015] EXT2-fs (sdd2): (no)user_xattr optionsnot suppor=
ted
[Thu May 14 08:23:02 2015] EXT2-fs (sdd2): error: couldn't mount because of=
 unsupported optional features (240)
[Thu May 14 08:23:02 2015] EXT4-fs (sdd2): acl option not supported
[Thu May 14 08:23:02 2015] EXT4-fs (sdd2): mounted filesystem with ordered =
data mode. Opts: acl,user_xattr
[Thu May 14 08:23:02 2015] device: 'vcs2': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa2': device_add
[Thu May 14 08:23:02 2015] device: 'vcs3': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa3': device_add
[Thu May 14 08:23:02 2015] device: 'vcs4': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa4': device_add
[Thu May 14 08:23:02 2015] device: 'vcs5': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa5': device_add
[Thu May 14 08:23:02 2015] device: 'vcs6': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa6': device_add
[Thu May 14 08:23:02 2015] device: 'vcs7': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa7': device_add
[Thu May 14 08:23:02 2015] device: 'vcs8': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa8': device_add
[Thu May 14 08:23:02 2015] device: 'vcs9': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa9': device_add
[Thu May 14 08:23:02 2015] device: 'vcs10': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa10': device_add
[Thu May 14 08:23:02 2015] device: 'vcs11': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa11': device_add
[Thu May 14 08:23:02 2015] device: 'vcs12': device_add
[Thu May 14 08:23:02 2015] device: 'vcsa12': device_add
[Thu May 14 08:23:06 2015] __allocate_fw_buf: fw-rtl_nic/rtl8168f-1.fw buf=
=3Dedbfd340
[Thu May 14 08:23:06 2015] r8169 0000:03:00.0: Direct firmware load for rtl=
_nic/rtl8168f-1.fw failed with error -2
[Thu May 14 08:23:06 2015] __fw_free_buf: fw-rtl_nic/rtl8168f-1.fw buf=3Ded=
bfd340 data=3D  (null) size=3D0
[Thu May 14 08:23:06 2015] r8169 0000:03:00.0 enp3s0: unable to load firmwa=
re patch rtl_nic/rtl8168f-1.fw (-2)
[Thu May 14 08:23:06 2015] r8169 0000:03:00.0 enp3s0: link down
[Thu May 14 08:23:06 2015] IPv6: ADDRCONF(NETDEV_UP): enp3s0: link is not r=
eady
[Thu May 14 08:23:06 2015] r8169 0000:03:00.0 enp3s0: link down
[Thu May 14 08:23:08 2015] r8169 0000:03:00.0 enp3s0: link up
[Thu May 14 08:23:08 2015] IPv6: ADDRCONF(NETDEV_CHANGE): enp3s0: link beco=
mes ready
[Thu May 14 08:23:10 2015] device: 'autofs': device_add
[Thu May 14 08:23:17 2015] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[Thu May 14 08:23:17 2015] Bluetooth: BNEP socket layer initialized
[Thu May 14 08:23:21 2015] bus: 'platform': add driver nct6775
[Thu May 14 08:23:21 2015] nct6775: Found NCT6779D or compatible chip at 0x=
2e:0x290
[Thu May 14 08:23:21 2015] Registering platform device 'nct6775.656'. Paren=
t at platform
[Thu May 14 08:23:21 2015] device: 'nct6775.656': device_add
[Thu May 14 08:23:21 2015] bus: 'platform': add device nct6775.656
[Thu May 14 08:23:21 2015] bus: 'platform': driver_probe_device: matched de=
vice nct6775.656 with driver nct6775
[Thu May 14 08:23:21 2015] bus: 'platform': really_probe: probing driver nc=
t6775 with device nct6775.656
[Thu May 14 08:23:21 2015] device: 'hwmon2': device_add
[Thu May 14 08:23:21 2015] driver: 'nct6775': driver_bound: bound to device=
 'nct6775.656'
[Thu May 14 08:23:21 2015] bus: 'platform': really_probe: bound device nct6=
775.656 to driver nct6775
[Thu May 14 08:23:22 2015] device: 'microcode': device_unregister
[Thu May 14 08:23:22 2015] device: 'microcode': device_create_release
[Thu May 14 08:23:22 2015] bus: 'platform': remove device microcode
[Thu May 14 08:23:22 2015] microcode: Microcode Update Driver: v2.00 remove=
d.

--FL5UXtIhxfXey3p5--

--aM3YZ0Iwxop3KEKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVVJtnAAoJEPFsbcakB4r7wIIH/16fXqpJp4Bf/5rp1rIdG9uN
moGHNZEKEpTP021p2gdSS4wmM9KmydMh7xpS+JuxLoWeGjuUvXRbgFsM3WkyM8ck
J+puRrEu2J6oCU68awy1GuMDtl26cep6OQSOnnpqhB+Xb12utRu/0QQqAoN8P9XU
fcrEQF/PW4w+y2BX3OAFgYNP+2WeIdpxWl0gAyi8Tr8W6TfLo7j0BPPVzaR3IGRX
XFcMTQWrXQJssW65ZFQEfJFSBCq6XuI83961VagQXaZfbLmjhJwrInbvFIwyzEY3
d97GOGUlyx+ldT5Jilcx55afbR03XkMZBum/lqViCDMvTYAC4XlWtshDT4kCPVU=
=9f9U
-----END PGP SIGNATURE-----

--aM3YZ0Iwxop3KEKx--
