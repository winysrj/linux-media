Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7CCMKEd026859
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 08:22:20 -0400
Received: from fmmailgate05.web.de (fmmailgate05.web.de [217.72.192.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7CCM672023576
	for <video4linux-list@redhat.com>; Tue, 12 Aug 2008 08:22:06 -0400
Received: from web.de
	by fmmailgate05.web.de (Postfix) with SMTP id 1607958F64B0
	for <video4linux-list@redhat.com>;
	Tue, 12 Aug 2008 14:22:01 +0200 (CEST)
Date: Tue, 12 Aug 2008 14:22:00 +0200
Message-Id: <750458896@web.de>
MIME-Version: 1.0
From: Stefan Lange <sailer22@web.de>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Subject: Problems Terratec Cinergy T XS no scan
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi all,

 i have now setup my Cinergy T XS with the v4l Sources.

So far everything looks fine. (Attached my dmesg)

But when i try to use vlc or w_scan or scan or any other Application, everything seems to hang.

After interrupting the Application i get the message when i try to restart that the ressource is busy.

Can anyone help me to get this dvb-t Stick working.

Thanx
sailer22

[   24.524493] usbcore: registered new interface driver hci_usb
[   24.623342] Linux video capture interface: v2.00
[   24.658822] em28xx v4l2 driver version 0.0.1 loaded
[   24.658848] em28xx new video device (0ccd:0043): interface 0, class 255
[   24.658851] em28xx: device is attached to a USB 2.0 bus
[   24.658852] em28xx: you're using the experimental/unstable tree from mcentral.de
[   24.658853] em28xx: there's also a stable tree available but which is limited to
[   24.658854] em28xx: linux <=2.6.19.2
[   24.658855] em28xx: it's fine to use this driver but keep in mind that it will move
[   24.658856] em28xx: to http://mcentral.de/hg/~mrec/v4l-dvb-kernel as soon as it's
[   24.658857] em28xx: proved to be stable
[   24.658859] em28xx #0: Alternate settings: 8
[   24.658860] em28xx #0: Alternate setting 0, max size= 0
[   24.658861] em28xx #0: Alternate setting 1, max size= 0
[   24.658863] em28xx #0: Alternate setting 2, max size= 1448
[   24.658864] em28xx #0: Alternate setting 3, max size= 2048
[   24.658865] em28xx #0: Alternate setting 4, max size= 2304
[   24.658866] em28xx #0: Alternate setting 5, max size= 2580
[   24.658868] em28xx #0: Alternate setting 6, max size= 2892
[   24.658869] em28xx #0: Alternate setting 7, max size= 3072
[   24.659395] em28xx-video.c: New Terratec XS Detected
[   24.929830] attach_inform: eeprom detected.
[   24.956637] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12 81 00 6a 24 8e 34
[   24.956642] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00 00 00 00 00 00 00
[   24.956647] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00 00 00 5b 00 00 00
[   24.956651] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 dc a7 4b 4a
[   24.956655] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956659] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956663] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 24 03 43 00 69 00
[   24.956667] em28xx #0: i2c eeprom 70: 6e 00 65 00 72 00 67 00 79 00 20 00 54 00 20 00
[   24.956671] em28xx #0: i2c eeprom 80: 55 00 53 00 42 00 20 00 58 00 53 00 00 00 34 03
[   24.956675] em28xx #0: i2c eeprom 90: 54 00 65 00 72 00 72 00 61 00 54 00 65 00 63 00
[   24.956679] em28xx #0: i2c eeprom a0: 20 00 45 00 6c 00 65 00 63 00 74 00 72 00 6f 00
[   24.956683] em28xx #0: i2c eeprom b0: 6e 00 69 00 63 00 20 00 47 00 6d 00 62 00 48 00
[   24.956687] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956691] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956695] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956699] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   24.956703] EEPROM ID= 0x9567eb1a
[   24.956704] Vendor/Product ID= 0ccd:0043
[   24.956705] No audio on board.
[   24.956706] 500mA max power
[   24.956706] Table at 0x06, strings=0x246a, 0x348e, 0x0000
[   24.957389] em28xx #0: Found Terratec Cinergy T XS (MT2060)
[   24.957411] usbcore: registered new interface driver em28xx
[   25.037967] tuner 0-0060: Chip ID is not zero. It is not a TEA5767
[   25.037970] tuner 0-0060: chip found @ 0xc0 (em28xx #0)
[   25.037985] attach inform (default): detected I2C address c0
[   25.037988] /home/langes/dvbt2/v4l-dvb-kernel/v4l/tuner-core.c: setting tuner callback
[   25.037989] /home/langes/dvbt2/v4l-dvb-kernel/v4l/tuner-core.c: setting tuner callback
[   25.253920] em2880-dvb.c: DVB Init
[   25.255819] MT2060: successfully identified (IF1 = 1220)
[   25.441437] iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
[   25.441726] wmaster0: Selected rate control algorithm 'iwl-4965-rs'
[   25.567049] cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xd3fff 0xe0000-0xfffff
[   25.569935] cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   25.569943] cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[   25.569951] cs: memory probe 0xe4100000-0xe43fffff: excluding 0xe4100000-0xe412ffff
[   25.574843] pcmcia: registering new device pcmcia1.0
[   25.655341] scsi5 : pata_pcmcia
[   25.655366] ata6: PATA max PIO0 cmd 0x100 ctl 0x10e irq 17
[   25.725206] DVB: registering new adapter (em2880 DVB-T)
[   25.725208] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   25.725360] Em28xx: Initialized (Em2880 DVB Extension) extension
[   26.825636] lp0: using parport0 (interrupt-driven).
[   26.880458] Adding 979924k swap on /dev/sda1.  Priority:-1 extents:1 across:979924k
[   26.962970] EXT3 FS on sda3, internal journal
[   27.075840] kjournald starting.  Commit interval 5 seconds
[   27.076035] EXT3 FS on sda4, internal journal
[   27.076038] EXT3-fs: mounted filesystem with ordered data mode.
[   27.224838] ip_tables: (C) 2000-2006 Netfilter Core Team
[   27.395393] No dock devices found.
[   27.849027] NET: Registered protocol family 10
[   27.849172] lo: Disabled Privacy Extensions
[   27.924668] ppdev: user-space parallel port driver
[   27.944430] audit(1218542214.553:2): type=1503 operation="inode_permission" requested_mask="a::" denied_mask="a::" name="/dev/tty" pid=5641 profile="/usr/sbin/cupsd" namespace="default"
[   28.291901] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   28.291911] vboxdrv: Successfully done.
[   28.291991] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   28.291996] vboxdrv: Successfully loaded version 1.5.6_OSE (interface 0x00050002).
[   29.161989] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   29.189944] Bluetooth: L2CAP ver 2.9
[   29.189947] Bluetooth: L2CAP socket layer initialized
[   29.235014] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[   29.235017] e1000: eth1: e1000_watchdog: 10/100 speed: disabling TSO
[   29.236993] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   29.240423] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   29.358749] Bluetooth: RFCOMM socket layer initialized
[   29.358771] Bluetooth: RFCOMM TTY layer initialized
[   29.358774] Bluetooth: RFCOMM ver 1.8
[   31.108362] NET: Registered protocol family 17
[   32.651409] /dev/vmmon[6220]: Module vmmon: registered with major=10 minor=165
[   32.651422] /dev/vmmon[6220]: Module vmmon: initialized
[   32.999397] /dev/vmnet: open called by PID 6247 (vmnet-bridge)
[   32.999408] /dev/vmnet: hub 0 does not exist, allocating memory.
[   32.999421] /dev/vmnet: port on hub 0 successfully opened
[   32.999442] bridge-eth0: peer interface eth0 not found, will wait for it to come up
[   32.999446] bridge-eth0: attached
[   33.009192] /dev/vmnet: open called by PID 6260 (vmnet-bridge)
[   33.009329] /dev/vmnet: hub 2 does not exist, allocating memory.
[   33.009497] /dev/vmnet: port on hub 2 successfully opened
[   33.009620] bridge-eth1: enabling the bridge
[   33.009715] bridge-eth1: up
[   33.009785] bridge-eth1: already up
[   33.009788] bridge-eth1: attached
[   33.015193] /dev/vmnet: open called by PID 6257 (vmnet-netifup)
[   33.015201] /dev/vmnet: hub 1 does not exist, allocating memory.
[   33.015215] /dev/vmnet: port on hub 1 successfully opened
[   33.017480] /dev/vmnet: open called by PID 6268 (vmnet-netifup)
[   33.017488] /dev/vmnet: hub 8 does not exist, allocating memory.
[   33.017501] /dev/vmnet: port on hub 8 successfully opened
[   33.046994] /dev/vmnet: open called by PID 6270 (vmnet-natd)
[   33.047014] /dev/vmnet: port on hub 8 successfully opened
[   33.151287] /dev/vmnet: open called by PID 6297 (vmnet-dhcpd)
[   33.151306] /dev/vmnet: port on hub 8 successfully opened
[   33.151646] /dev/vmnet: open called by PID 6290 (vmnet-dhcpd)
[   33.151661] /dev/vmnet: port on hub 1 successfully opened
[   33.305786] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   36.738478] vmnet1: no IPv6 routers present
[   36.782685] vmnet8: no IPv6 routers present
[   37.178356] eth1: no IPv6 routers present
[   62.318956] CPU0 attaching NULL sched-domain.
[   62.318960] CPU1 attaching NULL sched-domain.
[   62.333700] CPU0 attaching sched-domain:
[   62.333706]  domain 0: span 03
[   62.333708]   groups: 01 02
[   62.333710]   domain 1: span 03
[   62.333711]    groups: 03
[   62.333713] CPU1 attaching sched-domain:
[   62.333714]  domain 0: span 03
[   62.333715]   groups: 02 01
[   62.333717]   domain 1: span 03
[   62.333718]    groups: 03
[   76.189815] Unable to handle kernel paging request at 000000013a04d214 RIP: 
[   76.189824]  [<ffffffff88cb59a7>] :dvb_core:dvb_frontend_should_wakeup+0x7/0x30
[   76.189851] PGD 10e849067 PUD 0 
[   76.189856] Oops: 0000 [1] SMP 
[   76.189861] CPU 1 
[   76.189864] Modules linked in: xt_tcpudp nf_conntrack_irc nf_conntrack_ftp xt_state xt_limit ipt_LOG iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack vmnet(P) vmmon(P) binfmt_misc af_packet rfcomm l2cap vboxdrv ppdev ipv6 acpi_cpufreq cpufreq_stats cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_ondemand freq_table dock sbs sbshc iptable_filter ip_tables x_tables sbp2 lp pata_pcmcia arc4 ecb blkcipher qt1010 mt2060 xc3028_tuner joydev mt352 zl10353 pcmcia tuner em2880_dvb dvb_core tvp5150 em28xx compat_ioctl32 ir_common videodev v4l2_common v4l1_compat tveeprom hci_usb bluetooth iwl4965 snd_hda_intel iwlwifi_mac80211 snd_pcm_oss snd_mixer_oss nvidia(P) cfg80211 sr_mod cdrom snd_pcm i2c_core snd_page_alloc snd_hwdep container video output snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sdhci yenta_socket psmouse mmc_core serio_raw ricoh_mmc rsrc_nonstatic wmi_acer snd battery tpm_infineo
 n tpm tpm_bios button pcmcia_core ac parport_pc parport intel_agp shpchp pci_hotplug evdev iTCO_wdt iTCO_vendor_support soundcore pcspkr ext3 jbd mbcache usbhid hid sg sd_mod ata_piix pata_acpi ata_generic ohci1394 ahci ieee1394 libata scsi_mod uhci_hcd ehci_hcd usbcore e1000 thermal processor fan fbcon tileblit font bitblit softcursor fuse
