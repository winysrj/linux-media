Return-path: <linux-media-owner@vger.kernel.org>
Received: from router.ktuo.cz ([82.144.143.254]:56594 "EHLO router.ktuo.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbaD0LkW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Apr 2014 07:40:22 -0400
Received: from [192.168.132.120] (helo=[192.168.24.104])
	by router.ktuo.cz with esmtp (Exim 4.69)
	(envelope-from <kontakt@podvodnik.cz>)
	id 1WeNRU-0000D0-EA
	for linux-media@vger.kernel.org; Sun, 27 Apr 2014 13:40:20 +0200
Message-ID: <535CEC9E.2010309@podvodnik.cz>
Date: Sun, 27 Apr 2014 13:40:14 +0200
From: MMM <kontakt@podvodnik.cz>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AVerMedia A827 patching for kernel 3.13.0 (AVerMedia AverTV Hybrid
 Volar HX)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all.
I decided to try to look at my old dvb-t tuner AVerMedia Volar HX, which 
sensitivity I am missig. Replacement I purchased is way too worse. The 
manufacturer support was for me a disappointment (no more new 
AVerMedia), however the hardware performance for my purposes was fine, 
so I decided to try to make it once more working. I followed the tips 
from here:
http://www.linuxtv.org/wiki/index.php/AVerMedia_AverTV_Hybrid_Volar_HX_%28A827%29

I have applied all the patches up to 3.2.0 and looking what is missing 
to. Based on various unrelated patches found for similar issues i did 
following modificatons:

-----------------------------------------
in aver/osdep_vbuf.h I defined following to satisfy the code 
aver/osdep_vbuf.c:
-----------------------------------------
#ifndef VM_RESERVED
#define VM_RESERVED (VM_DONTEXPAND | VM_DONTDUMP)
#endif

-----------------------------------------
in aver/osdep_th2.c instead of:
-----------------------------------------
int SysKernelThread(void (*func)(void *),void *thObj)
{
         return kernel_thread((int (*)(void *))func,thObj,0);
}
-----------------------------------------
i used following code instead:
-----------------------------------------
int SysKernelThread(void (*func)(void *),void *thObj)
{
     struct task_struct *tsk;
     tsk = kthread_run((int (*)(void *))func , thObj, "h826_thread");
     return get_pid(task_pid(tsk));
}

-----------------------------------------
in aver/osdep_v4l2.c I aligned section:
-----------------------------------------
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
     cont->vfd->parent = (struct device *)dev;
     cont->vfd->release = video_device_release;
#elif LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
     cont->vfd->dev = (struct device *)dev;
     cont->vfd->release = video_device_release;
#endif
-----------------------------------------
to
-----------------------------------------
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,26)
     cont->vfd->v4l2_dev = (struct v4l2_device *)dev;
     cont->vfd->release = video_device_release;
#elif LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
     cont->vfd->dev = (struct device *)dev;
     cont->vfd->release = video_device_release;
#endif


The driver compiles okay (with few warnings which may not be the issue), 
but when the device is inserted I am getting errors in kernel log and I 
am not sure how to identify the cause (my skills are limited):


