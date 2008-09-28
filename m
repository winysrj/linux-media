Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8SH3jkO030024
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 13:03:45 -0400
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.27])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m8SH3UWI027879
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 13:03:30 -0400
Received: by ey-out-2122.google.com with SMTP id 4so432379eyf.39
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 10:03:29 -0700 (PDT)
Date: Sun, 28 Sep 2008 18:05:11 +0100
From: Jaime Velasco Juan <jsagarribay@gmail.com>
To: David Ellingsworth <david@identd.dyndns.org>
Message-ID: <20080928170511.GA6749@singular.sob>
References: <30353c3d0809202112i6f1b7f5do48dd7c9e299ba877@mail.gmail.com>
	<20080923195137.GA4038@singular.sob>
	<30353c3d0809251203q4f09a237xd08aa227d96e62b0@mail.gmail.com>
	<30353c3d0809251849t561c6c9dr4fd0ac26bf2924f5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30353c3d0809251849t561c6c9dr4fd0ac26bf2924f5@mail.gmail.com>
Cc: v4l <video4linux-list@redhat.com>
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

Hi,

El jue. 25 de sep. de 2008, a las 21:49:14 -0400, David Ellingsworth escribió:
> Jamie,
> 
> After re-examining stk-webcam, I believe the crash you experienced
> would occur despite having applied my patch. In the current version of
> stk-webcam.c there are two if conditions at the very beginning of the
> v4l_stk_release function that checks for NULL. In the case of a close
> occuring after disconnect, neither of these variable will be NULL. The
> sequence would be as follows:
> 
> v4l_stk_release
>   stk_free_buffers
>     stk_clean_iso
>       usb_kill_urb
>         (crash)
> 
> After the camera has been disconnected, usb_kill_urb should not be
> called since usb_disconnect already takes care of killing all urbs
> associated with a disconnected device. usb_free_urb however still
> needs to be called for every urb allocated. Therefore I believe the
> proper fix for this should be to checke that the camera is present
> before calling usb_kill_urb.
> 

Yes, I also think that the bug was present in the driver before your patch.
With these new patches, however, it still crashes at a different point:
(sorry, the log is not complete)

