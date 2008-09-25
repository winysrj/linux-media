Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8PJ3BoQ028407
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 15:03:11 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.157])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m8PJ30NQ012073
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 15:03:01 -0400
Received: by fg-out-1718.google.com with SMTP id e21so406861fga.7
	for <video4linux-list@redhat.com>; Thu, 25 Sep 2008 12:03:00 -0700 (PDT)
Message-ID: <30353c3d0809251203q4f09a237xd08aa227d96e62b0@mail.gmail.com>
Date: Thu, 25 Sep 2008 15:03:00 -0400
From: "David Ellingsworth" <david@identd.dyndns.org>
To: "Jaime Velasco Juan" <jsagarribay@gmail.com>
In-Reply-To: <20080923195137.GA4038@singular.sob>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <30353c3d0809202112i6f1b7f5do48dd7c9e299ba877@mail.gmail.com>
	<20080923195137.GA4038@singular.sob>
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

On Tue, Sep 23, 2008 at 3:51 PM, Jaime Velasco Juan
<jsagarribay@gmail.com> wrote:
> Hi David, sorry for the delay and thanks for working in this.
>
> I've done some testing and everything seemed to work, but I finally
> managed to trigger a bug. I think it's unrelated to this patch.
>
> The testing goes as follow:
> 1 - xawtv&
> 2 - rmmod ehci-hcd && modprobe ehci-hcd
> 3 - repeat...
>
> As I cannot unplug the camera, I unload the ehci driver to simulate the
> unplugging-while-in-use case. This normally works as expected, but after
> some iterations of the test I got this:
>
> [...]
> usb 4-4: new high speed USB device using ehci_hcd and address 2
> usb 4-4: configuration #1 chosen from 1 choice
> stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video2
> stkwebcam: OmniVision sensor detected, id 9652 at address 60
> stkwebcam: frame 3, bytesused=2461154, skipping
> stkwebcam: frame 11, bytesused=1157638, skipping
> stkwebcam: frame 4, bytesused=2586972, skipping
> stkwebcam: frame 10, bytesused=2343188, skipping
> ehci_hcd 0000:00:03.3: remove, state 1
> usb usb4: USB disconnect, address 1
> usb 4-4: USB disconnect, address 2
> stkwebcam: Error (-19) re-submitting urb in stk_isoc_handler.
> stkwebcam: Syntek USB2.0 Camera release resourcesvideo device /dev/video2
> ehci_hcd 0000:00:03.3: USB bus 4 deregistered
> ehci_hcd 0000:00:03.3: PCI INT D disabled
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000e8
> IP: [<ffffffff803e0660>] unlink1+0x30/0x170
> PGD 2b886067 PUD 2b875067 PMD 0
> Oops: 0000 [1] PREEMPT
> CPU 0
> Modules linked in: nouveau drm ppdev lp ipv6 fuse ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables loop firewire_sbp2 joydev stkwebcam compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rfkill rng_core mac80211 cfg80211 input_polldev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw k8temp r8169 bitrev snd_intel8x0 video output battery sdhci_pci sdhci snd_ac97_codec ac ac97_bus snd_pcm snd_timer mmc_core snd firewire_ohci firewire_core soundcore snd_page_alloc ssb crc_itu_t button ohci_hcd sg pcmcia sr_mod cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
> Pid: 3422, comm: cheese Not tainted 2.6.27-rc5-video0 #1
> RIP: 0010:[<ffffffff803e0660>]  [<ffffffff803e0660>] unlink1+0x30/0x170
> RSP: 0018:ffff88002b8a3e58  EFLAGS: 00010206
> RAX: ffff88002ca0b800 RBX: ffff880032cf3a00 RCX: ffff880032cf3a00
> RDX: 00000000fffffffe RSI: ffff880032cf3a00 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88003eeacef0
> R10: 0000000000000001 R11: 0000000000000206 R12: 00000000fffffffe
> R13: ffff88003f73f000 R14: ffff88003ed9db00 R15: 00007fd222fff940
> FS:  00007fd2284077e0(0000) GS:ffffffff805a8e80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00000000000000e8 CR3: 000000002b931000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process cheese (pid: 3422, threadinfo ffff88002b8a2000, task ffff8800365d38e0)
> Stack:  ffff880032cf3a00 0000000000000000 ffff88003ec24000 ffff88003f73f000
>  ffff88003ed9db00 ffffffff803e0949 ffff88002a4833f0 ffffffff803e1dd0
>  0000000000000246 ffff88002a462dc8 ffff88002a462dc8 ffff88002a4833f0
> Call Trace:
>  [<ffffffff803e0949>] usb_hcd_unlink_urb+0x19/0x30
>  [<ffffffff803e1dd0>] usb_kill_urb+0x50/0xe0
>  [<ffffffffa0204ab7>] stk_clean_iso+0x87/0xc0 [stkwebcam]
>  [<ffffffffa0206538>] v4l_stk_release+0x38/0x50 [stkwebcam]
>  [<ffffffff802a0bc1>] __fput+0xa1/0x1c0
>  [<ffffffff8029d7bb>] filp_close+0x5b/0x90
>  [<ffffffff8029d8a1>] sys_close+0xb1/0x140
>  [<ffffffff8020c37b>] system_call_fastpath+0x16/0x1b

The above stack trace is a result of a _close_ after _disconnect_.
Before my patch, it looks as if stk-webcam was able to detect that the
camera was already disconnected in the release function by examining
the stk_camera pointer and return an error. The above patch removed
this check as the pointer is still valid. If there really is nothing
for stk-webcam to do in this case, adding an if statement that
examines the state of the device using the is_present macro and
returning in v4l_stk_release should fix the above crash. Is this the
right thing to do though? Or does stk-webcam still have cleanup that
it needs to do before returning?

Under the circumstances, the urb error here is expected. It is a
result of the device physically being removed while stk-webcam is
trying to send it something. We know this to be the case as it is
immediately followed by a message that the video device has been
unregistered, which only happens once the device is disconnected.

I hope this clears up the issue for you. I noticed a small formatting
bug in the other output. I will correct it in the next patch. For
simplicity purposes, I'm going to split the above patch into 2. The
first will remove the reference count and the second will simplify
access to the stk_camera struct. Making this division, I believe the
second patch if kept the same as it is now would trigger the above
crash and requires a fix. How it should be fixed has yet to be
determined.

Regards,

David Ellingsworth

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
