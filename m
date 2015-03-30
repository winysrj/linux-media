Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55364 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbbC3Pah (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 11:30:37 -0400
Date: Mon, 30 Mar 2015 17:30:31 +0200
From: Stefan Lippers-Hollmann <s.l-h@gmx.de>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, m.chehab@samsung.com,
	James Hogan <james.hogan@imgtec.com>,
	"David =?UTF-8?B?SMOkcmRlbWFu?=" <david@hardeman.nu>,
	"Antti =?UTF-8?B?U2VwcMOkbMOk?=" <a.seppala@gmail.com>,
	Tomas Melin <tomas.melin@iki.fi>
Subject: Re: mceusb: sysfs: cannot create duplicate filename '/class/rc/rc0'
 (race condition between multiple RC_CORE devices)
Message-ID: <20150330173031.1fb46443@mir>
In-Reply-To: <201412302211.40801.s.L-H@gmx.de>
References: <201412181916.18051.s.L-H@gmx.de>
	<201412302211.40801.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/U.9O_s78Dcp0XF.H0aqp3MB"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/U.9O_s78Dcp0XF.H0aqp3MB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

This is a follow-up for:
	http://lkml.kernel.org/r/<201412181916.18051.s.L-H@gmx.de>
	http://lkml.kernel.org/r/<201412302211.40801.s.L-H@gmx.de>

On 2014-12-30, Stefan Lippers-Hollmann wrote:
> On Thursday 18 December 2014, Stefan Lippers-Hollmann wrote:
> > Occassionally, but not readily reproducably, I hit a race condition=20
> > between mceusb and other connected RC_CORE devices when mceusb tries=20
> > to create /class/rc/rc0, which is -by then- already taken by another=20
> > RC_CORE device. The other involved IR devices (physically only one)
> > are part of a PCIe TeVii s480 s2.1 twin-tuner DVB-S2 card and aren't=20
> > actually supposed to receive IR signals (IR receiver not connected):
> >=20
> > mceusb device transceiver:
> > Bus 002 Device 004: ID 0609:0334 SMK Manufacturing, Inc. eHome Infrared=
 Receiver
> >=20
> > DVB-T receiver (no RC_CORE device)
> > Bus 001 Device 004: ID 0ccd:0069 TerraTec Electronic GmbH Cinergy T XE =
(Version 2, AF9015)
> >=20
> > twin-tuner DVB-S2 PCIe device, TeVii s480 v2.1 (physically one IR=20
> > receiver (NEC protocol), logically recognized as two RC_CORE devices):
> [...]
> > 	Bus 006 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
> > 	Bus 003 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660

> Today I got a new, similar, trace with kernel 3.18.1, but this is not a
> regression and randomly happens with older kernels as well. The=20
> frequency of this occuring differs vastly, this time it was 12 days=20
> with probably 20 (re-)boots, before that it didn't happen for multiple
> weeks. I can not totally rule out if it ever happened in the reverse
> detection/ initialisation order, as I wouldn't notice the consequences=20
> of dvb_usb_dw2102's RC_CORE devices failing to initialise, but I think
> the problem might be seated in the common core of rc-main.c.

This remains to be a re-occuring issue with kernel 3.19 and 4.0-rc6,=20
not happening on every boot, but every few weeks.

[    1.837215] Registered IR keymap rc-rc6-mce
[    1.837225] ------------[ cut here ]------------
[    1.837229] WARNING: CPU: 3 PID: 277 at /tmp/buildd/linux-aptosid-4.0~rc=
6/fs/sysfs/dir.c:31 sysfs_warn_dup+0x55/0x70()
[    1.837230] sysfs: cannot create duplicate filename '/class/rc/rc0'
[    1.837231] Modules linked in: rt2800usb(+) rt2x00usb rt2800lib rt2x00li=
b mac80211 cfg80211 rc_rc6_mce crc_ccitt mceusb(+) rc_tevii_nec ds3000 btus=
b dvb_usb_af9015 dvb_usb_v2 bluetooth nls_utf8 nls_cp437 vfat fat snd_hda_c=
odec_hdmi iTCO_wdt eeepc_wmi iTCO_vendor_support asus_wmi sparse_keymap int=
el_rapl rfkill iosf_mbi x86_pkg_temp_thermal intel_powerclamp evdev coretem=
p snd_hda_codec_realtek snd_hda_codec_generic kvm_intel kvm crct10dif_pclmu=
l crc32_pclmul ghash_clmulni_intel dvb_usb_dw2102 dvb_usb aesni_intel aes_x=
86_64 lrw dvb_core gf128mul rc_core snd_hda_intel glue_helper i915 ablk_hel=
per snd_hda_controller cryptd snd_hda_codec i2c_algo_bit psmouse snd_hwdep =
drm_kms_helper snd_pcm serio_raw pcspkr i2c_i801 drm snd_timer lpc_ich snd =
i2c_core mfd_core soundcore intel_gtt mei_me battery ie31200_edac
[    1.837253]  mei 8250_fintek edac_core tpm_infineon video wmi processor =
button nct6775 hwmon_vid fuse parport_pc ppdev lp parport autofs4 ext4 crc1=
6 jbd2 mbcache dm_mod sg sd_mod ohci_pci crc32c_intel ahci libahci libata x=
hci_pci scsi_mod ohci_hcd ehci_pci xhci_hcd ehci_hcd r8169 mii usbcore usb_=
common fan thermal
[    1.837267] CPU: 3 PID: 277 Comm: systemd-udevd Not tainted 4.0.0-rc6-ap=
tosid-amd64 #1 aptosid 4.0~rc6-1~git0.slh.1
[    1.837268] Hardware name: System manufacturer System Product Name/P8H77=
-M PRO, BIOS 1503 03/17/2014
[    1.837269]  ffffffff816236d0 0000000054e7a09b ffffffff816236d0 ffffffff=
814fb0ee
[    1.837271]  ffff8807fb643880 ffffffff81060627 ffff8807fbe5c000 ffff8807=
fbe2ee78
[    1.837272]  ffff8807f93a07f8 ffff8807f93a07f8 ffffffffffffffef ffffffff=
810606b8
[    1.837273] Call Trace:
[    1.837277]  [<ffffffff814fb0ee>] ? dump_stack+0x47/0x67
[    1.837279]  [<ffffffff81060627>] ? warn_slowpath_common+0x77/0xb0
[    1.837280]  [<ffffffff810606b8>] ? warn_slowpath_fmt+0x58/0x80
[    1.837282]  [<ffffffff811ea562>] ? kernfs_path+0x42/0x50
[    1.837284]  [<ffffffff811ed975>] ? sysfs_warn_dup+0x55/0x70
[    1.837286]  [<ffffffff811edcce>] ? sysfs_do_create_link_sd.isra.2+0xbe/=
0xd0
[    1.837287]  [<ffffffff813887a4>] ? device_add+0x264/0x640
[    1.837291]  [<ffffffffa09c38dc>] ? rc_register_device+0x1bc/0x610 [rc_c=
ore]
[    1.837293]  [<ffffffffa0861f55>] ? mceusb_dev_probe+0x405/0xadd [mceusb]
[    1.837296]  [<ffffffff81271aa8>] ? ida_get_new_above+0x1f8/0x220
[    1.837298]  [<ffffffff81271b69>] ? ida_simple_get+0x99/0x120
[    1.837304]  [<ffffffffa0036763>] ? usb_probe_interface+0x193/0x290 [usb=
core]
[    1.837306]  [<ffffffff8138b647>] ? driver_probe_device+0x87/0x260
[    1.837309]  [<ffffffff8138b8eb>] ? __driver_attach+0x7b/0x80
[    1.837311]  [<ffffffff8138b870>] ? __device_attach+0x50/0x50
[    1.837312]  [<ffffffff813896fb>] ? bus_for_each_dev+0x6b/0xc0
[    1.837313]  [<ffffffff8138ade8>] ? bus_add_driver+0x178/0x230
[    1.837315]  [<ffffffff8138bf1e>] ? driver_register+0x5e/0xf0
[    1.837319]  [<ffffffffa003514b>] ? usb_register_driver+0x7b/0x160 [usbc=
ore]
[    1.837321]  [<ffffffffa0865000>] ? 0xffffffffa0865000
[    1.837323]  [<ffffffffa0865000>] ? 0xffffffffa0865000
[    1.837325]  [<ffffffff81002108>] ? do_one_initcall+0x98/0x1f0
[    1.837327]  [<ffffffff814fa016>] ? do_init_module+0x50/0x1b0
[    1.837329]  [<ffffffff810d1df3>] ? load_module+0x1b03/0x2030
[    1.837331]  [<ffffffff810cf240>] ? __symbol_put+0x70/0x70
[    1.837333]  [<ffffffff811819ae>] ? kernel_read+0x4e/0x80
[    1.837334]  [<ffffffff810d248d>] ? SyS_finit_module+0x8d/0xa0
[    1.837336]  [<ffffffff81500e49>] ? system_call_fastpath+0x12/0x17
[    1.837337] ---[ end trace 158112bdd663741e ]---
[    1.837347] mceusb 2-1.6:1.0: remote dev registration failed
[    1.837370] mceusb 2-1.6:1.0: mceusb_dev_probe: device setup failed!
[    1.837392] mceusb: probe of 2-1.6:1.0 failed with error -12
[    1.837410] usbcore: registered new interface driver mceusb

Regards
	Stefan Lippers-Hollmann

--Sig_/U.9O_s78Dcp0XF.H0aqp3MB
Content-Type: application/pgp-signature
Content-Description: Digitale Signatur von OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVGWwXAAoJEL/gLWWx0ULtyuUQAMnzaT4eXMZUhiXwopHxUeqr
3YcAm/j5e7RfNIEZGs2I9T1ZJ4q3vgqla+ZK3QD8leWjpsqr9eHtGMSjbtrVRnmg
U5mXVkPhXgdTt7yH25vIqvmNSMnBQllTjV/JmQbUjzKVG7XoDlVqMNFNGQsZ6OTj
frvYFUjEenvQJRmb0CBpgrM8lpDgPHddJXFAOaV6EYwDvsrwyq1YqW9krAOWrHid
6C6BxVf3ESGm5GZMLKGSydRazx/Nz4UoWTIKKM6xF+T+epW9sDMyMJRZus2c9aNl
qTiUqbdrVkSchvRzRFJ6uI4PYa4bpxKV+U5enuB8nPC7Y7hRFQ7LLSTn0BC5Cf4I
McEjdXs4leABflmaZGmXRu2H7I3KOZxk9v0PfTsiRkNGeYLhy2ow0frgTXrzphHg
s5kpdxH13BDPTNZwSEuclUxt3n5QijzQoxXujlDpnmmrgby4OHQBO9Mz+Eqj5aC6
MyYzt7dQXJlg9KRO0ECamI7Cp04tbxGXeqOaVwYaetf05YSmJ5r26ZLzlmkG4rKE
NpBblHtuEFrMYQpJ2bjPa3ytX1ieXFrRwKX/6b/YdwcqCHmTOA3x4AJanvMpq2g8
GFM2py2gFVNGtAI1hECU6UL0QDXW2Dp8pOyxiBJN2MeGZdeBHk0CzKfWoUmDUOOd
BVstSWjx3kxmx7UXrWaF
=JEh1
-----END PGP SIGNATURE-----

--Sig_/U.9O_s78Dcp0XF.H0aqp3MB--
