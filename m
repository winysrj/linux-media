Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53022 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1HUXI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Aug 2011 19:08:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Dickinson <daniel@cshore.neomailbox.net>
Subject: Re: [regression] uvcvideo: BUG at drivers/media/media-entity.c:346 for compaq presario cq56 (laptop) built-in webcam
Date: Mon, 22 Aug 2011 01:08:31 +0200
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-media@vger.kernel.org,
	637740@bugs.debian.org
References: <20110813235448.7243.32451.reportbug@henryj.momlan> <201108162051.32675.laurent.pinchart@ideasonboard.com> <cmu-lmtpd-26994-1313805139-0@perceval>
In-Reply-To: <cmu-lmtpd-26994-1313805139-0@perceval>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220108.31471.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Saturday 20 August 2011 03:52:10 Daniel Dickinson wrote:
> Requested output below:
> 
> On Tue, 16 Aug 2011 20:51:32 +0200 Laurent Pinchart wrote:
> > On Sunday 14 August 2011 18:31:31 Jonathan Nieder wrote:
> > > Daniel Dickinson wrote[1]:
> > > > New in 3.0.0:
> > > > 
> > > > webcam oopses and then spams syslog.  Didn't happen in .39 so is a
> > > > regression.
> > > > 
> > > > uvcvideo: Found UVC 1.00 device HP Webcam-101 (0bda:58e0)
> > > > 
> > > > From syslog:
> > > > 
> > > > [  428.117889] Linux video capture interface: v2.00
> > > > [  428.161164] uvcvideo: Found UVC 1.00 device HP Webcam-101
> > > > (0bda:58e0) [  428.167520] ------------[ cut here ]------------
> > > > [  428.167562] kernel BUG at
> > > > [...]/drivers/media/media-entity.c:346! [  428.167605] invalid
> > > > opcode: 0000 [#1] SMP [  428.167705] CPU 1
> > > > [  428.167739] Modules linked in: uvcvideo(+) snd_seq_midi joydev
> > > > videodev media v4l2_compat_ioctl32 snd_rawmidi snd_seq_midi_event
> > > > snd_seq arc4 snd_timer snd_seq_device ath9k radeon(+) mac80211
> > > > ath9k_common ath9k_hw ttm ath drm_kms_helper drm snd hp_wmi
> > > > cfg80211 sparse_keymap sp5100_tco edac_core soundcore rfkill
> > > > i2c_algo_bit evdev snd_page_alloc edac_mce_amd psmouse k10temp
> > > > shpchp i2c_piix4 serio_raw ac battery video i2c_core power_supply
> > > > pci_hotplug pcspkr wmi button processor ext4 mbcache jbd2 crc16
> > > > sha256_generic cryptd aes_x86_64 aes_generic cbc dm_crypt dm_mod
> > > > raid10 raid456 async_raid6_recov async_pq raid6_pq async_xor xor
> > > > async_memcpy async_tx raid1 raid0 multipath linear md_mod usbhid
> > > > hid sg sr_mod sd_mod cdrom crc_t10dif ohci_hcd thermal
> > > > thermal_sys ahci libahci r8169 ehci_hcd mii libata scsi_mod
> > > > usbcore [last unloaded: scsi_wait_scan] [  428.170836]
> > > > [  428.170872] Pid: 659, comm: modprobe Not tainted 3.0.0-1-amd64
> > > > #1 Hewlett-Packard Presario CQ56 Notebook PC/1604 [  428.171010]
> > > > RIP: 0010:[<ffffffffa04d0d18>]  [<ffffffffa04d0d18>]
> > > > media_entity_create_link+0x2c/0xd4 [media] [  428.171088] RSP:
> > > > 0018:ffff8801093c5c28  EFLAGS: 00010246 [  428.171125] RAX:
> > > > ffff88010861f800 RBX: ffff88010861f870 RCX: 0000000000000000
> > > > [  428.171163] RDX: ffff880108603870 RSI: 0000000000000000 RDI:
> > > > ffff88010861f870 [  428.171201] RBP: ffff880108603870 R08:
> > > > 0000000000000003 R09: ffffffff81756440 [ 428.171238] R10:
> > > > 0000000000012800 R11: 0000000000015670 R12: 0000000000000000
> > > > [  428.171276] R13: ffff880108603870 R14: 0000000000000000 R15:
> > > > 0000000000000000 [  428.171315] FS: 00007f6831cb3700(0000)
> > > > GS:ffff88010fc80000(0000) knlGS:0000000000000000 [  428.171355]
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b [ 428.171360]
> > > > CR2: 0000000001858008 CR3: 0000000109eaa000 CR4: 00000000000006e0
> > > > [  428.171360] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000 [  428.171360] DR3: 0000000000000000 DR6:
> > > > 00000000ffff0ff0 DR7: 0000000000000400 [ 428.171360] Process
> > > > modprobe (pid: 659, threadinfo ffff8801093c4000, task
> > > > ffff880107a70300) [  428.171360] Stack: [  428.171360]
> > > > 0000000000000002 0000000000000002 0000000000000000
> > > > ffff880108603800 [  428.171360]  ffff88010a0eac40
> > > > 0000000000000000 ffff880108603870 ffff88010a0eac58
> > > > [  428.171360]  0000000000000000 ffffffffa04fefb1
> > > > ffff8801099c1408 ffff88010a0eac48 [  428.171360] Call Trace:
> > > > [  428.171360]  [<ffffffffa04fefb1>] ?
> > > > uvc_mc_register_entities+0x160/0x1eb [uvcvideo] [  428.171360]
> > > > [<ffffffffa04f9793>] ? uvc_probe+0x1ee7/0x1f18 [uvcvideo]
> > > > [  428.171360] [<ffffffffa006c79d>] ?
> > > > usb_probe_interface+0xfc/0x16f [usbcore] [ 428.171360]
> > > > [<ffffffff81249a37>] ? driver_probe_device+0xb2/0x142
> > > > [ 428.171360]  [<ffffffff81249b16>] ? __driver_attach+0x4f/0x6f
> > > > [ 428.171360]  [<ffffffff81249ac7>] ?
> > > > driver_probe_device+0x142/0x142 [ 428.171360]
> > > > [<ffffffff81248d22>] ? bus_for_each_dev+0x47/0x72 [ 428.171360]
> > > > [<ffffffff812493a9>] ? bus_add_driver+0xa2/0x1f2 [ 428.171360]
> > > > [<ffffffff81249fb0>] ? driver_register+0x8d/0xf5 [ 428.171360]
> > > > [<ffffffffa006ba66>] ? usb_register_driver+0x80/0x128 [usbcore]
> > > > [  428.171360]  [<ffffffffa0508000>] ? 0xffffffffa0507fff
> > > > [  428.171360]  [<ffffffffa050801b>] ? uvc_init+0x1b/0x1000
> > > > [uvcvideo] [  428.171360]  [<ffffffff81002172>] ?
> > > > do_one_initcall+0x78/0x132 [  428.171360]  [<ffffffff81076703>] ?
> > > > sys_init_module+0xbc/0x245 [  428.171360]  [<ffffffff8133ba92>] ?
> > > > system_call_fastpath+0x16/0x1b [  428.171360] Code: 57 41 89 cf
> > > > 41 56 41 89 f6 41 55 41 54 55 48 89 d5 53 48 89 fb 48 83 ec 18 48
> > > > 85 d2 74 05 48 85 ff 75 02 0f 0b 66 3b 77 3c 72 02 <0f> 0b 66 3b
> > > > 4a 3c 72 02 0f 0b 44 89 44 24 08 41 bd f4 ff ff ff [ 428.171360]
> > > > RIP  [<ffffffffa04d0d18>] media_entity_create_link+0x2c/0xd4
> > > > [media] [  428.171360]  RSP <ffff8801093c5c28> [  428.175002]
> > > > ---[ end trace 3db524e10ad1aec0 ]---
> > > > 
> > > > and then:
> > > > 
> > > > udevd[420]: timeout: killing 'usb_id --export
> > > > /devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/video4linux/video0'
> > > > [712]
> > > 
> > > Known problem?  Any hints for tracking it down?
> > 
> > No it's not a know issue. I've answered (or at least tried to answer)
> > the original bug report. Daniel, could you please send me the output
> > of
> > 
> > lsusb -v -d 0bda:58e0
> > 
> > (running as root if possible) ?
> 
> On .39 I get the output below.  On 3.0.0, the lsusb process hangs.
> lsusb -v with no device shows other devices, but hangs on this one.
> Also, no other usb devices work in 3.0.0 (e.g. no USB mouse)
> 
> P.S. Thanks for the *fast* response (Jonathan thought he was slow to
> respond).  This isn't a critical system for me, and I can back down to
> a previous version, so it's not crunch (in fact because it's for my
> mother I'm thinking of tring Squeeze with only an updated alsa libs
> (apparently the version of alsa in squeeze doesn't work with at least
> some intel hda sound which is why I was experiment with wheezy for her
> in the first place), for the stability.
> 
> Bus 001 Device 002: ID 0bda:58e0 Realtek Semiconductor Corp.

[snip]

Thanks for the information. There's something unexpected in the descriptors,
but that shouldn't a crash. Could you please try the following test patch on top of v3.0 ?
It will print debugging messages to the kernel log which should help me to
identify the root cause of the kernel oops.

diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
index 48fea37..0b8b547 100644
--- a/drivers/media/video/uvc/uvc_entity.c
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -56,6 +56,11 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 			continue;
 
 		remote_pad = remote->num_pads - 1;
+		printk(KERN_INFO "connecting %s(%u):%u(/%u) to %s(%u):%u(/%u)\n",
+			source ? source->name : "NULL", source ? source->id : 0,
+			remote_pad, source ? source->num_pads : 0,
+			sink ? sink->name : "NULL", sink ? sink->id : 0,
+			i, sink ? sink->num_pads : 0);
 		ret = media_entity_create_link(source, remote_pad,
 					       sink, i, flags);
 		if (ret < 0)

-- 
Regards,

Laurent Pinchart
