Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8NJpiIW013803
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 15:51:45 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8NJpHZM014068
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 15:51:17 -0400
Received: by ey-out-2122.google.com with SMTP id 4so600894eyf.39
	for <video4linux-list@redhat.com>; Tue, 23 Sep 2008 12:51:17 -0700 (PDT)
Date: Tue, 23 Sep 2008 20:51:37 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080923195137.GA4038@singular.sob>
References: <30353c3d0809202112i6f1b7f5do48dd7c9e299ba877@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0809202112i6f1b7f5do48dd7c9e299ba877@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFT]: stk-webcam: release via video_device release
	callback
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

Hi David, sorry for the delay and thanks for working in this.

I've done some testing and everything seemed to work, but I finally
managed to trigger a bug. I think it's unrelated to this patch.

The testing goes as follow:
1 - xawtv&
2 - rmmod ehci-hcd && modprobe ehci-hcd
3 - repeat...

As I cannot unplug the camera, I unload the ehci driver to simulate the
unplugging-while-in-use case. This normally works as expected, but after
some iterations of the test I got this:

[...]
usb 4-4: new high speed USB device using ehci_hcd and address 2
usb 4-4: configuration #1 chosen from 1 choice
stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video2
stkwebcam: OmniVision sensor detected, id 9652 at address 60
stkwebcam: frame 3, bytesused=2461154, skipping
stkwebcam: frame 11, bytesused=1157638, skipping
stkwebcam: frame 4, bytesused=2586972, skipping
stkwebcam: frame 10, bytesused=2343188, skipping
ehci_hcd 0000:00:03.3: remove, state 1
usb usb4: USB disconnect, address 1
usb 4-4: USB disconnect, address 2
stkwebcam: Error (-19) re-submitting urb in stk_isoc_handler.
stkwebcam: Syntek USB2.0 Camera release resourcesvideo device /dev/video2
ehci_hcd 0000:00:03.3: USB bus 4 deregistered
ehci_hcd 0000:00:03.3: PCI INT D disabled
BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
IP: [<ffffffff803e0660>] unlink1+0x30/0x170
PGD 2b886067 PUD 2b875067 PMD 0 
Oops: 0000 [1] PREEMPT 
CPU 0 
Modules linked in: nouveau drm ppdev lp ipv6 fuse ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables loop firewire_sbp2 joydev stkwebcam compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rfkill rng_core mac80211 cfg80211 input_polldev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw k8temp r8169 bitrev snd_intel8x0 video output battery sdhci_pci sdhci snd_ac97_codec ac ac97_bus snd_pcm snd_timer mmc_core snd firewire_ohci firewire_core soundcore snd_page_alloc ssb crc_itu_t button ohci_hcd sg pcmcia sr_mod cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
Pid: 3422, comm: cheese Not tainted 2.6.27-rc5-video0 #1
RIP: 0010:[<ffffffff803e0660>]  [<ffffffff803e0660>] unlink1+0x30/0x170
RSP: 0018:ffff88002b8a3e58  EFLAGS: 00010206
RAX: ffff88002ca0b800 RBX: ffff880032cf3a00 RCX: ffff880032cf3a00
RDX: 00000000fffffffe RSI: ffff880032cf3a00 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88003eeacef0
R10: 0000000000000001 R11: 0000000000000206 R12: 00000000fffffffe
R13: ffff88003f73f000 R14: ffff88003ed9db00 R15: 00007fd222fff940
FS:  00007fd2284077e0(0000) GS:ffffffff805a8e80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000e8 CR3: 000000002b931000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process cheese (pid: 3422, threadinfo ffff88002b8a2000, task ffff8800365d38e0)
Stack:  ffff880032cf3a00 0000000000000000 ffff88003ec24000 ffff88003f73f000
 ffff88003ed9db00 ffffffff803e0949 ffff88002a4833f0 ffffffff803e1dd0
 0000000000000246 ffff88002a462dc8 ffff88002a462dc8 ffff88002a4833f0
Call Trace:
 [<ffffffff803e0949>] usb_hcd_unlink_urb+0x19/0x30
 [<ffffffff803e1dd0>] usb_kill_urb+0x50/0xe0
 [<ffffffffa0204ab7>] stk_clean_iso+0x87/0xc0 [stkwebcam]
 [<ffffffffa0206538>] v4l_stk_release+0x38/0x50 [stkwebcam]
 [<ffffffff802a0bc1>] __fput+0xa1/0x1c0
 [<ffffffff8029d7bb>] filp_close+0x5b/0x90
 [<ffffffff8029d8a1>] sys_close+0xb1/0x140
 [<ffffffff8020c37b>] system_call_fastpath+0x16/0x1b


Code: 89 1c 24 48 89 6c 24 08 48 89 f3 4c 89 64 24 10 4c 89 6c 24 18 48 89 fd 4c 89 74 24 20 48 8b 46 48 41 89 d4 48 83 78 38 00 74 30 <48> 8b 87 e8 00 00 00 48 8b 1c 24 48 8b 6c 24 08 4c 8b 64 24 10 
RIP  [<ffffffff803e0660>] unlink1+0x30/0x170
 RSP <ffff88002b8a3e58>
CR2: 00000000000000e8
---[ end trace c57f522e2b519e93 ]---
usb 1-2: new full speed USB device using ohci_hcd and address 8
usb 1-2: configuration #1 chosen from 1 choice
stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video0
ehci_hcd 0000:00:03.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:03.3: cache line size of 64 is not supported
ehci_hcd 0000:00:03.3: irq 23, io mem 0xfebfc000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 8 ports detected
usb 1-2: USB disconnect, address 8
stkwebcam: Syntek USB2.0 Camera release resourcesvideo device /dev/video0
usb 4-4: new high speed USB device using ehci_hcd and address 2
usb 4-4: configuration #1 chosen from 1 choice
stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video0

The difference between this run of the test and the previous (working)
one is the line 
stkwebcam: Error (-19) re-submitting urb in stk_isoc_handler.

I think what happens is that the ehci driver is unloaded while stkwebcam
is inside its ISOC handler, it fails resubmitting the URB and then it oopses
when finally cleaning up and trying to kill an unsubmitted URB. So I think
the bug is in the URB handling code in stk-webcam (or maybe in the usb core?).

I think your patch is correct, and will try to find some time and fix the
broken URB handling code in stk-webcam. I'd appreciate comments if someone
thinks I'm mistaken here, or any hints about fixing the bug.

In short,
Acked-by: Jaime Velasco Juan <jsagarribay@gmail.com>

Kind regards.

El dom. 21 de sep. de 2008, a las 00:12:03 -0400, David Ellingsworth escribió:
> With the recent patch to v4l2 titled "v4l2: use register_chrdev_region
> instead of register_chrdev", the internal reference count is no longer
> necessary in order to free the internal stk_webcam struct. This patch
> removes the reference counter from the stk_webcam struct and frees the
> struct via the video_device release callback. It also fixes an
> associated bug in stk_camera_probe which could result from
> video_unregister_device being called before video_register_device.
> Lastly, it simplifies access to the stk_webcam struct in several
> places. This patch should apply cleanly against the "working" branch
> of the v4l-dvb git repository.
> 
> This patch is identical to the patch I sent a couple of months back
> titled "stk-webcam: Fix video_device handling" except that it has been
> rebased against current modifications to stk-webcam and it no longer
> depends on any other outstanding patches.
> 
> Regards,
> 
> David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
