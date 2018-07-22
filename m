Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37649 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbeGVUJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Jul 2018 16:09:18 -0400
Received: by mail-pl0-f66.google.com with SMTP id 31-v6so7300622plc.4
        for <linux-media@vger.kernel.org>; Sun, 22 Jul 2018 12:11:36 -0700 (PDT)
Subject: Re: [PATCH v2 00/16] i.MX media mem2mem scaler
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
References: <20180719153042.533-1-p.zabel@pengutronix.de>
 <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
Message-ID: <f62cb09f-2507-d98a-78e2-5131e6cb5c61@gmail.com>
Date: Sun, 22 Jul 2018 12:11:34 -0700
MIME-Version: 1.0
In-Reply-To: <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/22/2018 11:30 AM, Steve Longerbeam wrote:
> Hi Philipp,
>
>
> On 07/19/2018 08:30 AM, Philipp Zabel wrote:
>> Hi,
>>
>> this is the second version of the i.MX mem2mem scaler series.
>> Patches 8 and 16 have been modified.
>>
>> Changes since v1:
>>   - Fix inverted allow_overshoot logic
>>   - Correctly switch horizontal / vertical tile alignment when
>>     determining seam positions with the 90° rotator active.
>
> Yes, this fixes the specific rotation test that was broken
> (720x480, UYVY --> 1280x768, UYVY, rotate 90).
>
> But running more tests on this v2 reveals more issues. I chose a
> somewhat random upscaling-only example as a first try:
>
> 640x480, YV12 --> full HD 2560x1600, YV12 (no rotation or flip).
>
> This produces division by zero backtraces and the conversion hangs:
>

The hang is apparently because the conversion is re-attempted over and
over again, with an endless WARN() from
drivers/media/common/videobuf2/videobuf2-core.c:900.

I fixed the hang with an additional patch:

50026cbe08 ("media: imx: mem2mem: Remove buffers on device_run failures")

With this the conversion completes, but the below div-by-zero errors
persist, and the resultant image is blank.

Steve

