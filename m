Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35432 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168Ab1FFLc1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 07:32:27 -0400
Received: by eyx24 with SMTP id 24so1313918eyx.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 04:32:26 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 21:32:26 +1000
Message-ID: <BANLkTiniqcB9ujn7Bn3M2KmzThfEuuem+g@mail.gmail.com>
Subject: [bug]? cx23885 - tries to create duplicate (firmware) filename in sysfs
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I just noticed this starting to happen - I can't see any sign of it in syslog
before I rebuilt the modules (git commit tags are listed below).
I don't know if this is a backporting issue or a bug in mainline.

The system in question has two dual-tuner cards, one a USB (mounted on
a PCI card)
the other a PCI card. Both use the cx23885 driver. As far as I can see
the PCI card is
where the problem lies - there's no way to distinguish between the two
tuners (I found
this when trying to write some udev rules to generate stably-named symlinks).


% uname -a
Linux ubuntu 2.6.32-27-generic #49-Ubuntu SMP Wed Dec 1 23:52:12 UTC
2010 i686 GNU/Linux

[    4.020062] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    4.020063]  5e094096b93c9c48b4b90457e83cbca6fc2ff5d4 [media] v1.88
DM04/QQBOX Move remote to use rc_core dvb-usb-remote
[    4.020064]  154d70a479c27695a4ad938cc0b14cb91866cf2d [media] Add
missing include guard to header file
[    4.020065]  537d9c461e6cbe7a2cc35121f0ee4d48f52753a3 [media]
Inlined functions should be static

The error I see is:

[   34.900554] ------------[ cut here ]------------
[   34.900561] WARNING: at
/build/buildd/linux-2.6.32/fs/sysfs/dir.c:491
sysfs_add_one+0xa0/0x100()
[   34.900563] Hardware name:
[   34.900565] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1c.3/0000:04:00.0/firmware/0000:04:00.0'
[   34.900567] Modules linked in: ppdev ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp
kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss fbcon snd_mixer_oss tileblit font snd_pcm
snd_seq_dummy bitblit ir_kbd_i2c tuner_xc2028 softcursor snd_seq_oss
vga16fb snd_seq_midi arc4 vgastate ir_lirc_codec lirc_dev rc_imon_mce
zl10353 snd_rawmidi ir_sony_decoder cx23885 lp i915 snd_seq_midi_event
ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder dvb_usb_cxusb snd_seq
parport cx2341x drm_kms_helper intel_agp videobuf_dma_sg videobuf_dvb
videobuf_core snd_timer snd_seq_device drm i2c_algo_bit video
ir_nec_decoder output v4l2_common snd rtl8180 dib7000p dibx000_common
soundcore agpgart snd_page_alloc videodev mac80211 eeprom_93cx6
dvb_usb btcx_risc imon psmouse dvb_core cfg80211 rc_core tveeprom
serio_raw dib0070 usb_storage raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0
ohci1394 multipath ieee1394 ahci e1000e pata_marvell linear
[   34.900653] Pid: 2399, comm: kdvb-ad-2-fe-0 Not tainted
2.6.32-27-generic #49-Ubuntu
[   34.900655] Call Trace:
[   34.900660]  [<c014c802>] warn_slowpath_common+0x72/0xa0
[   34.900663]  [<c02609e0>] ? sysfs_add_one+0xa0/0x100
[   34.900666]  [<c02609e0>] ? sysfs_add_one+0xa0/0x100
[   34.900669]  [<c014c87b>] warn_slowpath_fmt+0x2b/0x30
[   34.900672]  [<c02609e0>] sysfs_add_one+0xa0/0x100
[   34.900675]  [<c0260a8e>] create_dir+0x4e/0x90
[   34.900678]  [<c0260b00>] sysfs_create_dir+0x30/0x50
[   34.900682]  [<c034d642>] kobject_add_internal+0x92/0x1d0
[   34.900684]  [<c0353846>] ? vsnprintf+0x206/0x410
[   34.900687]  [<c034d86d>] kobject_add_varg+0x2d/0x50
[   34.900692]  [<c03e4aeb>] ? get_device_parent+0xcb/0x1a0
[   34.900695]  [<c034d8ec>] kobject_add+0x2c/0x60
[   34.900698]  [<c03e5c69>] device_add+0x99/0x430
[   34.900701]  [<c03ed8d0>] ? pm_runtime_init+0xb0/0xc0
[   34.900704]  [<c03e6017>] device_register+0x17/0x20
[   34.900707]  [<c03f098b>] fw_register_device+0x14b/0x210
[   34.900710]  [<c03f0a7d>] fw_setup_device+0x2d/0x100
[   34.900713]  [<c03f0c00>] _request_firmware+0xb0/0x220
[   34.900715]  [<c03f0e17>] request_firmware+0x17/0x20
[   34.900722]  [<f862317c>] generic_set_freq+0x99c/0x18f0 [tuner_xc2028]
[   34.900725]  [<c0353daa>] ? delay_tsc+0x2a/0x70
[   34.900727]  [<c0353d71>] ? __const_udelay+0x31/0x40
[   34.900735]  [<f858e549>] ? i2c_sendbytes+0x169/0x3c0 [cx23885]
[   34.900742]  [<f858e810>] ? i2c_xfer+0x70/0x140 [cx23885]
[   34.900745]  [<c058bde2>] ? _cond_resched+0x32/0x50
[   34.900749]  [<c0474804>] ? i2c_transfer+0x94/0xc0
[   34.900753]  [<f8624475>] xc2028_set_params+0x195/0x286 [tuner_xc2028]
[   34.900757]  [<f83e5c4c>] zl10353_set_parameters+0x4ec/0x630 [zl10353]
[   34.900763]  [<c058d9bf>] ? _spin_lock_irqsave+0x2f/0x50
[   34.900766]  [<c015b2ac>] ? lock_timer_base+0x2c/0x60
[   34.900777]  [<f82b71d5>]
dvb_frontend_swzigzag_autotune+0x115/0x300 [dvb_core]
[   34.900785]  [<f82b81d1>] dvb_frontend_swzigzag+0x261/0x300 [dvb_core]
[   34.900792]  [<f82b8a67>] dvb_frontend_thread+0x3c7/0x700 [dvb_core]
[   34.900795]  [<c058b8ec>] ? schedule+0x44c/0x840
[   34.900799]  [<c0167b50>] ? autoremove_wake_function+0x0/0x50
[   34.900807]  [<f82b86a0>] ? dvb_frontend_thread+0x0/0x700 [dvb_core]
[   34.900810]  [<c01678c4>] kthread+0x74/0x80
[   34.900813]  [<c0167850>] ? kthread+0x0/0x80
[   34.900817]  [<c0104087>] kernel_thread_helper+0x7/0x10
[   34.900819] ---[ end trace 14130c4e15fe09fe ]---
[   34.900822] kobject_add_internal failed for 0000:04:00.0 with -EEXIST, don't
try to register things with the same name in the same directory.

