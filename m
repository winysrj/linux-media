Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm14.bullet.mail.ird.yahoo.com ([77.238.189.67]:48867 "HELO
	nm14.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752665Ab3EFLyT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 May 2013 07:54:19 -0400
Message-ID: <1367840892.39557.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Date: Mon, 6 May 2013 12:48:12 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: rtl2832u+r820t dvb-t usb kernel crash
To: "Media Mailing List \(LMML\)\"" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My thanks to Mauro for his work on this device. Eager to try it, I built sources yesterday following directions on 

http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

My environment is Tinycore Linux 4.7.5:

Linux box 3.0.21-tinycore #3021 SMP Sat Feb 18 11:54:11 EET 2012 i686 GNU/Linux


The PC hangs (not even REISUB working) as soon as I plug my device in usb port.
Killing udevd and loading one module a time, I found that the crash occurs exactly when I load 

dvb-usb-rtl28xxu.ko
AND
the device is plugged.
I.e., to crash I just need to sudo modprobe dvb-usb-rtl28xxu and plug.


My device is as from subject, with lsusb giving 0bda:2838. It looks like this:
http://www.hamradioscience.com/wp-content/uploads/2012/10/R820T-560x420.jpg

I am quite sure it has a r820t tuner because sdr.osmocom.org logs told me so, and because I managed to make it work (as a DVB-T receiver) by patching some r820t code for an old kernel, see

http://www.spinics.net/lists/linux-media/msg57707.html.

Lars Buerding recently reported success on a newer kernel, so it might be a backport problem. However, I had similar results on a fresh Debian Wheezy yesterday.

I append
1) the crash log (used klogd spitting on a -o sync mounted device).
2) lsusb -v for the device


Regards,
Marco




*********************************
*********************************


