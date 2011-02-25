Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42409 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1BYIWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 03:22:12 -0500
From: Abhilash Kesavan <a.kesavan@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ilho Lee <ilho215.lee@samsung.com>
Subject: [PATCH/RFC 0/5] [media] s5p-tvout: Add S5P TVOUT driver
Date: Fri, 25 Feb 2011 16:53:28 +0900
Message-Id: <1298620413-24182-1-git-send-email-a.kesavan@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch-set adds support for TV-OUT interface in the EXYNOS4 series of SoCs.
TVOUT includes the HDMI interface, analog TV interface, mixer and video
processor. This is a full-featured driver providing the following:

1) HDMI Support
2) Analog Support
3) Mixer Support
4) Video Processor Support
5) Hotplug Detect Support
6) HDCP Support
7) CEC Support
8) I2S/SPDIF Support

The driver is under development and needs major modifications, as mentioned
later in the TODO section, to conform to open source standards. Please have
a look at the driver design and offer any suggestions/comments.


I) HARDWARE

Video processor is responsible for video scaling, de-interlacing, and video post
processing of TVOUT data path. It reads reconstructed YCbCr video sequences from
DRAM, processes the sequence, and sends it to mixer on-the-fly. Input to VP is
NV12 and NV21 (Linear and tiled) format while the output to the mixer is YUV444.

Mixer overlaps or blends input data such as graphic, video, background and sends
the resulting data to the HDMI or analog TV interface. Along with the YUV444 in-
put from VP interface, the mixer can receive two RGB inputs. It allows for  layer
blending, alpha blending, chroma key, scaling etc.

HDMI interface supports 1.3 Tx subsystem V1.0 comprising an HDMI Tx core with
I2S input interface, CEC block, and HDCP key block. It receives YUV444 or RGB888
data from the mixer and converts it into HDMI packets. Supports a variety of
video formats varying from 480p to 1080p.

Analog TV interface supports ITU-R BT 470 and EIA-770 compliant analog TV
signals with 1 channel 10bit DAC. Supports PAL-m@60Hz, PAL-60@60Hz, NTSC@60Hz,
NTSC-443@60Hz, PAL@50Hz, PAL-n@50Hz and (M)NTSC@60Hz formats for composite
output.


II) S/W DESIGN

===============================================================================
        -----------------------------------------------------------------------
                                        VFS
        -----------------------------------------------------------------------
KERNEL       |                               |
             V                               V
        ----------                       --------            ------------------
        V4L2 STACK                       FB STACK            Linux Driver Model
        ----------                       --------            ------------------
             |                               |                        |
=============+===============================+========================+========
             |                               |                        |
             |                               |          +-------------|
             |                               |          |             |
             V                               V          V             |
      +---------------------------------------------------------------+-------+
      |                                                               |       |
      |                                                               |       |
      | ------------    -------------   -----------                   |       |
      |  Video Ctrl  -- Graphics Ctrl -- TVOUT I/F                    |       |
      | ------------    -------------   -----------                   V       |
      |      |               |             |    |__________       ----------- |
      |      |               |             |               |       HPD Driver |
      |      V               V             V               V        (GPIO)    |
      | -----------     -----------   -----------   -----------   ----------- |
      |     VP I/F       Mixer I/F     Analog I/F    HDMI I/F                 |
      | -----------     -----------   -----------   -----------               |
      |      |               |               |         |   |                  |
DEVICE|      |               |               |         |   |_______________   |
DRIVER|      |               |               |         |           |       |  |
      |      |               |               |         |           V       V  |
      |      |               |               |         |         -----  ------|
      |      |               |               |         |          CEC    HDCP |
      |      |               |               |         |         -----  ------|
      |      |               |               |         |___________|_______|  |
      |      |               |               |                                |
      +------+---------------+---------------+--------------------------------+
             |               |               |         |
             |               |               |         |
=============+===============+===============+=================================
             |               |               |         |
             V               V               V         |
        -----------     -----------     -----------    |         --------
            VP     ---->   Mixer   ----> TV Encoder ---+-------->   DAC
        -----------     -----------  |  -----------    |         --------
                                     |                 |
HARDWARE                             |                 V
                                     |           ----------      --------
                                     +----------> HDMI Link  --> HDMI PHY
                                                 ----------      --------
===============================================================================
Description:
1) S5P TVOUT driver is devided into control layer and interface layer. interface
layer accesses hardware register in TVOUT subsystem like video processor, mixer,
hdmi and sdo. and control layer controls each hardware IPs and communicates with
other control modules.
2) S5P TVOUT driver is composed of 3 kinds of drivers logically.
	- Video driver controls video processor and follows V4L2 interface
	- Graphic driver controls mixer and follows framebuffer interface
	- TV interface driver selects hdmi or analog TV interface and follows V4L2
	  interface
