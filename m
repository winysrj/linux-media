Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52219 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab3IBWY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Sep 2013 18:24:57 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so5209034pbc.9
        for <linux-media@vger.kernel.org>; Mon, 02 Sep 2013 15:24:57 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 Sep 2013 23:24:57 +0100
Message-ID: <CA+fUvsiNVBvo3+fjvDcQr0Rc=Pp5pQA1qL_cYq46NCN5z5K=6g@mail.gmail.com>
Subject: dib7000p crash with divide error: 0000 [#1] SMP
From: gary smith <kaisersose77x@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am currently using the openelec OS - intel x64 3.1.6 build (uses a
3.10 kernel) and I'm using a sony play tv usb dvb-t dual tuner along
with 3 dvbsky s952 tuners. The sony tuner alway seems to crash after a
few days and this is the dmesg output i noticed this morning when i
noticed that tvheadend was frozen. I use suspend and resume so that
the pc goes to sleep when idle. The items below (cx23885_wakeup: 9
buffers handled (should be 1)) are coming from the dvbksy tuners and
seem to appear when the pc is suspended and resumed but i dont think
that is related to the sony tuner issue.


Anyways if anyone knows what the issue might be or knows if anything
can be done to prevent this crashing it would be appreciated. This has
been happening with openelec for as long as i can remember and is not
something that just started happening with the 3.1.6 build.


Full dmesg output here - sprunge dot us forwardslash FDRN and output
when crash occurred below.

[92356.001949] divide error: 0000 [#1] SMP
[92356.001996] Modules linked in: xhci_hcd cx23885 videobuf_dma_sg
altera_stapl cx2341x tda18271 videobuf_dvb videobuf_core altera_ci
btcx_risc tveeprom rfcomm rc_dvbsky m88ds3103 bnep bluetooth rfkill
iptable_filter ip_tables cx25840 ir_lirc_codec lirc_dev
ir_mce_kbd_decoder ir_sanyo_decoder ir_sony_decoder ir_jvc_decoder
ir_rc6_decoder ir_rc5_decoder ir_nec_decoder dvb_usb_dib0700
rc_rc6_mce dib7000p dib0090 dib7000m dib0070 snd_hda_codec_hdmi
intel_powerclamp snd_hda_intel dvb_usb dib8000 dib3000mc
dibx000_common mceusb rc_core snd_hda_codec v4l2_common videodev
snd_hwdep snd_pcm snd_page_alloc dvb_core [last unloaded:
videobuf_core]
[92356.002532] CPU: 0 PID: 24524 Comm: kdvb-ad-6-fe-0 Not tainted 3.10.7 #1
[92356.002583] Hardware name: Gigabyte Technology Co., Ltd. To be
filled by O.E.M./H61M-HD2, BIOS F2 10/12/2012
[92356.002656] task: ffff8800a84458d0 ti: ffff880038ae8000 task.ti:
ffff880038ae8000
[92356.002711] RIP: 0010:[<ffffffffa0227d05>] [<ffffffffa0227d05>]
dib7000p_set_frontend+0x471/0xe6c [dib7000p]
[92356.002791] RSP: 0018:ffff880038ae9978 EFLAGS: 00010246
[92356.002831] RAX: 0000000004000000 RBX: ffff88003704a000 RCX: 00000000000003e8
[92356.002884] RDX: 0000000000000000 RSI: ffff880108643d60 RDI: ffff88003704b888
[92356.002937] RBP: ffff88003704a000 R08: 000000000000b780 R09: 0000000000000000
[92356.002989] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88003704a000
[92356.003042] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880038ae9a30
[92356.003095] FS: 0000000000000000(0000) GS:ffff88011f200000(0000)
knlGS:0000000000000000
[92356.003155] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[92356.003198] CR2: 00007f78140fc348 CR3: 0000000101499000 CR4: 00000000000407b0
[92356.003250] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[92356.003302] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[92356.003354] Stack:
[92356.003371] 0000000000000282 ffffffff81095da5 00000000ffffffff
0000000000000001
[92356.003435] ffff8800a84458d0 0bd4dea00b54e980 0000000000000282
ffff880038ae9a94
[92356.003498] 0000000000001388 ffff880119a7c800 0000000000000002
0000000000000282
[92356.003561] Call Trace:
[92356.003587] [<ffffffff81095da5>] ? __cache_free.isra.54+0x178/0x187
[92356.003643] [<ffffffffa0028e25>] ?
dvb_frontend_swzigzag_autotune+0x156/0x1c9 [dvb_core]
[92356.003709] [<ffffffffa0029d80>] ?
dvb_frontend_swzigzag+0x1f5/0x261 [dvb_core]
[92356.003766] [<ffffffff81048395>] ? load_balance+0xae/0x561
[92356.003811] [<ffffffff81045c90>] ? arch_vtime_task_switch+0x56/0x69
[92356.003861] [<ffffffff8104167b>] ? mmdrop+0xd/0x1c
[92356.003900] [<ffffffff81041b1a>] ? finish_task_switch+0x55/0x82
[92356.003948] [<ffffffff8102d72d>] ? lock_timer_base.isra.27+0x22/0x46
[92356.003996] [<ffffffff8102d9ed>] ? try_to_del_timer_sync+0x46/0x51
[92356.004044] [<ffffffff8102da1f>] ? del_timer_sync+0x27/0x44
[92356.004089] [<ffffffff8159ce2f>] ? schedule_timeout+0xb8/0xd1
[92356.004135] [<ffffffff8103f17f>] ? down_interruptible+0x39/0x45
[92356.006248] [<ffffffffa002a4ea>] ? dvb_frontend_thread+0x3fb/0x4bd [dvb_core]
[92356.008360] [<ffffffff8103be86>] ? abort_exclusive_wait+0x79/0x79
[92356.010451] [<ffffffffa002a0ef>] ? dtv_set_frontend+0x303/0x303 [dvb_core]
[92356.012485] [<ffffffffa002a0ef>] ? dtv_set_frontend+0x303/0x303 [dvb_core]
[92356.014466] [<ffffffff8103b5a1>] ? kthread+0x81/0x89
[92356.016395] [<ffffffff81040000>] ? async_synchronize_cookie_domain+0x64/0x10c
[92356.018298] [<ffffffff81040000>] ? async_synchronize_cookie_domain+0x64/0x10c
[92356.020187] [<ffffffff8103b520>] ? __kthread_parkme+0x5d/0x5d
[92356.022005] [<ffffffff8159f0ac>] ? ret_from_fork+0x7c/0xb0
[92356.023755] [<ffffffff8103b520>] ? __kthread_parkme+0x5d/0x5d
[92356.025425] Code: 2c b9 e8 03 00 00 99 f7 f9 31 d2 41 89 c5 8b 85
34 03 00 00 f7 f1 41 29 c5 48 89 df e8 e4 d7 ff ff 31 d2 41 89 c6 b8
00 00 00 04 <41> f7 f6 89 44 24 18 44 89 e8 c1 f8 1f 41 89 c0 45 31 e8
41 29
[92356.029002] RIP [<ffffffffa0227d05>]
dib7000p_set_frontend+0x471/0xe6c [dib7000p]
[92356.030733] RSP <ffff880038ae9978>
[92356.041141] cx23885_wakeup: 6 buffers handled (should be 1)
[92356.041171] cx23885_wakeup: 9 buffers handled (should be 1)
[92356.041176] ---[ end trace b9737a8d1a55d524 ]---
