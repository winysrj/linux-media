Return-path: <linux-media-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:57297 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753947AbcIKNjF (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 09:39:05 -0400
Date: Sun, 11 Sep 2016 15:33:17 +0200
From: Philipp Matthias Hahn <pmhahn+video@pmhahn.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [BUG] process stuck when closing saa7146 [dvb_ttpci]
Message-ID: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I own a 
| 04:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
|         Subsystem: Siemens AG Fujitsu/Siemens DVB-C card rev1.5
|         Flags: bus master, medium devsel, latency 64, IRQ 16
|         Memory at febff800 (32-bit, non-prefetchable) [size=512]
|         Kernel driver in use: av7110
|         Kernel modules: dvb_ttpci
with the analog module, which I still sometimes use to digitalize some old
videos. I'm using ffmpeg to read /dev/video0, which sometimes doesn't terminate
when I stop the proces with SIGINT. The Linux kernel then starts logging this message:

> INFO: task ffmpeg:9864 blocked for more than 120 seconds.
>       Tainted: P           O    4.6.7 #3
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> ffmpeg          D ffff880177cc7b00     0  9864      1 0x00000000
>  ffff880177cc7b00 0000000000000202 0000000000000202 ffffffff8180b4c0
>  ffff88019d79e4c0 ffffffff81064050 ffff880177cc7ae0 ffff880177cc8000
>  ffff880177cc7b18 ffff8801fd41d648 ffff8802307acca0 ffff8802307acc70
> Call Trace:
>  [<ffffffff81064050>] ? preempt_count_add+0x89/0xab
>  [<ffffffff81477215>] schedule+0x86/0x9e
>  [<ffffffff81477215>] ? schedule+0x86/0x9e
>  [<ffffffffa0fe1c96>] videobuf_waiton+0x131/0x15e [videobuf_core]
>  [<ffffffff8107727b>] ? wait_woken+0x6d/0x6d
>  [<ffffffffa1017be9>] saa7146_dma_free+0x39/0x5b [saa7146_vv]
>  [<ffffffffa10186c4>] buffer_release+0x2a/0x3e [saa7146_vv]
>  [<ffffffffa0fee4a8>] videobuf_vm_close+0xd8/0x103 [videobuf_dma_sg]
>  [<ffffffff8112049e>] remove_vma+0x25/0x4d
>  [<ffffffff81121a32>] exit_mmap+0xce/0xf7
>  [<ffffffff8104381d>] mmput+0x4e/0xe2
>  [<ffffffff810491fd>] do_exit+0x372/0x920
>  [<ffffffff81049813>] do_group_exit+0x3c/0x98
>  [<ffffffff810522ef>] get_signal+0x4e8/0x56e
>  [<ffffffff810710a5>] ? task_dead_fair+0xd/0xf
>  [<ffffffff81017020>] do_signal+0x23/0x521
>  [<ffffffff81479e82>] ? _raw_spin_unlock_irqrestore+0x13/0x25
>  [<ffffffff8109710d>] ? hrtimer_try_to_cancel+0xd7/0x104
>  [<ffffffff8109b306>] ? ktime_get+0x4c/0xa1
>  [<ffffffff81096ea6>] ? update_rmtp+0x46/0x5b
>  [<ffffffff81097ce0>] ? hrtimer_nanosleep+0xe4/0x10e
>  [<ffffffff81096e3c>] ? hrtimer_init+0xeb/0xeb
>  [<ffffffff810014f8>] exit_to_usermode_loop+0x4f/0x93
>  [<ffffffff810019fe>] syscall_return_slowpath+0x3b/0x46
>  [<ffffffff8147a355>] entry_SYSCALL_64_fastpath+0x8d/0x8f

I'm running Debian-Sid on linux-4.6.7.
I need to reboot the PC to get back a working /dev/video0

- Is this a known problem?
- Is the a fix?
- What extra data is needed to fix it?

Thanks in advance.
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de
