Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43756 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729512AbeK3Bsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 20:48:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date: Thu, 29 Nov 2018 16:43:41 +0200
Message-ID: <4797131.2nEE5nGW4j@avalon>
In-Reply-To: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yong,

On Tuesday, 30 October 2018 00:22:54 EET Yong Zhi wrote:
> Hi,
> 
> This series adds support for the Intel IPU3 (Image Processing Unit)
> ImgU which is essentially a modern memory-to-memory ISP. It implements
> raw Bayer to YUV image format conversion as well as a large number of
> other pixel processing algorithms for improving the image quality.
> 
> Meta data formats are defined for image statistics (3A, i.e. automatic
> white balance, exposure and focus, histogram and local area contrast
> enhancement) as well as for the pixel processing algorithm parameters.
> The documentation for these formats is currently not included in the
> patchset but will be added in a future version of this set.
> 
> The algorithm parameters need to be considered specific to a given frame
> and typically a large number of these parameters change on frame to frame
> basis. Additionally, the parameters are highly structured (and not a flat
> space of independent configuration primitives). They also reflect the
> data structures used by the firmware and the hardware. On top of that,
> the algorithms require highly specialized user space to make meaningful
> use of them. For these reasons it has been chosen video buffers to pass
> the parameters to the device.
> 
> On individual patches:
> 
> The heart of ImgU is the CSS, or Camera Subsystem, which contains the
> image processors and HW accelerators.
> 
> The 3A statistics and other firmware parameter computation related
> functions are implemented in patch 11.
> 
> All IPU3 pipeline default settings can be found in patch 10.
> 
> To access DDR via ImgU's own memory space, IPU3 is also equipped with
> its own MMU unit, the driver is implemented in patch 6.
> 
> Patch 7 uses above driver for DMA mapping operation.
> 
> The communication between IPU3 firmware and driver is implemented with
> circular queues in patch 8.
> 
> Patch 9 provide some utility functions and manage IPU3 fw download and
> install.
> 
> The firmware which is called ipu3-fw.bin can be downloaded from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> (commit 2c27b0cb02f18c022d8378e0e1abaf8b7ae8188f)
> 
> Firmware ABI is defined in patches 4 and 5.
> 
> Patches 12 and 13 are of the same file, the former contains all h/w
> programming related code, the latter implements interface functions for
> access fw & hw capabilities.
> 
> Patch 14 has a dependency on Sakari's V4L2_BUF_TYPE_META_OUTPUT work:
> 
> <URL:https://patchwork.kernel.org/patch/9976295/>
> 
> Patch 15 represents the top level that glues all of the other components
> together, passing arguments between the components.
> 
> Patch 16 is a recent effort to extend v6 for advanced camera features like
> Continuous View Finder (CVF) and Snapshot During Video(SDV) support.
> 
> Link to user space implementation:
> 
> git clone https://chromium.googlesource.com/chromiumos/platform/arc-camera
> 
> ImgU media topology print:

[snip]

> v4l2-compliance utility is built with Sakari's patches for meta data
> output support(rebased):
> 
> <URL:https://patchwork.linuxtv.org/patch/43370/>
> <URL:https://patchwork.linuxtv.org/patch/43369/>
> 
> The test (v4l2-compliance -m 0) passes without error, outputs are appended
> at the end of revision history.
> 
> Note:
> 
> 1. Link pad flag of video nodes (i.e. ipu3-imgu 0 output) need to be enabled
> prior to the test.
> 2. Stream tests are not performed since it requires pre-configuration for
> each case.

And that's a bit of an issue. I've tested the driver with a small script based 
on media-ctl to configure links and yavta to interface with the video nodes, 
and got the following oops:

[  136.927788] divide error: 0000 [#1] PREEMPT SMP PTI
[  136.927801] CPU: 2 PID: 2069 Comm: yavta Not tainted 4.20.0-rc1+ #9
[  136.927806] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
[  136.927820] RIP: 0010:ipu3_css_osys_calc+0xc54/0xe14 [ipu3_imgu]
[  136.927825] Code: 89 44 24 28 42 8b 44 86 6c f7 54 24 04 81 64 24 28 00 fd 
ff ff 81 64 24 04 00 03 00 00 8d 44 03 ff 81 44 24 28 80 03 00 00 99 <f7> fb 
0f af c3 bb 20 00 00 00 99 f7 fb 8b 5c 24 40 83 fd 01 19 d2
[  136.927830] RSP: 0018:ffff9af2c0b837c8 EFLAGS: 00010202
[  136.927835] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 
ffff9af2c3e353c0
[  136.927839] RDX: 00000000ffffffff RSI: ffff9af2c0b838e0 RDI: 
ffff9af2c3e353c0
[  136.927843] RBP: 0000000000000001 R08: 0000000000000000 R09: 
ffff9af2c0b83880
[  136.927846] R10: ffff9af2c3e353c0 R11: ffff9af2c3e357c0 R12: 
00000000000003a0
[  136.927849] R13: 0000000000025a0a R14: 0000000000000000 R15: 
0000000000000000
[  136.927854] FS:  00007f1eca167700(0000) GS:ffff8c19fab00000(0000) knlGS:
0000000000000000
[  136.927858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.927862] CR2: 00007f1ec776c000 CR3: 00000001312a4003 CR4: 
00000000003606e0
[  136.927865] Call Trace:
[  136.927884]  ? __accumulate_pelt_segments+0x29/0x3a
[  136.927892]  ? __switch_to_asm+0x40/0x70
[  136.927899]  ? alloc_vmap_area+0x78/0x2f6
[  136.927903]  ? __switch_to_asm+0x40/0x70
[  136.927907]  ? __switch_to_asm+0x34/0x70
[  136.927911]  ? __switch_to_asm+0x40/0x70
[  136.927915]  ? __switch_to_asm+0x34/0x70
[  136.927923]  ? __inc_numa_state+0x28/0x70
[  136.927929]  ? preempt_latency_start+0x1e/0x3d
[  136.927936]  ? get_page_from_freelist+0x821/0xb62
[  136.927943]  ? slab_pre_alloc_hook+0x12/0x3b
[  136.927948]  ? kmem_cache_alloc_node_trace+0xf6/0x108
[  136.927954]  ? alloc_vmap_area+0x78/0x2f6
[  136.927965]  ipu3_css_cfg_acc+0xa0/0x1b5f [ipu3_imgu]
[  136.927981]  ipu3_css_set_parameters+0x286/0x6e7 [ipu3_imgu]
[  136.927995]  ipu3_css_start_streaming+0x1230/0x130a [ipu3_imgu]
[  136.928010]  imgu_s_stream+0x104/0x2f7 [ipu3_imgu]
[  136.928022]  ipu3_vb2_start_streaming+0x168/0x1bd [ipu3_imgu]
[  136.928034]  vb2_start_streaming+0x6c/0xf2 [videobuf2_common]
[  136.928044]  vb2_core_streamon+0xcf/0x109 [videobuf2_common]
[  136.928061]  __video_do_ioctl+0x239/0x388 [videodev]
[  136.928081]  video_usercopy+0x25d/0x47a [videodev]
[  136.928097]  ? copy_overflow+0x14/0x14 [videodev]
[  136.928115]  v4l2_ioctl+0x4d/0x58 [videodev]
[  136.928123]  vfs_ioctl+0x1b/0x28
[  136.928130]  do_vfs_ioctl+0x4de/0x566
[  136.928139]  ksys_ioctl+0x50/0x70
[  136.928146]  __x64_sys_ioctl+0x16/0x19
[  136.928152]  do_syscall_64+0x4d/0x5a
[  136.928158]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  136.928164] RIP: 0033:0x7f1ec9a84f47
[  136.928169] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48 c7 
c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 
01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
[  136.928173] RSP: 002b:00007ffe279e6188 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[  136.928178] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 
00007f1ec9a84f47
[  136.928181] RDX: 00007ffe279e6194 RSI: 0000000040045612 RDI: 
0000000000000003
[  136.928184] RBP: 0000000000000000 R08: 00007f1ec776d000 R09: 
0000000000000000
[  136.928188] R10: 0000000000000020 R11: 0000000000000246 R12: 
00007ffe279e6360
[  136.928191] R13: 0000000000000004 R14: 00007ffe279e6360 R15: 
00007ffe279e8826
[  136.928198] Modules linked in: ccm zram arc4 iwlmvm mac80211 intel_rapl 
x86_pkg_temp_thermal intel_powerclamp coretemp iwlwifi cfg80211 hid_multitouch 
ipu3_imgu ipu3_cio2 8250_dw videobuf2_dma_sg videobuf2_memops videobuf2_v4l2 
processor_thermal_device intel_soc_dts_iosf videobuf2_common ov5670 ov13858 
dw9714 v4l2_fwnode v4l2_common videodev media at24 cros_ec_lpcs cros_ec_core 
int3403_thermal int340x_thermal_zone int3400_thermal acpi_thermal_rel 
chromeos_pstore mac_hid autofs4 usbhid mmc_block hid_generic i915 sdhci_pci 
video cqhci i2c_algo_bit sdhci drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm drm_panel_orientation_quirks i2c_hid hid
[  136.928273] ---[ end trace 4ec6c2ce09e06d9d ]---
[  136.928288] RIP: 0010:ipu3_css_osys_calc+0xc54/0xe14 [ipu3_imgu]
[  136.928293] Code: 89 44 24 28 42 8b 44 86 6c f7 54 24 04 81 64 24 28 00 fd 
ff ff 81 64 24 04 00 03 00 00 8d 44 03 ff 81 44 24 28 80 03 00 00 99 <f7> fb 
0f af c3 bb 20 00 00 00 99 f7 fb 8b 5c 24 40 83 fd 01 19 d2
[  136.928297] RSP: 0018:ffff9af2c0b837c8 EFLAGS: 00010202
[  136.928302] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 
ffff9af2c3e353c0
[  136.928307] RDX: 00000000ffffffff RSI: ffff9af2c0b838e0 RDI: 
ffff9af2c3e353c0
[  136.928311] RBP: 0000000000000001 R08: 0000000000000000 R09: 
ffff9af2c0b83880
[  136.928320] R10: ffff9af2c3e353c0 R11: ffff9af2c3e357c0 R12: 
00000000000003a0
[  136.928324] R13: 0000000000025a0a R14: 0000000000000000 R15: 
0000000000000000
[  136.928330] FS:  00007f1eca167700(0000) GS:ffff8c19fab00000(0000) knlGS:
0000000000000000
[  136.928349] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  136.928364] CR2: 00007f1ec776c000 CR3: 00000001312a4003 CR4: 
00000000003606e0

The script can be found at https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/000040.html.

I may be doing something wrong (and I probably am), but in any case, the 
driver shouldn't crash. Could you please have a look ?

Please note that, as I couldn't get the IMGU to process frames, the part of 
the script that converts output files to PPM is untested and thus probably 
incorrect.

[snip]

-- 
Regards,

Laurent Pinchart