[...]
stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video3
stkwebcam: OmniVision sensor detected, id 9652 at address 60
stkwebcam: frame 9, bytesused=586798, skipping
stkwebcam: frame 12, bytesused=379780, skipping
stkwebcam: Frame buffer overflow, lost sync
stkwebcam: Frame buffer overflow, lost sync
stkwebcam: frame 13, bytesused=613382, skipping
ehci_hcd 0000:00:03.3: remove, state 1
usb usb2: USB disconnect, address 1
usb 2-4: USB disconnect, address 2
stkwebcam: Syntek USB2.0 Camera release resources video device /dev/video3
ehci_hcd 0000:00:03.3: USB bus 2 deregistered
ehci_hcd 0000:00:03.3: PCI INT D disabled
usb 1-2: new full speed USB device using ohci_hcd and address 6
usb 1-2: configuration #1 chosen from 1 choice
stkwebcam: Syntek USB2.0 Camera is now controlling video device /dev/video4
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
PGD 3ee2e067 PUD 2d1a5067 PMD 0 
Oops: 0002 [2] PREEMPT 
CPU 0 
Modules linked in: stkwebcam act_police sch_ingress cls_u32 sch_sfq sch_htb ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async nouveau drm ppdev lp ipv6 ppp_generic slhc option usbserial fuse ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables loop firewire_sbp2 usb_storage compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rfkill rng_core joydev mac80211 cfg80211 input_polldev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw k8temp r8169 bitrev video output battery ac sdhci_pci sdhci mmc_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer button firewire_ohci firewire_core snd crc_itu_t ssb ohci_hcd soundcore snd_page_alloc sg pcmcia sr_mod cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
Pid: 5303, comm: xawtv.bin Tainted: G      D   2.6.27-rc5-video0 #1
RIP: 0010:[<ffffffff80492aca>]  [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
RSP: 0018:ffff88002b161e70  EFLAGS: 00010202
RAX: ffff88002b161fd8 RBX: ffff880033e77d80 RCX: ffffffffa0213080
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff880033e77d80
RBP: ffff880033c045b0 R08: 0000000000000000 R09: ffff880001101040
R10: 0000000000000002 R11: 0000000000000000 R12: 00000000ffffffed
R13: ffff880033e77d88 R14: 00000000ffffffff R15: ffff880033e77d80
FS:  00007fc629032740(0000) GS:ffffffff805a8e80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000025af4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xawtv.bin (pid: 5303, threadinfo ffff88002b160000, task ffff880033c045b0)
Stack:  ffff880033e77d88 0000000000000000 ffff88002d173fc0 ffff88003f6af258
 0000000000000282 ffff88003e94d000 ffff880033e77888 00000000ffffffed
 ffff880033e77800 ffffffff804928b9 ffffffff803e548b 0000000000000100
Call Trace:
 [<ffffffff804928b9>] ? mutex_lock+0x9/0x10
 [<ffffffff803e548b>] ? usb_autopm_do_interface+0x4b/0x120
 [<ffffffffa021450d>] ? v4l_stk_release+0x1d/0x50 [stkwebcam]
 [<ffffffff802a0bc1>] ? __fput+0xa1/0x1c0
 [<ffffffff8029d7bb>] ? filp_close+0x5b/0x90
 [<ffffffff8029d8a1>] ? sys_close+0xb1/0x140
 [<ffffffff8020c37b>] ? system_call_fastpath+0x16/0x1b


Code: 8b 2c 25 00 00 00 00 65 48 8b 04 25 10 00 00 00 ff 80 48 e0 ff ff 48 8b 57 10 4c 8d 6f 08 48 89 63 10 4c 89 2c 24 48 89 54 24 08 <48> 89 22 48 c7 c2 ff ff ff ff 48 89 6c 24 10 48 89 d0 87 07 ff 
RIP  [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
 RSP <ffff88002b161e70>
CR2: 0000000000000000
---[ end trace bfdcde72f302e116 ]---
note: xawtv.bin[5303] exited with preempt_count 1
BUG: scheduling while atomic: xawtv.bin/5303/0x10000002
Modules linked in: stkwebcam act_police sch_ingress cls_u32 sch_sfq sch_htb ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async nouveau drm ppdev lp ipv6 ppp_generic slhc option usbserial fuse ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables loop firewire_sbp2 usb_storage compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rfkill rng_core joydev mac80211 cfg80211 input_polldev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw k8temp r8169 bitrev video output battery ac sdhci_pci sdhci mmc_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer button firewire_ohci firewire_core snd crc_itu_t ssb ohci_hcd soundcore snd_page_alloc sg pcmcia sr_mod cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
Pid: 5303, comm: xawtv.bin Tainted: G      D   2.6.27-rc5-video0 #1

Call Trace:
 [<ffffffff80491da0>] thread_return+0xd8/0x268
 [<ffffffff802b3be7>] d_kill+0x47/0x70
 [<ffffffff802b46d6>] dput+0xa6/0x210
 [<ffffffff8022c600>] __cond_resched+0x20/0x50
 [<ffffffff80491ff5>] _cond_resched+0x35/0x50
 [<ffffffff8023415a>] put_files_struct+0x7a/0xe0
 [<ffffffff80236299>] do_exit+0x789/0x970
 [<ffffffff80494574>] oops_end+0x74/0x80
 [<ffffffff804962bf>] do_page_fault+0x2df/0xa60
 [<ffffffff8040950e>] sock_aio_read+0x19e/0x1b0
 [<ffffffff80493fa9>] error_exit+0x0/0x51
 [<ffffffffa0213080>] stk_free_sio_buffers+0x110/0x160 [stkwebcam]
 [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
 [<ffffffff804928b9>] mutex_lock+0x9/0x10
 [<ffffffff803e548b>] usb_autopm_do_interface+0x4b/0x120
 [<ffffffffa021450d>] v4l_stk_release+0x1d/0x50 [stkwebcam]
 [<ffffffff802a0bc1>] __fput+0xa1/0x1c0
 [<ffffffff8029d7bb>] filp_close+0x5b/0x90
 [<ffffffff8029d8a1>] sys_close+0xb1/0x140
 [<ffffffff8020c37b>] system_call_fastpath+0x16/0x1b

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
PGD 2d2a0067 PUD 2d17e067 PMD 0 
Oops: 0002 [3] PREEMPT 
CPU 0 
Modules linked in: stkwebcam act_police sch_ingress cls_u32 sch_sfq sch_htb ppp_deflate zlib_deflate zlib_inflate bsd_comp ppp_async nouveau drm ppdev lp ipv6 ppp_generic slhc option usbserial fuse ipt_LOG ipt_recent nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables loop firewire_sbp2 usb_storage compat_ioctl32 videodev v4l1_compat arc4 ecb crypto_blkcipher cryptomgr crypto_algapi b43 rfkill rng_core joydev mac80211 cfg80211 input_polldev irtty_sir sir_dev irda crc_ccitt pcspkr psmouse serio_raw k8temp r8169 bitrev video output battery ac sdhci_pci sdhci mmc_core snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer button firewire_ohci firewire_core snd crc_itu_t ssb ohci_hcd soundcore snd_page_alloc sg pcmcia sr_mod cdrom crc32 ext3 jbd mbcache sd_mod [last unloaded: ehci_hcd]
Pid: 5177, comm: xawtv.bin Tainted: G      D   2.6.27-rc5-video0 #1
RIP: 0010:[<ffffffff80492aca>]  [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
RSP: 0018:ffff880026131e70  EFLAGS: 00010202
RAX: ffff880026131fd8 RBX: ffff88003fbc7d80 RCX: ffffffffa0213080
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff88003fbc7d80
RBP: ffff88002d1b9c70 R08: 0000000000000000 R09: ffff880001101040
R10: 0000000000000002 R11: 0000000000000000 R12: 00000000ffffffed
R13: ffff88003fbc7d88 R14: 00000000ffffffff R15: ffff88003fbc7d80
FS:  00007f1eb5e84740(0000) GS:ffffffff805a8e80(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000002d17b000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process xawtv.bin (pid: 5177, threadinfo ffff880026130000, task ffff88002d1b9c70)
Stack:  ffff88003fbc7d88 0000000000000000 ffff88003705c280 ffff88003c3e3578
 0000000000000282 ffff88003e951800 ffff88003fbc7888 00000000ffffffed
 ffff88003fbc7800 ffffffff804928b9 ffffffff803e548b 0000000000000100
Call Trace:
 [<ffffffff804928b9>] ? mutex_lock+0x9/0x10
 [<ffffffff803e548b>] ? usb_autopm_do_interface+0x4b/0x120
 [<ffffffffa021450d>] ? v4l_stk_release+0x1d/0x50 [stkwebcam]
 [<ffffffff802a0bc1>] ? __fput+0xa1/0x1c0
 [<ffffffff8029d7bb>] ? filp_close+0x5b/0x90
 [<ffffffff8029d8a1>] ? sys_close+0xb1/0x140
 [<ffffffff8020c37b>] ? system_call_fastpath+0x16/0x1b


Code: 8b 2c 25 00 00 00 00 65 48 8b 04 25 10 00 00 00 ff 80 48 e0 ff ff 48 8b 57 10 4c 8d 6f 08 48 89 63 10 4c 89 2c 24 48 89 54 24 08 <48> 89 22 48 c7 c2 ff ff ff ff 48 89 6c 24 10 48 89 d0 87 07 ff 
RIP  [<ffffffff80492aca>] __mutex_lock_slowpath+0x3a/0x100
 RSP <ffff880026131e70>
CR2: 0000000000000000
---[ end trace bfdcde72f302e116 ]---

The following patch seems to fix this crash. What do you think about it?

Regards.

>From 3f8ffca543dfb32b011888a7cd1659efb5036556 Mon Sep 17 00:00:00 2001
From: Jaime Velasco Juan <jsagarribay@gmail.com>
Date: Sun, 28 Sep 2008 16:19:54 +0100
Subject: [PATCH] stkwebcam: Check device is present before modifying autopm status

Signed-off-by: Jaime Velasco Juan <jsagarribay@gmail.com>
---
 drivers/media/video/stk-webcam.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index 5c62280..1a1b1d5 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -689,18 +689,14 @@ static int v4l_stk_release(struct inode *inode, struct file *fp)
 {
 	struct stk_camera *dev = fp->private_data;
 
-	if (dev->owner != fp) {
-		usb_autopm_put_interface(dev->interface);
-		return 0;
+	if (dev->owner == fp) {
+		stk_stop_stream(dev);
+		stk_free_buffers(dev);
+		dev->owner = NULL;
 	}
 
-	stk_stop_stream(dev);
-
-	stk_free_buffers(dev);
-
-	dev->owner = NULL;
-
-	usb_autopm_put_interface(dev->interface);
+	if (is_present(dev))
+		usb_autopm_put_interface(dev->interface);
 
 	return 0;
 }
-- 
1.5.6.5

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
