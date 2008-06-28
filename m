Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5SE6vNK030466
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 10:06:57 -0400
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5SE6jPn008201
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 10:06:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so240980nfc.21
	for <video4linux-list@redhat.com>; Sat, 28 Jun 2008 07:06:44 -0700 (PDT)
Date: Sat, 28 Jun 2008 15:06:39 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080628140639.GA4089@singular.sob>
References: <30353c3d0806271636k31f1fac7r90d1dccafde99f1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0806271636k31f1fac7r90d1dccafde99f1b@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: stk-webcam: [RFT] Fix video_device handling
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

Hi David,

El vie. 27 de jun. de 2008, a las 19:36:03 -0400, David Ellingsworth
escribió:
> This patch replaces the internal video_device struct of the stk_camera
> struct with a pointer. video_device_alloc() is the used to fill this
> pointer and video_device_release to free it. This prevents freeing of
> the video_device struct before the release callback of the
> video_device has been called per the V4L2 api specs.
> 
The driver did that initially, but as the video_device struct is always
needed, it was embedded in the main stk_camera struct to avoid doing
another allocation and check if it succeded, etc. Also, I didn't want to
use video_get_drvdata, because it's defined inside an
#ifdef OBSOLETE_OWNER /* to be removed soon */
which didn't sound well to me.

In any case, the data should never be freed before all users of the
device have closed it, because it is protected with a kref.

> This patch also relocates the call to video_unregister_device to the
> disconnect callback of the usb_driver. This prevents calling
> video_unregister_device from the usb probe callback in error paths.
> Doing so removes the /dev device from the system when the physical
> device no longer exists thus preventing future opens. Careful
> attention has been paid to close after disconnect as well.

This sounds good to me, but I remember having problems when the camera was
disconnected while in use, so that's what I tried with your patch.  My
camera is integrated but I test disconnection removing the ehci_hcd
module (I'm sure there are better ways...).

This happens when xawtv is running while the camera is disconnected:

ehci_hcd 0000:00:03.3: remove, state 1
usb usb4: USB disconnect, address 1
usb 4-4: USB disconnect, address 2
stkwebcam: Syntek USB2.0 Camera release resources video device /dev/video0
ehci_hcd 0000:00:03.3: USB bus 4 deregistered
ACPI: PCI interrupt for device 0000:00:03.3 disabled
BUG: unable to handle kernel NULL pointer dereference at 000000000000024c
IP: [<ffffffffa0205172>] :videodev:__video_do_ioctl+0x62/0x2ff0
PGD 33faf067 PUD 2e9d9067 PMD 0 
Oops: 0000 [1] PREEMPT 
CPU 0 
Modules linked in: act_police sch_ingress cls_u32 sch_sfq sch_htb af_packet nouveau drm ppdev lp ipv6 ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables fuse loop firewire_sbp2 stkwebcam compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rng_core mac80211 cfg80211 joydev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw sdhci r8169 mmc_core bitrev firewire_ohci firewire_core crc_itu_t video output battery ac snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer button snd ssb soundcore ohci_hcd snd_page_alloc sg pcmcia sr_mod firmware_class cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
Pid: 3516, comm: xawtv.bin Not tainted 2.6.26-rc8-po0 #2
RIP: 0010:[<ffffffffa0205172>]  [<ffffffffa0205172>] :videodev:__video_do_ioctl+0x62/0x2ff0
RSP: 0018:ffff81001f0b3d38  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff81003fafc940 RCX: ffff81001f0b3e28
RDX: 00000000c0585611 RSI: ffff81002e9a5b40 RDI: ffff81003fafc940
RBP: 00000000c0585611 R08: 0000000000000001 R09: 0000000000000000
R10: ffff81003f9d3900 R11: 0000000000000000 R12: ffff81002e9a5b40
R13: 00000000c0585611 R14: 0000000000000000 R15: ffff81001f0b3e28
FS:  00007f59284966e0(0000) GS:ffffffff80591000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000000024c CR3: 000000002ea64000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xawtv.bin (pid: 3516, threadinfo ffff81001f0b2000, task ffff81002e8ed140)
Stack:  0000100000000040 ffff810033a73180 0000000000000246 ffffffff80304431
 ffff81001f0b3d60 ffff81001f0b3e08 0000000100000000 0000000100000003
 00007fff305bc6c0 ffff81002e8ed140 0000000000000000 ffffffff802ab18f
Call Trace:
 [<ffffffff80304431>] ? avc_has_perm_noaudit+0x181/0x510
 [<ffffffff802ab18f>] ? core_sys_select+0x26f/0x320
 [<ffffffffa0208267>] ? :videodev:video_ioctl2+0x167/0x344
 [<ffffffff802a979d>] ? vfs_ioctl+0x7d/0xa0
 [<ffffffff802a9a33>] ? do_vfs_ioctl+0x273/0x2e0
 [<ffffffff802a9b41>] ? sys_ioctl+0xa1/0xb0
 [<ffffffff8020c33b>] ? system_call_after_swapgs+0x7b/0x80


Code: ac 24 a0 00 00 00 41 89 d5 48 8b 46 18 49 89 cf 4c 8b 96 90 00 00 00 48 8b 40 08 8b 40 58 25 ff ff 0f 00 4c 8b 34 c5 00 c1 20 a0 <41> 8b 86 4c 02 00 00 83 e0 03 ff c8 0f 84 0a 1f 00 00 41 81 fd 
RIP  [<ffffffffa0205172>] :videodev:__video_do_ioctl+0x62/0x2ff0
 RSP <ffff81001f0b3d38>
CR2: 000000000000024c
---[ end trace f1332077cdef4f39 ]---


I recall working around a similar bug in the past, but the workaround
don't seem very good now ;), and I haven't touch the driver in a while,
so I'm not sure where is the problem. It seems that
video_unregister_device cannot be called when the device is open.

Regards,
Jaime

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
