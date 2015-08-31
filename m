Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33205 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbbHaWsc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 18:48:32 -0400
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Subject: Linux 4.2 ALSA snd-usb-audio inconsistent lock state warn in PCM
 nonatomic mode
Message-ID: <55E4D9BE.2040308@osg.samsung.com>
Date: Mon, 31 Aug 2015 16:48:30 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Takashi,

I am seeing the following inconsistent lock state warning when PCM
is run in nonatomic mode. This is on 4.2.0 and with the following
change to force PCM on nonatomic mode:

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index 310a382..16bbb71 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -370,6 +370,7 @@ int snd_usb_add_audio_stream(struct snd_usb_audio *chip,
        pcm->private_data = as;
        pcm->private_free = snd_usb_audio_pcm_free;
        pcm->info_flags = 0;
+       pcm->nonatomic = true;
        if (chip->pcm_devs > 0)
                sprintf(pcm->name, "USB Audio #%d", chip->pcm_devs);
        else

The device Bus 003 Device 002: ID 2040:7200 Hauppauge
Please let me know if you need more information and any ideas on
how to fix this problem.

thanks,
-- Shuah

[  120.283960] =================================
[  120.283964] [ INFO: inconsistent lock state ]
[  120.283968] 4.2.0+ #29 Not tainted
[  120.283972] ---------------------------------
[  120.283975] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[  120.283980] swapper/1/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[  120.283983]  (&(&subs->lock)->rlock){?.+...}, at:
[<ffffffffa05ed210>] retire_capture_urb+0x140/0x2b0 [snd_usb_audio]
[  120.284005] {HARDIRQ-ON-W} state was registered at:
[  120.284008]   [<ffffffff810af230>] __lock_acquire+0xc50/0x2380
[  120.284016]   [<ffffffff810b1631>] lock_acquire+0xb1/0x130
[  120.284022]   [<ffffffff817fd4a1>] _raw_spin_lock+0x31/0x40
[  120.284028]   [<ffffffffa05ee81d>] snd_usb_pcm_pointer+0x5d/0xc0
[snd_usb_audio]
[  120.284040]   [<ffffffffa01c6498>] snd_pcm_update_hw_ptr0+0x38/0x3a0
[snd_pcm]
[  120.284052]   [<ffffffffa01c73f0>] snd_pcm_update_hw_ptr+0x10/0x20
[snd_pcm]
[  120.284063]   [<ffffffffa01beae5>] snd_pcm_hwsync+0x45/0xa0 [snd_pcm]
[  120.284071]   [<ffffffffa01c1347>] snd_pcm_common_ioctl1+0x277/0xce0
[snd_pcm]
[  120.284081]   [<ffffffffa01c227e>] snd_pcm_capture_ioctl1+0x1be/0x2d0
[snd_pcm]
[  120.284090]   [<ffffffffa01c2444>] snd_pcm_capture_ioctl+0x34/0x40
[snd_pcm]
[  120.284100]   [<ffffffff811ed7e1>] do_vfs_ioctl+0x301/0x560
[  120.284107]   [<ffffffff811edab9>] SyS_ioctl+0x79/0x90
[  120.284112]   [<ffffffff817fdf17>] entry_SYSCALL_64_fastpath+0x12/0x6f
[  120.284119] irq event stamp: 823304
[  120.284122] hardirqs last  enabled at (823301): [<ffffffff816707ad>]
cpuidle_enter_state+0xed/0x230
[  120.284129] hardirqs last disabled at (823302): [<ffffffff817fea28>]
common_interrupt+0x68/0x6d
[  120.284135] softirqs last  enabled at (823304): [<ffffffff81060351>]
_local_bh_enable+0x21/0x50
[  120.284139] softirqs last disabled at (823303): [<ffffffff810611ac>]
irq_enter+0x4c/0x70
[  120.284143]
other info that might help us debug this:
[  120.284146]  Possible unsafe locking scenario:

[  120.284149]        CPU0
[  120.284150]        ----
[  120.284152]   lock(&(&subs->lock)->rlock);
[  120.284155]   <Interrupt>
[  120.284157]     lock(&(&subs->lock)->rlock);
[  120.284160]
 *** DEADLOCK ***
[  120.284163] no locks held by swapper/1/0.
[  120.284165]
stack backtrace:
[  120.284170] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.2.0+ #29
[  120.284173] Hardware name: Hewlett-Packard HP ProBook 6475b/180F,
BIOS 68TTU Ver. F.04 08/03/2012
[  120.284176]  ffffffff828d5630 ffff88023ec83a68 ffffffff817f4ea0
0000000000000007
[  120.284181]  ffff880235a6a500 ffff88023ec83ac8 ffffffff810ad97f
0000000000000000
[  120.284186]  0000000000000000 ffff880200000001 ffffffff810134df
ffffffff827c5390
[  120.284192] Call Trace:
[  120.284194]  <IRQ>  [<ffffffff817f4ea0>] dump_stack+0x45/0x57
[  120.284203]  [<ffffffff810ad97f>] print_usage_bug+0x1ff/0x210
[  120.284209]  [<ffffffff810134df>] ? save_stack_trace+0x2f/0x50
[  120.284214]  [<ffffffff810adffe>] mark_lock+0x66e/0x6f0
[  120.284218]  [<ffffffff810aceb0>] ?
print_shortest_lock_dependencies+0x1d0/0x1d0
[  120.284222]  [<ffffffff810af3ab>] __lock_acquire+0xdcb/0x2380
[  120.284226]  [<ffffffff81091a2c>] ? __enqueue_entity+0x6c/0x70
[  120.284230]  [<ffffffff810ab8dd>] ? __lock_is_held+0x4d/0x70
[  120.284234]  [<ffffffff810ab8dd>] ? __lock_is_held+0x4d/0x70
[  120.284238]  [<ffffffff810ab8dd>] ? __lock_is_held+0x4d/0x70
[  120.284242]  [<ffffffff810ab8dd>] ? __lock_is_held+0x4d/0x70
[  120.284246]  [<ffffffff810b1631>] lock_acquire+0xb1/0x130
[  120.284256]  [<ffffffffa05ed210>] ? retire_capture_urb+0x140/0x2b0
[snd_usb_audio]
[  120.284261]  [<ffffffff817fd61c>] _raw_spin_lock_irqsave+0x3c/0x50
[  120.284270]  [<ffffffffa05ed210>] ? retire_capture_urb+0x140/0x2b0
[snd_usb_audio]
[  120.284276]  [<ffffffff81595325>] ? usb_hcd_get_frame_number+0x25/0x30
[  120.284285]  [<ffffffffa05ed210>] retire_capture_urb+0x140/0x2b0
[snd_usb_audio]
[  120.284294]  [<ffffffffa05e513c>] snd_complete_urb+0x13c/0x250
[snd_usb_audio]
[  120.284298]  [<ffffffff81592cb2>] __usb_hcd_giveback_urb+0x72/0x110
[  120.284303]  [<ffffffff81592e53>] usb_hcd_giveback_urb+0x43/0x140
[  120.284307]  [<ffffffff815d1b02>] xhci_irq+0xd42/0x1fc0
[  120.284312]  [<ffffffff815d2d91>] xhci_msi_irq+0x11/0x20
[  120.284317]  [<ffffffff810c4570>] handle_irq_event_percpu+0x80/0x1a0
[  120.284322]  [<ffffffff810c46da>] handle_irq_event+0x4a/0x70
[  120.284325]  [<ffffffff810c7794>] ? handle_edge_irq+0x24/0x150
[  120.284329]  [<ffffffff810c77f1>] handle_edge_irq+0x81/0x150
[  120.284333]  [<ffffffff81005c85>] handle_irq+0x25/0x40
[  120.284337]  [<ffffffff818008ef>] do_IRQ+0x4f/0xe0
[  120.284341]  [<ffffffff817fea2d>] common_interrupt+0x6d/0x6d
[  120.284343]  <EOI>  [<ffffffff816707b2>] ? cpuidle_enter_state+0xf2/0x230
[  120.284351]  [<ffffffff816707ad>] ? cpuidle_enter_state+0xed/0x230
[  120.284355]  [<ffffffff81670927>] cpuidle_enter+0x17/0x20
[  120.284360]  [<ffffffff810a3862>] call_cpuidle+0x32/0x60
[  120.284364]  [<ffffffff81670903>] ? cpuidle_select+0x13/0x20
[  120.284369]  [<ffffffff810a3aa6>] cpu_startup_entry+0x216/0x2d0
[  120.284374]  [<ffffffff8103679d>] start_secondary+0x12d/0x150
[  125.426447] device: 'ep_84': device_unregister
[  125.426511] PM: Removing info for No Bus:ep_84
[  125.426542] device: 'ep_84': device_add
[  125.426602] PM: Adding info for No Bus:ep_84

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
