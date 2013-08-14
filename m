Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:39041 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485Ab3HNIyp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Aug 2013 04:54:45 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Johannes Rohr <jorohr@gmail.com>
Cc: 719623@bugs.debian.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: Bug#719623: linux-image-3.10-2-amd64: kernel panic on inserting DVB-T stick
References: <20130813191517.8235.17574.reportbug__30229.9182200388$1376421507$gmane$org@Erwin.babel>
Date: Wed, 14 Aug 2013 10:34:51 +0200
In-Reply-To: <20130813191517.8235.17574.reportbug__30229.9182200388$1376421507$gmane$org@Erwin.babel>
	(Johannes Rohr's message of "Tue, 13 Aug 2013 21:15:17 +0200")
Message-ID: <87bo50brh0.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I took a quick look at the code and wonder if the problem is caused by
an initial zero statistics message?  This is all just a wild guess, but
if it is correct, then the attached untested patch might fix it...


Bj=C3=B8rn


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline;
 filename=0001-media-siano-fix-divide-error-on-0-counters.patch
Content-Transfer-Encoding: quoted-printable

>From d78a0599d5b5d4da384eae08bf7da316389dfbe5 Mon Sep 17 00:00:00 2001
From: =3D?UTF-8?q?Bj=3DC3=3DB8rn=3D20Mork?=3D <bjorn@mork.no>
Date: Wed, 14 Aug 2013 10:24:39 +0200
Subject: [PATCH] [media] siano: fix divide error on 0 counters
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

ts_packets and ets_packets counters can be 0.  Don't fall over
if they are. Fixes:

[  846.851711] divide error: 0000 [#1] SMP
[  846.851806] Modules linked in: smsdvb dvb_core ir_lirc_codec lirc_dev ir=
_sanyo_decoder ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder ir_rc6_dec=
oder ir_rc5_decoder ir_nec_decoder rc_hauppauge smsusb smsmdtv rc_core pci_=
stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) parport_pc ppdev lp =
parport cpufreq_userspace cpufreq_powersave cpufreq_stats cpufreq_conservat=
ive rfcomm bnep binfmt_misc uinput nfsd auth_rpcgss oid_registry nfs_acl nf=
s lockd dns_resolver fscache sunrpc ext4 jbd2 fuse tp_smapi(O) thinkpad_ec(=
O) loop firewire_sbp2 dm_crypt snd_hda_codec_conexant snd_hda_intel snd_hda=
_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm thinkpad_acpi nvram snd_=
page_alloc hid_generic snd_seq_midi snd_seq_midi_event arc4 usbhid snd_rawm=
idi uvcvideo hid iwldvm coretemp kvm_intel mac8021
 1 cdc_wdm
[  846.853477]  cdc_acm snd_seq videobuf2_vmalloc videobuf2_memops videobuf=
2_core videodev media kvm radeon r852 ttm joydev cdc_ether usbnet pcmcia mi=
i sm_common nand btusb drm_kms_helper tpm_tis acpi_cpufreq bluetooth iwlwif=
i nand_ecc drm nand_ids i2c_i801 mtd snd_seq_device iTCO_wdt iTCO_vendor_su=
pport r592 memstick lpc_ich mperf tpm yenta_socket pcmcia_rsrc pcmcia_core =
cfg80211 snd_timer snd pcspkr i2c_algo_bit crc16 i2c_core tpm_bios processo=
r mfd_core wmi psmouse mei_me rfkill mei serio_raw soundcore evdev battery =
button video ac microcode ext3 mbcache jbd md_mod dm_mirror dm_region_hash =
dm_log dm_mod sg sr_mod sd_mod cdrom crc_t10dif firewire_ohci sdhci_pci sdh=
ci mmc_core firewire_core crc_itu_t thermal thermal_sys ahci libahci ehci_p=
ci uhci_hcd ehci_hcd libata scsi_mod usbcore e1000
 e usb_common
[  846.855310]  ptp pps_core
[  846.855356] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           O 3.10-2-=
amd64 #1 Debian 3.10.5-1
[  846.855490] Hardware name: LENOVO 4061WFA/4061WFA, BIOS 6FET92WW (3.22 )=
 12/14/2011
[  846.855609] task: ffffffff81613400 ti: ffffffff81600000 task.ti: fffffff=
f81600000
[  846.855636] RIP: 0010:[<ffffffffa092be0c>]  [<ffffffffa092be0c>] smsdvb_=
onresponse+0x264/0xa86 [smsdvb]
[  846.863906] RSP: 0018:ffff88013bc03cf0  EFLAGS: 00010046
[  846.863906] RAX: 0000000000000000 RBX: ffff880133bf6000 RCX: 00000000000=
00000
[  846.863906] RDX: 0000000000000000 RSI: ffff88005d3b58c0 RDI: ffff880133b=
f6000
[  846.863906] RBP: ffff88005d1da000 R08: 0000000000000058 R09: 00000000000=
00015
[  846.863906] R10: 0000000000001a0d R11: 000000000000021a R12: ffff88005d3=
b58c0
[  846.863906] R13: ffff88005d1da008 R14: 00000000ffffff8d R15: ffff880036c=
f5060
[  846.863906] FS:  0000000000000000(0000) GS:ffff88013bc00000(0000) knlGS:=
0000000000000000
[  846.863906] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  846.863906] CR2: 00007f3a4b69ae50 CR3: 0000000036dac000 CR4: 00000000000=
407f0
[  846.863906] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[  846.863906] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00000000000=
00400
[  846.863906] Stack:
[  846.863906]  ffff88007a102000 ffff88005d1da000 ffff88005d3b58c0 00000000=
00085824
[  846.863906]  ffffffffa08c5aa3 ffff88005d1da000 ffff8800a6907390 ffff8800=
a69073b0
[  846.863906]  ffff8800a6907000 ffffffffa08b642c 000000000000021a ffff8800=
a69073b0
[  846.863906] Call Trace:
[  846.863906]  <IRQ>
[  846.863906]
[  846.863906]  [<ffffffffa08c5aa3>] ? smscore_onresponse+0x1d5/0x353 [smsm=
dtv]
[  846.863906]  [<ffffffffa08b642c>] ? smsusb_onresponse+0x146/0x192 [smsus=
b]
[  846.863906]  [<ffffffffa004cb1a>] ? usb_hcd_giveback_urb+0x6c/0xac [usbc=
ore]
[  846.863906]  [<ffffffffa0217be1>] ? ehci_urb_done+0x62/0x72 [ehci_hcd]
[  846.863906]  [<ffffffffa0217c82>] ? qh_completions+0x91/0x364 [ehci_hcd]
[  846.863906]  [<ffffffffa0219bba>] ? ehci_work+0x8a/0x68e [ehci_hcd]
[  846.863906]  [<ffffffff8107336c>] ? timekeeping_get_ns.constprop.10+0xd/=
0x31
[  846.863906]  [<ffffffff81064d41>] ? update_cfs_rq_blocked_load+0xde/0xec
[  846.863906]  [<ffffffff81058ec2>] ? run_posix_cpu_timers+0x25/0x575
[  846.863906]  [<ffffffffa021aa46>] ? ehci_irq+0x211/0x23d [ehci_hcd]
[  846.863906]  [<ffffffffa004c0c1>] ? usb_hcd_irq+0x31/0x48 [usbcore]
[  846.863906]  [<ffffffff810996fd>] ? handle_irq_event_percpu+0x49/0x1a4
[  846.863906]  [<ffffffff8109988a>] ? handle_irq_event+0x32/0x4b
[  846.863906]  [<ffffffff8109bd76>] ? handle_fasteoi_irq+0x80/0xb6
[  846.863906]  [<ffffffff8100e93e>] ? handle_irq+0x18/0x20
[  846.863906]  [<ffffffff8100e657>] ? do_IRQ+0x40/0x95
[  846.863906]  [<ffffffff813883ed>] ? common_interrupt+0x6d/0x6d
[  846.863906]  <EOI>
[  846.863906]
[  846.863906]  [<ffffffff812a011c>] ? arch_local_irq_enable+0x4/0x8
[  846.863906]  [<ffffffff812a04f3>] ? cpuidle_enter_state+0x52/0xc1
[  846.863906]  [<ffffffff812a0636>] ? cpuidle_idle_call+0xd4/0x143
[  846.863906]  [<ffffffff8101398c>] ? arch_cpu_idle+0x5/0x17
[  846.863906]  [<ffffffff81072571>] ? cpu_startup_entry+0x10d/0x187
[  846.863906]  [<ffffffff816b3d3d>] ? start_kernel+0x3e8/0x3f3
[  846.863906]  [<ffffffff816b3777>] ? repair_env_string+0x54/0x54
[  846.863906]  [<ffffffff816b3598>] ? x86_64_start_kernel+0xf2/0xfd
[  846.863906] Code: 25 09 00 00 c6 83 da 08 00 00 03 8b 45 54 48 01 83 b6 =
08 00 00 8b 45 50 48 01 83 db 08 00 00 8b 4d 18 69 c1 ff ff 00 00 03 4d 14 =
<48> f7 f1 89 83 a8 09 00 00 e9 68 fe ff ff 48 8b 7f 10 e8 79 92
[  846.863906] RIP  [<ffffffffa092be0c>] smsdvb_onresponse+0x264/0xa86 [sms=
dvb]
[  846.863906]  RSP <ffff88013bc03cf0>

Reported-by: Johannes Rohr <jorohr@gmail.com>
Reference: http://bugs.debian.org/719623
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
---
 drivers/media/common/siano/smsdvb-main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/commo=
n/siano/smsdvb-main.c
index 0862622..63676a8 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -276,7 +276,8 @@ static void smsdvb_update_per_slices(struct smsdvb_clie=
nt_t *client,
=20
 	/* Legacy PER/BER */
 	tmp =3D p->ets_packets * 65535;
-	do_div(tmp, p->ts_packets + p->ets_packets);
+	if (p->ts_packets + p->ets_packets)
+		do_div(tmp, p->ts_packets + p->ets_packets);
 	client->legacy_per =3D tmp;
 }
=20
--=20
1.7.10.4


--=-=-=--
