Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58405 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1DRLp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 07:45:27 -0400
Received: by bwz15 with SMTP id 15so3737806bwz.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 04:45:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 Apr 2011 13:45:26 +0200
Message-ID: <BANLkTikrC+sR4FJ3zuci==_Bs7tk0-4CRw@mail.gmail.com>
Subject: DiB0700: get rid of on-stack dma buffers
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Olivier Grenie <olivier.grenie@dibcom.fr>,
	Patrick Boettcher <patrick.boettcher@dibcom.fr>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Florian Mickler <florian@mickler.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

I''ve tested patch:  115ab9ed519fa45f553b1d32241eb28e01430f7f
(http://git.linuxtv.org/pb/media_tree.git?a=commit;h=16b54de2d8b46e48c5c8bdf9b350eac04e8f6b46)

And I still get:

dib0700: firmware started successfully.
dvb-usb: found a 'Hauppauge Nova-TD Stick (52009)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:867 check_for_stack+0xb3/0xf0()
Hardware name: 6464CTO
ehci_hcd 0000:00:1d.7: DMA-API: device driver maps memory fromstack
[addr=ffff880138b13bd6]
Modules linked in: ir_lirc_codec dvb_usb_dib0700(+) lirc_dev dib7000p
ir_sony_decoder dib7000m dib0070 ir_jvc_decoder dvb_usb ir_rc6_decoder
dib8000 dvb_core ir_rc5_decoder ir_nec_decoder dib3000mc rc_core
dibx000_common ip6_tables ebtable_nat ebtables iptable_mangle
xt_tcpudp tun bridge ipv6 stp llc sunrpc bluetooth ipt_REJECT
xt_physdev xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables x_tables
snd_hda_codec_analog arc4 ecb crypto_blkcipher cryptomgr aead
crypto_algapi iwl3945 iwl_legacy snd_hda_intel mac80211 snd_hda_codec
snd_seq snd_seq_device psmouse serio_raw cfg80211 e1000e snd_pcm
i2c_i801 iTCO_wdt thinkpad_acpi snd_timer iTCO_vendor_support
snd_page_alloc wmi snd soundcore nvram evdev i915 dm_mirror
dm_region_hash dm_log dm_mod drm_kms_helper drm i2c_algo_bit i2c_core
autofs4 usbhid hid pcmcia sdhci_pci uhci_hcd sr_mod ehci_hcd sdhci
yenta_socket mmc_core cdrom usbcore video backlight
Pid: 1185, comm: modprobe Not tainted 2.6.39-rc3-00236-g115ab9e #7
Call Trace:
 [<ffffffff810501df>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff810502d6>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81496d69>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff812a3713>] check_for_stack+0xb3/0xf0
 [<ffffffff812a3acf>] debug_dma_map_page+0xff/0x150
 [<ffffffffa00baea2>] usb_hcd_map_urb_for_dma+0x522/0x590 [usbcore]
 [<ffffffff81496d69>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffffa00bb055>] usb_hcd_submit_urb+0x145/0x7e0 [usbcore]
 [<ffffffff8108b463>] ? lockdep_init_map+0xb3/0x560
 [<ffffffffa00bc3e4>] usb_submit_urb+0xf4/0x390 [usbcore]
 [<ffffffffa00bd94c>] usb_start_wait_urb+0x6c/0x170 [usbcore]
 [<ffffffffa00bc7d5>] ? usb_init_urb+0x55/0xf0 [usbcore]
 [<ffffffffa00bdcd6>] usb_control_msg+0xe6/0x120 [usbcore]
 [<ffffffffa0571404>] ? dib0700_i2c_xfer+0x64/0x350 [dvb_usb_dib0700]
 [<ffffffffa0571404>] ? dib0700_i2c_xfer+0x64/0x350 [dvb_usb_dib0700]
 [<ffffffffa0571368>] dib0700_ctrl_rd+0x88/0xc0 [dvb_usb_dib0700]
 [<ffffffffa05714da>] dib0700_i2c_xfer+0x13a/0x350 [dvb_usb_dib0700]
 [<ffffffffa0044f3a>] i2c_transfer+0xaa/0x120 [i2c_core]
 [<ffffffffa055989e>] dib7000p_read_word+0x6e/0xd0 [dib7000p]
 [<ffffffffa055adf1>] dib7000p_identify+0x31/0x110 [dib7000p]
 [<ffffffffa055afcb>] dib7000p_i2c_enumeration+0xfb/0x310 [dib7000p]
 [<ffffffffa0571082>] ? dib0700_rc_urb_completion+0x12/0x140 [dvb_usb_dib0700]
 [<ffffffffa0573b6c>] stk7070pd_frontend_attach0+0xfc/0x1c0 [dvb_usb_dib0700]
 [<ffffffffa04ed46e>] dvb_usb_adapter_frontend_init+0x1e/0x110 [dvb_usb]
 [<ffffffffa04ec960>] dvb_usb_device_init+0x390/0x670 [dvb_usb]
 [<ffffffffa0571fca>] dib0700_probe+0x6a/0xe0 [dvb_usb_dib0700]
 [<ffffffffa00c10b6>] usb_probe_interface+0xf6/0x250 [usbcore]
 [<ffffffff81354c2c>] driver_probe_device+0x9c/0x2b0
 [<ffffffff81354eeb>] __driver_attach+0xab/0xb0
 [<ffffffff81354e40>] ? driver_probe_device+0x2b0/0x2b0
 [<ffffffff81354e40>] ? driver_probe_device+0x2b0/0x2b0
 [<ffffffff81353a24>] bus_for_each_dev+0x64/0xa0
 [<ffffffff8135484e>] driver_attach+0x1e/0x20
 [<ffffffff81354440>] bus_add_driver+0x1c0/0x2b0
 [<ffffffff81355466>] driver_register+0x76/0x140
 [<ffffffff81298028>] ? __raw_spin_lock_init+0x38/0x70
 [<ffffffffa00bfe75>] usb_register_driver+0xc5/0x1b0 [usbcore]
 [<ffffffffa058e000>] ? 0xffffffffa058dfff
 [<ffffffffa058e034>] dib0700_module_init+0x34/0x51 [dvb_usb_dib0700]
 [<ffffffff810001d2>] do_one_initcall+0x42/0x180
 [<ffffffff8109df6b>] sys_init_module+0xab/0x200
 [<ffffffff8149ac6b>] system_call_fastpath+0x16/0x1b
---[ end trace 5934ecdc00d47ffa ]---
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Hauppauge Nova-TD Stick (52009))


