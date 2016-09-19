Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:47976 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S935439AbcISFzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 01:55:47 -0400
Message-ID: <1474264541.16492.6.camel@mtksdaap41>
Subject: Re: [PATCH v6 0/6] Add MT8173 MDP Driver
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Mon, 19 Sep 2016 13:55:41 +0800
In-Reply-To: <703024ec-f6d4-60e8-ed09-6a2e935857d7@xs4all.nl>
References: <1473340146-6598-1-git-send-email-minghsiu.tsai@mediatek.com>
         <703024ec-f6d4-60e8-ed09-6a2e935857d7@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2016-09-14 at 14:43 +0200, Hans Verkuil wrote:
> Hi Minghsiu,
> 
> v6 looks good, but I get these warnings when compiling it for i686:
> 
> linux-git-i686: WARNINGS
> 
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_handle_init_ack':
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:28:28: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
>                             ^
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_ipi_handler':
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:40:28: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
>                             ^
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_send_ap_ipi':
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:111:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   msg.ap_inst = (uint64_t)vpu;
>                 ^
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_init':
> /home/hans/work/build/media-git/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:129:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>   msg.ap_inst = (uint64_t)vpu;
>                 ^
> 
> This is not blocking, but if you can post a follow-up patch for this, then that
> would be helpful.
> 

Hi Hans,

I have duplicated this warning message in arch x86. 
I also got the report from kbuild robot. There are build errors in
mtk_mdp_pm_suspend().
Besides, in arch x86, I also have build warning messages in kzalloc()
and kfree() used in mtk_mdp_m2m.c. It can be fixed by including
linux/slab.h
I will upload the patches today.
Thanks


Ming Hsiu

