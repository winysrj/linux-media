Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:35770 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdCEMwn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 5 Mar 2017 07:52:43 -0500
Received: by mail-yw0-f172.google.com with SMTP id v198so19039180ywc.2
        for <linux-media@vger.kernel.org>; Sun, 05 Mar 2017 04:52:42 -0800 (PST)
MIME-Version: 1.0
From: Josef Schlehofer <pepe.schlehofer@gmail.com>
Date: Sun, 5 Mar 2017 13:52:41 +0100
Message-ID: <CABPHAJws=uaHUoetHQBKbBKZ6cxK-kw4kdK5UYqZ2sO+_-sVNw@mail.gmail.com>
Subject: TechnoTrend AG TT-connect CT-3650 CI - itself disconnecting and
 connecting back (upstream driver)
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

With provided kernel image from Debian I had these two issues:
sysfs: cannot create duplicate filename '/class/dvb/dvb0.ca0
'sysfs group 'power' not found for kobject 'dvb0.ca0'
= It seems that this was fixed by upstream driver.

Now I have this issue:
My tuner itself is disconnecting and connecting back in this case
tvheadend doesn't seen it and I need to restart tvheadend.
I also noticed in dmesg that I have two different bug traces
1)

779.987906] ------------[ cut here ]------------
[ 2779.987916] WARNING: CPU: 0 PID: 2372 at
/home/zumbi/linux-4.9.2/kernel/module.c:1108 module_put+0x8e/0xa0
[ 2779.987917] Modules linked in: binfmt_misc cpufreq_conservative
cpufreq_powersave cpufreq_userspace cfg80211 bonding mt2063(OE)
drxk(OE) rc_tt_1500(OE) tda10048(OE) tda827x(OE) tda10023(OE)
dvb_usb_az6007(OE) cypress_firmware(OE) dvb_usb_ttusb2(OE)
dvb_usb_v2(OE) dvb_usb(OE) dvb_core(OE) rc_core(OE) media(OE)
snd_hda_codec_hdmi nls_ascii nls_cp437 vfat fat snd_hda_codec_realtek
snd_hda_codec_generic zfs(POE) zunicode(POE) zavl(POE) zcommon(POE)
znvpair(POE) intel_rapl intel_soc_dts_iosf intel_powerclamp spl(OE)
coretemp iTCO_wdt iTCO_vendor_support kvm_intel ppdev kvm irqbypass
crct10dif_pclmul crc32_pclmul i915 efi_pstore ghash_clmulni_intel
cryptd intel_cstate serio_raw snd_intel_sst_acpi pcspkr efivars
snd_soc_rt5645 snd_intel_sst_core snd_hda_intel i2c_i801
drm_kms_helper snd_soc_sst_mfld_platform
[ 2779.987964]  i2c_smbus snd_soc_rt5640 lpc_ich snd_soc_sst_match
snd_soc_rl6231 snd_hda_codec mfd_core drm snd_soc_core evdev
snd_hda_core hci_uart snd_hwdep snd_compress btbcm btqca i2c_algo_bit
parport_pc snd_pcm shpchp battery parport btintel snd_timer bluetooth
snd video soundcore dw_dmac dw_dmac_core rfkill
i2c_designware_platform tpm_tis i2c_designware_core tpm_tis_core tpm
button fuse autofs4 ext4 crc16 jbd2 fscrypto mbcache btrfs xor
raid6_pq dm_mod md_mod sg uas usb_storage hid_generic usbhid sd_mod
xhci_pci xhci_hcd ahci libahci e1000e usbcore libata ptp crc32c_intel
pps_core usb_common scsi_mod psmouse thermal r8169 mii fan fjes
sdhci_acpi i2c_hid sdhci hid mmc_core
[ 2779.988022] CPU: 0 PID: 2372 Comm: tvheadend Tainted: P
OE   4.9.0-0.bpo.1-amd64 #1 Debian 4.9.2-2~bpo8+1
[ 2779.988023] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./Q1900-ITX, BIOS P1.80 11/08/2016
[ 2779.988027]  0000000000000000 ffffffff8972a1f5 0000000000000000
0000000000000000
[ 2779.988031]  ffffffff89477884 ffff9f12b2dbaf00 ffff9f126a17c100
ffff9f12b535e648
[ 2779.988034]  ffff9f12b656d960 ffff9f12b48fee40 ffff9f12b535e648
ffffffff894fe3be
[ 2779.988038] Call Trace:
[ 2779.988044]  [<ffffffff8972a1f5>] ? dump_stack+0x5c/0x77
[ 2779.988048]  [<ffffffff89477884>] ? __warn+0xc4/0xe0
[ 2779.988051]  [<ffffffff894fe3be>] ? module_put+0x8e/0xa0
[ 2779.988060]  [<ffffffffc0dccb0c>] ?
dvb_ca_en50221_io_release+0x4c/0x90 [dvb_core]
[ 2779.988064]  [<ffffffff89605b0d>] ? __fput+0xcd/0x1e0
[ 2779.988067]  [<ffffffff89495bc2>] ? task_work_run+0x72/0x90
[ 2779.988070]  [<ffffffff8947be55>] ? do_exit+0x395/0xb50
[ 2779.988072]  [<ffffffff8947c689>] ? do_group_exit+0x39/0xb0
[ 2779.988075]  [<ffffffff8947c710>] ? SyS_exit_group+0x10/0x10
[ 2779.988079]  [<ffffffff899fa1bb>] ? system_call_fast_compare_end+0xc/0x9b
[ 2779.988081] ---[ end trace c675cdf08c26442d ]---


