Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6617EC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14F3D2086D
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 22:24:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="qoPsso5w"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14F3D2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbeLMWYD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 17:24:03 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:54274 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbeLMWYC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 17:24:02 -0500
Received: from avalon.localnet (dfj612ybrt5fhg77mgycy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:2e86:4862:ef6a:2804])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id B7CAE549;
        Thu, 13 Dec 2018 23:23:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544739839;
        bh=9C5c3zYpTkRLZhLFEiuFiykJv6HwSYAGo3zaGV8MPxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoPsso5wp3nti6VOqiqsrYZz04+31Z8Ra2OOaLg7Ac7SEtaQFXA+oiFMv2yuygJu2
         AE3HSly1SUY5/V+w9UC/xBfOM+2ZahztDwbkQgJOYtZe+SQIPbm08LW3ksUs6yd2f8
         1AQ82KUgmSNQYTfuC9FOCPmBd0OVcz4oB1pfxNgY=
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Bingbu Cao <bingbu.cao@linux.intel.com>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Zhi, Yong" <yong.zhi@intel.com>,
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
Date:   Fri, 14 Dec 2018 00:24:46 +0200
Message-ID: <1609628.n3aCoxV5Mp@avalon>
Organization: Ideas on Board Oy
In-Reply-To: <14cba24a-a2c3-f0d4-5d5b-f514f9a24035@linux.intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <1645510.9NPTHXyo7j@avalon> <14cba24a-a2c3-f0d4-5d5b-f514f9a24035@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello Bingbu,

On Wednesday, 12 December 2018 06:55:53 EET Bingbu Cao wrote:
> On 12/11/2018 09:43 PM, Laurent Pinchart wrote:
> > On Tuesday, 11 December 2018 15:34:49 EET Laurent Pinchart wrote:
> >> On Wednesday, 5 December 2018 02:30:46 EET Mani, Rajmohan wrote:
> >> 
> >> [snip]
> >> 
> >>> I can see a couple of steps missing in the script below.
> >>> (https://lists.libcamera.org/pipermail/libcamera-devel/2018-November/000
> >>> 040.html)
> >>> 
> >>>  From patch 02 of this v7 series "doc-rst: Add Intel IPU3
> >>>  documentation", under section "Configuring ImgU V4L2 subdev for image
> >>>  processing"...
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
> 
> The video mode is set by default. If you want to set to still mode or change
> mode, you need set the subdev control.
> 
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
> >>> https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/m
> >>> aster/baseboard-poppy/media-libs/cros-camera-hal-configs-poppy/files/
> >>> gcss/graph_settings_ov5670.xml
> >>> 
> >>> For the ov5670 example, for an input frame with a resolution of
> >>> 2592x1944 (which is input to the ImgU subdev pad 0), the corresponding
> >>> resolutions for input feeder, BDS and GDC are 2592x1944, 2592x1944 and
> >>> 2560x1920 respectively.
> >> 
> >> How is the GDC output resolution computed from the input resolution ?
> >> Does the GDC always consume 32 columns and 22 lines ?
> 
> All the intermediate resolutions in the pipeline are determined by the
> actual use case, in other word determined by the IMGU input
> resolution(sensor output) and the final output and viewfinder resolution.
> BDS mainly do Bayer downscaling, it has limitation that the downscaling
> factor must be a value a integer multiple of 1/32.
> GDC output depends on the input and width should be x8 and height x4
> alignment.

Thank you for the information. This will need to be captured in the 
documentation, along with information related to how each block in the 
hardware pipeline interacts with the image size. It should be possible for a 
developer to compute the output and viewfinder resolutions based on the 
parameters of the image processing algorithms just with the information 
contained in the driver documentation.

> >>> The following steps prepare the ImgU ISP pipeline for the image
> >>> processing.
> >>> 
> >>> 1. The ImgU V4L2 subdev data format should be set by using the
> >>> VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
> >>> above.
> >> 
> >> If I understand things correctly, the GDC resolution is the pipeline
> >> output resolution. Why is it configured on pad 0 ?
> 
> We see the GDC output resolution as the input of output system, the sink pad
> format is used for output and viewfinder resolutions.

The ImgU subdev is supposed to represent the ImgU. Pad 0 should thus be the 
ImgU input, the format configured there should correspond to the format on the 
connected video node, and should thus be the sensor format. You can then use 
the crop and compose rectangles on pad 0, along with the format, crop and 
compose rectangles on the output and viewfinder pads, to configure the device. 
This should be fixed in the driver, and the documentation should then be 
updated accordingly.

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
> >> they related to the IF -> BDS -> GDC pipeline, are they both fed from the
> >> GDC output ? If so, how does the viewfinder scaler fit in that picture ?
> 
> The output capture should be set, the viewfinder can be disabled.
> The IF and BDS are seen as crop and compose of the imgu input video
> device. The GDC is seen as the subdev sink pad and OUTPUT/VF are source
> pads.

The GDC is the last block in the pipeline according to the information 
provided above. How can it be seen as the subdev sink pad ? That doesn't make 
sense to me. I'm not asking for the MC graph to expose all internal blocks of 
the ImgU, but if you want to retain a single subdev model, the format on the 
sink pad needs to correspond to what is provided to the ImgU. Please see 
figure 4.6 of https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-subdev.html for more information regarding how you can use the sink crop, sink 
compose and source crop rectangles.

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
> >> 
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

-- 
Regards,

Laurent Pinchart



