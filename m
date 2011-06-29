Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22100 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755439Ab1F2Mvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:51:51 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ006FGYEDBO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ0017CYEC0G@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:48 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:09 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH v6 0/8]  TV drivers for Samsung S5P platform (media part)
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I would like to present the 6th version of TV drivers for Samsung S5P platform.
The most recent changes are:

1. The patch for TV drivers was separated into three patches.
- one patch for HDMI and HDMIPHY driver
- two patches respectively for SDO and Mixer

2. Number of fixes after Hans Verkuil's review.
- code cleanup, fixed upside-down function order
- merged PAL standards for SDO driver
- added colorspace support
- fixed setting caps bits
- fixed return values on errors
- add usage of v4l2_fh framework
- reduced debugging control to simple on/off switch in Kconfig
- marked drivers as experimental due to usage of OVERLAY buffer
  for cropping configuration

3. New API features.
- support for VIDIOC_G_DV_PRESET
- support for VIDIOC_G_STD
- support for VIDIOC_G_OUTPUT
- support for PRIORITY api
- drivers passed v4l2-compliance tests

4. Other fixes
- fixed hang-up problem on pm_runtime resume caused by resetting mixer while
  its clock's parent was off. The problem is caused by incorrect clock
  modelling for Samsung S5P platform
- fixed calculations of multiplane related fields
- fix in v4l_fill_dv_preset_info function
- added new callbacks to v4l2_subdev: g_tvnorms_output, g_dv_preset,
  g_std_output

Updated RFC for TV driver:

==============
 Introduction
==============

The purpose of this RFC is to discuss the driver for a TV output interface
available in upcoming Samsung SoC. The HW is able to generate digital and
analog signals. Current version of the driver supports only digital output.

Internally the driver uses videobuf2 framework, and DMA-CONTIG memory allocator.

======================
 Hardware description
======================

The SoC contains a few HW sub-blocks:

1. Video Processor (VP). It is used for processing of NV12 data.  An image
stored in RAM is accessed by DMA. Pixels are cropped, scaled. Additionally,
post processing operations like brightness, sharpness and contrast adjustments
could be performed. The output in YCbCr444 format is send to Mixer.

2. Mixer (MXR). The piece of hardware responsible for mixing and blending
multiple data inputs before passing it to an output device.  The MXR is capable
of handling up to three image layers. One is the output of VP.  Other two are
images in RGB format (multiple variants are supported).  The layers are scaled,
cropped and blended with background color.  The blending factor, and layers'
priority are controlled by MXR's registers. The output is passed either to HDMI
or SDO.

3. HDMI. The piece of HW responsible for generation of HDMI packets. It takes
pixel data from mixer and transforms it into data frames. The output is send
to HDMIPHY interface.

4. HDMIPHY. Physical interface for HDMI. Its duties are sending HDMI packets to
HDMI connector. Basically, it contains a PLL that produces source clock for
Mixer, VP and HDMI during streaming.

5. SDO. Generation of TV analog signal. The alternative output for the Mixer.
It receives data and passes it to VideoDAC. The SDO is responsible for timing
generation of analog TV signal. It supports multiple standards.

6. VideoDAC. Modulator for TVOUT signal. Receives data from SDO. Converts
it to analog domain. Next, the signal is modulated to CVBS format, amplified
and sent to Composite Connector.

The diagram below depicts connection between all HW pieces.
                    +-----------+
NV12 data ---dma--->|   Video   |
                    | Processor |
                    +-----------+
                          |
                          V
                    +-----------+
RGB data  ---dma--->|           |
                    |   Mixer   |
RGB data  ---dma--->|           |
                    +-----------+
                          |
                          * dmux
                         /
                  +-----*   *------+
                  |                |
                  V                V
            +-----------+    +-----------+
            |    HDMI   |    |    SDO    |
            +-----------+    +-----------+
                  |                |
                  V                V
            +-----------+    +-----------+
            |  HDMIPHY  |    |  VideoDAC |
            +-----------+    +-----------+
                  |                |
                  V                V
                HDMI           Composite
             connector         connector


==================
 Driver interface
==================