[41529.658175] usb 2-5: Product: AVerTV
[41529.658182] usb 2-5: Manufacturer: AVerMedia
[41529.658190] usb 2-5: SerialNumber: 000000000000
[41529.745958] Linux video capture interface: v2.00
[41529.752878] AVerMedia USB Wrapper for H826D version 0.28 loaded
[41529.768494] AVerTV Volar HX AX MAX version 0.10 loaded
[41529.860156] usb 2-1.1: new high-speed USB device number 55 using ehci-pci
[41530.123389] SysKernelThread, before kthread_run ffffffffa0c265e0 
ffff88022ff50330
[41530.123962] BUG: unable to handle kernel paging request at 
00000000040001f3
[41530.123988] IP: [<00000000040001f3>] 0x40001f3
[41530.124007] PGD 1a2c5a067 PUD 1a621a067 PMD 0
[41530.124031] Oops: 0010 [#1] SMP
[41530.124047] Modules linked in: h826d(POF+) averusbh826d(OF) videodev 
rc_it913x_v1 it913x_fe dvb_usb_it913x dvb_usb_v2 dvb_core rc_core hidp 
pci_stub vboxpci(OF) vboxnetadp(OF) vboxnetflt(OF) vboxdrv(OF) dm_crypt 
eeepc_wmi asus_wmi sparse_keymap video bnep rfcomm binfmt_misc kvm_amd 
kvm dm_multipath scsi_dh psmouse serio_raw cdc_acm btusb bluetooth 
snd_seq_midi snd_seq_midi_event fglrx(POF) snd_hda_codec_realtek 
snd_rawmidi k10temp snd_hda_codec_hdmi snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_pcm snd_seq_device sp5100_tco snd_page_alloc 
i2c_piix4 snd_timer snd soundcore parport_pc amd_iommu_v2 ppdev mac_hid 
lp parport dm_mirror dm_region_hash dm_log hid_generic usbhid hid 
usb_storage firewire_ohci firewire_core r8169 crc_itu_t mii ahci libahci wmi
[41530.124194] CPU: 1 PID: 2829 Comm: h826_thread Tainted: PF          O 
3.13.0-24-generic #46-Ubuntu
[41530.124204] Hardware name: System manufacturer System Product 
Name/E35M1-M, BIOS 0401 02/16/2011
[41530.124212] task: ffff8800363417f0 ti: ffff8801d43cc000 task.ti: 
ffff8801d43cc000
[41530.124219] RIP: 0010:[<00000000040001f3>] [<00000000040001f3>] 0x40001f3
[41530.124232] RSP: 0018:ffff8801d43cdeb0  EFLAGS: 00010246
[41530.124239] RAX: ffff880200000101 RBX: ffff88022ff50330 RCX: 
ffff880209e54cc0
[41530.124245] RDX: ffffffffffffffff RSI: ffff88022edce048 RDI: 
ffff88022ecabe00
[41530.124252] RBP: ffff8801d43cdec8 R08: ffff8801d43cc000 R09: 
0000000000000000
[41530.124258] R10: 0000000000000000 R11: ffffffff81c27ea0 R12: 
ffff88022ff50330
[41530.124263] R13: ffffffffa0c265e0 R14: 0000000000000000 R15: 
0000000000000000
[41530.124272] FS:  00007f86c63ff880(0000) GS:ffff88023ed00000(0000) 
knlGS:0000000000000000
[41530.124278] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[41530.124284] CR2: 00000000040001f3 CR3: 00000001d43d8000 CR4: 
00000000000007e0
[41530.124290] Stack:
[41530.124295]  ffffffffa0c26608 ffff88022ff50330 ffff8800962c3740 
ffff8801d43cdf48
[41530.124307]  ffffffff8108b312 0000000000000000 ffff8801d43cdef8 
ffff88022ff50330
[41530.124318]  ffff880200000000 ffff880100000000 ffff8801d43cdf00 
ffff8801d43cdf00
[41530.124329] Call Trace:
[41530.124471]  [<ffffffffa0c26608>] ? 
_ZN11CThread2Lnx16StaticThreadFuncEPv+0x28/0x50 [h826d]
[41530.124486]  [<ffffffff8108b312>] kthread+0xd2/0xf0
[41530.124498]  [<ffffffff8108b240>] ? kthread_create_on_node+0x1d0/0x1d0
[41530.124510]  [<ffffffff8172637c>] ret_from_fork+0x7c/0xb0
[41530.124520]  [<ffffffff8108b240>] ? kthread_create_on_node+0x1d0/0x1d0
[41530.124526] Code:  Bad RIP value.
[41530.124532] RIP  [<00000000040001f3>] 0x40001f3
[41530.124545]  RSP <ffff8801d43cdeb0>
[41530.124550] CR2: 00000000040001f3
[41530.124559] ---[ end trace 9b73b3a6421194b4 ]---
[41530.126783] usbcore: registered new interface driver AVerTV Volar HX 
AX MAX


Thanks in advance for any hint.
Martin
