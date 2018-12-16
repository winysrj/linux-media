Return-Path: <SRS0=vP0A=OZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971DAC43387
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 07:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 426D8206C2
	for <linux-media@archiver.kernel.org>; Sun, 16 Dec 2018 07:25:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="TsU69jXm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbeLPHZd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 16 Dec 2018 02:25:33 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:46106 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbeLPHZd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Dec 2018 02:25:33 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2B95659;
        Sun, 16 Dec 2018 08:25:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544945129;
        bh=lLOXedP8Vb4ODAd8b2z6UfhbhKAzQ6xFZT5lmbzVY60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TsU69jXmrRnEHYr+xoZOkU5TjizHpYZnn5niT6dE2CFdNPYEgkK267GSvBtbiHmSI
         7P7EF1wJMwrYNWXI9U1asvvubsS/SDWsXo4YOhzXtUiUo7CRNgk9qcz3qs1tFfMdA5
         IezIAYz3RJDFROrvhAr4fc21IbpQmZKZDNqOKTMs=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     "Zhi, Yong" <yong.zhi@intel.com>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Hu, Jerry W" <jerry.w.hu@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: Re: [PATCH v7 00/16] Intel IPU3 ImgU patchset
Date:   Sun, 16 Dec 2018 09:26:18 +0200
Message-ID: <2135468.G1bK1392oW@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <1819843.KIqgResAvh@avalon>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <1645510.9NPTHXyo7j@avalon> <1819843.KIqgResAvh@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Yong,

Could you please have a look at the crash reported below ?