2)

[ 1209.584994] INFO: task kworker/0:0:4 blocked for more than 120 seconds.
[ 1209.585005]       Tainted: P           OE   4.9.0-0.bpo.1-amd64 #1
[ 1209.585009] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1209.585013] kworker/0:0     D    0     4      2 0x00000000
[ 1209.585047] Workqueue: usb_hub_wq hub_event [usbcore]
[ 1209.585052]  ffff9f12a5070800 ffff9f12b1c19800 ffff9f12b1f88f40
ffff9f12b6628080
[ 1209.585059]  ffff9f12bfc187c0 ffffb7e840c7bb58 ffffffff899f536d
0000000000000286
[ 1209.585065]  000000007977594d 00000000b1e76938 ffffb7e840c7bb78
ffff9f12b6628080
[ 1209.585072] Call Trace:
[ 1209.585082]  [<ffffffff899f536d>] ? __schedule+0x23d/0x6d0
[ 1209.585087]  [<ffffffff899f5832>] ? schedule+0x32/0x80
[ 1209.585102]  [<ffffffffc0dc697d>] ? dvb_dmxdev_release+0x4d/0x120 [dvb_core]
[ 1209.585108]  [<ffffffff894bb7d0>] ? wake_up_atomic_t+0x30/0x30
[ 1209.585116]  [<ffffffffc0d79b34>] ?
dvb_usb_adapter_dvb_exit+0x44/0x90 [dvb_usb]
[ 1209.585121]  [<ffffffffc0d78499>] ? dvb_usb_exit+0x49/0xe0 [dvb_usb]
[ 1209.585127]  [<ffffffffc0d7856b>] ? dvb_usb_device_exit+0x3b/0x50 [dvb_usb]
[ 1209.585150]  [<ffffffffc05726d1>] ? usb_unbind_interface+0x71/0x270 [usbcore]
[ 1209.585156]  [<ffffffff8986e285>] ? __device_release_driver+0x95/0x140
[ 1209.585160]  [<ffffffff8986e34e>] ? device_release_driver+0x1e/0x30
[ 1209.585165]  [<ffffffff8986cfc5>] ? bus_remove_device+0xf5/0x170
[ 1209.585169]  [<ffffffff898694a7>] ? device_del+0x127/0x260
[ 1209.585192]  [<ffffffffc057702b>] ? usb_remove_ep_devs+0x1b/0x30 [usbcore]
[ 1209.585215]  [<ffffffffc05700a3>] ? usb_disable_device+0x93/0x260 [usbcore]
[ 1209.585237]  [<ffffffffc0565d9a>] ? usb_disconnect+0x8a/0x260 [usbcore]
[ 1209.585259]  [<ffffffffc0567f90>] ? hub_event+0x7d0/0x1530 [usbcore]
[ 1209.585264]  [<ffffffff8949172b>] ? process_one_work+0x14b/0x410
[ 1209.585269]  [<ffffffff894921e5>] ? worker_thread+0x65/0x4a0
[ 1209.585273]  [<ffffffff89492180>] ? rescuer_thread+0x340/0x340
[ 1209.585277]  [<ffffffff894974e0>] ? kthread+0xe0/0x100
[ 1209.585282]  [<ffffffff8942476b>] ? __switch_to+0x2bb/0x700
[ 1209.585286]  [<ffffffff89497400>] ? kthread_park+0x60/0x60
[ 1209.585291]  [<ffffffff899fa435>] ? ret_from_fork+0x25/0x30