>
> [  131.079978] Division by zero in kernel.
> [  131.083853] CPU: 0 PID: 683 Comm: mx6-m2m Tainted: G W 
> 4.18.0-rc2-13448-g678218d #7
> [  131.092830] Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> [  131.099372] Backtrace:
> [  131.101858] [<c010def8>] (dump_backtrace) from [<c010e1b8>] 
> (show_stack+0x18/0x1c)
> [  131.109450]  r7:00000000 r6:600f0013 r5:00000000 r4:c107db3c
> [  131.115135] [<c010e1a0>] (show_stack) from [<c0aa5aec>] 
> (dump_stack+0xb4/0xe8)
> [  131.122380] [<c0aa5a38>] (dump_stack) from [<c010e048>] 
> (__div0+0x18/0x20)
> [  131.129274]  r9:ec37d800 r8:00000003 r7:00000000 r6:00000000 
> r5:00000000 r4:ec37dae8
> [  131.137036] [<c010e030>] (__div0) from [<c0aa3b34>] (Ldiv0+0x8/0x10)
> [  131.143425] [<c0590078>] (ipu_image_convert_prepare) from 
> [<c07c92b4>] (mem2mem_start_streaming+0xe0/0x1c0)
> [  131.153186]  r10:c0b9f640 r9:c071958c r8:00000280 r7:000001e0 
> r6:32315659 r5:c1008908
> [  131.161030]  r4:ecf9c800
> [  131.163588] [<c07c91d4>] (mem2mem_start_streaming) from 
> [<c073ac44>] (vb2_start_streaming+0x64/0x160)
> [  131.172826]  r8:c1008908 r7:00000001 r6:ed01b808 r5:ed01b934 
> r4:ed01b810
> [  131.179547] [<c073abe0>] (vb2_start_streaming) from [<c073c214>] 
> (vb2_core_streamon+0x10c/0x164)
> [  131.188351]  r9:c071958c r8:c1008908 r7:00000001 r6:ec1038f8 
> r5:00000000 r4:ed01b808
> [  131.196114] [<c073c108>] (vb2_core_streamon) from [<c073ebe0>] 
> (vb2_streamon+0x34/0x58)
> [  131.204133]  r5:40045612 r4:ed01b800
> [  131.207733] [<c073ebac>] (vb2_streamon) from [<c072f33c>] 
> (v4l2_m2m_streamon+0x24/0x3c)
> [  131.215758] [<c072f318>] (v4l2_m2m_streamon) from [<c072f36c>] 
> (v4l2_m2m_ioctl_streamon+0x18/0x1c)
> [  131.224732]  r5:40045612 r4:c072f354
> [  131.228330] [<c072f354>] (v4l2_m2m_ioctl_streamon) from 
> [<c07195b0>] (v4l_streamon+0x24/0x28)
> [  131.236878] [<c071958c>] (v4l_streamon) from [<c071be3c>] 
> (__video_do_ioctl+0x284/0x4f8)
> [  131.244984]  r5:40045612 r4:ecc50800
> [  131.248583] [<c071bbb8>] (__video_do_ioctl) from [<c071f9dc>] 
> (video_usercopy+0x260/0x55c)
> [  131.256866]  r10:00000004 r9:00000000 r8:c1008908 r7:ed747dfc 
> r6:00000000 r5:00000004
> [  131.264709]  r4:40045612
> [  131.267265] [<c071f77c>] (video_usercopy) from [<c071fcec>] 
> (video_ioctl2+0x14/0x1c)
> [  131.275026]  r10:00000036 r9:00000003 r8:ed480068 r7:c0254840 
> r6:ecc76000 r5:bea6ab38
> [  131.282869]  r4:c071fcd8
> [  131.285424] [<c071fcd8>] (video_ioctl2) from [<c0717924>] 
> (v4l2_ioctl+0x44/0x5c)
> [  131.292845] [<c07178e0>] (v4l2_ioctl) from [<c0253e60>] 
> (do_vfs_ioctl+0xa8/0xa4c)
> [  131.300343]  r5:bea6ab38 r4:c1008908
> [  131.303940] [<c0253db8>] (do_vfs_ioctl) from [<c0254840>] 
> (ksys_ioctl+0x3c/0x60)
> [  131.311355]  r10:00000036 r9:ed746000 r8:bea6ab38 r7:40045612 
> r6:00000003 r5:ecc76000
> [  131.319198]  r4:ecc76000
> [  131.321752] [<c0254804>] (ksys_ioctl) from [<c0254874>] 
> (sys_ioctl+0x10/0x14)
> [  131.328907]  r9:ed746000 r8:c01011e4 r7:00000036 r6:00010960 
> r5:00000000 r4:00012620
> [  131.336672] [<c0254864>] (sys_ioctl) from [<c0101000>] 
> (ret_fast_syscall+0x0/0x28)
> [  131.344256] Exception stack(0xed747fa8 to 0xed747ff0)
> [  131.349327] 7fa0:                   00012620 00000000 00000003 
> 40045612 bea6ab38 00000003
> [  131.357524] 7fc0: 00012620 00000000 00010960 00000036 00000000 
> 00000000 45d80000 bea6abac
> [  131.365717] 7fe0: 0002312c bea6aaa4 00012308 45e58d5c
>
>
> To aid in debugging this I created branch 'imx-mem2mem.stevel' in my
> mediatree fork on github. I moved the mem2mem driver to the beginning
> and added a few patches:
>
> d317a7771c ("gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma 
> buffers")
> b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust in try 
> format")
> 4758be0cf8 ("gpu: ipu-v3: image-convert: Fix width/height alignment")
> d069163c7f ("gpu: ipu-v3: image-convert: Fix input bytesperline clamp 
> in adjust")
>
> (feel free to squash some of those if you agree with them for v3).
>
> By moving the mem2mem driver before the seam avoidance patches, and 
> making
> it independent of the image converter implementation, the driver can 
> be tested with
> and without the seam avoidance changes.
>
> If you run a git rebase and build/run the kernel when stopped at 
> b4362162c0 (e.g.
> without the seam avoidance patches), you will find that the above 
> 640x480 -->
> 2560x1600 conversion succeeds, albeit with the expected visible seams 
> at the
> tile boundaries.
>
> Also, I'm trying to parse the functions find_best_seam() and 
> find_seams(). Can
> you provide some more background on the behavior of those functions?
>
> Steve
>
>>   - Fix SPDX-License-Identifier and remove superfluous license
>>     text.
>>   - Fix uninitialized walign in try_fmt
>>
>> Previous cover letter:
>>
>> we have image conversion code for scaling and colorspace conversion in
>> the IPUv3 base driver for a while. Since the IC hardware can only write
>> up to 1024x1024 pixel buffers, it scales to larger output buffers by
>> splitting the input and output frame into similarly sized tiles.
>>
>> This causes the issue that the bilinear interpolation resets at the tile
>> boundary: instead of smoothly interpolating across the seam, there is a
>> jump in the input sample position that is very apparent for high
>> upscaling factors. This can be avoided by slightly changing the scaling
>> coefficients to let the left/top tiles overshoot their input sampling
>> into the first pixel / line of their right / bottom neighbors. The error
>> can be further reduced by letting tiles be differently sized and by
>> selecting seam positions that minimize the input sampling position error
>> at tile boundaries.
>> This is complicated by different DMA start address, burst size, and
>> rotator block size alignment requirements, depending on the input and
>> output pixel formats, and the fact that flipping happens in different
>> places depending on the rotation.
>>
>> This series implements optimal seam position selection and seam hiding
>> with per-tile resizing coefficients and adds a scaling mem2mem device
>> to the imx-media driver.
>>
>> regards
>> Philipp
>>
>> Philipp Zabel (16):
>>    gpu: ipu-v3: ipu-ic: allow to manually set resize coefficients
>>    gpu: ipu-v3: image-convert: prepare for per-tile configuration
>>    gpu: ipu-v3: image-convert: calculate per-tile resize coefficients
>>    gpu: ipu-v3: image-convert: reconfigure IC per tile
>>    gpu: ipu-v3: image-convert: store tile top/left position
>>    gpu: ipu-v3: image-convert: calculate tile dimensions and offsets
>>      outside fill_image
>>    gpu: ipu-v3: image-convert: move tile alignment helpers
>>    gpu: ipu-v3: image-convert: select optimal seam positions
>>    gpu: ipu-v3: image-convert: fix debug output for varying tile sizes
>>    gpu: ipu-v3: image-convert: relax tile width alignment for NV12 and
>>      NV16
>>    gpu: ipu-v3: image-convert: relax input alignment restrictions
>>    gpu: ipu-v3: image-convert: relax output alignment restrictions
>>    gpu: ipu-v3: image-convert: fix bytesperline adjustment
>>    gpu: ipu-v3: image-convert: add some ASCII art to the exposition
>>    gpu: ipu-v3: image-convert: disable double buffering if necessary
>>    media: imx: add mem2mem device
>>
>>   drivers/gpu/ipu-v3/ipu-ic.c                   |  52 +-
>>   drivers/gpu/ipu-v3/ipu-image-convert.c        | 870 +++++++++++++---
>>   drivers/staging/media/imx/Kconfig             |   1 +
>>   drivers/staging/media/imx/Makefile            |   1 +
>>   drivers/staging/media/imx/imx-media-dev.c     |  11 +
>>   drivers/staging/media/imx/imx-media-mem2mem.c | 946 ++++++++++++++++++
>>   drivers/staging/media/imx/imx-media.h         |  10 +
>>   include/video/imx-ipu-v3.h                    |   6 +
>>   8 files changed, 1758 insertions(+), 139 deletions(-)
>>   create mode 100644 drivers/staging/media/imx/imx-media-mem2mem.c
>>
>
