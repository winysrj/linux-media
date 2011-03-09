Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48887 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab1CIMQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 07:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <001b01cbde53$1ee09e40$5ca1dac0$%kim@samsung.com>
References: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
	<001b01cbde53$1ee09e40$5ca1dac0$%kim@samsung.com>
Date: Wed, 9 Mar 2011 21:16:26 +0900
Message-ID: <AANLkTim6KaB=MGqTEkXwScit12YSv7k=tuB=rn3Tb05a@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] HDMI driver for Samsung S5PV310 platform
From: Kyungmin Park <kmpark@infradead.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Mar 9, 2011 at 9:11 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Hi all,
>
> As I know, S5P-TV(HDMI) stuff needs more discussion.
>
> I don't want to just merge platform devices which is not used anywhere.

> Besides, there are two schemes for it in mailing list now.
It's different one, which scheme is used at multimedia, platform
devices are same.
>
> I think we have to improve this next time and need to focus more on its
> driver now.

As you said, arch supports the platform devices, we focus on only driver itself.
>
> Thanks.
>
> Best regards,
> Kgene.
> --
> Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> SW Solution Development Team, Samsung Electronics Co., Ltd.
>
> Tomasz Stanislawski wrote:
>>
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> Hello,
>>
>> I would like to present the second version of HDMI driver for S5PC210
>> platform.
>> The driver is under a heavy development. The most recent changes are:
>>
>> 1. Minor bugs and fixes:
>> - pink line on left side of display
>> - premature start of VP's streaming
>> - usage of free memory
>> - usage of non-initialized variables
>> - fixed sequence of power setup
>> - dependencies in Kconfig
>>
>> 2. Integration with Runtime Power Managment and Power Domain driver.
>>
>> 3. The CMA was substituted by the SYSMMU driver.
>>
>> 4. Applying existing frameworks:
>> - activation of HDMIPHY using clock API
>> - control of power on HDMI-5V pin using regulator API
>>
>> 5. Moving all clocks and regulator management from platform to the
> drivers'
>> code.
>>
>> 6. Redesigned the control of mixer's debugging.
>>
>> 7. Added a watchdog to deal with HW failures.
>>
>> Original HDMI driver RFC:
>>
>> ==============
>>  Introduction
>> ==============
>>
>> The purpose of this RFC is to discuss the driver for a TV output interface
>> available in upcoming Samsung SoC. The HW is able to generate digital and
>> analog signals. Current version of the driver supports only digital
> output.
>>
>> Internally the driver uses videobuf2 framework, and CMA memory allocator.
>> Not
>> all of them are merged by now, but I decided to post the sources to start
>> discussion driver's design.
>>
>> ======================
>>  Hardware description
>> ======================
>>
>> The SoC contains a few HW sub-blocks:
>>
>> 1. Video Processor (VP). It is used for processing of NV12 data.  An image
>> stored in RAM is accessed by DMA. Pixels are cropped, scaled.
> Additionally,
>> post processing operations like brightness, sharpness and contrast
>> adjustments
>> could be performed. The output in YCbCr444 format is send to Mixer.
>>
>> 2. Mixer (MXR). The piece of hardware responsible for mixing and blending
>> multiple data inputs before passing it to an output device.  The MXR is
>> capable
>> of handling up to three image layers. One is the output of VP.  Other two
> are
>> images in RGB format (multiple variants are supported).  The layers are
>> scaled,
>> cropped and blended with background color.  The blending factor, and
> layers'
>> priority are controlled by MXR's registers. The output is passed either to
>> HDMI
>> or TVOUT.
>>
>> 3. HDMI. The piece of HW responsible for generation of HDMI packets. It
> takes
>> pixel data from mixer and transforms it into data frames. The output is
> send
>> to HDMIPHY interface.
>>
>> 4. HDMIPHY. Physical interface for HDMI. Its duties are sending HDMI
> packets
>> to
>> HDMI connector. Basically, it contains a PLL that produces source clock
> for
>> Mixer, VP and HDMI during streaming.
>>
>> 5. TVOUT. Generation of TV analog signal. (driver not implemented)
>>
>> 6. VideoDAC. Modulator for TVOUT signal. (driver not implemented)
>>
>>
>> The diagram below depicts connection between all HW pieces.
>>                     +-----------+
>> NV12 data ---dma--->|   Video   |
>>                     | Processor |
>>                     +-----------+
>>                           |
>>                           V
>>                     +-----------+
>> RGB data  ---dma--->|           |
>>                     |   Mixer   |
>> RGB data  ---dma--->|           |
>>                     +-----------+
>>                           |
>>                           * dmux
>>                          /
>>                   +-----*   *------+
>>                   |                |
>>                   V                V
>>             +-----------+    +-----------+
>>             |    HDMI   |    |   TVOUT   |
>>             +-----------+    +-----------+
>>                   |                |
>>                   V                V
>>             +-----------+    +-----------+
>>             |  HDMIPHY  |    |  VideoDAC |
>>             +-----------+    +-----------+
>>                   |                |
>>                   V                V
>>                 HDMI           Composite
>>              connector         connector
>>
>>
>> ==================
>>  Driver interface
>> ==================
>>
>> The posted driver implements three V4L2 nodes. Every video node implements
>> V4L2
>> output buffer. One of nodes corresponds to input of Video Processor. The
>> other
>> two nodes correspond to RGB inputs of Mixer. All nodes share the same
> output.
>> It is one of the Mixer's outputs: TVOUT or HDMI. Changing output in one
> layer
>> using S_OUTPUT would change outputs of all other video nodes. The same
> thing
>> happens if one try to reconfigure output i.e. by calling S_DV_PRESET.
> However
>> it not possible to change or reconfigure the output while streaming. To
> sum
>> up,
>> all features in posted version of driver goes as follows:
>>
>> 1. QUERYCAP
>> 2. S_FMT, G_FMT - single and multiplanar API
>>   a) node named video0 supports formats NV12, NV12, NV12T (tiled version
> of
>> NV12), NV12MT (multiplane version of NV12T).
>>   b) nodes named graph0 and graph1 support formats RGB565, ARGB1555,
> ARGB4444,
>> ARGB8888.
>> 3. Buffer with USERPTR and MMAP memory.
>> 4. Streaming and buffer control. (STREAMON, STREAMOFF, REQBUF, QBUF,
> DQBUF)
>> 5. OUTPUT enumeration.
>> 6. DV preset control (SET, GET, ENUM). Currently modes 480P59_94,
> 720P59_94,
>> 1080P30, 1080P59_94 and 1080P60 work.
>> 7. Positioning layer's window on output display using S_CROP, G_GROP,
> CROPCAP.
>> 8. Positioning and cropping data in buffer using S_CROP, G_GROP, CROPCAP
> with
>> buffer type OVERLAY. *
>>
>> TODOs:
>> - add analog TVOUT driver
>> - add S_OUTPUT
>> - add S_STD ioctl
>> - add control of alpha blending / chroma keying via V4L2 controls
>> - add controls for luminance curve and sharpness in VP
>> - consider exporting all output functionalities to separate video node
>> - consider media controller framework
>> - better control over debugging
>> - fix dependency between all TV drivers
>>
>> * The need of cropping in source buffers came from problem with MFC driver
>> for
>> S5P. The MFC supports only width divisible by 64. If a width of a decoded
>> movie
>> is not aligned do 64 then padding pixels are filled with zeros. This is an
>> ugly
>> green color in YCbCr colorspace. Filling it with zeros by a CPU is a waste
> of
>> resources since an image can be cropped in VP. Is it possible to set crops
>> for
>> user data for M2M devices. V4L2 lacks such functionality of non-M2M
> devices.
>> Therefore cropping in buffer V4L2_BUF_TYPE_VIDEO_OVERLAY was used as an
> work
>> around.
>>
>> =====================
>>  Device Architecture
>> =====================
>>
>> Three drivers are added in this patch.
>>
>> 1. HDMIPHY. It is an I2C driver for HDMIPHY interface. It exports
> following
>> callback by V4L2 subdevice:
>> - s_power: currently stub
>> - s_stream: configures and starts/stops HDMIPHY
>> - s_dv_preset: used to choose proper frequency of clock for other TV
> devices
>>
>> 2. HDMI. The auxiliary driver used to control HDMI interface. It exports
> its
>> subdev to a subdev pool for use by other drivers. The following callbacks
> are
>> implemented:
>> - s_power: runs HDMI hardware, regulators and clocks.
>> - s_stream: runs HDMIPHY and starts generation of video frames.
>> - enum_dv_presets
>> - s_dv_preset
>> - g_mbus_format: returns information on data format expected by on HDMI
> input
>>   The driver supports an interrupt. It is used to detect plug/unplug
> events
>> in
>> kernel debugs.  The API for detection of such an events in V4L2 API is to
> be
>> defined.
>>
>> 3. Mixer & Video Processor driver. It is called 's5p-mixer' because of
>> historical reasons. It was decided combine VP and MXR drivers into one
>> because
>> of shared interrupt and very similar interface via V4L2 nodes. The driver
> is
>> a
>> realization of many-to-many relation between multiple input layers and
>> multiple
>> outputs. All shared resources are kept in struct mxr_device. It provides
>> utilities for management and synchronization of access to resources and
>> reference counting. The outputs are obtained from subdev pool basing on
> names
>> supplied in platform data. One layer is a single video node. Since layers
>> differs simple inheritance is applied. Every layer type implements set of
> ops.
>> There are different ops for Mixer layers and other for VP layer.
>>
>> The videobuf2 framework was used for the management of buffers and
> streaming.
>> All other V4L2 ioctls are processed in layers common interface. The CMA
> was
>> used as memory allocator for Mixer's buffers. It could be easily exchanged
>> with
>> any other allocator integrated with videobuf2 framework.
>>
>> Driver is not yet integrated with power domain driver. Moreover one of
>> mixer's
>> clocks has to change parent while entering streaming mode. Therefore all
>> power
>> and clock management was moved to platform data until final solutions
> emerges.
>>
>> ===============
>>  Usage summary
>> ===============
>>
>> Follow steps below to display double-buffered animation on HDMI output.
>>
>> 01. Open video node named graph0.
>> 02. S_FMT(type = OUTPUT, pixelformat = V4L2_PIX_FMT_RGB*, width, height,
> ...)
>> 03. REQ_BUFS(type = OUTPUT, memory = MMAP, count = 2)
>> 04. MMAP(type = OUTPUT, index = 0)
>> 05. MMAP(type = OUTPUT, index = 1)
>> 06. Fill buffer 0 with data
>> 07. QBUF(type = OUTPUT, index = 0)
>> 08. STREAM_ON(type = OUTPUT)
>> 09. Fill buffer 1 with data
>> 10. QBUF(type = OUTPUT, index = 1)
>> 11. DQBUF(type = OUTPUT)
>> 12. QBUF(type = OUTPUT, index = 0)
>> 13. DQBUF(type = OUTPUT)
>> 14. Goto 09
>>
>> ===============
>>  Patch Summary
>> ===============
>>
>> Tomasz Stanislawski (6):
>>   i2c-s3c2410: fix I2C dedicated for hdmiphy
>>   universal: i2c: add I2C controller 8 (HDMIPHY)
>>   v4l: add macro for 1080p59_54 preset
>>   s5p-tv: add driver for HDMI output on S5PC210 platform
>>   s5pv310: add s5p-tv to platform devices
>>   s5pv310: add s5p-tv to Universal C210 board
>>
>>  arch/arm/mach-s5pv310/Kconfig                   |    7 +
>>  arch/arm/mach-s5pv310/Makefile                  |    1 +
>>  arch/arm/mach-s5pv310/clock.c                   |  138 ++-
>>  arch/arm/mach-s5pv310/dev-tv.c                  |  103 ++
>>  arch/arm/mach-s5pv310/include/mach/irqs.h       |    8 +
>>  arch/arm/mach-s5pv310/include/mach/map.h        |   27 +
>>  arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
>>  arch/arm/mach-s5pv310/include/mach/regs-pmu.h   |    2 +
>>  arch/arm/mach-s5pv310/mach-universal_c210.c     |   54 +
>>  arch/arm/plat-samsung/Kconfig                   |    5 +
>>  arch/arm/plat-samsung/Makefile                  |    1 +
>>  arch/arm/plat-samsung/dev-i2c8.c                |   68 +
>>  arch/arm/plat-samsung/include/plat/devs.h       |    3 +
>>  arch/arm/plat-samsung/include/plat/iic.h        |    1 +
>>  arch/arm/plat-samsung/include/plat/tv.h         |   26 +
>>  drivers/i2c/busses/i2c-s3c2410.c                |   36 +-
>>  drivers/media/video/Kconfig                     |    8 +
>>  drivers/media/video/Makefile                    |    1 +
>>  drivers/media/video/s5p-tv/Kconfig              |   58 +
>>  drivers/media/video/s5p-tv/Makefile             |   15 +
>>  drivers/media/video/s5p-tv/hdmi.h               |   74 +
>>  drivers/media/video/s5p-tv/hdmi_drv.c           |  963 ++++++++++++
>>  drivers/media/video/s5p-tv/hdmiphy_drv.c        |  247 +++
>>  drivers/media/video/s5p-tv/mixer.h              |  314 ++++
>>  drivers/media/video/s5p-tv/mixer_drv.c          |  487 ++++++
>>  drivers/media/video/s5p-tv/mixer_grp_layer.c    |  180 +++
>>  drivers/media/video/s5p-tv/mixer_reg.c          |  523 +++++++
>>  drivers/media/video/s5p-tv/mixer_reg.h          |   44 +
>>  drivers/media/video/s5p-tv/mixer_video.c        |  863 +++++++++++
>>  drivers/media/video/s5p-tv/mixer_vp_layer.c     |  201 +++
>>  drivers/media/video/s5p-tv/regs-hdmi.h          | 1849
>> +++++++++++++++++++++++
>>  drivers/media/video/s5p-tv/regs-vmx.h           |  196 +++
>>  drivers/media/video/s5p-tv/regs-vp.h            |  277 ++++
>>  drivers/media/video/v4l2-common.c               |    1 +
>>  include/linux/videodev2.h                       |    1 +
>>  35 files changed, 6783 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/arm/mach-s5pv310/dev-tv.c
>>  create mode 100644 arch/arm/plat-samsung/dev-i2c8.c
>>  create mode 100644 arch/arm/plat-samsung/include/plat/tv.h
>>  create mode 100644 drivers/media/video/s5p-tv/Kconfig
>>  create mode 100644 drivers/media/video/s5p-tv/Makefile
>>  create mode 100644 drivers/media/video/s5p-tv/hdmi.h
>>  create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
>>  create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
>>  create mode 100644 drivers/media/video/s5p-tv/mixer.h
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_reg.h
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
>>  create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
>>  create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
>>  create mode 100644 drivers/media/video/s5p-tv/regs-vmx.h
>>  create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
>>
>> --
>> 1.7.1.569.g6f426
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