The posted driver implements three V4L2 nodes. Every video node implements V4L2
output buffer. One of nodes corresponds to input of Video Processor. The other
two nodes correspond to RGB inputs of Mixer. All nodes share the same output.
It is one of the Mixer's outputs: SDO or HDMI. Changing output in one layer
using S_OUTPUT would change outputs of all other video nodes. The same thing
happens if one try to reconfigure output i.e. by calling S_DV_PRESET. However
it not possible to change or reconfigure the output while streaming. To sum up,
all features in posted version of driver goes as follows:

1. QUERYCAP
2. S_FMT, G_FMT - multiplanar API, single planar modes must be emulated
  a) node named video0 supports formats NV12, NV21, NV12T (tiled version of
NV12), NV12MT (multiplane version of NV12T).
  b) nodes named graph0 and graph1 support formats RGB565, ARGB1555, ARGB4444,
ARGB8888.
3. Buffer with USERPTR and MMAP memory.
4. Streaming and buffer control. (STREAMON, STREAMOFF, REQBUF, QBUF, DQBUF)
5. OUTPUT configurations and enumeration using VIDIOC_{ENUM/S/G}_OUTPUT.
6. DV preset control (SET, GET, ENUM). Currently modes 480P59_94, 720P59_94,
1080P30, 1080P59_94 and 1080P60 work.
7. Analog standards using VIDIOC_{S_/G_/ENUM}STD. Modes PAL_N, PAL_Nc, PAL_M,
   PAL_60, NTSC_443, PAL_BGHID, NTSC_M are supported.
8. Positioning layer's window on output display using S_CROP, G_GROP, CROPCAP.
9. Positioning and cropping data in buffer using S_CROP, G_GROP, CROPCAP with
buffer type OVERLAY *. This is temporary interface and it is going to be
substituted by SELECTION api.
10. Support for priority api: VIDIOC_{G/S}_PRIORITY

TODOs:
- add control of alpha blending / chroma keying via V4L2 controls
- add controls for luminance curve and sharpness in VP
- consider exporting all output functionalities to separate video node
- consider media controller framework

* The need of cropping in source buffers came from problem with MFC driver for
S5P. The MFC supports only width divisible by 64. If a width of a decoded movie
is not aligned do 64 then padding pixels are filled with zeros. This is an ugly
green color in YCbCr colorspace. Filling it with zeros by a CPU is a waste of
resources since an image can be cropped in VP. Is it possible to set crops for
user data for M2M devices. V4L2 lacks such functionality of non-M2M devices.
Therefore cropping in buffer V4L2_BUF_TYPE_VIDEO_OVERLAY was used as an work
around.

=====================
 Device Architecture
=====================

Three drivers are added in this patch.

1. HDMIPHY. It is an I2C driver for HDMIPHY interface. It exports following
callback by V4L2 subdevice:
- s_power: currently stub
- s_stream: configures and starts/stops HDMIPHY
- s_dv_preset: used to choose proper frequency of clock for other TV devices

2. HDMI. The auxiliary driver used to control HDMI interface. It exports its
subdev in its private data for use by other drivers. The following callbacks are
implemented:
- s_power: runs HDMI hardware, regulators and clocks.
- s_stream: runs HDMIPHY and starts generation of video frames.
- enum_dv_presets
- s_dv_preset
- g_dv_preset: returns current preset used by HDMI
- g_mbus_format: returns information on data format expected by on HDMI input
  The driver supports an interrupt. It is used to detect plug/unplug events in
kernel debugs.  The API for detection of such an events in V4L2 API is to be
defined.

3. SDO. The auxiliary driver used to control analog TV. It also exports its
subdev for other drivers. The following callbacks are implemented.
- s_power: runs TV hardware, regulators and clocks.
- s_stream: runs TV clock and starts generation of video signal.
- s_std_output: set configuration of TV standard from one of PAL/NTSC family
- g_std_output: get current configuration of TV standard
- g_tvnorms_output: used by Mixer to obtain tv standards supported by SDO
- g_mbus_format: returns information on data format expected by on SDO input

