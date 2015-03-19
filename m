Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout05.plus.net ([84.93.230.250]:41380 "EHLO
	avasout05.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbbCSWol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 18:44:41 -0400
Received: from [192.168.0.209] (gromit.baker-net.org.uk [192.168.0.209])
	by debian.baker-net.org.uk (Postfix) with ESMTPS id 44D48CD4230
	for <linux-media@vger.kernel.org>; Thu, 19 Mar 2015 22:37:02 +0000 (GMT)
Message-ID: <550B4F8D.7070905@baker-net.org.uk>
Date: Thu, 19 Mar 2015 22:37:01 +0000
From: Adam Baker <linux@baker-net.org.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: divide error in dib7000p driver
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After upgrading my DVB recording PC I started observing the error shown below every couple of days (I've only shown the first instance but I usually get a pair of identical errors). Unfortunately I upgraded hardware and OS at the same time so it is hard to be certain exactly what the trigger was to make it start happening.

I upgraded the kernel from the default vendor 3.11 kernel to a vanilla 3.19 kernel but the problem persisted (the log below is from 3.19). I tried moving the adapter from the USB3 socket it was connected to a USB2 connector and the frequency of the problem dropped from roughly once every 2 days to once in the last month.

Feb 17 01:35:04 mythbox kernel: [119054.840777] divide error: 0000 [#1] SMP
Feb 17 01:35:04 mythbox kernel: [119054.840840] Modules linked in: hidp rpcsec_gss_krb5 nfsv4 dns_resolver parport_pc ppdev lp parport rfcomm bnep cpufreq_stats cpufreq_conservative cpufreq_userspace cpufreq_powersave binfmt_misc uinput nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc nls_utf8 nls_cp437 vfat fat fuse ecryptfs dm_crypt rc_pinnacle_pctv_hd em28xx_rc si2157 si2168 i2c_mux em28xx_dvb rc_dib0700_rc5 dib7000p joydev dvb_usb_dib0700 dib7000m dib0090 dib0070 dib3000mc dibx000_common em28xx tveeprom v4l2_common videodev hid_logitech dvb_usb dvb_core media ff_memless usbhid hid ecb btusb bluetooth snd_hda_codec_hdmi iwlwifi snd_hda_codec_realtek coretemp iTCO_wdt kvm_intel snd_hda_codec_generic cfg80211 kvm iTCO_vendor_support xhci_pci xhci_hcd usbcore snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_seq_midi_event ir_lirc_codec rfkill usb_common i2c_i801 ir_nec_decoder ir_rc6_decoder ir_mce_kbd_dec
 o
der ir_sony_decoder ir_jvc_decoder ir_rc5_decoder ir_sharp_decoder ir_sanyo_decoder ir_xmp_decoder lirc_dev snd_rawmidi pcspkr snd_seq snd_seq_device snd_timer snd soundcore lpc_ich microcode efivars mfd_core rc_rc6_mce battery nuvoton_cir rc_core evdev processor ext4 crc16 mbcache jbd2 dm_mod uvesafb sg sd_mod crc32c_intel ghash_clmulni_intel cryptd i915 ahci libahci fan thermal i2c_algo_bit drm_kms_helper libata drm r8169 mii scsi_mod i2c_core video thermal_sys sdhci_acpi sdhci mmc_core button
Feb 17 01:35:04 mythbox kernel: [119054.842641] CPU: 0 PID: 8479 Comm: kdvb-ad-0-fe-0 Not tainted 3.19.0 #1
Feb 17 01:35:04 mythbox kernel: [119054.842717] Hardware name: Motherboard by ZOTAC ZBOX-CI320NANO series/ZBOX-CI320NANO series, BIOS B219P012 07/09/2014
Feb 17 01:35:04 mythbox kernel: [119054.842835] task: ffff8800b6ef4ec0 ti: ffff880035f28000 task.ti: ffff880035f28000
Feb 17 01:35:04 mythbox kernel: [119054.842919] RIP: 0010:[<ffffffffa0635381>]  [<ffffffffa0635381>] dib7000p_set_frontend+0x891/0x1000 [dib7000p]
Feb 17 01:35:04 mythbox kernel: [119054.843039] RSP: 0018:ffff880035f2b9c8  EFLAGS: 00010246
Feb 17 01:35:04 mythbox kernel: [119054.843100] RAX: 0000000004000000 RBX: ffff880139298000 RCX: 0000000010624dd3
Feb 17 01:35:04 mythbox kernel: [119054.843180] RDX: 0000000000000000 RSI: 0000000000000282 RDI: ffff880139299a00
Feb 17 01:35:04 mythbox kernel: [119054.843260] RBP: ffff880139298000 R08: 0000000000000001 R09: 0000000000000000
Feb 17 01:35:04 mythbox kernel: [119054.843339] R10: ffff8801392999e8 R11: 0000000000000000 R12: ffff880139298000
Feb 17 01:35:04 mythbox kernel: [119054.843419] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Feb 17 01:35:04 mythbox kernel: [119054.843499] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlGS:0000000000000000
Feb 17 01:35:04 mythbox kernel: [119054.843589] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Feb 17 01:35:04 mythbox kernel: [119054.843654] CR2: 00007f3ec41fc000 CR3: 0000000001814000 CR4: 00000000001007f0
Feb 17 01:35:04 mythbox kernel: [119054.843734] Stack:
Feb 17 01:35:04 mythbox kernel: [119054.843759]  ffff880035f2ba08 ffffffff810b95f2 ffffffff81a27340 ffffffff814e6054
Feb 17 01:35:04 mythbox kernel: [119054.843852]  ffff880100030003 1cbabc803669fac0 ffff8800b855c000 ffff880035d7f400
Feb 17 01:35:04 mythbox kernel: [119054.843946]  ffff880139298000 0000000000000000 000000001cbabc80 ffff880035f2ba40
Feb 17 01:35:04 mythbox kernel: [119054.844039] Call Trace:
Feb 17 01:35:04 mythbox kernel: [119054.844076]  [<ffffffff810b95f2>] ? del_timer_sync+0x42/0x50
Feb 17 01:35:04 mythbox kernel: [119054.844145]  [<ffffffff814e6054>] ? schedule_timeout+0x154/0x260
Feb 17 01:35:04 mythbox kernel: [119054.844221]  [<ffffffffa05c473e>] ? dvb_frontend_swzigzag_autotune+0xfe/0x2c0 [dvb_core]
Feb 17 01:35:04 mythbox kernel: [119054.844318]  [<ffffffffa05c584a>] ? dvb_frontend_swzigzag+0x2aa/0x350 [dvb_core]
Feb 17 01:35:04 mythbox kernel: [119054.844405]  [<ffffffff8108eccd>] ? update_curr+0x8d/0x120
Feb 17 01:35:04 mythbox kernel: [119054.844470]  [<ffffffff81092f58>] ? pick_next_task_fair+0x1f8/0x870
Feb 17 01:35:04 mythbox kernel: [119054.844544]  [<ffffffff81090b23>] ? dequeue_task_fair+0x2a3/0x960
Feb 17 01:35:04 mythbox kernel: [119054.844616]  [<ffffffff8101155e>] ? __switch_to+0xde/0x580
Feb 17 01:35:04 mythbox kernel: [119054.844681]  [<ffffffff810b85e5>] ? lock_timer_base.isra.36+0x25/0x50
Feb 17 01:35:04 mythbox kernel: [119054.844756]  [<ffffffff810b9597>] ? try_to_del_timer_sync+0x47/0x60
Feb 17 01:35:04 mythbox kernel: [119054.844828]  [<ffffffff810b95f2>] ? del_timer_sync+0x42/0x50
Feb 17 01:35:04 mythbox kernel: [119054.844895]  [<ffffffff814e6054>] ? schedule_timeout+0x154/0x260
Feb 17 01:35:04 mythbox kernel: [119054.844965]  [<ffffffff8108686f>] ? ttwu_do_wakeup+0xf/0xc0
Feb 17 01:35:04 mythbox kernel: [119054.845031]  [<ffffffff810b84d0>] ? internal_add_timer+0x80/0x80
Feb 17 01:35:04 mythbox kernel: [119054.845101]  [<ffffffff8109c908>] ? down_interruptible+0x28/0x50
Feb 17 01:35:04 mythbox kernel: [119054.845176]  [<ffffffffa05c5d74>] ? dvb_frontend_thread+0x3d4/0x560 [dvb_core]
Feb 17 01:35:04 mythbox kernel: [119054.848403]  [<ffffffff81098530>] ? prepare_to_wait_event+0xf0/0xf0
Feb 17 01:35:04 mythbox kernel: [119054.851541]  [<ffffffffa05c59a0>] ? dvb_frontend_release+0xb0/0xb0 [dvb_core]
Feb 17 01:35:04 mythbox kernel: [119054.854595]  [<ffffffff8107dbe5>] ? kthread+0xc5/0xe0
Feb 17 01:35:04 mythbox kernel: [119054.857532]  [<ffffffff8107db20>] ? kthread_create_on_node+0x170/0x170
Feb 17 01:35:04 mythbox kernel: [119054.860373]  [<ffffffff814e6f7c>] ? ret_from_fork+0x7c/0xb0
Feb 17 01:35:04 mythbox kernel: [119054.863106]  [<ffffffff8107db20>] ? kthread_create_on_node+0x170/0x170
Feb 17 01:35:04 mythbox kernel: [119054.865747] Code: 06 41 29 f5 c1 ea 06 41 29 d5 44 89 e8 c1 f8 1f 41 89 c6 45 31 ee 41 29 c6 48 89 ef e8 09 c0 ff ff 31 d2 41 89 c7 b8 00 00 00 04 <41> f7 f7 41 89 c0 48 8b 85 38 05 00 00 8b 40 14 41 89 c2 c1 e8
Feb 17 01:35:04 mythbox kernel: [119054.873808]  RSP <ffff880035f2b9c8>
Feb 17 01:35:04 mythbox kernel: [119054.889519] ---[ end trace eeebde0c7841cb81 ]---
Feb 17 01:39:55 mythbox kernel: [119346.242590] divide error: 0000 [#2] SMP

If I've manage to drive objdump correctly then the code sequence leading to the crash is
    4357:       41 29 f5                sub    %esi,%r13d
    435a:       c1 ea 06                shr    $0x6,%edx
    435d:       41 29 d5                sub    %edx,%r13d
    4360:       44 89 e8                mov    %r13d,%eax
    4363:       c1 f8 1f                sar    $0x1f,%eax
    4366:       41 89 c6                mov    %eax,%r14d
    4369:       45 31 ee                xor    %r13d,%r14d
    436c:       41 29 c6                sub    %eax,%r14d
    436f:       48 89 ef                mov    %rbp,%rdi
    4372:       e8 09 c0 ff ff          callq  380 <dib7000p_get_internal_freq>
    4377:       31 d2                   xor    %edx,%edx
    4379:       41 89 c7                mov    %eax,%r15d
    437c:       b8 00 00 00 04          mov    $0x4000000,%eax
    4381:       41 f7 f7                div    %r15d

Looking to see where dib7000p_get_internal_freq() gets called from dib7000p_set_frontend() I see the code sequence

        /* start up the AGC */
        state->agc_state = 0;
        do {
                time = dib7000p_agc_startup(fe);
                if (time != -1)
                        msleep(time);
        } while (time != -1);

and dib7000p_agc_startup() calls dib7000p_set_dds() which beginsv 

static void dib7000p_set_dds(struct dib7000p_state *state, s32 offset_khz)
{
        u32 internal = dib7000p_get_internal_freq(state);
        s32 unit_khz_dds_val = 67108864 / (internal);   /* 2**26 / Fsampling is the unit 1KHz offset */
        u32 abs_offset_khz = ABS(offset_khz);

which allowing for some inlining I would guess is the code sequence triggering the bug.

This would suggest that dib7000p_get_internal_freq() is returning 0 which would either mean that either
dib7000p_update_pll() or dib7000p_reset_pll() have somehow managed to write 0 to registers 18 & 19 or
the contents of those registers have become corrupted.

Does anyone have a suggestion to make as to whether this is more likely to be a subtle timing error or a case
of hardware forgetting it's config due to something like poor quality USB 5V lines

Thanks

Adam
