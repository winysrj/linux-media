Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:59130 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935573Ab3DIKSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 06:18:35 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: Andy Walls <awalls@md.metrocast.net>
Subject: cx18 list corruption and related problems
Date: Tue, 09 Apr 2013 10:50:20 +0100
Message-ID: <1450190.lkntI0Udds@deuteros>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Andy, all,

Were there any known problems in the cx18 locking department regarding video 
buffers or mailbox handling fixed sometime between 3.5.0 and today?

We are seeing some issues there (on a flavour of 3.5.0) and I just wanted to 
quickly check here before diving in the code. I'll paste below some of the 
problems we are seeing.

 cx18-0: Skipped encoder PCM audio, MDL 223, 62 times - it must have dropped 
out of rotation

 cx18-0: Could not find MDL 358 for stream encoder PCM audio
 cx18-0: Skipped encoder PCM audio, MDL 357, 62 times - it must have dropped 
out of rotation
 cx18-0: Could not find MDL 218 for stream encoder PCM audio
 cx18-0: Skipped encoder PCM audio, MDL 217, 62 times - it must have dropped 
out of rotation

 ------------[ cut here ]------------
 WARNING: at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
 Hardware name:         
 list_del corruption. prev->next should be ffff8800371d1d40, but was 
dead000000100100
 Modules linked in: tun dummy ip6t_REJECT snd_dummy w83627ehf hwmon_vid 
cx18_alsa mxl5005s s5h1409 tuner_simple tuner_types cs5345 tda9887 tda8290 
tuner snd_hda_codec_realtek snd_hda_intel snd_hda_codec cx18 coretemp 
snd_hwdep dvb_core cx2341x snd_seq videobuf_vmalloc videobuf_core 
snd_seq_device ppdev tveeprom v4l2_common snd_pcm videodev parport_pc media 
parport snd_timer snd soundcore lpc_ich i2c_i801 mfd_core r8169 snd_page_alloc 
mii ftdi_sio serio_raw microcode i915 drm_kms_helper drm i2c_algo_bit i2c_core 
video [last unloaded: nf_conntrack]
 Pid: 5562, comm: player_movie Tainted: G        W    3.5.0-93.fc16.x86_64 #1
 Call Trace:
  [<ffffffff8105927f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81059376>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff812e4f81>] __list_del_entry+0xa1/0xd0
  [<ffffffff812e4fc1>] list_del+0x11/0x40
  [<ffffffffa01cd4b6>] videobuf_queue_cancel+0x66/0x100 [videobuf_core]
  [<ffffffffa01ce4ee>] videobuf_streamoff+0x2e/0x70 [videobuf_core]
  [<ffffffffa0221672>] cx18_streamoff+0x52/0x70 [cx18]
  [<ffffffffa01806e7>] __video_do_ioctl+0x2507/0x5350 [videodev]
  [<ffffffff8109132f>] ? wakeup_preempt_entity+0x4f/0x60
  [<ffffffff8108b1a4>] ? check_preempt_curr+0x84/0xa0
  [<ffffffff8109132f>] ? wakeup_preempt_entity+0x4f/0x60
  [<ffffffff8108b1fd>] ? ttwu_do_wakeup+0x3d/0x120
  [<ffffffffa017dd70>] video_usercopy+0x120/0x570 [videodev]
  [<ffffffffa017e1e0>] ? video_ioctl2+0x20/0x20 [videodev]
  [<ffffffff8108e940>] ? wake_up_state+0x10/0x20
  [<ffffffff810b11ab>] ? wake_futex+0x3b/0x60
  [<ffffffff810b1d10>] ? futex_wake+0x100/0x120
  [<ffffffffa017e1d5>] video_ioctl2+0x15/0x20 [videodev]
  [<ffffffffa02221ce>] cx18_v4l2_ioctl+0x6e/0xa0 [cx18]
  [<ffffffffa017c783>] v4l2_ioctl+0x113/0x1c0 [videodev]
  [<ffffffff81092a1d>] ? set_next_entity+0x9d/0xb0
  [<ffffffff81198a88>] do_vfs_ioctl+0x98/0x550
  [<ffffffff8160f8d4>] ? __schedule+0x3c4/0x7c0
  [<ffffffff810b3c7a>] ? sys_futex+0x10a/0x1a0
  [<ffffffff81198fd1>] sys_ioctl+0x91/0xa0
  [<ffffffff81619129>] system_call_fastpath+0x16/0x1b
 ---[ end trace 8e1185c5fb30e531 ]---

 ------------[ cut here ]------------
 WARNING: at lib/list_debug.c:33 __list_add+0xc8/0xd0()
 Hardware name:         
 list_add corruption. prev->next should be next (ffff88007af48c70), but was           
(null). (prev=ffff880064dc6d40).
 Modules linked in: tun dummy ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter 
ip6_tables snd_dummy w83627ehf hwmon_vid cx18_alsa mxl5005s s5h1409 
tuner_simple tuner_types cs5345 tda9887 tda8290 tuner snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec cx18 coretemp snd_hwdep dvb_core cx2341x snd_seq 
videobuf_vmalloc videobuf_core snd_seq_device ppdev tveeprom v4l2_common 
snd_pcm videodev parport_pc media parport snd_timer snd soundcore lpc_ich 
i2c_i801 mfd_core r8169 snd_page_alloc mii ftdi_sio serio_raw microcode i915 
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
 Pid: 5562, comm: player_movie Tainted: G        W    3.5.0-93.fc16.x86_64 #1
 Call Trace:
  [<ffffffff8105927f>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff81059376>] warn_slowpath_fmt+0x46/0x50
  [<ffffffff812e50b8>] __list_add+0xc8/0xd0
  [<ffffffffa021c971>] buffer_queue+0x31/0x40 [cx18]
  [<ffffffffa01ce456>] videobuf_streamon+0xb6/0x120 [videobuf_core]
  [<ffffffffa0221722>] cx18_streamon+0x92/0xb0 [cx18]
  [<ffffffffa018070c>] __video_do_ioctl+0x252c/0x5350 [videodev]
  [<ffffffffa01d8658>] ? __videobuf_mmap_mapper+0x118/0xac0 [videobuf_vmalloc]
  [<ffffffff812d471b>] ? prio_tree_insert+0x12b/0x230
  [<ffffffffa017dd70>] video_usercopy+0x120/0x570 [videodev]
  [<ffffffffa017e1e0>] ? video_ioctl2+0x20/0x20 [videodev]
  [<ffffffffa017e1d5>] video_ioctl2+0x15/0x20 [videodev]
  [<ffffffffa02221ce>] cx18_v4l2_ioctl+0x6e/0xa0 [cx18]
  [<ffffffffa017c783>] v4l2_ioctl+0x113/0x1c0 [videodev]
  [<ffffffff81198a88>] do_vfs_ioctl+0x98/0x550
  [<ffffffff81198fd1>] sys_ioctl+0x91/0xa0
  [<ffffffff81619129>] system_call_fastpath+0x16/0x1b
 ---[ end trace 8e1185c5fb30e529 ]---


Regards,

Tvrtko


