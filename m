Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:51623 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752760AbdDJIzQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 04:55:16 -0400
Subject: Re: [PATCH v3 0/8] Add support for DCMI camera interface of
 STMicroelectronics STM32 SoC series
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1491320678-17246-1-git-send-email-hugues.fruchet@st.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <695c96ef-afbf-da4c-d9b3-7ce16067f7c0@xs4all.nl>
Date: Mon, 10 Apr 2017 10:55:08 +0200
MIME-Version: 1.0
In-Reply-To: <1491320678-17246-1-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/04/2017 05:44 PM, Hugues Fruchet wrote:
> This patchset introduces a basic support for Digital Camera Memory Interface
> (DCMI) of STMicroelectronics STM32 SoC series.
> 
> This first basic support implements RGB565 & YUV frame grabbing.
> Cropping and JPEG support will be added later on.
> 
> This has been tested on STM324x9I-EVAL evaluation board embedding
> an OV2640 camera sensor.
> 
> This driver depends on:
>   - [PATCHv6 00/14] atmel-isi/ov7670/ov2640: convert to standalone drivers http://www.spinics.net/lists/linux-media/msg113480.html
> 
> ===========
> = history =
> ===========
> version 3:
>   - stm32-dcmi: Add "Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>"
>   - dt-bindings: Fix remarks from Rob Herring:
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg110956.html
> 
> version 2:
>   - Fix a Kbuild warning in probe:
>     http://www.mail-archive.com/linux-media@vger.kernel.org/msg110678.html
>   - Fix a warning in dcmi_queue_setup()
>   - dt-bindings: warn on sensor signals level inversion in board example
>   - Typos fixing
> 
> version 1:
>   - Initial submission
> 
> ===================
> = v4l2-compliance =
> ===================
> Below is the v4l2-compliance report for this current version of the DCMI camera interface.
> v4l2-compliance has been built from v4l-utils-1.12.3.

Please test with 'v4l2-compliance -s -f' as well and mail me the output of
that test.

Once you have the Acks for the DT/bindings patches just let me know and I'll
make a pull request.

Regards,

	Hans

> 
> v4l2-compliance SHA   : f5f45e17ee98a0ebad7836ade2b34ceec909d751
> 
> Driver Info:
>         Driver name   : stm32-dcmi
>         Card type     : STM32 Digital Camera Memory Int
>         Bus info      : platform:dcmi
>         Driver version: 4.11.0
>         Capabilities  : 0x85200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
>                 Device Capabilities
>         Device Caps   : 0x05200001
>                 Video Capture
>                 Read/Write
>                 Streaming
>                 Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
>         test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
>         test second video open: OK
>         test VIDIOC_QUERYCAP: OK
>         test VIDIOC_G/S_PRIORITY: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>         test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 3 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK (Not Supported)
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 test VIDIOC_TRY_FMT: OK
>                 test VIDIOC_S_FMT: OK
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
>         Codec ioctls:
>                 test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>                 test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>                 test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
>         Buffer ioctls:
>                 test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>                 test VIDIOC_EXPBUF: OK
> 
> Test input 0:
> 
> Streaming ioctls:
>         test read/write: OK
>         test MMAP: OK
>         test USERPTR: OK (Not Supported)
>         test DMABUF: Cannot test, specify --expbuf-device
> 
> 
> Total: 46, Succeeded: 46, Failed: 0, Warnings: 0
> 
> Hugues Fruchet (8):
>   dt-bindings: Document STM32 DCMI bindings
>   [media] stm32-dcmi: STM32 DCMI camera interface driver
>   ARM: dts: stm32: Enable DCMI support on STM32F429 MCU
>   ARM: dts: stm32: Enable DCMI camera interface on STM32F429-EVAL board
>   ARM: dts: stm32: Enable STMPE1600 gpio expander of STM32F429-EVAL
>     board
>   ARM: dts: stm32: Enable OV2640 camera support of STM32F429-EVAL board
>   ARM: configs: stm32: STMPE1600 GPIO expander
>   ARM: configs: stm32: DCMI + OV2640 camera support
> 
>  .../devicetree/bindings/media/st,stm32-dcmi.txt    |   46 +
>  arch/arm/boot/dts/stm32429i-eval.dts               |   56 +
>  arch/arm/boot/dts/stm32f429.dtsi                   |   37 +
>  arch/arm/configs/stm32_defconfig                   |    9 +
>  drivers/media/platform/Kconfig                     |   12 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/stm32/Makefile              |    1 +
>  drivers/media/platform/stm32/stm32-dcmi.c          | 1419 ++++++++++++++++++++
>  8 files changed, 1582 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-dcmi.txt
>  create mode 100644 drivers/media/platform/stm32/Makefile
>  create mode 100644 drivers/media/platform/stm32/stm32-dcmi.c
> 
