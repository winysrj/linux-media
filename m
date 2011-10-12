Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:36214 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab1JLV7p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Oct 2011 17:59:45 -0400
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-media@vger.kernel.org
Cc: Antonio Ospite <ospite@studenti.unina.it>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] videodev: fix a NULL pointer dereference in v4l2_device_release()
Date: Wed, 12 Oct 2011 23:59:26 +0200
Message-Id: <1318456766-4165-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The change in 8280b66 does not cover the case when v4l2_dev is already
NULL, fix that.

With a Kinect sensor, seen as an USB camera using GSPCA in this context,
a NULL pointer dereference BUG can be triggered by just unplugging the
device after the camera driver has been loaded.

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
---
Hi,

can anyone reproduce this?

This is the complete trace, I left it out of the commit message, but feel free 
to include it if you think it is worth it.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
IP: [<ffffffffa10cc604>] v4l2_device_release+0xb8/0xe8 [videodev]
PGD 0 
Oops: 0000 [#1] SMP 
CPU 0 
Modules linked in: snd_usb_audio snd_usbmidi_lib gspca_kinect gspca_main 
videodev media v4l2_compat_ioctl32 hidp snd_hrtimer ebtable_nat ebtables 
powernow_k8 mperf cpufreq_powersave cpufreq_conservative cpufreq_stats 
cpufreq_userspace ipt_MASQUERADE xt_CHECKSUM bridge stp ppdev lp bnep rfcomm 
tun sit tunnel4 ip6table_raw ip6table_mangle ip6t_REJECT ip6t_LOG 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_rt ip6table_filter ip6_tables decnet 
binfmt_misc uinput fuse xt_tcpudp ipt_REJECT ipt_ULOG xt_limit xt_state 
xt_multiport iptable_filter iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack 
nf_defrag_ipv4 iptable_mangle iptable_raw ip_tables x_tables nfsd nfs lockd 
fscache auth_rpcgss nfs_acl sunrpc it87 hwmon_vid loop kvm_amd kvm 
snd_hda_codec_hdmi snd_hda_codec_via nvidia(P) snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_midi snd_rawmidi cryptd 
aes_x86_64 snd_seq_midi_event aes_generic ecb snd_seq btusb bluetooth evdev 
snd_timer snd_seq_device edac_core parport_pc pcspkr parport rfkill snd 
edac_mce_amd k8temp crc16 soundcore mxm_wmi snd_page_alloc asus_atk0110 shpchp 
video pci_hotplug i2c_nforce2 wmi i2c_core processor thermal_sys button ext3 
jbd mbcache dm_mod sg sd_mod sr_mod crc_t10dif cdrom ata_generic usb_storage 
usbhid hid uas ahci libahci pata_amd libata scsi_mod forcedeth floppy ohci_hcd 
ehci_hcd usbcore [last unloaded: scsi_wait_scan]

Pid: 125, comm: khubd Tainted: P            3.1.0-rc9-ao2 #3 System manufacturer System Product Name/M3N78-VM
RIP: 0010:[<ffffffffa10cc604>]  [<ffffffffa10cc604>] v4l2_device_release+0xb8/0xe8 [videodev]
RSP: 0018:ffff88011639fc10  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8800ca61a088 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffffffa10db000
RBP: 0000000000000000 R08: ffffffff8119b320 R09: ffffffff8119b320
R10: 0000000000000001 R11: 0000000000000001 R12: ffff8800ca61a000
R13: ffffffff8164ffb0 R14: 0000000000000000 R15: 000000000000001f
FS:  00007f61275f37a0(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000090 CR3: 00000001150de000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process khubd (pid: 125, threadinfo ffff88011639e000, task ffff88011639d590)
Stack:
 ffff8800ca5d8380 ffff8800ca61a098 ffff8800ca66c200 ffffffff81232e94
 ffff8800ca61a0d0 ffffffff8119a7fa ffffffff8119b320 ffff8800ca61a0d0
 ffffffff8119a7ab ffff8800ca56dc00 ffffffffa10e1068 ffffffff8119b93a
Call Trace:
 [<ffffffff81232e94>] ? device_release+0x41/0x72
 [<ffffffff8119a7fa>] ? kobject_release+0x4f/0x6c
 [<ffffffff8119b320>] ? add_uevent_var+0xdc/0xdc
 [<ffffffff8119a7ab>] ? kobject_del+0x2d/0x2d
 [<ffffffff8119b93a>] ? kref_put+0x3e/0x47
 [<ffffffffa0039f15>] ? usb_unbind_interface+0x4d/0x111 [usbcore]
 [<ffffffff81235b9b>] ? __device_release_driver+0x7d/0xc9
 [<ffffffff81235c02>] ? device_release_driver+0x1b/0x27
 [<ffffffff81235804>] ? bus_remove_device+0x7c/0x8b
 [<ffffffff812337e6>] ? device_del+0x129/0x177
 [<ffffffffa00384f7>] ? usb_disable_device+0x6a/0x159 [usbcore]
 [<ffffffffa003250c>] ? usb_disconnect+0x8c/0x108 [usbcore]
 [<ffffffffa00324ed>] ? usb_disconnect+0x6d/0x108 [usbcore]
 [<ffffffffa0033bc5>] ? hub_thread+0x58e/0xec6 [usbcore]
 [<ffffffff81036e08>] ? set_next_entity+0x32/0x52
 [<ffffffff8105ec53>] ? add_wait_queue+0x3c/0x3c
 [<ffffffffa0033637>] ? usb_remote_wakeup+0x2f/0x2f [usbcore]
 [<ffffffff8105e60d>] ? kthread+0x76/0x7e
 [<ffffffff81332f34>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff8105e597>] ? kthread_worker_fn+0x139/0x139
 [<ffffffff81332f30>] ? gs_change+0x13/0x13
Code: 0d a1 e8 7a ec 25 e0 48 8b 83 78 02 00 00 48 85 c0 74 18 48 83 78 08 00 74 11 83 bb b0 02 00 00 03 74 08 4c 89 e7 e8 03 5a ff ff 
 83 bd 90 00 00 00 00 b8 00 00 00 00 4c 89 e7 48 0f 44 e8 ff 
RIP  [<ffffffffa10cc604>] v4l2_device_release+0xb8/0xe8 [videodev]
 RSP <ffff88011639fc10>
CR2: 0000000000000090
---[ end trace 99f7feddc91f30d6 ]---

Thanks,
   Antonio Ospite
   http://ao2.it

 drivers/media/video/v4l2-dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index d721565..a5c9ed1 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -181,7 +181,7 @@ static void v4l2_device_release(struct device *cd)
 	 * TODO: In the long run all drivers that use v4l2_device should use the
 	 * v4l2_device release callback. This check will then be unnecessary.
 	 */
-	if (v4l2_dev->release == NULL)
+	if (v4l2_dev && v4l2_dev->release == NULL)
 		v4l2_dev = NULL;
 
 	/* Release video_device and perform other
-- 
1.7.7