(as reported in https://bugzilla.kernel.org/show_bug.cgi?id=15977)

Also the stick is impossible to suspend & resume while it's in use:
(essentially suspend led keeps flashing)


[   67.456753] PM: Syncing filesystems ... done.
[   67.471267] PM: Preparing system for mem sleep
[   67.478857] Freezing user space processes ... (elapsed 0.01 seconds) done.
[   67.499501] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[   67.519556] PM: Entering mem sleep
[   67.523442] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   67.529871] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   67.536396] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   67.542800] uhci_hcd 0000:00:1a.1: power state changed by ACPI to D0
[   67.549327] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[   67.556523] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[   67.562494] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   67.568901] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   67.576516] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   67.582932] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[   67.589339] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   67.596531] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   67.602685] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   67.609874] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   67.615808] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   67.622215] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   67.628717] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   67.635130] uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
[   67.641636] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   67.648897] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   67.828124] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   67.834110] sd 0:0:0:0: [sda] Stopping disk
[   67.887464] ACPI handle has no context!
[   67.891339] sdhci-pci 0000:15:00.3: PCI INT C disabled
[   67.897077] ACPI handle has no context!
[   67.897666] ACPI handle has no context!
[   67.897677] sdhci-pci 0000:15:00.2: PCI INT C disabled
[   67.897689] ACPI handle has no context!
[   67.898106] ata_piix 0000:00:1f.1: PCI INT C disabled
[   67.898447] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[   67.898478] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[   67.898500] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[   67.903375] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[   67.903398] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[   67.903420] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[   67.960162] i915 0000:00:02.0: power state changed by ACPI to D3
[   68.050559] HDA Intel 0000:00:1b.0: PCI INT B disabled
[   68.144358] e1000e 0000:00:19.0: PME# enabled
[   68.148749] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[   90.506798] thinkpad_acpi: fan watchdog: enabling fan