On Tuesday, 11 December 2018 16:20:43 EET Laurent Pinchart wrote:
> On Tuesday, 11 December 2018 15:43:53 EET Laurent Pinchart wrote:
> > On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> >> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> >> 
> >> [snip]
> >> 
> >>> I can see a couple of steps missing in the script below.
> >>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/0
> >>> 00040.html)
> >>> 
> >>> From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> >>> documentation",
> >>> under section "Configuring ImgU V4L2 subdev for image processing"...
> >>> 
> >>> 1. The pipe mode needs to be configured for the V4L2 subdev.
> >>> 
> >>> Also the pipe mode of the corresponding V4L2 subdev should be set as
> >>> desired (e.g 0 for video mode or 1 for still mode) through the control
> >>> id 0x009819a1 as below.
> >>> 
> >>> e.g v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1
> >> 
> >> I assume the control takes a valid default value ? It's better to set it
> >> explicitly anyway, so I'll do so.
> >> 
> >>> 2. ImgU pipeline needs to be configured for image processing as below.
> >>> 
> >>> RAW bayer frames go through the following ISP pipeline HW blocks to
> >>> have the processed image output to the DDR memory.
> >>> 
> >>> RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) ->
> >>> Geometric Distortion Correction (GDC) -> DDR
> >>> 
> >>> The ImgU V4L2 subdev has to be configured with the supported
> >>> resolutions in all the above HW blocks, for a given input resolution.
> >>> 
> >>> For a given supported resolution for an input frame, the Input Feeder,
> >>> Bayer Down Scaling and GDC blocks should be configured with the
> >>> supported resolutions. This information can be obtained by looking at
> >>> the following IPU3 ISP configuration table for ov5670 sensor.
> >>> 
> >>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+
> >>> /master/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/
> >>> gcss/graph_settings_ov5670.xml
> >>> 
> >>> For the ov5670 example, for an input frame with a resolution of
> >>> 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
> >>> resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
> >>> 2560x1920 respectively.
> >> 
> >> How is the GDC output resolution computed from the input resolution ?
> >> Does the GDC always consume 32 columns and 22 lines ?
> >> 
> >>> The following steps prepare the ImgU ISP pipeline for the image
> >>> processing.
> >>> 
> >>> 1. The ImgU V4L2 subdev data format should be set by using the
> >>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
> >>> above.
> >> 
> >> If I understand things correctly, the GDC resolution is the pipeline
> >> output resolution. Why is it configured on pad 0 ?
> >> 
> >>> 2. The ImgU V4L2 subdev cropping should be set by using the
> >>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the
> >>> target, using the input feeder height and width.
> >>> 
> >>> 3. The ImgU V4L2 subdev composing should be set by using the
> >>> VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> >>> target, using the BDS height and width.
> >>> 
> >>> Once these 2 steps are done, the raw bayer frames can be input to the
> >>> ImgU V4L2 subdev for processing.
> >> 
> >> Do I need to capture from both the output and viewfinder nodes ? How are
> >> they related to the IF -> BDS -> GDC pipeline, are they both fed from
> >> the GDC output ? If so, how does the viewfinder scaler fit in that
> >> picture ?
> >> 
> >> I have tried the above configuration with the IPU3 v8 driver, and while
> >> the kernel doesn't crash, no images get processed. The userspace
> >> processes wait forever for buffers to be ready. I then configured pad 2
> >> to 2560x1920 and pad 3 to 1920x1080, and managed to capture images \o/
> >> 
> >> There's one problem though: during capture, or very soon after it, the
> >> machine locks up completely. I suspect a memory corruption, as when it
> >> doesn't log immediately commands such as dmesg will not produce any
> >> output and just block, until the system freezes soon after (especially
> >> when moving the mouse).
> >> 
> >> I would still call this an improvement to some extent, but there's
> >> definitely room for more improvements :-)
> >> 
> >> To reproduce the issue, you can run the ipu3-process.sh script (attached
> >> to this e-mail) with the following arguments:
> >> 
> >> $ ipu3-process.sh --out 2560x1920 frame-2592x1944.cio2
> 
> This should have read
> 
> $ ipu3-process.sh --out 2560x1920 --vf 1920x1080 frame-2592x1944.cio2
> 
> Without the --vf argument no images are processed.
> 
> It seems that the Intel mail server blocked the mail that contained the
> script. You can find a copy at http://paste.debian.net/hidden/fd5bb8df/.
> 
> >> frame-2592x1944.cio2 is a binary file containing a 2592x1944 images in
> >> the IPU3-specific Bayer format (for a total of 6469632 bytes).
> > 
> > I managed to get the dmesg output, and it doesn't look pretty.
> > 
> > [  571.217192] WARNING: CPU: 3 PID: 1303 at /home/laurent/src/iob/oss/
> > libcamera/linux/drivers/staging/media/ipu3/ipu3-dmamap.c:172
> > ipu3_dmamap_unmap+0x30/0x75 [ipu3_imgu]
> > [  571.217196] Modules linked in: asix usbnet mii zram arc4 iwlmvm
> > mac80211
> > iwlwifi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp cfg80211
> > 8250_dw hid_multitouch ipu3_cio2 ipu3_imgu(C) videobuf2_dma_sg
> > videobuf2_memops videobuf2_v4l2 videobuf2_common processor_thermal_device
> > intel_soc_dts_iosf ov13858 dw9714 ov5670 v4l2_fwnode v4l2_common videodev
> > at24 media int3403_thermal int340x_thermal_zone cros_ec_lpcs cros_ec_core
> > int3400_thermal chromeos_pstore mac_hid acpi_thermal_rel autofs4 usbhid
> > mmc_block hid_generic i915 video i2c_algo_bit drm_kms_helper syscopyarea
> > sysfillrect sdhci_pci sysimgblt fb_sys_fops cqhci sdhci drm
> > drm_panel_orientation_quirks i2c_hid hid
> > [  571.217254] CPU: 3 PID: 1303 Comm: yavta Tainted: G         C
> > 4.20.0-rc6+ #2
> > [  571.217256] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> > [  571.217267] RIP: 0010:ipu3_dmamap_unmap+0x30/0x75 [ipu3_imgu]
> > [  571.217271] Code: 54 55 48 8d af d0 6e 00 00 53 48 8b 76 10 49 89 fc f3
> > 48 0f bc 8f f0 6e 00 00 48 89 ef 48 d3 ee e8 e6 73 d9 e6 48 85 c0 75 07
> > <0f> 0b 5b 5d 41 5c c3 48 8b 70 20 48 89 c3 48 8b 40 18 49 8b bc 24
> > [  571.217274] RSP: 0018:ffffb675021c7b38 EFLAGS: 00010246
> > [  571.217278] RAX: 0000000000000000 RBX: ffff8f5cf58f8448 RCX:
> > 000000000000000c
> > [  571.217280] RDX: 0000000000000000 RSI: 0000000000000202 RDI:
> > 00000000ffffffff
> > [  571.217283] RBP: ffff8f5cf58f6ef8 R08: 00000000000006c5 R09:
> > ffff8f5cfaba16f0
> > [  571.217286] R10: ffff8f5cbf508f98 R11: 000000e03da27aba R12:
> > ffff8f5cf58f0028
> > [  571.217289] R13: ffff8f5cf58f0028 R14: 0000000000000000 R15:
> > ffff8f5cf58f04e8
> > [  571.217293] FS:  00007f85d009c700(0000) GS:ffff8f5cfab80000(0000)
> > knlGS:
> > 0000000000000000
> > [  571.217296] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  571.217299] CR2: 00007f3440fce4b0 CR3: 000000014abf2001 CR4:
> > 00000000003606e0
> > [  571.217301] Call Trace:
> > [  571.217316]  ipu3_dmamap_free+0x5b/0x8f [ipu3_imgu]
> > [  571.217326]  ipu3_css_pool_cleanup+0x25/0x2f [ipu3_imgu]
> > [  571.217338]  ipu3_css_pipeline_cleanup+0x59/0x8f [ipu3_imgu]
> > [  571.217348]  ipu3_css_stop_streaming+0x15b/0x20f [ipu3_imgu]
> > [  571.217360]  imgu_s_stream+0x5a/0x30a [ipu3_imgu]
> > [  571.217371]  ? ipu3_all_nodes_streaming+0x14f/0x16b [ipu3_imgu]
> > [  571.217382]  ipu3_vb2_stop_streaming+0xe4/0x10f [ipu3_imgu]
> > [  571.217392]  __vb2_queue_cancel+0x2b/0x1b8 [videobuf2_common]
> > [  571.217402]  vb2_core_streamoff+0x30/0x71 [videobuf2_common]
> > [  571.217418]  __video_do_ioctl+0x258/0x38e [videodev]
> > [  571.217438]  video_usercopy+0x25f/0x4e5 [videodev]
> > [  571.217453]  ? copy_overflow+0x14/0x14 [videodev]
> > [  571.217471]  v4l2_ioctl+0x4d/0x58 [videodev]
> > [  571.217480]  vfs_ioctl+0x1e/0x2b
> > [  571.217486]  do_vfs_ioctl+0x531/0x559
> > [  571.217494]  ? vfs_write+0xd1/0xdf
> > [  571.217500]  ksys_ioctl+0x50/0x70
> > [  571.217506]  __x64_sys_ioctl+0x16/0x19
> > [  571.217512]  do_syscall_64+0x53/0x60
> > [  571.217519]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [  571.217524] RIP: 0033:0x7f85cf9b9f47
> > [  571.217528] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48
> > c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05
> > <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> > [  571.217531] RSP: 002b:00007ffc59056b78 EFLAGS: 00000246 ORIG_RAX:
> > 0000000000000010
> > [  571.217535] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
> > 00007f85cf9b9f47
> > [  571.217537] RDX: 00007ffc59056b84 RSI: 0000000040045613 RDI:
> > 0000000000000003
> > [  571.217540] RBP: 000055f4c4dc0af8 R08: 00007f85cd7c4000 R09:
> > 00007f85d009c700
> > [  571.217542] R10: 0000000000000020 R11: 0000000000000246 R12:
> > 000055f4c4dc0b06
> > [  571.217545] R13: 0000000000000004 R14: 00007ffc59056d50 R15:
> > 00007ffc59057825
> > [  571.217553] ---[ end trace 4b42bd84953eff53 ]---
> > [  571.318645] ipu3-imgu 0000:00:05.0: wait cio gate idle timeout
> 
> And after fixing another issue in the capture script (which was setting the
> format on the ImgU subdev pad 3 to 2560x1920 but capture in 1920x1080), I
> now get plenty of the following messages:
> 
> [  221.366131] BUG: Bad page state in process yavta  pfn:14a4ff
> [  221.366134] page:ffffde5d45293fc0 count:-1 mapcount:0 mapping:
> 0000000000000000 index:0x0
> [  221.366137] flags: 0x200000000000000()
> [  221.366140] raw: 0200000000000000 dead000000000100 dead000000000200
> 0000000000000000
> [  221.366143] raw: 0000000000000000 0000000000000000 ffffffffffffffff
> 0000000000000000
> [  221.366145] page dumped because: nonzero _refcount
> [  221.366147] Modules linked in: asix usbnet mii zram arc4 iwlmvm
> intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp mac80211 iwlwifi
> cfg80211 hid_multitouch 8250_dw ipu3_cio2 ipu3_imgu(C) videobuf2_dma_sg
> videobuf2_memops videobuf2_v4l2 processor_thermal_device videobuf2_common
> intel_soc_dts_iosf ov13858 ov5670 dw9714 v4l2_fwnode v4l2_common videodev
> media at24 cros_ec_lpcs cros_ec_core int3403_thermal int340x_thermal_zone
> chromeos_pstore mac_hid int3400_thermal acpi_thermal_rel autofs4 usbhid
> mmc_block hid_generic i915 video i2c_algo_bit drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops sdhci_pci cqhci sdhci drm
> drm_panel_orientation_quirks i2c_hid hid
> [  221.366172] CPU: 3 PID: 1022 Comm: yavta Tainted: G    B   WC
> 4.20.0-rc6+ #2
> [  221.366173] Hardware name: HP Soraka/Soraka, BIOS  08/30/2018
> [  221.366173] Call Trace:
> [  221.366176]  dump_stack+0x46/0x59
> [  221.366179]  bad_page+0xf2/0x10c
> [  221.366182]  free_pages_check+0x78/0x81
> [  221.366186]  free_pcppages_bulk+0xa6/0x236
> [  221.366190]  free_unref_page+0x4b/0x53
> [  221.366193]  vb2_dma_sg_put+0x95/0xb5 [videobuf2_dma_sg]
> [  221.366197]  __vb2_buf_mem_free+0x3a/0x6e [videobuf2_common]
> [  221.366202]  __vb2_queue_free+0xe3/0x1be [videobuf2_common]
> [  221.366207]  vb2_core_reqbufs+0xe9/0x2cc [videobuf2_common]
> [  221.366212]  vb2_ioctl_reqbufs+0x78/0x9e [videobuf2_v4l2]
> [  221.366220]  __video_do_ioctl+0x258/0x38e [videodev]
> [  221.366229]  video_usercopy+0x25f/0x4e5 [videodev]
> [  221.366237]  ? copy_overflow+0x14/0x14 [videodev]
> [  221.366240]  ? unmap_region+0xe0/0x10a
> [  221.366250]  v4l2_ioctl+0x4d/0x58 [videodev]
> [  221.366253]  vfs_ioctl+0x1e/0x2b
> [  221.366255]  do_vfs_ioctl+0x531/0x559
> [  221.366260]  ksys_ioctl+0x50/0x70
> [  221.366263]  __x64_sys_ioctl+0x16/0x19
> [  221.366266]  do_syscall_64+0x53/0x60
> [  221.366269]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  221.366270] RIP: 0033:0x7fbe39f6af47
> [  221.366272] Code: 00 00 00 48 8b 05 51 6f 2c 00 64 c7 00 26 00 00 00 48
> c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05
> <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 6f 2c 00 f7 d8 64 89 01 48
> [  221.366273] RSP: 002b:00007fff05638e68 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000010
> [  221.366275] RAX: ffffffffffffffda RBX: 0000000000000007 RCX:
> 00007fbe39f6af47
> [  221.366279] RDX: 00007fff05638f90 RSI: 00000000c0145608 RDI:
> 0000000000000003
> [  221.366283] RBP: 0000000000000004 R08: 0000000000000000 R09:
> 0000000000000045
> [  221.366287] R10: 0000000000000557 R11: 0000000000000246 R12:
> 000055c83bd76750
> [  221.366290] R13: 000055c83b6b26a0 R14: 0000000000000001 R15:
> 00007fff0563a825

-- 
Regards,

Laurent Pinchart



