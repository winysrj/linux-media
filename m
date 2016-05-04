Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:13007 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757571AbcEDITx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 04:19:53 -0400
Message-ID: <1462349987.1891.5.camel@mtksdaap41>
Subject: Re: [PATCH v10 0/8] Add MT8173 Video Encoder Driver and VPU Driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Wed, 4 May 2016 16:19:47 +0800
In-Reply-To: <5729A57E.1080505@xs4all.nl>
References: <1462270287-11374-1-git-send-email-tiffany.lin@mediatek.com>
	 <5729A57E.1080505@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, 2016-05-04 at 09:32 +0200, Hans Verkuil wrote:
> Hi Tiffany,
> 
> On 05/03/2016 12:11 PM, Tiffany Lin wrote:
> > ==============
> >  Introduction
> > ==============
> > 
> > The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
> > Mediatek Video Codec is able to handle video encoding of in a range of formats.
> > 
> > This patch series also include VPU driver. Mediatek Video Codec driver rely on VPU driver to load,
> > communicate with VPU.
> > 
> > Internally the driver uses videobuf2 framework and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
> > This patch series need [PATCH v15 8/8] memory: mtk-smi: export mtk_smi_larb_get/put[1] to build as module
> > 
> > [1]http://lists.infradead.org/pipermail/linux-mediatek/2016-April/005173.html
> > 
> > ==================
> >  Device interface
> > ==================
> > 
> > In principle the driver bases on v4l2 memory-to-memory framework:
> > it provides a single video node and each opened file handle gets its own private context with separate
> > buffer queues. Each context consist of 2 buffer queues: OUTPUT (for source buffers, i.e. raw video
> > frames) and CAPTURE (for destination buffers, i.e. encoded video frames).
> > 
> > ==============================
> >  VPU (Video Processor Unit)
> > ==============================
> > The VPU driver for hw video codec embedded in Mediatek's MT8173 SOCs.
> > It is able to handle video decoding/encoding in a range of formats.
> > The driver provides with VPU firmware download, memory management and the communication interface between CPU and VPU.
> > For VPU initialization, it will create virtual memory for CPU access and physical address for VPU hw device access. 
> > When a decode/encode instance opens a device node, vpu driver will download vpu firmware to the device.
> > A decode/encode instant will decode/encode a frame using VPU interface to interrupt vpu to handle decoding/encoding jobs.
> > 
> > Please have a look at the code and comments will be very much appreciated.
> > 
> > Change in v10:
> > 1. Fix smatch/sparse error message
> > 2. Add depends on ARM || ARM64 and MTK_IOMMU in Kconfig
> 
> I don't like the ARM or ARM64 dependency since that makes COMPILE_TEST harder.
> 
> I removed it here and for the VPU and everything still compiles fine with
> sparse and smatch. So I'll drop those dependencies.
> 
> Why is the MTK_IOMMU dependency needed? Just curious.
> 
This is because we need MTK_IOMMU module to get dma continuous memory
for HW.

> Note that sparse still complains about this:
> 
> media-git/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c:261:24: warning: incorrect type in assignment (different base types)
> 
> I think this code should be rewritten. Something like this would work
> (if I understand the code correctly):
> 
> u32 tag = (bs_hdr_len << 5) | 0x10 | not_key;
> 
> ac_tag[0] = tag & 0xff;
> ac_tag[1] = (tag >> 8) & 0xff;
> ac_tag[2] = (tag >> 16) & 0xff;
> 
> It's perhaps a bit more verbose, but a lot easier to understand.
> 

> I'm accepting this driver but I'll remove the ARM || ARM64 dependency. Can
> you post a follow-up patch for this sparse warning?
> 

Got it. We will provide a patch to fix this.
I was curious why my sparse do not show this warning.
Is there any parameter I need to set except C=1?

best regards,
Tiffany