[   76.190041] Pid: 7209, comm: kdvb-fe-0 Tainted: P        2.6.24-19-generic #1
[   76.190045] RIP: 0010:[<ffffffff88cb59a7>]  [<ffffffff88cb59a7>] :dvb_core:dvb_frontend_should_wakeup+0x7/0x30
[   76.190066] RSP: 0018:ffff8101228b3e98  EFLAGS: 00010282
[   76.190071] RAX: 000000013a04d000 RBX: 00000000000000fa RCX: ffffffff8806a6cf
[   76.190075] RDX: 0000000000000000 RSI: ffff81000102bec0 RDI: ffff81013a654808
[   76.190079] RBP: ffff81013a654808 R08: 0000000000000000 R09: ffff81013fa06138
[   76.190083] R10: ffff81000102efe0 R11: 0000000000000001 R12: ffff81013a04d000
[   76.190088] R13: ffff8101228b3ec0 R14: ffff81013a04d1e8 R15: ffff81013a04d1b8
[   76.190093] FS:  0000000000000000(0000) GS:ffff81013b401800(0000) knlGS:0000000000000000
[   76.190098] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   76.190102] CR2: 000000013a04d214 CR3: 000000010e848000 CR4: 00000000000006e0
[   76.190106] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.190110] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.190115] Process kdvb-fe-0 (pid: 7209, threadinfo ffff8101228b2000, task ffff810114d907e0)
[   76.190119] Stack:  ffffffff88cb75bf 33611339c61a1bd5 ffff81013a04d008 ffff81013a04d228
[   76.190129]  ffff8101228b3ed8 0000000000000000 ffff810114d907e0 ffffffff80253a00
[   76.190136]  ffff8101228b3ed8 ffff8101228b3ed8 0000000000000000 ffff8101228b3f20
[   76.190143] Call Trace:
[   76.190162]  [<ffffffff88cb75bf>] :dvb_core:dvb_frontend_thread+0x10f/0x360
[   76.190191]  [<ffffffff80253a00>] autoremove_wake_function+0x0/0x30
[   76.190227]  [<ffffffff88cb74b0>] :dvb_core:dvb_frontend_thread+0x0/0x360
[   76.190243]  [<ffffffff8025363b>] kthread+0x4b/0x80
[   76.190259]  [<ffffffff8020d198>] child_rip+0xa/0x12
[   76.190307]  [<ffffffff802535f0>] kthread+0x0/0x80
[   76.190317]  [<ffffffff8020d18e>] child_rip+0x0/0x12
[   76.190332] 
[   76.190334] 
[   76.190335] Code: 44 8b 80 14 02 00 00 45 85 c0 74 10 c7 80 14 02 00 00 00 00 
[   76.190355] RIP  [<ffffffff88cb59a7>] :dvb_core:dvb_frontend_should_wakeup+0x7/0x30
[   76.190373]  RSP <ffff8101228b3e98>
[   76.190376] CR2: 000000013a04d214
[   76.190427] ---[ end trace 158c1b3493d98587 ]---
[   76.199575] Unable to handle kernel paging request at 000000013a04d178 RIP: 
[   76.199583]  [<ffffffff88cb6da0>] :dvb_core:dvb_frontend_ioctl+0x530/0xa70
[   76.199606] PGD 12a696067 PUD 0 
[   76.199612] Oops: 0000 [2] SMP 
[   76.199617] CPU 0 
[   76.199619] Modules linked in: xt_tcpudp nf_conntrack_irc nf_conntrack_ftp xt_state xt_limit ipt_LOG iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack vmnet(P) vmmon(P) binfmt_misc af_packet rfcomm l2cap vboxdrv ppdev ipv6 acpi_cpufreq cpufreq_stats cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_ondemand freq_table dock sbs sbshc iptable_filter ip_tables x_tables sbp2 lp pata_pcmcia arc4 ecb blkcipher qt1010 mt2060 xc3028_tuner joydev mt352 zl10353 pcmcia tuner em2880_dvb dvb_core tvp5150 em28xx compat_ioctl32 ir_common videodev v4l2_common v4l1_compat tveeprom hci_usb bluetooth iwl4965 snd_hda_intel iwlwifi_mac80211 snd_pcm_oss snd_mixer_oss nvidia(P) cfg80211 sr_mod cdrom snd_pcm i2c_core snd_page_alloc snd_hwdep container video output snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device sdhci yenta_socket psmouse mmc_core serio_raw ricoh_mmc rsrc_nonstatic wmi_acer snd battery tpm_infineo
 n tpm tpm_bios button pcmcia_core ac parport_pc parport intel_agp shpchp pci_hotplug evdev iTCO_wdt iTCO_vendor_support soundcore pcspkr ext3 jbd mbcache usbhid hid sg sd_mod ata_piix pata_acpi ata_generic ohci1394 ahci ieee1394 libata scsi_mod uhci_hcd ehci_hcd usbcore e1000 thermal processor fan fbcon tileblit font bitblit softcursor fuse