> Regards,
> 
> 	Hans
> 
> 
> On 09/08/2016 03:09 PM, Minghsiu Tsai wrote:
> > Changes in v6:
> > - s_selection() can't set the _DEFAULT and _BOUNDS targets
> > - Add Maintainers entry
> > 
> > Changes in v5:
> > - Add ack in the comment of dts patch
> > - Fix s/g_selection()
> > - Separate format V4L2_PIX_FMT_MT21C into new patch  
> > 
> > Changes in v4:
> > - Add "depends on HAS_DMA" in Kconfig.
> > - Fix s/g_selection()
> > - Replace struct v4l2_crop with u32 and struct v4l2_rect
> > - Remove VB2_USERPTR
> > - Move mutex lock after ctx allocation in mtk_mdp_m2m_open()
> > - Add new format V4L2_PIX_FMT_YVU420 to support software on Android platform.
> > - Only width/height of image in format V4L2_PIX_FMT_MT21 is aligned to 16/16,
> >   other ones are aligned to 2/2 by default
> > 
> > Changes in v3:
> > - Modify device ndoe as structured one.
> > - Fix conflict in dts on Linux 4.8-rc1
> > 
> > Changes in v2:
> > - Add section to describe blocks function in dts-bindings
> > - Remove the assignment of device_caps in querycap()
> > - Remove format's name assignment
> > - Copy colorspace-related parameters from OUTPUT to CAPTURE
> > - Use m2m helper functions
> > - Fix DMA allocation failure
> > - Initialize lazily vpu instance in streamon()
> > 
> > ==============
> >  Introduction
> > ==============
> > 
> > The purpose of this series is to add the driver for Media Data Path HW embedded in the Mediatek's MT8173 SoC.
> > MDP is used for scaling and color space conversion.
> > 
> > It could convert V4L2_PIX_FMT_MT21 to V4L2_PIX_FMT_NV12M or V4L2_PIX_FMT_YUV420M.
> > 
> > NV12M/YUV420M/MT21 -> MDP -> NV12M/YUV420M
> > 
> > This patch series rely on MTK VPU driver in patch series "Add MT8173 Video Encoder Driver and VPU Driver"[1] and "Add MT8173 Video Decoder Driver"[2].
> > MDP driver rely on VPU driver to load, communicate with VPU.
> > 
> > Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
> > 
> > [1]https://patchwork.kernel.org/patch/9002171/
> > [2]https://patchwork.kernel.org/patch/9141245/
> > 
> > ==================
> >  Device interface
> > ==================
> > 
> > In principle the driver bases on v4l2 memory-to-memory framework:
> > it provides a single video node and each opened file handle gets its own private context with separate buffer queues. Each context consist of 2 buffer queues: OUTPUT (for source buffers) and CAPTURE (for destination buffers).
> > OUTPUT and CAPTURE buffer could be MMAP or DMABUF memory type.
> > 
> > v4l2-compliance test output:
> > v4l2-compliance SHA   : abc1453dfe89f244dccd3460d8e1a2e3091cbadb
> > 
> > Driver Info:
> >         Driver name   : mtk-mdp
> >         Card type     : soc:mdp
> >         Bus info      : platform:mt8173
> >         Driver version: 4.8.0
> >         Capabilities  : 0x84204000
> >                 Video Memory-to-Memory Multiplanar
> >                 Streaming
> >                 Extended Pix Format
> >                 Device Capabilities
> >         Device Caps   : 0x04204000
> >                 Video Memory-to-Memory Multiplanar
> >                 Streaming
> >                 Extended Pix Format
> > 
> > Compliance test for device /dev/image-proc0 (not using libv4l2):
> > 
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> > 
> > Allow for multiple opens:
> >         test second video open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
> >         test for unlimited opens: OK
> > 
> > Debug ioctls:
> >         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> >         test VIDIOC_LOG_STATUS: OK (Not Supported)
> > 
> > Input ioctls:
> >         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> >         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> >         test VIDIOC_ENUMAUDIO: OK (Not Supported)
> >         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
> >         test VIDIOC_G/S_AUDIO: OK (Not Supported)
> >         Inputs: 0 Audio Inputs: 0 Tuners: 0
> > 
> > Output ioctls:
> >         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> >         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> >         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> >         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> >         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> >         Outputs: 0 Audio Outputs: 0 Modulators: 0
> > 
> > Input/Output configuration ioctls:
> >         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> >         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> >         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> >         test VIDIOC_G/S_EDID: OK (Not Supported)
> > 
> >         Control ioctls:
> >                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> >                 test VIDIOC_QUERYCTRL: OK
> >                 test VIDIOC_G/S_CTRL: OK
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 5 Private Controls: 0
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK (Not Supported)
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 test VIDIOC_G_FMT: OK
> >                 test VIDIOC_TRY_FMT: OK
> >                 test VIDIOC_S_FMT: OK
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> >                 test Cropping: OK
> >                 test Composing: OK
> >                 test Scaling: OK
> > 
> >         Codec ioctls:
> >                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> >                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> > 
> >         Buffer ioctls:
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >                 test VIDIOC_EXPBUF: OK
> > 
> > Test input 0:
> > 
> > 
> > Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
> > 
> > Minghsiu Tsai (6):
> >   VPU: mediatek: Add mdp support
> >   dt-bindings: Add a binding for Mediatek MDP
> >   media: Add Mediatek MDP Driver
> >   arm64: dts: mediatek: Add MDP for MT8173
> >   media: mtk-mdp: support pixelformat V4L2_PIX_FMT_MT21C
> >   media: mtk-mdp: add Maintainers entry for Mediatek MDP driver
> > 
> >  .../devicetree/bindings/media/mediatek-mdp.txt     |  109 ++
> >  MAINTAINERS                                        |    9 +
> >  arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   84 ++
> >  drivers/media/platform/Kconfig                     |   17 +
> >  drivers/media/platform/Makefile                    |    2 +
> >  drivers/media/platform/mtk-mdp/Makefile            |    9 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.c      |  159 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_comp.h      |   72 ++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.c      |  294 +++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_core.h      |  260 ++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h       |  126 ++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       | 1278 ++++++++++++++++++++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h       |   22 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.c      |  156 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_regs.h      |   31 +
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c       |  145 +++
> >  drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h       |   41 +
> >  drivers/media/platform/mtk-vpu/mtk_vpu.h           |    5 +
> >  18 files changed, 2819 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt
> >  create mode 100644 drivers/media/platform/mtk-mdp/Makefile
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_comp.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_core.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_ipi.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_regs.h
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.h
> > 