> Regards,
> 
> 	Hans
> 
> 
> > 
> > VPU part
> > 1. Fix smatch/sparse error message
> > 2. Use totalram_pages instead of max_pfn to decide VPU 4GB mode
> > 3. Protect variable "fw_load"
> > 4. Add depends on ARM || ARM64 in Kconfig
> > 
> > Change in v9:
> > 1. Rename idx in mtk_vcodec_ctx to id and curr_max_idx in mtk_vcodec_dev to id_counter.
> > 2. Refine fops_vcodec_open
> > 
> > VPU part
> > Merge Julia Lawall's fixes to "[PATCH v9 2/8] [media] VPU: mediatek: support Mediatek VPU"
> > 1.[PATCH] VPU: mediatek: fix simple_open.cocci warnings 
> > 2.[PATCH] VPU: mediatek: fix platform_no_drv_owner.cocci warnings
> > 
> > Change in v8:
> > 1. Refine indentation
> > 2. Refine colorspace information process vidioc_try_fmt_vid_out_mplane
> > 3. Remove instance_mask in mtk_vcodec_dev, use curr_max_idx for instance index
> > 4. Use kzalloc to allocate ctx
> > 5. Refine fops_vcodec_open
> > 
> > VPU Part
> > 1. Refine vpu_load_firmware
> > 
> > Change in v7:
> > 1. Rebase against the master branch of git://linuxtv.org/media_tree.git
> > 2. Add ycbcr_enc, quantization and xfer_func in try_fmt, g_fmt, s_fmt
> > 3. Merge h264_enc and vp8_enc to venc directory
> > 
> > Change in v6:
> > 1. Add synchronization access protect between irq handler and work thread
> > 2. Add DMA_ATTR_ALLOC_SINGLE_PAGES support
> > 3. S_FMT will return coded_width, coded_height, so user space could allocate correct size memory that HW required
> > 4. merge h264/vp8 enc ap and md32 ipi msg
> > 5. separate h264/vp8 enc gop_size and intra_period handle
> > 6. remove sizeimage relative code in work buffer function
> > 7. Refine makefile to build as an module
> > 8. Code clean up
> > 
> > VPU Part
> > 1. export symbols for building VPU as an module
> > 2. change function from "wait_event_interruptible_timeout" to "wait_event_timeout" since
> >    CPU needs to wait for ACK from VPU even if it was interrupted by a signal
> > 
> > v4l2-compliance test output:
> > localhost Encode # ./v4l2-compliance -d /dev/video1
> > Driver Info:
> >         Driver name   : mtk-vcodec-enc
> >         Card type     : platform:mt8173
> >         Bus info      : platform:mt8173
> >         Driver version: 4.4.0
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
> > Compliance test for device /dev/video1 (not using libv4l2):
> > 
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> > 
> > Allow for multiple opens:
> >         test second video open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
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
> >                 test VIDIOC_QUERYCTRL/MENU: OK
> >                 test VIDIOC_G/S_CTRL: OK
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 12 Private Controls: 0
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 test VIDIOC_G_FMT: OK
> >                 test VIDIOC_TRY_FMT: OK
> >                 test VIDIOC_S_FMT: OK
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 
> >         Codec ioctls:
> >                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> >                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> > 
> >         Buffer ioctls:
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >                 test VIDIOC_EXPBUF: OK
> > Total: 38, Succeeded: 38, Failed: 0, Warnings: 0
> > 
> > 
> > v4l2-compliance test output:
> > localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1
> >  
> > Change in v5:
> > Vcodec Part
> > 1. Pass checkpatch and v4l2-compliance test
> > 2. Remove unused g/s_selection for now
> > 3. add vidioc_g_parm support
> > 4. add vidioc_create_bufs and vidioc_prepare_buf support
> > 5. Remove instance check in fops_vcodec_open
> > 6. Fix comments for data structure and code
> > 7. Refine venc, venc_lt clock source name in devicetree and binding document
> > 8. Fix Author information and copyright information
> > 9. Refine code according to review comments
> > 
> > VPU Part
> > 
> > v4l2-compliance test output:
> > localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1
> > Driver Info:
> >         Driver name   : mtk-vcodec-enc
> >         Card type     : platform:mt8173
> >         Bus info      : platform:mt8173
> >         Driver version: 4.4.0
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
> > Compliance test for device /dev/video1 (not using libv4l2):
> > 
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> > 
> > Allow for multiple opens:
> >         test second video open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
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
> >                 test VIDIOC_QUERYCTRL/MENU: OK
> >                 test VIDIOC_G/S_CTRL: OK
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 12 Private Controls: 0
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 test VIDIOC_G_FMT: OK
> >                 test VIDIOC_TRY_FMT: OK
> >                 test VIDIOC_S_FMT: OK
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
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
> > 
> > Total: 38, Succeeded: 38, Failed: 0, Warnings: 0
> > 
> > 
> > Change in v4:
> > Vcodec Part
> > 1. Remove MTK_ENCODE_PARAM_SKIP_FRAME support
> > 2. Remove MTK_ENCODE_PARAM_FRAME_TYPE and change to use V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME[3]
> > 3. Refine Encoder HW clock source
> > 4. Refine debug log
> > 5. Add watchdog support
> > 6. With patch "media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32"[4],
> > v4l2-compliance test passed[5] in v4.4-rc5 
> > 
> > VPU Part
> > 1. These two patches were Acked-by: Rob Herring <robh <at> kernel.org> in v3
> >    [PATCH v3 1/8] dt-bindings: Add a binding for Mediatek Video Processor
> >    [PATCH v3 3/8] arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
> >    Because we were wrong about how the hardware works, there is no connection between VPU and IOMMU HW
> >    We remove VPU attaching to IOMMU
> > 2. Support VPU running on 4GB DRAM system
> > 3. Support VPU watchdog reset
> > 4. Refine for coding style 
> > 
> > [3]https://patchwork.linuxtv.org/patch/32670/
> > [4] https://patchwork.linuxtv.org/patch/32631/
> > [5]localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1
> > Driver Info:
> >         Driver name   : mtk-vcodec-en
> >         Card type     : platform:mt817
> >         Bus info      : platform:mt817
> >         Driver version: 4.4.0
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
> > Compliance test for device /dev/video1 (not using libv4l2):
> > 
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> > 
> > Allow for multiple opens:
> >         test second video open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
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
> >                 test VIDIOC_QUERYCTRL/MENU: OK
> >                 test VIDIOC_G/S_CTRL: OK
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 12 Private Controls: 0
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK (Not Supported)
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 test VIDIOC_G_FMT: OK
> >                 test VIDIOC_TRY_FMT: OK
> >                 test VIDIOC_S_FMT: OK
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 
> >         Codec ioctls:
> >                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> >                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> > 
> >         Buffer ioctls:
> >                 warn: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(475):
> > VIDIOC_CREATE_BUFS not supported
> >                 warn: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(475):
> > VIDIOC_CREATE_BUFS not supported
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> >                 test VIDIOC_EXPBUF: OK
> > 
> > Total: 38, Succeeded: 38, Failed: 0, Warnings: 2
> > 
> > Change in v3:
> > 1.Refine code to pass v4l2-compliance test, now it still has 2 issues 2.Refine code according to latest MTK
> > IOMMU patches[1] 3.Remove MFC51 specific CIDs and add MTK specific CIDs for for keyframe and
> >   skip I-frame
> > 4.Refine code according to review comments
> > 
> > Below is the v1.6 version v4l2-compliance report for the mt8173 encoder driver.
> > Now there are still 2 test fail in v1.6.
> > For VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF, we directly use v4l2_m2m_ioctl_* functions, but it still
> > fail. It pass in kernel 3.18 but fail in kernel 4.4.
> > We will try v1.8 in next version.
> > VIDIOC_EXPBUF is becuase we support all three memory types VB2_DMABUF, VB2_MMAP and VB2_USERPTR.
> > VIDIOC_EXPBUF only allowed when only VB2_MMAP supported.
> > localhost ~ # /usr/bin/v4l2-compliance -d /dev/video1 Driver Info:
> >         Driver name   : mtk-vcodec-en
> >         Card type     : platform:mt817
> >         Bus info      : platform:mt817
> >         Driver version: 4.4.0
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
> > Compliance test for device /dev/video1 (not using libv4l2):
> > 
> > Required ioctls:
> >         test VIDIOC_QUERYCAP: OK
> > 
> > Allow for multiple opens:
> >         test second video open: OK
> >         test VIDIOC_QUERYCAP: OK
> >         test VIDIOC_G/S_PRIORITY: OK
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
> >                 test VIDIOC_QUERYCTRL/MENU: OK
> >                 test VIDIOC_G/S_CTRL: OK
> >                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> >                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> >                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> >                 Standard Controls: 11 Private Controls: 2
> > 
> >         Format ioctls:
> >                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> >                 test VIDIOC_G/S_PARM: OK (Not Supported)
> >                 test VIDIOC_G_FBUF: OK (Not Supported)
> >                 test VIDIOC_G_FMT: OK
> >                 test VIDIOC_TRY_FMT: OK
> >                 test VIDIOC_S_FMT: OK
> >                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> > 
> >         Codec ioctls:
> >                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> >                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> >                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> > 
> >         Buffer ioctls:
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(266): vp->length
> > == 0
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(335):
> > buf.check(Unqueued, i)
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(420):
> > testQueryBuf(node, i, q.g_buffers())
> >                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> >                 fail: ../../../v4l-utils-1.6.0/utils/v4l2-compliance/v4l2-test-buffers.cpp(500): q.has_expbuf(node)
> >                 test VIDIOC_EXPBUF: FAIL
> > Total: 38, Succeeded: 36, Failed: 2, Warnings: 0
> > 
> > Change in v2:
> > Vcodec Part
> > 1.Remove common and include directory in mtk-vcodec 2.Refine vb2ops_venc_start_streaming and
> > vb2ops_venc_stop_streaming and state machine 3.Remove venc_if_init and venc_if_deinit 4.Refine
> > debug message 5.Refine lab and vpu decription in mediatek-vcodec.txt
> > 
> > VPU Part
> > 1. Modify VPU Kconfig
> > 2. Move encoder header files to other patch sets 3. Remove marcos for extended virtual/iova address 4.
> > Change register and variable names 5. Add a reference counter for VPU watchdog 6. Remove one busy waiting
> > in function vpu_ipi_send 7. Operate VPU clock in VPU driver (not called by encoder drivers) 8. Refine
> > memory mapping, firmware download and extended memory allocation/free functions 9. Release more
> > allocated resources in driver remove function
> > 
> > Andrew-CT Chen (3):
> >   dt-bindings: Add a binding for Mediatek Video Processor
> >   VPU: mediatek: support Mediatek VPU
> >   arm64: dts: mediatek: Add node for Mediatek Video Processor Unit
> > 
> > Tiffany Lin (5):
> >   dt-bindings: Add a binding for Mediatek Video Encoder
> >   vcodec: mediatek: Add Mediatek V4L2 Video Encoder Driver
> >   vcodec: mediatek: Add Mediatek VP8 Video Encoder Driver
> >   vcodec: mediatek: Add Mediatek H264 Video Encoder Driver
> >   arm64: dts: mediatek: Add Video Encoder for MT8173
> > 
> >  .../devicetree/bindings/media/mediatek-vcodec.txt  |   59 +
> >  .../devicetree/bindings/media/mediatek-vpu.txt     |   31 +
> >  arch/arm64/boot/dts/mediatek/mt8173.dtsi           |   62 +
> >  drivers/media/platform/Kconfig                     |   32 +
> >  drivers/media/platform/Makefile                    |    4 +
> >  drivers/media/platform/mtk-vcodec/Makefile         |   19 +
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  338 +++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1288 ++++++++++++++++++++
> >  drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h |   58 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  454 +++++++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c  |  137 +++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h  |   26 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.c    |   55 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |   27 +
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.c    |   94 ++
> >  .../media/platform/mtk-vcodec/mtk_vcodec_util.h    |   87 ++
> >  .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |  679 +++++++++++
> >  .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |  481 ++++++++
> >  drivers/media/platform/mtk-vcodec/venc_drv_base.h  |   62 +
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.c    |  113 ++
> >  drivers/media/platform/mtk-vcodec/venc_drv_if.h    |  163 +++
> >  drivers/media/platform/mtk-vcodec/venc_ipi_msg.h   |  210 ++++
> >  drivers/media/platform/mtk-vcodec/venc_vpu_if.c    |  237 ++++
> >  drivers/media/platform/mtk-vcodec/venc_vpu_if.h    |   61 +
> >  drivers/media/platform/mtk-vpu/Makefile            |    3 +
> >  drivers/media/platform/mtk-vpu/mtk_vpu.c           |  950 +++++++++++++++
> >  drivers/media/platform/mtk-vpu/mtk_vpu.h           |  162 +++
> >  27 files changed, 5892 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vcodec.txt
> >  create mode 100644 Documentation/devicetree/bindings/media/mediatek-vpu.txt
> >  create mode 100644 drivers/media/platform/mtk-vcodec/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_pm.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_intr.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_base.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_drv_if.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_ipi_msg.h
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.c
> >  create mode 100644 drivers/media/platform/mtk-vcodec/venc_vpu_if.h
> >  create mode 100644 drivers/media/platform/mtk-vpu/Makefile
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.c
> >  create mode 100644 drivers/media/platform/mtk-vpu/mtk_vpu.h
> > 