5. Mixer & Video Processor driver. It is called 's5p-mixer' because of
historical reasons. It was decided combine VP and MXR drivers into one because
of shared interrupt and very similar interface via V4L2 nodes. The driver is a
realization of many-to-many relation between multiple input layers and multiple
outputs. All shared resources are kept in struct mxr_device. It provides
utilities for management and synchronization of access to resources and
reference counting. The outputs are obtained from HDMI/SDO private data.  One
layer is a single video node. Simple inheritance is applied because there only
little difference between layer's types. Every layer type implements set of
ops. There are different ops for Mixer layers and other for VP layer.

The videobuf2 framework was used for the management of buffers and streaming.
All other V4L2 ioctls are processed in layers common interface. The DMA-COHERENT
was used as memory allocator for Mixer's buffers. It could be easily exchanged
with any other allocator integrated with videobuf2 framework.

===============
 Usage summary
===============

Follow steps below to display double-buffered animation on output.
In order to use other output please use VIDIOC_S_OUTPUT.

01. Open video node named graph0.
02. S_FMT(type = OUTPUT, pixelformat = V4L2_PIX_FMT_RGB*, width, height, ...)
03. REQ_BUFS(type = OUTPUT, memory = MMAP, count = 2)
04. MMAP(type = OUTPUT, index = 0)
05. MMAP(type = OUTPUT, index = 1)
06. Fill buffer 0 with data
07. QBUF(type = OUTPUT, index = 0)
08. STREAM_ON(type = OUTPUT)
09. Fill buffer 1 with data
10. QBUF(type = OUTPUT, index = 1)
11. DQBUF(type = OUTPUT)
12. QBUF(type = OUTPUT, index = 0)
13. DQBUF(type = OUTPUT)
14. Goto 09

===============
 Patch Summary
===============

Tomasz Stanislawski (8):
  v4l: add macro for 1080p59_54 preset
  v4l: add g_tvnorms_output callback to V4L2 subdev
  v4l: add g_dv_preset callback to V4L2 subdev
  v4l: add g_std_output callback to V4L2 subdev
  v4l: fix v4l_fill_dv_preset_info function
  v4l: s5p-tv: add drivers for HDMI on Samsung S5P platform
  v4l: s5p-tv: add SDO driver for Samsung S5P platform
  v4l: s5p-tv: add TV Mixer driver for Samsung S5P platform

 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-tv/Kconfig           |   76 ++
 drivers/media/video/s5p-tv/Makefile          |   17 +
 drivers/media/video/s5p-tv/hdmi_drv.c        | 1043 ++++++++++++++++++++++++++
 drivers/media/video/s5p-tv/hdmiphy_drv.c     |  196 +++++
 drivers/media/video/s5p-tv/mixer.h           |  354 +++++++++
 drivers/media/video/s5p-tv/mixer_drv.c       |  487 ++++++++++++
 drivers/media/video/s5p-tv/mixer_grp_layer.c |  185 +++++
 drivers/media/video/s5p-tv/mixer_reg.c       |  541 +++++++++++++
 drivers/media/video/s5p-tv/mixer_video.c     | 1006 +++++++++++++++++++++++++
 drivers/media/video/s5p-tv/mixer_vp_layer.c  |  211 ++++++
 drivers/media/video/s5p-tv/regs-hdmi.h       |  141 ++++
 drivers/media/video/s5p-tv/regs-mixer.h      |  121 +++
 drivers/media/video/s5p-tv/regs-sdo.h        |   63 ++
 drivers/media/video/s5p-tv/regs-vp.h         |   88 +++
 drivers/media/video/s5p-tv/sdo_drv.c         |  479 ++++++++++++
 drivers/media/video/v4l2-common.c            |    3 +
 include/linux/videodev2.h                    |    1 +
 include/media/v4l2-subdev.h                  |   12 +
 20 files changed, 5027 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/Kconfig
 create mode 100644 drivers/media/video/s5p-tv/Makefile
 create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
 create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer.h
 create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
 create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
 create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
 create mode 100644 drivers/media/video/s5p-tv/regs-mixer.h
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c

-- 
1.7.5.4