3) HPD(Hot-Plug Detection) driver is used for HDMI interface. It generates event
when plugging or unplugging HDMI cable.

4) CEC(Consumer Electronic Control) driver is also used for HDMI interface.
It can send signals like turning on/off from source to sink device.

III) CODE STRUCTURE

 +---------------------+	+--------------------------+
 |API 		       |	|Platform Drivers	   |
 |    s5p_tvout_v4l2.c |	|          s5p_tvout.c	   |
 |    s5p_tvout_fb.c   |	|          s5p_tvout_hpd.c |
 +---------------------+ 	|          s5p_tvout_cec.c |
				+--------------------------+

 +-----------------------+	+----------------------------+
 |CONTROL CLASS	 	 |	|COMMON			     |
 |	s5p_vp_ctrl.c    |	|     s5p_tvout_common_lib.c |
 |	s5p_mixer_ctrl.c |	+----------------------------+
 |	s5p_tvif_ctrl.c  |
 +-----------------------+

 +-----------------------------------------------------------+
 |HARDWARE INTERFACE					     |
 |	vp.c   mixer.c   cec.c   hdcp.c   hdmi.c   sdo.c     |
 +-----------------------------------------------------------+


Notes:
1) A hw_if interface sub-directory has been created to collect all the
APIs for accessing each of the IPs like VP, Mixer and HDMI. The sdo.c
file contains functions for TV Encoder + DAC.
2) The common library provides common memory allocator and run-time PM
APIs.
3) V4L2 callbacks for the s5p_tvout driver and fb registration & initi-
alization has been implemented in the two API files.
4) TV-OUT interface component has 3 classes. (tvif, hdmi, sdo)
	- tvif ctrl class: controls hdmi and sdo ctrl class.
	- hdmi ctrl class: contrls hdmi hardware by using hw_if/hdmi.c
	- sdo  ctrl class: contrls sdo hardware by using hw_if/sdo.c

                       +-----------------+
                       | tvif ctrl class |
                       +-----------------+
                              |   |
                   +----------+   +----------+             ctrl class layer
                   |                         |
                   V                         V
          +-----------------+       +-----------------+
          | sdo ctrl class  |       | hdmi ctrl class |
          +-----------------+       +-----------------+
                   |                         |
    ---------------+-------------------------+------------------------------
                   V                         V
          +-----------------+       +-----------------+
          |   hw_if/sdo.c   |       |   hw_if/hdmi.c  |         hw_if layer
          +-----------------+       +-----------------+
                   |                         |
    ---------------+-------------------------+------------------------------
                   V                         V
          +-----------------+       +-----------------+
          |   sdo hardware  |       |   hdmi hardware |          Hardware
          +-----------------+       +-----------------+


IV) APPLICATION FLOW

a) open "/dev/video14" node.
b) query device capabilities VIDIOC_QUERYCAP
c) set output device standard VIDIOC_S_STD
d) set output device VIDIOC_S_OUTPUT
e) Use CEC (if output is HDMI)
f) Enable/Disable HDCP
g) open "/dev/fb10" node.
h) configure attributes of graphics layer using fb such as pixel format,
window position, window size etc. FBIOPUT_VSCREENINFO
i) turn on the window FBIOBLANK_UNBLANK
j) open "/dev/video21" (overlay) node.
k) set source video plane parameters VIDIOC_S_FMT.
l) set source video data information VIDIOC_S_CROP
m) set destination (video plane of mixer) information VIDIOC_S_FBUF
n) set destination video overlay format VIDIO_S_FMT
o) start overlay VIDIOC_OVERLAY


V) MISCELLANEOUS

a) The driver has undergone HDMI compliance tests and has been verfied to be
HDMI 1.3 compliant.
b) The driver uses the framebuffer interface on mixer's graphic layer to 
support many customer requirements like a Xdriver.
c) All of the following video formats are supported by the HDMI driver: 480p@
59.94Hz/60Hz, 576p@50Hz, 720p@50Hz/59.94Hz/60Hz, 1080i@50Hz/59.94Hz/60Hz,
1080p@30Hz, 1080p@60Hz.
d) Support 1 video layer and 2 graphics layers, and blending of all 3 layers.


VI) TODO

a) Use the newer videobuf2 framework for buffer management.
b) Modify the tvout_fb code to be more in line with the framebuffer stack.

* NOTE: The arch/mach specific header files Will be added later.

[PATCH 1/5] [media] s5p-tvout: Add TVOUT core driver for S5P SoCs
[PATCH 2/5] [media] s5p-tvout: Add Graphic layer control for S5P TVOUT driver
[PATCH 3/5] [media] s5p-tvout: Add TVOUT interface control for S5P TVOUT driver
[PATCH 4/5] [media] s5p-tvout: Add CEC driver for S5P TVOUT
[PATCH 5/5] [media] s5p-tvout: Add HPD driver for S5P TVOUT
