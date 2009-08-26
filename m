Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmailhost.telefonica.net ([213.4.149.242]:41797 "EHLO
	ctsmtpout2.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752470AbZHZS3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2009 14:29:20 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: dvb_usb_af9015: Oops on hotplugging with 2.6.31-rc5-git3
Date: Wed, 26 Aug 2009 20:29:11 +0200
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <200908052032.09709.s.L-H@gmx.de>
In-Reply-To: <200908052032.09709.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_37XlKWhs2pwznq7"
Message-Id: <200908262029.11579.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_37XlKWhs2pwznq7
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

El Mi=C3=A9rcoles, 5 de Agosto de 2009, Stefan Lippers-Hollmann escribi=C3=
=B3:
> Hi
>
> Connecting my TerraTec Cinergy T USB XE rev. 2 (0x0ccd, 0x0069) to kernel
> 2.6.31-rc5-git3, I get following kernel oops (complete dmesg and kernel
> config (amd64) attached) while the firmware[1] is uploaded to the device.
>
> This is a regression relative to 2.6.30.x, where this device is working
> fine. It also seems to be restricted to dvb_usb_af9015, as firmwares for
> several wlan cards are uploading fine. Would it help to bisect based on
> the changes to drivers/media/dvb/dvb-usb/af9015.c or is a wider scope
> required?
>
> Regards
> 	Stefan Lippers-Hollmann
>
> [1]	http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmw=
ar
>e_files/4.95.0/dvb-usb-af9015.fw
>
> usb 1-2: new high speed USB device using ehci_hcd and address 4
> usb 1-2: New USB device found, idVendor=3D0ccd, idProduct=3D0069
> usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D3
> usb 1-2: Product: Cinergy T USB XE Ver.2
> usb 1-2: Manufacturer: TerraTec
> usb 1-2: SerialNumber: 10012007
> usb 1-2: configuration #1 chosen from 1 choice
> dvb-usb: found a 'TerraTec Cinergy T USB XE' in cold state, will try to
> load a firmware usb 1-2: firmware: requesting dvb-usb-af9015.fw
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> BUG: unable to handle kernel paging request at ffffc9000db5ee17
> IP: [<ffffffff811d173b>] memcpy_c+0xb/0x20
> PGD 22fc07067 PUD 22fc14067 PMD 1a091b067 PTE 800000020d5fd161
> Oops: 0003 [#1] PREEMPT SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:1a.7/usb1/1-2/firmware/1-2/loading CPU 0
> Modules linked in: dvb_usb_af9015(+) dvb_usb dvb_core radeon drm bnep sco
> rfcomm l2cap bluetooth ppdev parport_pc lp parport acpi_cpufreq
> cpufreq_conservative cpufreq_stats cpufreq_ondemand freq_table
> cpufreq_performance cpufreq_powersave kvm_intel kvm ipv6 af_packet bridge
> stp snd_hda_codec_atihdmi rt2800usb snd_hda_codec_realtek zd1211rw
> rt2x00usb snd_hda_intel snd_hda_codec rt2x00lib input_polldev crc_ccitt
> snd_hwdep arc4 ath9k ecb snd_pcm b43 ath snd_seq snd_timer rng_core
> snd_seq_device mac80211 cfg80211 evdev snd rtc_cmos rtc_core soundcore
> rtc_lib pcspkr rfkill snd_page_alloc i2c_i801 processor led_class i2c_core
> button ext4 mbcache jbd2 crc16 dm_mirror dm_region_hash dm_log dm_snapshot
> dm_mod sg sr_mod sd_mod cdrom usbhid hid uhci_hcd ahci ssb firewire_ohci
> pcmcia firewire_core libata pcmcia_core crc_itu_t scsi_mod r8169 ehci_hcd
> mii usbcore nls_base intel_agp thermal fan Pid: 18663, comm: modprobe Not
> tainted 2.6.31-rc5-sidux-amd64 #1 EP45-DS3 RIP: 0010:[<ffffffff811d173b>]=
=20
> [<ffffffff811d173b>] memcpy_c+0xb/0x20 RSP: 0018:ffff880221185b50  EFLAGS:
> 00010202
> RAX: ffffc9000db5ee17 RBX: ffff880221185c18 RCX: 0000000000000002
> RDX: 0000000000000002 RSI: ffff880221185b6a RDI: ffffc9000db5ee17
> RBP: 0000000000000000 R08: ffff8800280442a0 R09: 0000000000000001
> R10: ffff8800378010c0 R11: ffffffff810284b0 R12: 0000000000000008
> R13: ffff880221185b68 R14: ffff880221179800 R15: ffff880221185bb4
> FS:  00007f7f1d4286f0(0000) GS:ffff880028034000(0000)
> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffffc9000db5ee17 CR3: 00000001e21ec000 CR4: 00000000000026e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process modprobe (pid: 18663, threadinfo ffff880221184000, task
> ffff88021f0393e0) Stack:
>  ffffffffa060b2ad ffffffffa060f220 00ff880221179800 0f002f4b88d0002b
> <0> 004500088673e9ea 0d13c9141c915e02 06803e010101fb08 0c800cc012007d40
> <0> bb800cc01200fa80 010000a000006480 ff02010202020102 ffff8802260823c0
> Call Trace:
>  [<ffffffffa060b2ad>] ? af9015_rw_udev+0x24d/0x2d0 [dvb_usb_af9015]
>  [<ffffffffa060b91b>] ? af9015_download_firmware+0x12b/0x190
> [dvb_usb_af9015] [<ffffffffa0604334>] ? dvb_usb_download_firmware+0x94/0x=
e0
> [dvb_usb] [<ffffffffa0604669>] ? dvb_usb_device_init+0x179/0x700 [dvb_usb]
>  [<ffffffffa060c3ff>] ? af9015_usb_probe+0x12f/0xbf4 [dvb_usb_af9015]
>  [<ffffffffa002e0a7>] ? usb_probe_interface+0xb7/0x190 [usbcore]
>  [<ffffffff8126b5c8>] ? driver_probe_device+0x98/0x1b0
>  [<ffffffff8126b773>] ? __driver_attach+0x93/0xa0
>  [<ffffffff8126b6e0>] ? __driver_attach+0x0/0xa0
>  [<ffffffff8126ad58>] ? bus_for_each_dev+0x58/0x80
>  [<ffffffff8126a648>] ? bus_add_driver+0x268/0x2f0
>  [<ffffffff8126ba69>] ? driver_register+0x79/0x170
>  [<ffffffffa002de09>] ? usb_register_driver+0xa9/0x120 [usbcore]
>  [<ffffffffa0063000>] ? af9015_usb_module_init+0x0/0x37 [dvb_usb_af9015]
>  [<ffffffffa006301b>] ? af9015_usb_module_init+0x1b/0x37 [dvb_usb_af9015]
>  [<ffffffff8100a04b>] ? do_one_initcall+0x3b/0x180
>  [<ffffffff811cd8b1>] ? __up_read+0x21/0xc0
>  [<ffffffff81072585>] ? __blocking_notifier_call_chain+0x65/0x90
>  [<ffffffff81085618>] ? sys_init_module+0xe8/0x240
>  [<ffffffff81011fc2>] ? system_call_fastpath+0x16/0x1b
> Code: 81 ea d8 1f 00 00 48 3b 42 20 73 07 48 8b 50 f9 31 c0 c3 31 d2 48 c7
> c0 f2 ff ff ff c3 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 <f3> 48 a5 89
> d1 f3 a4 c3 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 RIP=20
> [<ffffffff811d173b>] memcpy_c+0xb/0x20
>  RSP <ffff880221185b50>
> CR2: ffffc9000db5ee17
> ---[ end trace 605ab93fe7120203 ]---

I have the same problem with a recent v4l-dvb. The attached patch seem to=20
solve the problem.

Jose Alberto

--Boundary-00=_37XlKWhs2pwznq7
Content-Type: text/x-patch;
  charset="UTF-8";
  name="af9015.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="af9015.patch"

diff -r 57c666b8ef50 linux/drivers/media/dvb/dvb-usb/af9015.c
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Aug 26 08:34:16 2009 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	Wed Aug 26 20:23:07 2009 +0200
@@ -108,7 +108,7 @@
 	}
 
 	/* write requested */
-	if (write) {
+	if (write && req->data_len) {
 		memcpy(&buf[8], req->data, req->data_len);
 		msg_len += req->data_len;
 	}

--Boundary-00=_37XlKWhs2pwznq7--
