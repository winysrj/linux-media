Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2KHNCJL011138
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 13:23:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2KHMSir011439
	for <video4linux-list@redhat.com>; Thu, 20 Mar 2008 13:22:28 -0400
Date: Thu, 20 Mar 2008 14:22:12 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Bongani Hlope <bonganilinux@mweb.co.za>
Message-ID: <20080320142212.2361f6d8@gaivota>
In-Reply-To: <200803172351.56717.bonganilinux@mweb.co.za>
References: <200802171036.19619.bonganilinux@mweb.co.za>
	<20080226154102.GD30463@localhost>
	<20080227014238.GA2685@localhost>
	<200803172351.56717.bonganilinux@mweb.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc[12] Video4Linux Bttv Regression
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

On Mon, 17 Mar 2008 23:51:56 +0200
Bongani Hlope <bonganilinux@mweb.co.za> wrote:

> On Wednesday 27 February 2008 03:42:38 Robert Fitzsimons wrote:
> > > I think I might have seen this problem but it didn't cause a oops for
> > > me,
> >
> > Ok, I found the cause of the oops.  Some of radio tuner code was
> > expecting a struct bttv_fh to be allocated but this wasn't done in
> > radio_open.  So it would dereference an invalid data structure, causing
> > a hang for me and an oops for Bongani.  I also had to add support for
> > the radio tuner to some shared functions.  Patches to follow.
> >
> > Robert
> 
> More info... 
> 
> The Oops seems to be caused by a size mismatch that causes memset to write 
> over other variables in the stack... The following debug hack moved oops to 
> another point in the v4l1-compact code..
> 
> So memset(&tun2,0,sizeof(tun2))  seems to be overwriting btv->lock->wait_list:
> 
> --- drivers/media/video/v4l1-compat.c~  2007-11-13 10:25:52.000000000 +0200
> +++ drivers/media/video/v4l1-compat.c   2008-03-17 23:17:38.000000000 +0200
> @@ -688,7 +688,7 @@
>         {
>                 struct video_tuner      *tun = arg;
> 
> -               memset(&tun2,0,sizeof(tun2));
> +               memset(&tun2,-1,sizeof(tun2));
>                 err = drv(inode, file, VIDIOC_G_TUNER, &tun2);
>                 if (err < 0) {
>                         dprintk("VIDIOCGTUNER / VIDIOC_G_TUNER: %d\n",err);
> 
> The new oops, where there's another memset(&tun2,0,sizeof(tun2)):
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff8045a329>] __mutex_lock_slowpath+0x3b/0xb2
> PGD 699d9067 PUD 65837067 PMD 0
> Oops: 0002 [1] PREEMPT SMP
> CPU 1
> Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq 
> binfmt_misc loop nls_cp437 vfat fat nls_iso8859_1 ntfs thermal processor fan 
> container button pcspkr snd_pcm_oss snd_mixer_oss snd_emu10k1 tuner tea5767 
> tda8290 tuner_xc2028 tda9887 tuner_simple snd_rawmidi mt20xx snd_ac97_codec 
> tea5761 bttv ac97_bus snd_pcm ir_common firewire_ohci snd_seq_device 
> compat_ioctl32 firewire_core snd_timer uhci_hcd videodev ehci_hcd 
> snd_page_alloc v4l1_compat crc_itu_t snd_util_mem usbcore v4l2_common 
> snd_hwdep videobuf_dma_sg ohci1394 ide_cd_mod snd videobuf_core emu10k1_gp 
> ieee1394 sr_mod btcx_risc evdev gameport i2c_viapro tveeprom cdrom sg tg3 
> soundcore
> Pid: 4230, comm: radio Not tainted 2.6.25-rc5-dirty #46
> RIP: 0010:[<ffffffff8045a329>]  [<ffffffff8045a329>] 
> __mutex_lock_slowpath+0x3b/0xb2
> RSP: 0018:ffff8100658455e8  EFLAGS: 00010246
> RAX: ffff81007fbeff10 RBX: ffff81007fbeff08 RCX: 0000000000000000
> RDX: ffff8100658455e8 RSI: ffffffff8816711c RDI: ffff81007fbeff0c
> RBP: ffff810065845628 R08: ffffffff880e98df R09: 0000000000000002
> R10: ffff810065845f38 R11: 0000000000000246 R12: ffff81007fbeff0c
> R13: 0000000000000000 R14: ffff8100699d0d10 R15: ffffffff88167110
> FS:  00007f0c740e46f0(0000) GS:ffff81007fb6adc0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000065835000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process radio (pid: 4230, threadinfo ffff810065844000, task ffff8100699d0d10)
> Stack:  ffff81007fbeff10 ffff810065845774 0000000265845688 ffff810065845768
>  ffff81007fbef800 ffff810065845c68 0000000000000000 ffff81007fbeff08
>  ffff810065845638 ffffffff8045a16f ffff810065845668 ffffffff8814692f
> Call Trace:
>  [<ffffffff8045a16f>] mutex_lock+0xe/0x10
>  [<ffffffff8814692f>] :bttv:bttv_s_frequency+0x46/0x9f
>  [<ffffffff880ec583>] :videodev:__video_do_ioctl+0x2ca4/0x2e16
>  [<ffffffff8022b6fe>] ? hrtick_set+0xdf/0xe8
>  [<ffffffff8020a003>] ? default_idle+0x0/0x5f
>  [<ffffffff80459c51>] ? thread_return+0x6c/0xbf
>  [<ffffffff880d52a9>] :v4l1_compat:v4l_compat_translate_ioctl+0x1116/0x1b01
>  [<ffffffff802ff5bb>] ? generic_unplug_device+0x2c/0x30
>  [<ffffffff880e98df>] ? :videodev:__video_do_ioctl+0x0/0x2e16
>  [<ffffffff80266946>] ? mark_page_accessed+0x20/0x36
>  [<ffffffff802a57af>] ? __find_get_block+0x153/0x165
>  [<ffffffff802a57e1>] ? __getblk+0x20/0x22b
>  [<ffffffff803021ff>] ? blk_recount_segments+0x3e/0x68
>  [<ffffffff80260795>] ? mempool_alloc+0x48/0xf9
>  [<ffffffff8028073b>] ? cache_alloc_refill+0x1cc/0x233
>  [<ffffffff80302a5a>] ? blk_rq_map_sg+0x12b/0x24b
>  [<ffffffff80238971>] ? lock_timer_base+0x26/0x4a
>  [<ffffffff8038df34>] ? dma_timer_expiry+0x0/0x6d
>  [<ffffffff80238b1c>] ? __mod_timer+0xc4/0xd6
>  [<ffffffff80311a3b>] ? __delay+0x27/0x59
>  [<ffffffff80311a3b>] ? __delay+0x27/0x59
>  [<ffffffff80311a3b>] ? __delay+0x27/0x59
>  [<ffffffff80311a3b>] ? __delay+0x27/0x59
>  [<ffffffff80311a3b>] ? __delay+0x27/0x59
>  [<ffffffff80311aef>] ? __udelay+0x40/0x42
>  [<ffffffff803c1ba4>] ? i2c_stop+0x47/0x4b
>  [<ffffffff803c236b>] ? bit_xfer+0x412/0x423
>  [<ffffffff803c01ed>] ? i2c_transfer+0x79/0x85
>  [<ffffffff881a3318>] ? :tuner_simple:simple_set_params+0x2b9/0xc18
>  [<ffffffff8022589b>] ? enqueue_task_fair+0x179/0x186
>  [<ffffffff80227ff2>] ? task_rq_lock+0x3d/0x73
>  [<ffffffff802284b9>] ? try_to_wake_up+0x1ae/0x1bf
>  [<ffffffff8021a49d>] ? smp_send_reschedule+0x1d/0x1f
>  [<ffffffff802284d7>] ? default_wake_function+0xd/0xf
>  [<ffffffff802246cc>] ? __wake_up_common+0x46/0x75
>  [<ffffffff880e9a18>] :videodev:__video_do_ioctl+0x139/0x2e16
>  [<ffffffff80357b8c>] ? n_tty_receive_buf+0xf18/0xf77
>  [<ffffffff80260449>] ? filemap_fault+0x1fe/0x371
>  [<ffffffff880eca95>] :videodev:video_ioctl2+0x1b8/0x259
>  [<ffffffff802426de>] ? remove_wait_queue+0x3c/0x41
>  [<ffffffff80226ea2>] ? __wake_up+0x43/0x4f
>  [<ffffffff80291252>] vfs_ioctl+0x5e/0x77
>  [<ffffffff802914b8>] do_vfs_ioctl+0x24d/0x262
>  [<ffffffff8029150f>] sys_ioctl+0x42/0x67
>  [<ffffffff802862af>] ? sys_write+0x47/0x70
>  [<ffffffff8020b32b>] system_call_after_swapgs+0x7b/0x80
> 
> 
> Code: 89 fb 4c 89 e7 48 83 ec 20 65 4c 8b 34 25 00 00 00 00 e8 e5 0f 00 00 48 
> 8d 43 08 48 8d 55 c0 48 8b 48 08 48 89 45 c0 48 89 50 08 <48> 89 11 48 83 ca 
> ff 48 89 4d c8 4c 89 75 d0 48 89 d0 87 03 ff
> RIP  [<ffffffff8045a329>] __mutex_lock_slowpath+0x3b/0xb2
>  RSP <ffff8100658455e8>
> CR2: 0000000000000000
> ---[ end trace 821f8e64b81db17b ]---

Could you please test this small patch?

diff -r 134d43b48b4a linux/drivers/media/video/bt8xx/bttv-driver.c
--- a/linux/drivers/media/video/bt8xx/bttv-driver.c	Tue Mar 18 23:46:37 2008 +0000
+++ b/linux/drivers/media/video/bt8xx/bttv-driver.c	Thu Mar 20 14:20:54 2008 -0300
@@ -3288,6 +3288,7 @@ static int bttv_open(struct inode *inode
 		return -ENOMEM;
 	file->private_data = fh;
 	*fh = btv->init;
+	fh->btv = btv;
 	fh->type = type;
 	fh->ov.setup_ok = 0;
 	v4l2_prio_open(&btv->prio,&fh->prio);


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