Full log: pastebin.com/VWDQE8DC

I also noticed these messages in log, but I think there're just
flooding system and syslog, which has 3GB  after 2-3 minutes.
All cores because of this are at 100%. This happens when I unplug usb
and plug it back (but I didnt unplug it) log: pastebin.com/52Fgdf6b

[ 4285.212518] usb read operation failed. (-71)
[ 4285.212522] usb in operation failed. (-5)
[ 4285.212775] usb read operation failed. (-71)
[ 4285.212778] usb in operation failed. (-5)
[ 4285.212930] usb read operation failed. (-71)
[ 4285.212932] usb in operation failed. (-5)
[ 4285.213024] usb read operation failed. (-71)
[ 4285.213026] usb in operation failed. (-5)
[ 4285.213205] usb read operation failed. (-71)
[ 4285.213208] usb in operation failed. (-5)
[ 4285.213375] usb read operation failed. (-71)
[ 4285.213377] usb in operation failed. (-5)
[ 4285.213505] usb read operation failed. (-71)
[ 4285.213507] usb in operation failed. (-5)
[ 4285.213637] usb read operation failed. (-71)
[ 4285.213639] usb in operation failed. (-5)

This flood exactly same  I'm having on
- Odroid C2 (Linux odroid64 3.14.79-92 #1 SMP PREEMPT Mon Oct 31
19:37:22 BRST 2016 aarch64 aarch64 aarch64 GNU/Linux)
- Turris 1.1 (Linux turris 3.18.48-d530b2d348ac893d980001e28f6e5eb3-2
#1 SMP Sat Feb 18 01:13:49 CET 2017 ppc n)
Except this flood it works on both devices, but there it won't
disconnect itself.

I tried lsusb -t after that and it didnt work. Only power shutdown of
that unit helped.

When you will need more informations/details, please write my I will
try to do my best. I'm newbie to reporting bugs to upstream.
Also take my apologize that I'm writing it here (even I created issue
on bugtracker - bugzilla.kernel.org/show_bug.cgi?id=194783 after I
mention I created issue) on IRC then Marcus told me that it's better
to send email.

// I think better would be split my issue with another tuner
(TechniSat Digital GmbH CableStar Combo HD CI), but I tried with with
mainline z6007 and drxk and sometimes I get flood, too.
pastebin.com/6amB39TK , pastebin.com/RMF67uez

For me it's interesting to see that I didnt have drxk issue (I didn't
notice that), but when I have connected both tuners to one machines. I
splitted them to different machines I see it now.

Looking forward to hearing from you,
Josef Schlehofer
