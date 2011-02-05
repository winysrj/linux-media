Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28572 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752536Ab1BEVZB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Feb 2011 16:25:01 -0500
Subject: Re: cx25840: probe crashes for cx25837 chip on 2.6.37
From: Andy Walls <awalls@md.metrocast.net>
To: Sven Barth <pascaldragon@googlemail.com>
Cc: LMML <linux-media@vger.kernel.org>
In-Reply-To: <4D4D7088.5080903@googlemail.com>
References: <4D4D7088.5080903@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Feb 2011 16:25:01 -0500
Message-ID: <1296941101.2429.80.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2011-02-05 at 16:45 +0100, Sven Barth wrote:
> Hello together!
> 
> I was eager to test my patch for cx25840 that was included in 2.6.37, so 
> I've updated my system and plugged in my Grabster AV400. But this 
> resulted in a "kernel bug" printed to dmesg:
> 
> ==== dmesg begin ====
> 
> usb 1-5: new high speed USB device using ehci_hcd and address 6
> Linux video capture interface: v2.00
> pvrusb2: Hardware description: Terratec Grabster AV400
> pvrusb2: **********
> pvrusb2: WARNING: Support for this device (Terratec Grabster AV400) is 
> experimental.
> pvrusb2: Important functionality might not be entirely working.
> pvrusb2: Please consider contacting the driver author to help with 
> further stabilization of the driver.
> pvrusb2: **********
> usb 1-5: USB disconnect, address 6
> usbcore: registered new interface driver pvrusb2
> pvrusb2: 20110116 (from www.isely.net):Hauppauge WinTV-PVR-USB2 MPEG2 
> Encoder/Tuner
> pvrusb2: Debug mask is 31 (0x1f)
> pvrusb2: Failed to submit write-control URB status=-19
> pvrusb2: Device being rendered inoperable
> pvrusb2: ***WARNING*** pvrusb2 device hardware appears to be jammed and 
> I can't clear it.
> pvrusb2: You might need to power cycle the pvrusb2 device in order to 
> recover.
> usb 1-5: new high speed USB device using ehci_hcd and address 7
> pvrusb2: Hardware description: Terratec Grabster AV400
> pvrusb2: **********
> pvrusb2: WARNING: Support for this device (Terratec Grabster AV400) is 
> experimental.
> pvrusb2: Important functionality might not be entirely working.
> pvrusb2: Please consider contacting the driver author to help with 
> further stabilization of the driver.
> pvrusb2: **********
> cx25840 6-0044: cx25837-3 found @ 0x88 (pvrusb2_a)
> ------------[ cut here ]------------
> kernel BUG at drivers/media/video/v4l2-ctrls.c:1143!
> invalid opcode: 0000 [#1] PREEMPT SMP
> last sysfs file: 
> /sys/devices/pci0000:00/0000:00:02.2/usb1/1-5/i2c-6/6-0044/uevent
> CPU 1
> Modules linked in: cx25840 pvrusb2 dvb_core cx2341x v4l2_common videodev 
> v4l1_compat v4l2_compat_ioctl32 tveeprom ipv6 xfs exportfs ext2 radeon 
> snd_emu10k1 snd_intel8x0 ohci_hcd snd_rawmidi snd_ac97_codec ttm 
> drm_kms_helper ac97_bus snd_seq_dummy skge ehci_hcd snd_seq_oss 
> snd_seq_midi_event snd_seq snd_util_mem snd_seq_device snd_pcm_oss 
> snd_hwdep snd_mixer_oss snd_pcm snd_timer emu10k1_gp drm i2c_algo_bit 
> shpchp snd i2c_nforce2 soundcore usbcore processor pci_hotplug i2c_core 
> parport_pc snd_page_alloc floppy serio_raw button psmouse ns558 
> edac_core ppdev k8temp edac_mce_amd evdev sg analog lp gameport pcspkr 
> parport ext4 mbcache jbd2 crc16 sd_mod sr_mod cdrom sata_nv pata_acpi 
> sata_sil24 pata_amd libata scsi_mod raid1 md_mod
> 
> Pid: 2184, comm: pvrusb2-context Not tainted 2.6.37-ARCH #1 nForce/
> RIP: 0010:[<ffffffffa020b352>]  [<ffffffffa020b352>] 
> v4l2_ctrl_cluster+0x32/0x40 [videodev]
> RSP: 0018:ffff880033c61a30  EFLAGS: 00010246
> RAX: 0000000000000001 RBX: ffff880038065800 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffff880039de1ee0 RDI: 0000000000000002
> RBP: ffff880033c61a30 R08: 2222222222222222 R09: 2222222222222222
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880039de1e78
> R13: 0000000000008373 R14: ffff880039de1e00 R15: 00000000000000ed
> FS:  00007f05b98a8700(0000) GS:ffff88003fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 00007fff6c8c5fe0 CR3: 000000003c89b000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process pvrusb2-context (pid: 2184, threadinfo ffff880033c60000, task 
> ffff88003f8ada30)
> Stack:
>   ffff880033c61aa0 ffffffffa0310b99 ffff880000000000 ffff88003c99e3fc
>   ffff880033c61ab0 ffffffff00000000 0000000000000200 ffff880039de1e08
>   ffff880033c61ac0 ffff880038065828 ffffffffa0318590 ffffffffa0318540
> Call Trace:
>   [<ffffffffa0310b99>] cx25840_probe+0x479/0x840 [cx25840]
>   [<ffffffffa0308694>] i2c_device_probe+0x94/0xd0 [i2c_core]
>   [<ffffffff812b0f0a>] ? driver_sysfs_add+0x7a/0xb0
>   [<ffffffff812b11e6>] driver_probe_device+0x96/0x1c0
>   [<ffffffff812b13b0>] ? __device_attach+0x0/0x60
>   [<ffffffff812b13fb>] __device_attach+0x4b/0x60
>   [<ffffffff812afdd4>] bus_for_each_drv+0x64/0x90
>   [<ffffffff812b107f>] device_attach+0x8f/0xb0
>   [<ffffffff812b0805>] bus_probe_device+0x25/0x40
>   [<ffffffff812ae574>] device_add+0x4e4/0x5c0
>   [<ffffffff812ba941>] ? pm_runtime_init+0xd1/0xe0
>   [<ffffffff812ae669>] device_register+0x19/0x20
>   [<ffffffffa03091d5>] i2c_new_device+0x145/0x250 [i2c_core]
>   [<ffffffffa00b77b6>] v4l2_i2c_new_subdev_board+0x96/0x240 [v4l2_common]
>   [<ffffffffa00b79e3>] v4l2_i2c_new_subdev_cfg+0x83/0xb0 [v4l2_common]
>   [<ffffffffa0363760>] ? pvr2_context_notify+0x0/0x10 [pvrusb2]
>   [<ffffffffa0363760>] ? pvr2_context_notify+0x0/0x10 [pvrusb2]
>   [<ffffffffa035b606>] pvr2_hdw_initialize+0x346/0x1060 [pvrusb2]
>   [<ffffffffa036394b>] pvr2_context_thread_func+0x9b/0x320 [pvrusb2]
>   [<ffffffffa03638b0>] ? pvr2_context_thread_func+0x0/0x320 [pvrusb2]
>   [<ffffffff81077db0>] ? autoremove_wake_function+0x0/0x40
>   [<ffffffff813a6dc2>] ? _raw_spin_unlock_irqrestore+0x32/0x40
>   [<ffffffffa03638b0>] ? pvr2_context_thread_func+0x0/0x320 [pvrusb2]
>   [<ffffffff81077826>] kthread+0x96/0xa0
>   [<ffffffff8100cd24>] kernel_thread_helper+0x4/0x10
>   [<ffffffff81077790>] ? kthread+0x0/0xa0
>   [<ffffffff8100cd20>] ? kernel_thread_helper+0x0/0x10
> Code: e5 74 28 31 c0 85 ff 74 20 48 63 d0 48 8d 14 d6 48 8b 0a 48 85 c9 
> 74 0a 48 89 71 18 48 8b 12 89 7a 20 83 c0 01 39 f8 72 e0 c9 c3 <0f> 0b 
> 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 c7 c2 e0 ff 20
> RIP  [<ffffffffa020b352>] v4l2_ctrl_cluster+0x32/0x40 [videodev]
>   RSP <ffff880033c61a30>
> ---[ end trace f2fe4d11aa83a3aa ]---
> 
> ==== dmesg end ====
> 
> I have pinpointed the problem to the following part of cx25840_probe in 
> cx25840-core.c:
> 
> ==== source begin =====
>          sd->ctrl_handler = &state->hdl;
>          if (state->hdl.error) {
>                  int err = state->hdl.error;
> 
>                  v4l2_ctrl_handler_free(&state->hdl);
>                  kfree(state);
>                  return err;
>          }
>          v4l2_ctrl_cluster(2, &state->volume); // <= here the crash occurs
>          v4l2_ctrl_handler_setup(&state->hdl);
> ==== source end ====
> 
> I have added a "if (!is_cx2583x(state))" check before the marked line 
> and now the probing (and my device) works. If this is the correct 
> solution for this problem I'll prepare a mail containing a patch. If not 
> feel free to propose a better solution.

That is the correct solution.  Please prepare and submit a patch.

Note that in the logic a few lines above where the problem call happens,
a volume and mute control were intentionally not created for CX2583x
chips.


> Note: This is a regression as the module used to work in 2.6.35 together 
> with the AV400 (I haven't tested 2.6.36 though).

Yes 2.6.36 also has the new control framework change and the bug.
Kernel 2.6.36 is also missing this other patch for cx25840 devices with
a volume control:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f23b7952d37c69c0caa6c8dfb85dbf2eb9e5fcaa

which reminds me, I have to send a request to get that back into
2.6.36-stable.


> Regards,
> Sven
> 
> PS: Is there a way to get the source file and line of a dmesg "kernel 
> bug" report?

Yes.  If one reads the log carefully, one may notice...

> kernel BUG at drivers/media/video/v4l2-ctrls.c:1143
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;)

Also, since the report calls out 
function_name+current_offset/function_end_offset [module_name]:

> RIP: 0010:[<ffffffffa020b352>]  [<ffffffffa020b352>] 
> v4l2_ctrl_cluster+0x32/0x40 [videodev]
[...]
>  [<ffffffffa0310b99>] cx25840_probe+0x479/0x840 [cx25840]

one could do something like:

$ objdump -d -l  /lib/modules/2.6.37-ARCH/kernel/drivers/media/video/videodev.ko | less
$ objdump -d -l  /lib/modules/2.6.37-ARCH/kernel/drivers/media/video/cx25840/cx25840.ko | less

to find the source file and line.

Regards,
Andy