May  6 12:56:50 box user.info kernel: usb 1-4: new high speed USB device number 4 using ehci_hcd
May  6 12:56:50 box user.err kernel: WARNING: You are using an experimental version of the media stack.
May  6 12:56:50 box user.err kernel:     As the driver is backported to an older kernel, it doesn't offer
May  6 12:56:50 box user.err kernel:     enough quality for its usage in production.
May  6 12:56:50 box user.err kernel:     Use it with care.
May  6 12:56:50 box user.err kernel: Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
May  6 12:56:50 box user.err kernel:     02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less verbose
May  6 12:56:50 box user.err kernel:     a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at em28xx_dvb_bus_ctrl()
May  6 12:56:50 box user.err kernel:     4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix indentation of the help section in Kconfig
May  6 12:56:50 box user.err kernel: WARNING: You are using an experimental version of the media stack.
May  6 12:56:50 box user.err kernel:     As the driver is backported to an older kernel, it doesn't offer
May  6 12:56:50 box user.err kernel:     enough quality for its usage in production.
May  6 12:56:50 box user.err kernel:     Use it with care.
May  6 12:56:50 box user.err kernel: Latest git patches (needed if you report a bug to linux-media@vger.kernel.org):
May  6 12:56:50 box user.err kernel:     02615ed5e1b2283db2495af3cf8f4ee172c77d80 [media] cx88: make core less verbose
May  6 12:56:50 box user.err kernel:     a3b60209e7dd4db05249a9fb27940bb6705cd186 [media] em28xx: fix oops at em28xx_dvb_bus_ctrl()
May  6 12:56:50 box user.err kernel:     4494f0fdd825958d596d05a4bd577df94b149038 [media] s5c73m3: fix indentation of the help section in Kconfig
May  6 12:56:50 box user.info kernel: usb 1-4: dvb_usb_v2: found a 'Realtek RTL2832U reference design' in warm state
May  6 12:56:50 box user.info kernel: usbcore: registered new interface driver dvb_usb_rtl28xxu
May  6 12:56:50 box user.alert kernel: BUG: unable to handle kernel NULL pointer dereference at 00000028
May  6 12:56:50 box user.alert kernel: IP: [<f11e171d>] 0xf11e171d
May  6 12:56:50 box user.warn kernel: *pde = 00000000 
May  6 12:56:50 box user.emerg kernel: Oops: 0000 [#1] SMP 
May  6 12:56:50 box user.warn kernel: Modules linked in: dvb_usb_rtl28xxu dvb_usb_v2 rtl2830 dvb_core rc_core rt73usb rt2x00usb rt2x00lib mac80211 cfg80211 acpi_cpufreq cpufreq_userspace mperf cpufreq_stats cpufreq_powersave cpufreq_conservative squashfs scsi_wait_
May  6 12:56:50 box user.warn kernel: Pid: 52, comm: kworker/1:2 Tainted: P         C  3.0.21-tinycore #3021 FUJITSU SIEMENS AMILO Li1705/AMILO Li1705
May  6 12:56:50 box user.warn kernel: EIP: 0060:[<f11e171d>] EFLAGS: 00010246 CPU: 1
May  6 12:56:50 box user.warn kernel: EAX: 00000000 EBX: ed07ff02 ECX: 00000000 EDX: ffffffff
May  6 12:56:50 box user.warn kernel: ESI: ed232038 EDI: 00000000 EBP: eee06a00 ESP: ed901f54
May  6 12:56:50 box user.warn kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May  6 12:56:50 box user.emerg kernel: Process kworker/1:2 (pid: 52, ti=ed900000 task=ed839030 task.ti=ed900000)
May  6 12:56:50 box user.emerg kernel: Stack:
May  6 12:56:50 box user.warn kernel:  00000000 ed232000 c05af00c eee03078 00000001 eee03030 243e1b2c 00000000
May  6 12:56:50 box user.warn kernel:  ed8f2d80 ed232038 eee026c0 eee06a00 c013b0be eee02700 00000000 f11e1597
May  6 12:56:50 box user.warn kernel:  eee06a05 ed8f2d80 eee026c0 ed8f2d90 ed839030 c013bc6f ed8f2d90 ee867f34
May  6 12:56:50 box user.emerg kernel: Call Trace:
May  6 12:56:50 box user.warn kernel:  [<c013b0be>] ? 0xc013b0be
May  6 12:56:50 box user.warn kernel:  [<f11e1597>] ? 0xf11e1597
May  6 12:56:50 box user.warn kernel:  [<c013bc6f>] ? 0xc013bc6f
May  6 12:56:50 box user.warn kernel:  [<c013bbc6>] ? 0xc013bbc6
May  6 12:56:50 box user.warn kernel:  [<c013e3a8>] ? 0xc013e3a8
May  6 12:56:50 box user.warn kernel:  [<c013e345>] ? 0xc013e345
May  6 12:56:50 box user.warn kernel:  [<c0417936>] ? 0xc0417936
May  6 12:56:50 box user.emerg kernel: Code: 00 00 8b 44 24 14 e8 54 fc ff ff 8b 43 c8 8b 50 70 83 c4 10 85 d2 74 10 8b 44 24 04 ff d2 85 c0 89 c7 0f 88 bd 06 00 00 8b 43 c8 
May  6 12:56:50 box user.emerg kernel: 3> 78 28 00 74 67 8b 53 cc b9 30 00 00 00 8d 83 a8 01 00 00 8d 
May  6 12:56:50 box user.emerg kernel: EIP: [<f11e171d>]  SS:ESP 0068:ed901f54
May  6 12:56:50 box user.emerg kernel: CR2: 0000000000000028
May  6 12:56:50 box user.warn kernel: ---[ end trace 604313c755d73a7e ]---
May  6 12:56:50 box user.alert kernel: BUG: unable to handle kernel paging request at fffffffc
May  6 12:56:50 box user.alert kernel: IP: [<c013e501>] 0xc013e501
May  6 12:56:50 box user.warn kernel: *pde = 005b9067 *pte = 00000000 
May  6 12:56:50 box user.emerg kernel: Oops: 0000 [#2] SMP 
May  6 12:56:50 box user.warn kernel: Modules linked in: dvb_usb_rtl28xxu dvb_usb_v2 rtl2830 dvb_core rc_core rt73usb rt2x00usb rt2x00lib mac80211 cfg80211 acpi_cpufreq cpufreq_userspace mperf cpufreq_stats cpufreq_powersave cpufreq_conservative squashfs scsi_wait_
May  6 12:56:50 box user.warn kernel: Pid: 52, comm: kworker/1:2 Tainted: P      D  C  3.0.21-tinycore #3021 FUJITSU SIEMENS AMILO Li1705/AMILO Li1705
May  6 12:56:50 box user.warn kernel: EIP: 0060:[<c013e501>] EFLAGS: 00010002 CPU: 1
May  6 12:56:50 box user.warn kernel: EAX: 00000000 EBX: eee05700 ECX: 00000001 EDX: 00000001
May  6 12:56:50 box user.warn kernel: ESI: 00000001 EDI: ed839030 EBP: ed839030 ESP: ed901dac
May  6 12:56:50 box user.warn kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
May  6 12:56:50 box user.emerg kernel: Process kworker/1:2 (pid: 52, ti=ed900000 task=ed839030 task.ti=ed900000)
May  6 12:56:50 box user.emerg kernel: Stack:
May  6 12:56:50 box user.warn kernel:  c013bf2a eee05700 00000000 ed839030 c0415549 ee824980 c01c7389 00000001
May  6 12:56:50 box user.warn kernel:  c05b1700 ed8391c8 c05b1700 00000034 ee844650 ee844640 00000034 ed83858c
May  6 12:56:50 box user.warn kernel:  ed838584 ed83b040 00000002 ee803a40 00000246 c015fd31 ed839030 ed839030
May  6 12:56:50 box user.emerg kernel: Call Trace:
May  6 12:56:50 box user.warn kernel:  [<c013bf2a>] ? 0xc013bf2a
May  6 12:56:50 box user.warn kernel:  [<c0415549>] ? 0xc0415549
May  6 12:56:50 box user.warn kernel:  [<c01c7389>] ? 0xc01c7389
May  6 12:56:50 box user.warn kernel:  [<c015fd31>] ? 0xc015fd31
May  6 12:56:50 box user.warn kernel:  [<c012e01b>] ? 0xc012e01b
May  6 12:56:50 box user.warn kernel:  [<c04158f7>] ? 0xc04158f7
May  6 12:56:50 box user.warn kernel:  [<c012f3d5>] ? 0xc012f3d5
May  6 12:56:50 box user.warn kernel:  [<c014dd19>] ? 0xc014dd19
May  6 12:56:50 box user.warn kernel:  [<c0104d6b>] ? 0xc0104d6b
May  6 12:56:50 box user.warn kernel:  [<c0411f49>] ? 0xc0411f49
May  6 12:56:50 box user.warn kernel:  [<c041209c>] ? 0xc041209c
May  6 12:56:50 box user.warn kernel:  [<c011ba09>] ? 0xc011ba09
May  6 12:56:50 box user.warn kernel:  [<c0410001>] ? 0xc0410001
May  6 12:56:50 box user.warn kernel:  [<c011b8c8>] ? 0xc011b8c8
May  6 12:56:50 box user.warn kernel:  [<c041715a>] ? 0xc041715a
May  6 12:56:50 box user.warn kernel:  [<c011b8c8>] ? 0xc011b8c8
May  6 12:56:50 box user.warn kernel:  [<f11e171d>] ? 0xf11e171d
May  6 12:56:50 box user.warn kernel:  [<c013b0be>] ? 0xc013b0be
May  6 12:56:50 box user.warn kernel:  [<f11e1597>] ? 0xf11e1597
May  6 12:56:50 box user.warn kernel:  [<c013bc6f>] ? 0xc013bc6f
May  6 12:56:50 box user.warn kernel:  [<c013bbc6>] ? 0xc013bbc6
May  6 12:56:50 box user.warn kernel:  [<c013e3a8>] ? 0xc013e3a8
May  6 12:56:50 box user.warn kernel:  [<c013e345>] ? 0xc013e345
May  6 12:56:50 box user.warn kernel:  [<c0417936>] ? 0xc0417936
May  6 12:56:50 box user.emerg kernel: Code: 89 f0 83 e0 1f c1 ee 05 8d 14 85 78 c1 41 c0 89 d8 c1 e6 02 29 f2 e8 0e ab fe ff 81 4b 0c 00 00 00 04 5b 5e c3 8b 80 6c 01 00 00 <8b> 40 fc c3 31 c0 c3 57 ba c6 ee 47 c0 56 53 64 8b 35 c4 d4 5a 
May  6 12:56:50 box user.emerg kernel: EIP: [<c013e501>]  SS:ESP 0068:ed901dac
May  6 12:56:50 box user.emerg kernel: CR2: 00000000fffffffc
May  6 12:56:50 box user.warn kernel: ---[ end trace 604313c755d73a7f ]---
May  6 12:56:50 box user.alert kernel: Fixing recursive fault but reboot is needed!



*********************************
*********************************



Bus 001 Device 006: ID 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x0bda Realtek Semiconductor Corp.
  idProduct          0x2838 RTL2838 DVB-T
  bcdDevice            1.00
  iManufacturer           1 Realtek
  iProduct                2 RTL2838UHIDIR
  iSerial                 3 00000013
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           34
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          4 USB2.0-Bulk&Iso
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 Bulk-In, Interface
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
      iInterface              5 Bulk-In, Interface
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      2
Device Status:     0x0000
  (Bus Powered)