[   76.199783] Pid: 7208, comm: vlc Tainted: P      D 2.6.24-19-generic #1
[   76.199788] RIP: 0010:[<ffffffff88cb6da0>]  [<ffffffff88cb6da0>] :dvb_core:dvb_frontend_ioctl+0x530/0xa70
[   76.199809] RSP: 0018:ffff8101228b1ca8  EFLAGS: 00010246
[   76.199813] RAX: 0000000000000000 RBX: 000000013a04d030 RCX: 0000000000000000
[   76.199818] RDX: ffff8101228b1fd8 RSI: ffff810114c0fcc0 RDI: ffff81013a04d1b8
[   76.199822] RBP: 000000013a04d000 R08: 0000000000000001 R09: 0000000000000002
[   76.199826] R10: 0000000000000095 R11: ffffffff80316960 R12: 0000000000000000
[   76.199830] R13: ffff81013a654808 R14: ffff81013a04d000 R15: ffff8101228b1e28
[   76.199836] FS:  0000000043a7c950(0063) GS:ffffffff805b9000(0000) knlGS:0000000000000000
[   76.199841] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   76.199844] CR2: 000000013a04d178 CR3: 0000000114de9000 CR4: 00000000000006e0
[   76.199849] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.199853] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.199858] Process vlc (pid: 7208, threadinfo ffff8101228b0000, task ffff81013b2ec000)
[   76.199862] Stack:  ffff81013877e600 ffffffff8028506d ffff81013a04d1b8 000088028062b960
[   76.199871]  000000000000000e ffffffff8062b960 ffff81013f53ad20 ffffffff80287408
[   76.199879]  ffff81012a4efc60 ffff8101206fcdd8 ffff810114c33728 ffff8101206fccc8
[   76.199886] Call Trace:
[   76.199900]  [<ffffffff8028506d>] find_lock_page+0x3d/0xc0
[   76.199921]  [<ffffffff80287408>] filemap_fault+0x188/0x390
[   76.199960]  [<ffffffff80294425>] __do_fault+0x1f5/0x430
[   76.200044]  [<ffffffff88caf102>] :dvb_core:dvb_usercopy+0x82/0x180
[   76.200062]  [<ffffffff88cb6870>] :dvb_core:dvb_frontend_ioctl+0x0/0xa70
[   76.200093]  [<ffffffff8046a280>] do_page_fault+0x1d0/0x840
[   76.200150]  [<ffffffff802c075d>] do_ioctl+0x7d/0xa0
[   76.200167]  [<ffffffff802c09a0>] vfs_ioctl+0x220/0x2c0
[   76.200194]  [<ffffffff802c0ad1>] sys_ioctl+0x91/0xb0
[   76.200221]  [<ffffffff8020c37e>] system_call+0x7e/0x83
[   76.200268] 
[   76.200270] 
[   76.200271] Code: 44 8b 9b 48 01 00 00 45 85 db 0f 84 e1 00 00 00 41 bc b5 ff 
[   76.200291] RIP  [<ffffffff88cb6da0>] :dvb_core:dvb_frontend_ioctl+0x530/0xa70
[   76.200310]  RSP <ffff8101228b1ca8>
[   76.200313] CR2: 000000013a04d178
[   76.200319] ---[ end trace 158c1b3493d98587 ]---
[  412.584381] irq 19: nobody cared (try booting with the "irqpoll" option)
[  412.584396] Pid: 0, comm: swapper Tainted: P      D 2.6.24-19-generic #1
[  412.584400] 
[  412.584401] Call Trace:
[  412.584405]  <IRQ>  [<ffffffff802800ae>] __report_bad_irq+0x1e/0x80
[  412.584463]  [<ffffffff802803bd>] note_interrupt+0x2ad/0x2e0
[  412.584496]  [<ffffffff80280f01>] handle_fasteoi_irq+0xa1/0x110
[  412.584520]  [<ffffffff8020ef6b>] do_IRQ+0x7b/0x100
[  412.584535]  [<ffffffff8020c891>] ret_from_intr+0x0/0xa
[  412.584542]  <EOI>  [<ffffffff802204e0>] lapic_next_event+0x0/0x10
[  412.584597]  [<ffffffff8802e6f3>] :processor:acpi_idle_enter_simple+0x162/0x1cb
[  412.584626]  [<ffffffff8802e6e9>] :processor:acpi_idle_enter_simple+0x158/0x1cb
[  412.584639]  [<ffffffff8020b390>] default_idle+0x0/0x40
[  412.584653]  [<ffffffff803d6c02>] cpuidle_idle_call+0xa2/0xe0
[  412.584658]  [<ffffffff8020b390>] default_idle+0x0/0x40
[  412.584663]  [<ffffffff803d6b60>] cpuidle_idle_call+0x0/0xe0
[  412.584672]  [<ffffffff8020b43f>] cpu_idle+0x6f/0xc0
[  412.584747] 
[  412.584749] handlers:
[  412.584752] [<ffffffff88265c60>] (sdhci_irq+0x0/0x6e0 [sdhci])
[  412.584765] Disabling IRQ #19
[  517.574885] sr0: CDROM not ready.  Make sure there is a disc in the drive.
[  597.971928] device-mapper: uevent: version 1.0.3
[  597.971987] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
[  601.852450] /dev/vmnet: open called by PID 7912 (vmware-vmx)
[  601.852554] /dev/vmnet: port on hub 8 successfully opened
[  601.895962] /dev/vmmon[8027]: host clock rate change request 0 -> 19
[  601.895974] /dev/vmmon[8027]: host clock rate change request 19 -> 83
[  610.506438] /dev/vmmon[7912]: host clock rate change request 83 -> 0
[  610.511298] vmmon: Had to deallocate locked 1523 pages from vm driver ffff81010347c000
[  610.515375] vmmon: Had to deallocate AWE 2524 pages from vm driver ffff81010347c000

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
