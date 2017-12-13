Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:46223 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753215AbdLMWEc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 17:04:32 -0500
Received: by mail-qt0-f173.google.com with SMTP id r39so5610295qtr.13
        for <linux-media@vger.kernel.org>; Wed, 13 Dec 2017 14:04:32 -0800 (PST)
Message-ID: <1513202668.26958.36.camel@ndufresne.ca>
Subject: Re: Kernel Oopses from v4l_enum_fmt
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Oleksandr Ostrenko <oleksandr.ostrenko@tu-dresden.de>,
        linux-media@vger.kernel.org
Date: Wed, 13 Dec 2017 17:04:28 -0500
In-Reply-To: <56d711bd-3b48-a1ad-03c6-e49585a6c268@tu-dresden.de>
References: <56d711bd-3b48-a1ad-03c6-e49585a6c268@tu-dresden.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-dwnJ9tjkLeF7ss3SqQKy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-dwnJ9tjkLeF7ss3SqQKy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 13 d=C3=A9cembre 2017 =C3=A0 22:33 +0100, Oleksandr Ostrenko a
=C3=A9crit :
> Dear all,
>=20
> There is an issue in v4l_enum_fmt leading to kernel panic under
> certain=20
> circumstance. It happens while I try to capture video from my TV
> tuner.
>=20
> When I connect this USB TV tuner (WinTV HVR-1900) it gets recognized=20
> just fine. However, whenever I try to capture a video from the
> device,=20
> it hangs the terminal and I end up with a lot of "Unknown
> pixelformat=20
> 0x00000000" errors from v4l_enum_fmt in dmesg that eventually lead
> to=20
> kernel panic on a machine with Linux Mint. On another machine with=20
> openSUSE it does not hang but just keeps producing the error message=20
> below until I stop the video acquisition. I have already tried
> several=20
> kernel versions (4.4, 4.8, 4.14) and two different distributions
> (Mint,=20
> openSUSE) but to no avail.
>=20
> Can somebody give me a hint on debugging this issue?
> Below are sample outputs of lsusb and dmesg.
>=20
> Thanks,
> Oleksandr
>=20
> lsusb
>=20
> Bus 001 Device 002: ID 8087:8001 Intel Corp.
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> Bus 003 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
> Bus 002 Device 002: ID 8087:0a2a Intel Corp.
> Bus 002 Device 005: ID 2040:7300 Hauppauge
> Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>=20
> Relevant dmesg
>=20
> [  515.920080] usb 2-3: new high-speed USB device number 4 using
> xhci_hcd
> [  516.072041] usb 2-3: New USB device found, idVendor=3D2040,
> idProduct=3D7300
> [  516.072045] usb 2-3: New USB device strings: Mfr=3D1, Product=3D2,=20
> SerialNumber=3D3
> [  516.072047] usb 2-3: Product: WinTV
> [  516.072049] usb 2-3: Manufacturer: Hauppauge
> [  516.072051] usb 2-3: SerialNumber: 7300-00-F04BADA0
> [  516.072474] pvrusb2: Hardware description: WinTV HVR-1900 Model
> 73xxx
> [  517.089290] pvrusb2: Device microcontroller firmware (re)loaded;
> it=20
> should now reset and reconnect.
> [  517.121228] usb 2-3: USB disconnect, device number 4
> [  517.121436] pvrusb2: Device being rendered inoperable
> [  518.908091] usb 2-3: new high-speed USB device number 5 using
> xhci_hcd
> [  519.065592] usb 2-3: New USB device found, idVendor=3D2040,
> idProduct=3D7300
> [  519.065597] usb 2-3: New USB device strings: Mfr=3D1, Product=3D2,=20
> SerialNumber=3D3
> [  519.065600] usb 2-3: Product: WinTV
> [  519.065602] usb 2-3: Manufacturer: Hauppauge
> [  519.065605] usb 2-3: SerialNumber: 7300-00-F04BADA0
> [  519.066862] pvrusb2: Hardware description: WinTV HVR-1900 Model
> 73xxx
> [  519.098815] pvrusb2: Binding ir_rx_z8f0811_haup to i2c address
> 0x71.
> [  519.098872] pvrusb2: Binding ir_tx_z8f0811_haup to i2c address
> 0x70.
> [  519.131651] cx25840 6-0044: cx25843-24 found @ 0x88 (pvrusb2_a)
> [  519.133234] lirc_dev: IR Remote Control driver registered, major
> 241
> [  519.134192] lirc_zilog: module is from the staging directory, the=20
> quality is unknown, you have been warned.
> [  519.134194] lirc_zilog: module is from the staging directory, the=20
> quality is unknown, you have been warned.
> [  519.134564] Zilog/Hauppauge IR driver initializing
> [  519.135628] probing IR Rx on pvrusb2_a (i2c-6)
> [  519.135674] probe of IR Rx on pvrusb2_a (i2c-6) done. Waiting on
> IR Tx.
> [  519.135678] i2c i2c-6: probe of IR Rx on pvrusb2_a (i2c-6) done
> [  519.135706] probing IR Tx on pvrusb2_a (i2c-6)
> [  519.135728] i2c i2c-6: Direct firmware load for haup-ir-
> blaster.bin=20
> failed with error -2
> [  519.135730] i2c i2c-6: firmware haup-ir-blaster.bin not available
> (-2)
> [  519.135799] i2c i2c-6: lirc_dev: driver lirc_zilog registered at=20
> minor =3D 0
> [  519.135800] i2c i2c-6: IR unit on pvrusb2_a (i2c-6) registered as=20
> lirc0 and ready
> [  519.135802] i2c i2c-6: probe of IR Tx on pvrusb2_a (i2c-6) done
> [  519.135826] initialization complete
> [  519.140759] pvrusb2: Attached sub-driver cx25840
> [  519.147644] tuner: 6-0042: Tuner -1 found with type(s) Radio TV.
> [  519.147667] pvrusb2: Attached sub-driver tuner
> [  521.029446] cx25840 6-0044: loaded v4l-cx25840.fw firmware (14264
> bytes)
> [  521.124582] tveeprom: Hauppauge model 73219, rev D1E9, serial#
> 4031491488
> [  521.124586] tveeprom: MAC address is 00:0d:fe:4b:ad:a0
> [  521.124588] tveeprom: tuner model is Philips 18271_8295 (idx 149,=20
> type 54)
> [  521.124591] tveeprom: TV standards PAL(B/G) PAL(I) SECAM(L/L')=20
> PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [  521.124593] tveeprom: audio processor is CX25843 (idx 37)
> [  521.124594] tveeprom: decoder processor is CX25843 (idx 30)
> [  521.124596] tveeprom: has radio, has IR receiver, has IR
> transmitter
> [  521.124606] pvrusb2: Supported video standard(s) reported
> available=20
> in hardware: PAL-B/B1/D/D1/G/H/I/K;SECAM-B/D/G/H/K/K
> [  521.124617] pvrusb2: Device initialization completed successfully.
> [  521.124811] pvrusb2: registered device video0 [mpeg]
> [  521.124819] dvbdev: DVB: registering new adapter (pvrusb2-dvb)
> [  523.039178] cx25840 6-0044: loaded v4l-cx25840.fw firmware (14264
> bytes)
> [  523.160593] tda829x 6-0042: setting tuner address to 60
> [  523.217717] tda18271 6-0060: creating new instance
> [  523.260592] tda18271: TDA18271HD/C1 detected @ 6-0060
> [  523.768592] tda829x 6-0042: type set to tda8295+18271
> [  533.360586] cx25840 6-0044: 0x0000 is not a valid video input!
> [  533.416296] usb 2-3: DVB: registering adapter 0 frontend 0 (NXP=20
> TDA10048HN DVB-T)...
> [  533.417571] tda829x 6-0042: type set to tda8295
> [  533.455567] tda18271 6-0060: attaching existing instance
> [  591.458582] cx25840 6-0044: loaded v4l-cx25840.fw firmware (14264
> bytes)
> [  595.551320] Unknown pixelformat 0x00000000
> [  595.551344] ------------[ cut here ]------------
> [  595.551363] WARNING: CPU: 2 PID: 5820 at=20

This is not a kernel panic, but a warning. In recent code it's this
one:

https://elixir.free-electrons.com/linux/latest/source/drivers/media/v4l2-co=
re/v4l2-ioctl.c#L1288

Though, it is usually a driver issue. More information will be needed.


> ../drivers/media/v4l2-core/v4l2-ioctl.c:1288
> v4l_enum_fmt+0xcf6/0x13a0=20
> [videodev]
> [  595.551365] Modules linked in: tda10048 tda18271 tda8290 tuner=20
> lirc_zilog(C) lirc_dev rc_core cx25840 pvrusb2 tveeprom cx2341x
> dvb_core=20
> v4l2_common videodev nf_log_ipv6 xt_comment nf_log_ipv4
> nf_log_common=20
> xt_LOG xt_limit af_packet iscsi_ibft iscsi_boot_sysfs ip6t_REJECT=20
> nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT=20
> nf_reject_ipv4 xt_pkttype xt_tcpudp iptable_filter ip6table_mangle=20
> nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4=20
> nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter=20
> ip6_tables x_tables snd_hda_codec_hdmi snd_hda_codec_realtek=20
> snd_hda_codec_generic arc4 intel_rapl xfs x86_pkg_temp_thermal=20
> intel_powerclamp coretemp kvm_intel kvm libcrc32c irqbypass=20
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc raid1 iwlmvm=20
> intel_spi_platform intel_spi
> [  595.551436]  spi_nor mtd iTCO_wdt mac80211 iTCO_vendor_support=20
> snd_hda_intel snd_hda_codec snd_soc_rt5640 snd_hda_core snd_hwdep=20
> snd_soc_rl6231 snd_soc_core md_mod snd_compress btusb
> snd_pcm_dmaengine=20
> iwlwifi btrtl btbcm snd_pcm btintel bluetooth aesni_intel
> ecdh_generic=20
> snd_timer battery cfg80211 aes_x86_64 snd pcspkr crypto_simd
> glue_helper=20
> rfkill cryptd i915 e1000e i2c_i801 lpc_ich ptp pps_core thermal
> mei_me=20
> drm_kms_helper fan mei drm fb_sys_fops syscopyarea sysfillrect
> sysimgblt=20
> i2c_algo_bit shpchp elan_i2c soundcore tpm_tis video tpm_tis_core=20
> snd_soc_sst_acpi tpm snd_soc_sst_match gpio_lynxpoint dw_dmac=20
> spi_pxa2xx_platform acpi_pad acpi_als kfifo_buf button industrialio=20
> btrfs xor zstd_decompress zstd_compress xxhash raid6_pq crc32c_intel=20
> nvme xhci_pci ehci_pci ehci_hcd xhci_hcd nvme_core usbcore
> [  595.551523]  sdhci_acpi sdhci mmc_core i2c_hid sg
> [  595.551533] CPU: 2 PID: 5820 Comm: motv Tainted: G         C=20
> 4.14.2-3.gb5596a5-default #1
> [  595.551535] Hardware name:                  /NUC5i5RYB, BIOS=20
> RYBDWi35.86A.0367.2017.0929.1059 09/29/2017
> [  595.551538] task: ffff979f823f8140 task.stack: ffffbde8826e4000
> [  595.551550] RIP: 0010:v4l_enum_fmt+0xcf6/0x13a0 [videodev]
> [  595.551552] RSP: 0018:ffffbde8826e7ca8 EFLAGS: 00010296
> [  595.551556] RAX: 000000000000001e RBX: ffffbde8826e7d98 RCX:=20
> 0000000000000000
> [  595.551558] RDX: ffff979f96d16440 RSI: ffff979f96d0e2d8 RDI:=20
> ffff979f96d0e2d8
> [  595.551560] RBP: 0000000000000000 R08: 0000000000000001 R09:=20
> 0000000000000322
> [  595.551562] R10: ffff979f8507ab00 R11: 0000000000000000 R12:=20
> ffff979f85a5a300
> [  595.551564] R13: ffffffffc12a1cc0 R14: ffff979f8507ab00 R15:=20
> ffff979f85a5a300
> [  595.551567] FS:  00007ff613fb9780(0000) GS:ffff979f96d00000(0000)=20
> knlGS:0000000000000000
> [  595.551569] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  595.551571] CR2: 00007ff60a198290 CR3: 000000041b3e6004 CR4:=20
> 00000000003606e0
> [  595.551574] Call Trace:
> [  595.551590]  __video_do_ioctl+0x310/0x320 [videodev]
> [  595.551602]  ? video_usercopy+0x1ec/0x600 [videodev]
> [  595.551612]  video_usercopy+0x174/0x600 [videodev]
> [  595.551623]  ? v4l_enum_fmt+0x13a0/0x13a0 [videodev]
> [  595.551632]  ? v4l_enum_fmt+0x13a0/0x13a0 [videodev]
> [  595.551647]  pvr2_v4l2_ioctl+0x83/0x100 [pvrusb2]
> [  595.551658]  v4l2_ioctl+0xa9/0xd0 [videodev]
> [  595.551665]  do_vfs_ioctl+0x8d/0x5d0
> [  595.551670]  ? __fput+0x15b/0x1d0
> [  595.551676]  ? mntput_no_expire+0x11/0x1a0
> [  595.551680]  SyS_ioctl+0x74/0x80
> [  595.551686]  entry_SYSCALL_64_fastpath+0x1e/0xa9
> [  595.551690] RIP: 0033:0x7ff610862659
> [  595.551691] RSP: 002b:00007ffe84b2a078 EFLAGS: 00000246 ORIG_RAX:=20
> 0000000000000010
> [  595.551695] RAX: ffffffffffffffda RBX: 000000000192ee20 RCX:=20
> 00007ff610862659
> [  595.551697] RDX: 00007ffe84b2a110 RSI: 00000000c0405602 RDI:=20
> 0000000000000004
> [  595.551699] RBP: 00007ffe84b29f80 R08: 0000000000000000 R09:=20
> 0000000000000004
> [  595.551701] R10: 00007ff60c6c9620 R11: 0000000000000246 R12:=20
> 000000000192ee20
> [  595.551703] R13: 0000000000000049 R14: 00007ff613fec000 R15:=20
> 0000000000000000
> [  595.551706] Code: 3d 4f 35 31 31 0f 84 bf 05 00 00 3d 4d 54 32 31
> 48=20
> c7 c6 59 17 22 c1 0f 84 e5 f5 ff ff 89 c6 48 c7 c7 77 23 22 c1 e8 15
> c2=20
> ec c1 <0f> ff 80 7b 0c 00 0f 85 73 f3 ff ff 8b 43 2c 48 c7 c1 1e 17
> 22
> [  595.551775] ---[ end trace d1089f1c30e702b9 ]---
--=-dwnJ9tjkLeF7ss3SqQKy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWjGj7AAKCRBxUwItrAao
HCNaAKDAC9j6FllTT9d6QIXfW+AGo1QvpQCghbzsEHJdhNofuBz3JuU8hZ6huYg=
=wYw1
-----END PGP SIGNATURE-----

--=-dwnJ9tjkLeF7ss3SqQKy--