[   34.900826] Pid: 2399, comm: kdvb-ad-2-fe-0 Tainted: G        W  2.6.32-27-ge
neric #49-Ubuntu
[   34.900828] Call Trace:
[   34.900830]  [<c058b313>] ? printk+0x1d/0x22
[   34.900833]  [<c034d6ec>] kobject_add_internal+0x13c/0x1d0
[   34.900836]  [<c034d86d>] kobject_add_varg+0x2d/0x50
[   34.900839]  [<c03e4aeb>] ? get_device_parent+0xcb/0x1a0
[   34.900842]  [<c034d8ec>] kobject_add+0x2c/0x60
[   34.900845]  [<c03e5c69>] device_add+0x99/0x430
[   34.900848]  [<c03ed8d0>] ? pm_runtime_init+0xb0/0xc0
[   34.900851]  [<c03e6017>] device_register+0x17/0x20
[   34.900854]  [<c03f098b>] fw_register_device+0x14b/0x210
[   34.900857]  [<c03f0a7d>] fw_setup_device+0x2d/0x100
[   34.900859]  [<c03f0c00>] _request_firmware+0xb0/0x220
[   34.900867]  [<f862317c>] generic_set_freq+0x99c/0x18f0 [tuner_xc2028]
[   34.900870]  [<c0353daa>] ? delay_tsc+0x2a/0x70
[   34.900873]  [<c0353d71>] ? __const_udelay+0x31/0x40
[   34.900880]  [<f858e549>] ? i2c_sendbytes+0x169/0x3c0 [cx23885]
[   34.900889]  [<f858e810>] ? i2c_xfer+0x70/0x140 [cx23885]
[   34.900892]  [<c058bde2>] ? _cond_resched+0x32/0x50
[   34.900895]  [<c0474804>] ? i2c_transfer+0x94/0xc0
[   34.900899]  [<f8624475>] xc2028_set_params+0x195/0x286 [tuner_xc2028]
[   34.900902]  [<f83e5c4c>] zl10353_set_parameters+0x4ec/0x630 [zl10353]
[   34.900905]  [<c058d9bf>] ? _spin_lock_irqsave+0x2f/0x50
[   34.900908]  [<c015b2ac>] ? lock_timer_base+0x2c/0x60
[   34.900916]  [<f82b71d5>]
dvb_frontend_swzigzag_autotune+0x115/0x300 [dvb_core]
[   34.900924]  [<f82b81d1>] dvb_frontend_swzigzag+0x261/0x300 [dvb_core]
[   34.900931]  [<f82b8a67>] dvb_frontend_thread+0x3c7/0x700 [dvb_core]
[   34.900934]  [<c058b8ec>] ? schedule+0x44c/0x840
[   34.900937]  [<c0167b50>] ? autoremove_wake_function+0x0/0x50
[   34.900945]  [<f82b86a0>] ? dvb_frontend_thread+0x0/0x700 [dvb_core]
[   34.900948]  [<c01678c4>] kthread+0x74/0x80
[   34.900951]  [<c0167850>] ? kthread+0x0/0x80
[   34.900954]  [<c0104087>] kernel_thread_helper+0x7/0x10
[   34.900954]  [<c0104087>] kernel_thread_helper+0x7/0x10
[   34.900956] cx23885 0000:04:00.0: fw_register_device: device_register failed
[   34.900965] BUG: unable to handle kernel NULL pointer dereference at 00000040
[   34.900968] IP: [<c03eff62>] fw_dev_release+0x12/0x60
[   34.900971] *pde = 7c87e067
[   34.900974] Oops: 0000 [#1] SMP
[   34.900976] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host2/target2:0:0/2:0:0:0/block/sda/size
[   34.900979] Modules linked in: ppdev ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack
ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp
kvm_intel kvm snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss fbcon snd_mixer_oss tileblit font snd_pcm
snd_seq_dummy bitblit ir_kbd_i2c tuner_xc2028 softcursor snd_seq_oss
vga16fb snd_seq_midi arc4 vgastate ir_lirc_codec lirc_dev rc_imon_mce
zl10353 snd_rawmidi ir_sony_decoder cx23885 lp i915 snd_seq_midi_event
ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder dvb_usb_cxusb snd_seq
parport cx2341x drm_kms_helper intel_agp videobuf_dma_sg videobuf_dvb
videobuf_core snd_timer snd_seq_device drm i2c_algo_bit video
ir_nec_decoder output v4l2_common snd rtl8180 dib7000p dibx000_common
soundcore agpgart snd_page_alloc videodev mac80211 eeprom_93cx6
dvb_usb btcx_risc imon psmouse dvb_core cfg80211 rc_core tveeprom
serio_raw dib0070 usb_storage raid10 raid456 async_raid6_recov
async_pq raid6_pq async_xor xor async_memcpy async_tx raid1 raid0
ohci1394 multipath ieee1394 ahci e1000e pata_marvell linear
[   34.901053]
[   34.901055] Pid: 2399, comm: kdvb-ad-2-fe-0 Tainted: G        W
(2.6.32-27-generic #49-Ubuntu)
[   34.901058] EIP: 0060:[<c03eff62>] EFLAGS: 00010246 CPU: 0
[   34.901060] EIP is at fw_dev_release+0x12/0x60
[   34.901062] EAX: 00000000 EBX: 00000000 ECX: ffffe688 EDX: c03eff50
[   34.901064] ESI: c078a2a0 EDI: f396d200 EBP: f39dbc84 ESP: f39dbc78
[   34.901066]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   34.901069] Process kdvb-ad-2-fe-0 (pid: 2399, ti=f39da000
task=f39bbfc0 task.ti=f39da000)
[   34.901070] Stack:
[   34.901072]  00000000 c078a2a0 f5c8c330 f39dbca0 c03e500e 00000033
0000000f 00000000
[   34.901077] <0> 205bbca0 f396d208 f39dbcb4 c034d4da f396d224
c034d4a0 f7184858 f39dbcc4
[   34.901084] <0> c034e36d ffffffef f396d200 f39dbce4 c034d3cd
8f7bda99 ffffffef f396d200
[   34.901091] Call Trace:
[   34.901094]  [<c03e500e>] ? device_release+0x1e/0x80
[   34.901097]  [<c034d4da>] ? kobject_release+0x3a/0x80
[   34.901100]  [<c034d4a0>] ? kobject_release+0x0/0x80
[   34.901103]  [<c034e36d>] ? kref_put+0x2d/0x60
[   34.901106]  [<c034d3cd>] ? kobject_put+0x1d/0x50
[   34.901108]  [<c058b313>] ? printk+0x1d/0x22
[   34.901111]  [<c03e4924>] ? put_device+0x14/0x20
[   34.901114]  [<c03f0a14>] ? fw_register_device+0x1d4/0x210
[   34.901119]  [<c03f0a7d>] ? fw_setup_device+0x2d/0x100
[   34.901122]  [<c03f0c00>] ? _request_firmware+0xb0/0x220
[   34.901125]  [<c03f0e17>] ? request_firmware+0x17/0x20
[   34.901129]  [<f862317c>] ? generic_set_freq+0x99c/0x18f0 [tuner_xc2028]
[   34.901131]  [<c0353daa>] ? delay_tsc+0x2a/0x70
[   34.901134]  [<c0353d71>] ? __const_udelay+0x31/0x40
[   34.901141]  [<f858e549>] ? i2c_sendbytes+0x169/0x3c0 [cx23885]
[   34.901147]  [<f858e810>] ? i2c_xfer+0x70/0x140 [cx23885]
[   34.901150]  [<c058bde2>] ? _cond_resched+0x32/0x50
[   34.901154]  [<c0474804>] ? i2c_transfer+0x94/0xc0
[   34.901158]  [<f8624475>] ? xc2028_set_params+0x195/0x286 [tuner_xc2028]
[   34.901162]  [<f83e5c4c>] ? zl10353_set_parameters+0x4ec/0x630 [zl10353]
[   34.901165]  [<c058d9bf>] ? _spin_lock_irqsave+0x2f/0x50
[   34.901167]  [<c015b2ac>] ? lock_timer_base+0x2c/0x60
[   34.901175]  [<f82b71d5>] ?
dvb_frontend_swzigzag_autotune+0x115/0x300 [dvb_core]
[   34.901183]  [<f82b81d1>] ? dvb_frontend_swzigzag+0x261/0x300 [dvb_core]
[   34.901190]  [<f82b8a67>] ? dvb_frontend_thread+0x3c7/0x700 [dvb_core]
[   34.901193]  [<c058b8ec>] ? schedule+0x44c/0x840
[   34.901196]  [<c0167b50>] ? autoremove_wake_function+0x0/0x50
[   34.901205]  [<f82b86a0>] ? dvb_frontend_thread+0x0/0x700 [dvb_core]
[   34.901208]  [<c01678c4>] ? kthread+0x74/0x80
[   34.901210]  [<c0167850>] ? kthread+0x0/0x80
[   34.901214]  [<c0104087>] ? kernel_thread_helper+0x7/0x10
[   34.901215] Code: 08 e8 13 3b f6 ff 83 c4 0c 5b 5d c3 8d b6 00 00
00 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 0f 1f 44 00 00 89 c7 e8
5e 7f ff ff <8b> 58 40 89 c6 85 db 7e 1a 31 db 8d 76 00 8b 46 3c 31 d2
8b 04
[   34.901251] EIP: [<c03eff62>] fw_dev_release+0x12/0x60 SS:ESP 0068:f39dbc78
[   34.901255] CR2: 0000000000000040
[   34.901261] ---[ end trace 14130c4e15fe09ff ]---


% dmesg |grep -i cx23885   # up to the point where excerpt above appears:
[    5.222141] cx23885 driver version 0.0.2 loaded
[    5.222178] cx23885 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.222243] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO
FusionHDTV DVB-T Dual Express [card=11,autodetected]
[    5.476509] cx23885_dvb_register() allocating 1 frontend(s)
[    5.476512] cx23885[0]: cx23885 based dvb card
[    5.477126] DVB: registering new adapter (cx23885[0])
[    5.477381] cx23885_dvb_register() allocating 1 frontend(s)
[    5.477383] cx23885[0]: cx23885 based dvb card
[    5.477988] DVB: registering new adapter (cx23885[0])
[    5.478551] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    5.478557] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 19,
latency: 0, mmio: 0x90000000
[    5.478564] cx23885 0000:04:00.0: setting latency timer to 64
[    5.478646] cx23885 0000:04:00.0: irq 32 for MSI/MSI-X
[    5.556503] cxusb: No IR receiver detected on this device.
[    5.557278] usbcore: registered new interface driver dvb_usb_cxusb
[   34.888152] cx23885 0000:04:00.0: firmware: requesting xc3028-v27.fw
[   34.900542] cx23885 0000:04:00.0: firmware: requesting xc3028-v27.fw

Hardware details

% lsusb | grep -i dvico
Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)

% lspci |grep -i cx
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)
% lspci -vvn -s 04:00
04:00.0 0400: 14f1:8852 (rev 02)
        Subsystem: 18ac:db78
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 32
        Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <2us, L1 <4us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data <?>
        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000fee0200c  Data: 41c9
        Capabilities: [100] Advanced Error Reporting <?>
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885

Regards
Vince
