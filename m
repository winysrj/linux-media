Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:60914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbeK3J5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 04:57:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yong Zhi <yong.zhi@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        tfiga@chromium.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        rajmohan.mani@intel.com, jian.xu.zheng@intel.com,
        jerry.w.hu@intel.com, tuukka.toivonen@intel.com,
        tian.shu.qiu@intel.com, bingbu.cao@intel.com
Subject: Re: [PATCH v7 02/16] doc-rst: Add Intel IPU3 documentation
Date: Fri, 30 Nov 2018 00:50:36 +0200
Message-ID: <10308698.8BjB4BRxet@avalon>
In-Reply-To: <1540851790-1777-3-git-send-email-yong.zhi@intel.com>
References: <1540851790-1777-1-git-send-email-yong.zhi@intel.com> <1540851790-1777-3-git-send-email-yong.zhi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Yong,

Thank you for the patch.

On Tuesday, 30 October 2018 00:22:56 EET Yong Zhi wrote:
> From: Rajmohan Mani <rajmohan.mani@intel.com>
> 
> This patch adds the details about the IPU3 Imaging Unit driver.

Strictly speaking this documents both the CIO2 and the IMGU. As they're 
handled by two separate drivers, should they be split in two separate files ? 
If you prefer keeping them together you should update the commit message 
accordingly. I would in that case also split the documentation in a CIO2 and a 
IMGU section in the file, instead of mixing them.

> Change-Id: I560cecf673df2dcc3ec72767cf8077708d649656

The Change-Id: tag isn't suitable for mainline, you can drop it.

> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
>  Documentation/media/v4l-drivers/index.rst |   1 +
>  Documentation/media/v4l-drivers/ipu3.rst  | 326 +++++++++++++++++++++++++++
>  2 files changed, 327 insertions(+)
>  create mode 100644 Documentation/media/v4l-drivers/ipu3.rst
> 
> diff --git a/Documentation/media/v4l-drivers/index.rst
> b/Documentation/media/v4l-drivers/index.rst index 679238e..179a393 100644
> --- a/Documentation/media/v4l-drivers/index.rst
> +++ b/Documentation/media/v4l-drivers/index.rst
> @@ -44,6 +44,7 @@ For more details see the file COPYING in the source
> distribution of Linux. davinci-vpbe
>  	fimc
>  	imx
> +	ipu3
>  	ivtv
>  	max2175
>  	meye
> diff --git a/Documentation/media/v4l-drivers/ipu3.rst
> b/Documentation/media/v4l-drivers/ipu3.rst new file mode 100644
> index 0000000..045bf42
> --- /dev/null
> +++ b/Documentation/media/v4l-drivers/ipu3.rst
> @@ -0,0 +1,326 @@
> +.. include:: <isonum.txt>
> +
> +===============================================================
> +Intel Image Processing Unit 3 (IPU3) Imaging Unit (ImgU) driver
> +===============================================================
> +
> +Copyright |copy| 2018 Intel Corporation
> +
> +Introduction
> +============
> +
> +This file documents Intel IPU3 (3rd generation Image Processing Unit)
> Imaging

s/documents Intel/documents the Intel/

> +Unit driver located under drivers/media/pci/intel/ipu3.
> +
> +The Intel IPU3 found in certain Kaby Lake (as well as certain Sky Lake)
> +platforms (U/Y processor lines) is made up of two parts namely Imaging Unit
> +(ImgU) and CIO2 device (MIPI CSI2 receiver).

s/namely Imaging Unit/, namely the Imaging Unit/
s/and CIO2/and the CIO2/

> +
> +The CIO2 device receives the raw bayer data from the sensors and outputs
> the +frames in a format that is specific to IPU3 (for consumption by IPU3
> ImgU).

s/to IPU3/to the IPU3/
s/by IPU3/by the IPU3/

> +CIO2 driver is available as drivers/media/pci/intel/ipu3/ipu3-cio2*
> and is +enabled through the CONFIG_VIDEO_IPU3_CIO2 config option.

s/CIO2 driver/The CIO2 driver/

> +
> +The Imaging Unit (ImgU) is responsible for processing images captured

s/images/the images/

> +through IPU3 CIO2 device. The ImgU driver sources can be found under

s/IPU3 CIO2/the IPU3 CIO2/

> +drivers/media/pci/intel/ipu3 directory. The driver is enabled through the
> +CONFIG_VIDEO_IPU3_IMGU config option.
> +
> +The two driver modules are named ipu3-csi2 and ipu3-imgu, respectively.
> +
> +The driver has been tested on Kaby Lake platforms (U/Y processor lines).

I assume both drivers have been tested, so I would write

s/The driver has/The drivers have/

> +The driver implements V4L2, Media controller and V4L2 sub-device
> interfaces.

As this is true for both drivers,

s/The driver implements V4L2/Both drivers implement the V4L2/
s/Media controller/Media Controller/

> +Camera sensors that have CSI-2 bus, which are connected to the IPU3 CIO2
> +device are supported.

I would rephrase this slightly, as "The IPU3 CIO2 driver supports camera 
sensors connected to the CIO2 MIPI CSI-2 interfaces through V4L2 sub-device 
sensor drivers."

> Support for lens and flash drivers depends on the
> +above sensors.

That's a very good introduction !

I would follow with two sections, "IPU3 CIO2" followed by "IPU3 ImgU".

> +ImgU device nodes
> +=================
> +
> +The ImgU is represented as two V4L2 subdevs, each of which provides a V4L2
> +subdev interface to the user space.

Not just subdevs, but video nodes too. I would rephrase as follows (please 
note that this might not be valid .rst content, I haven't tried compiling it, 
it might need to be reworked slightly) :

"The ImgU contains two independent pipes, each modelled as a V4L2 sub-device 
exposed to userspace as a V4L2 sub-device node.

Each pipe has two input pads and three output pads for the following purpose:

Pad 0 (input): Input raw video stream
Pad 1 (input): Processing parameters
Pad 2 (output): Output processed video stream
Pad 3 (output): Output viewfinder video stream
Pad 4 (output): 3A statistics

Each pad is connected to a corresponding V4L2 video interface, exposed to 
userspace as a V4L2 video device node."

> +Each V4L2 subdev represents a pipe, which can support a maximum of 2
> +streams. A private ioctl can be used to configure the mode (video or still)
> +of the pipe.
> +
> +This helps to support advanced camera features like Continuous View Finder
> +(CVF) and Snapshot During Video(SDV).

As far as I know there's no private ioctl anymore, at least I can't find it in 
the source code. Could you thus rephrase that sentence and the next one to 
explain the current method to implement CVF and SDV ?

> +CIO2 device
> +===========
> +
> +The CIO2 is represented as a single V4L2 subdev, which provides a V4L2
> subdev +interface to the user space. There is a video node for each CSI-2
> receiver, +with a single media controller interface for the entire device.

Similarly, I think we should explain here that there are four channels :

"The CIO2 contains four independent capture channel, each with its own MIPI 
CSI-2 receiver and DMA engine. Each channel is modelled as a V4L2 sub-device 
exposed to userspace as a V4L2 sub-device node and has two pads:

Pad 0 (input): MIPI CSI-2 input, connected to the sensor subdev
Pad 1 (output): Raw video capture, connected to the V4L2 video interface

The V4L2 video interfaces model the DMA engines. They are exposed to userspace 
as V4L2 video device nodes."

The section should be moved above the IPU3 ImgU section.

> +Media controller
> +----------------
> +
> +The media device interface allows to configure the ImgU links, which
> defines +the behavior of the IPU3 firmware.

s/defines/define/ or possibly better s/defines/control/

> +
> +Device operation
> +----------------
> +
> +With IPU3, once the input video node ("ipu3-imgu 0/1":0,
> +in <entity>:<pad-number> format) is queued with buffer (in packed raw bayer

s/bayer/Bayer/

> +format), IPU3 ISP starts processing the buffer and produces the video

s/IPU3 ISP/the IPU3 ISP/

This is the first time you mention an ISP. Should the term ISP be replaced by 
ImgU here and below ? I'm fine keeping it, but it should then be defined in 
the introduction, in particular with an explanation of the difference between 
ImgU and ISP.

> output +in YUV format and statistics output on respective output nodes. The
> driver +is expected to have buffers ready for all of parameter, output and
> +statistics nodes, when input video node is queued with buffer.

Why is that, shouldn't the driver wait for all necessary buffers to be ready 
before processing ?

> +At a minimum, all of input, main output, 3A statistics and viewfinder
> +video nodes should be enabled for IPU3 to start image processing.

If they all need to be enabled, shouldn't the respective links be ENABLED and 
IMMUTABLE ?

> +Each ImgU V4L2 subdev has the following set of video nodes.
> +
> +input, output and viewfinder video nodes
> +----------------------------------------
> +
> +The frames (in packed raw bayer format specific to IPU3) received by the

s/bayer/Bayer/

(same in a few other locations below)

> +input video node is processed by the IPU3 Imaging Unit and is output to 2

s/is output/are output/

> +video nodes, with each targeting different purpose (main output and

s/different purpose/a different purpose/

> viewfinder +output).

We will eventually need more information about this, but that could come as a 
separate patch.

> +Details on raw bayer format specific to IPU3 can be found as below.
> +Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst

How about linking to the document using :ref: instead of adding the file path 
?

> +The driver supports V4L2 Video Capture Interface as defined at
> :ref:`devices`.
> +
> +Only the multi-planar API is supported. More details can be found at
> +:ref:`planar-apis`.
> +
> +
> +parameters video node
> +---------------------
> +
> +The parameter video node receives the ISP algorithm parameters that are

s/parameters/parameter/

> used +to configure how the ISP algorithms process the image.
> +
> +Details on raw bayer format specific to IPU3 can be found as below.

I assume you meant processing parameters, not raw Bayer format.

> +Documentation/media/uapi/v4l/pixfmt-meta-intel-ipu3.rst

:ref: here too.

> +3A statistics video node
> +------------------------
> +
> +3A statistics video node is used by the ImgU driver to output the 3A (auto
> +focus, auto exposure and auto white balance) statistics for the frames that
> +are being processed by the ISP to user space applications. User space
> +applications can use this statistics data to arrive at desired algorithm
> +parameters for ISP.

s/arrive at/compute the/
s/ISP/the ISP/

> +
> +CIO2 device nodes
> +=================
> +
> +CIO2 is represented as a single V4L2 sub-device with a video node for each
> +CSI-2 receiver. The video node represents the DMA engine.

I think you can remove this section, it's already explained above. If you want 
to keep it, please move it with the rest of the CIO2 documentation above the 
ImgU documentation.

> +Configuring the Intel IPU3
> +==========================
> +
> +The Intel IPU3 ImgU driver supports V4L2 interface. Using V4L2 ioctl calls,
> +the ISP can be configured and enabled.
> +
> +The IPU3 ImgU pipelines can be configured using media controller APIs,
> +defined at :ref:`media_controller`.
> +
> +Capturing frames in raw bayer format
> +------------------------------------
> +
> +IPU3 MIPI CSI2 receiver is used to capture frames (in packed raw bayer
> +format) from the raw sensors connected to the CSI2 ports. The captured
> +frames are used as input to the ImgU driver.
> +
> +Image processing using IPU3 ImgU requires tools such as v4l2n [#f1]_,

I would drop v4l2n from the documentation as it's not maintained and is not 
functional (in particular it doesn't implement MPLANE support which the driver 
requires).

> +raw2pnm [#f1]_, and yavta [#f2]_ due to the following unique requirements
> +and / or features specific to IPU3.
> +
> +-- The IPU3 CSI2 receiver outputs the captured frames from the sensor in
> +packed raw bayer format that is specific to IPU3

s/to IPU3/to the IPU3/.

> +
> +-- Multiple video nodes have to be operated simultaneously
> +
> +Let us take the example of ov5670 sensor connected to CSI2 port 0, for a
> +2592x1944 image capture.
> +
> +Using the media contorller APIs, the ov5670 sensor is configured to send
> +frames in packed raw bayer format to IPU3 CSI2 receiver.
> +
> +# This example assumes /dev/media0 as the ImgU media device

Shouldn't that be CIO2 ?

> +
> +export MDEV=/dev/media0
> +
> +# and that ov5670 sensor is connected to i2c bus 10 with address 0x36
> +
> +export SDEV="ov5670 10-0036"
> +
> +# Establish the link for the media devices using media-ctl [#f3]_
> +media-ctl -d $MDEV -l "ov5670 ":0 -> "ipu3-csi2 0":0[1]

You're missing quotes around the link description, and the entity name is 
incorrect. Please test all the commands listed here with the upstream driver.

> +media-ctl -d $MDEV -l "ipu3-csi2 0":1 -> "ipu3-cio2 0":0[1]

Shouldn't this link be immutable ?

> +# Set the format for the media devices
> +media-ctl -d $MDEV -V "ov5670 ":0 [fmt:SGRBG10/2592x1944]

The entity name is incorrect.

> +media-ctl -d $MDEV -V "ipu3-csi2 0":0 [fmt:SGRBG10/2592x1944]
> +
> +media-ctl -d $MDEV -V "ipu3-csi2 0":1 [fmt:SGRBG10/2592x1944]
> +
> +Once the media pipeline is configured, desired sensor specific settings
> +(such as exposure and gain settings) can be set, using the yavta tool.
> +
> +e.g
> +
> +yavta -w 0x009e0903 444 $(media-ctl -d $MDEV -e "$SDEV")
> +
> +yavta -w 0x009e0913 1024 $(media-ctl -d $MDEV -e "$SDEV")
> +
> +yavta -w 0x009e0911 2046 $(media-ctl -d $MDEV -e "$SDEV")
> +
> +Once the desired sensor settings are set, frame captures can be done as
> below.
> +
> +e.g
> +
> +yavta --data-prefix -u -c10 -n5 -I -s2592x1944 --file=/tmp/frame-#.bin

Do you need --data-prefix ?

> +-f IPU3_GRBG10 media-ctl -d $MDEV -e ipu3-cio2 0

The upstream yavta names the format IPU3_SGRBG10.

You're missing $(...) around the media-ctl command, and double quotes around 
the entity name.

> +
> +With the above command, 10 frames are captured at 2592x1944 resolution,
> with +sGRBG10 format and output as IPU3_GRBG10 format.

IPU3_SGRBG10 here too.

> +
> +The captured frames are available as /tmp/frame-#.bin files.

All this should be moved to the CIO2 section.

> +Processing the image in raw bayer format
> +----------------------------------------
> +
> +Configuring ImgU V4L2 subdev for image processing
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +The ImgU V4L2 subdevs have to be configured with media controller APIs to
> +have all the video nodes setup correctly.
> +
> +Let us take "ipu3-imgu 0" subdev as an example.
> +
> +media-ctl -d $MDEV -r
> +
> +media-ctl -d $MDEV -l "ipu3-imgu 0 input":0 -> "ipu3-imgu 0":0[1]
> +
> +media-ctl -d $MDEV -l "ipu3-imgu 0":2 -> "output":0[1]
> +
> +media-ctl -d $MDEV -l "ipu3-imgu 0":3 -> "viewfinder":0[1]
> +
> +media-ctl -d $MDEV -l "ipu3-imgu 0":4 -> "3a stat":0[1]

Entity names are incorrect here too.

> +Also the pipe mode of the corresponding V4L2 subdev should be set as
> +desired (e.g 0 for video mode or 1 for still mode) through the
> +control id 0x009819a1 as below.
> +
> +e.g
> +
> +v4l2n -d /dev/v4l-subdev7 --ctrl=0x009819A1=1

You can use yavta instead of v4l2n. Another option would be v4l2-ctl, but I'd 
avoid adding a dependency to another tool if yavta is already used in other 
places.

> +RAW bayer frames go through the following ISP pipeline HW blocks to
> +have the processed image output to the DDR memory.
> +
> +RAW bayer frame -> Input Feeder -> Bayer Down Scaling (BDS) -> Geometric
> +Distortion Correction (GDC) -> DDR

A more detailed block diagram, with the other blocks included, should be added 
to the ImgU description above. Each block should have a short description of 
its purpose.

> +The ImgU V4L2 subdev has to be configured with the supported resolutions
> +in all the above HW blocks, for a given input resolution.
> +
> +For a given supported resolution for an input frame, the Input Feeder,
> +Bayer Down Scaling and GDC blocks should be configured with the supported
> +resolutions. This information can be obtained by looking at the following
> +IPU3 ISP configuration table.

Does this mean that the ImgU will not operate properly when exercised through 
the MC and V4L2 only without configuration of the internal blocks through the 
processing parameters device node ?

> +https://chromium.googlesource.com/chromiumos/overlays/board-overlays/+/mast
> er
> +
> +Under baseboard-poppy/media-libs/arc-camera3-hal-configs-poppy/files/gcss
> +directory, graph_settings_ov5670.xml can be used as an example.

The directory name is incorrect.

> +The following steps prepare the ImgU ISP pipeline for the image processing.
> +
> +1. The ImgU V4L2 subdev data format should be set by using the
> +VIDIOC_SUBDEV_S_FMT on pad 0, using the GDC width and height obtained
> above.
> +
> +2. The ImgU V4L2 subdev cropping should be set by using the
> +VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_CROP as the target,
> +using the input feeder height and width.
> +
> +3. The ImgU V4L2 subdev composing should be set by using the
> +VIDIOC_SUBDEV_S_SELECTION on pad 0, with V4L2_SEL_TGT_COMPOSE as the
> target, +using the BDS height and width.

How the format and selection rectangles related to the internal processing 
blocks should also be explained in more details.

> +For the ov5670 example, for an input frame with a resolution of 2592x1944
> +(which is input to the ImgU subdev pad 0), the corresponding resolutions
> +for input feeder, BDS and GDC are 2592x1944, 2592x1944 and 2560x1920
> +respectively.

Why ? How is that computed ? If my input resolution was different, how would I 
compute the other resolutions ?

> +Once this is done, the received raw bayer frames can be input to the ImgU
> +V4L2 subdev as below, using the open source application v4l2n.
> +
> +For an image captured with 2592x1944 [#f4]_ resolution, with desired output
> +resolution as 2560x1920 and viewfinder resolution as 2560x1920, the
> following +v4l2n command can be used. This helps process the raw bayer
> frames and +produces the desired results for the main output image and the
> viewfinder +output, in NV12 format.
> +
> +v4l2n --pipe=4 --load=/tmp/frame-#.bin --open=/dev/video4
> +--fmt=type:VIDEO_OUTPUT_MPLANE,width=2592,height=1944,pixelformat=0X4733706
> 9 +--reqbufs=type:VIDEO_OUTPUT_MPLANE,count:1 --pipe=1
> --output=/tmp/frames.out +--open=/dev/video5
> +--fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
> +--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=2
> --output=/tmp/frames.vf +--open=/dev/video6
> +--fmt=type:VIDEO_CAPTURE_MPLANE,width=2560,height=1920,pixelformat=NV12
> +--reqbufs=type:VIDEO_CAPTURE_MPLANE,count:1 --pipe=3 --open=/dev/video7
> +--output=/tmp/frames.3A --fmt=type:META_CAPTURE,?
> +--reqbufs=count:1,type:META_CAPTURE --pipe=1,2,3,4 --stream=5

You can replace this with four yavta commands.

> +where /dev/video4, /dev/video5, /dev/video6 and /dev/video7 devices point
> to +input, output, viewfinder and 3A statistics video nodes respectively. +
> +Converting the raw bayer image into YUV domain
> +----------------------------------------------
> +
> +The processed images after the above step, can be converted to YUV domain
> +as below.
> +
> +Main output frames
> +~~~~~~~~~~~~~~~~~~
> +
> +raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.out /tmp/frames.out.pnm

PNM is an umbrella term that refers to any of the PBM, PGM or PPM format. As 
the raw2pnm tool outputs PPM files, let's name them .ppm here and below. This 
helps with some image viewers that use file extensions to identify the format, 
and have trouble handling .pnm files.

> +where 2560x1920 is output resolution, NV12 is the video format, followed
> +by input frame and output PNM file.
> +
> +Viewfinder output frames
> +~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +raw2pnm -x2560 -y1920 -fNV12 /tmp/frames.vf /tmp/frames.vf.pnm
> +
> +where 2560x1920 is output resolution, NV12 is the video format, followed
> +by input frame and output PNM file.
> +
> +Example user space code for IPU3
> +================================
> +
> +User space code that configures and uses IPU3 is available here.
> +
> +https://chromium.googlesource.com/chromiumos/platform/arc-camera/+/master/
> +
> +The source can be located under hal/intel directory.
> +
> +References
> +==========
> +
> +include/uapi/linux/intel-ipu3.h
> +
> +.. [#f1] https://github.com/intel/nvt
> +
> +.. [#f2] http://git.ideasonboard.org/yavta.git
> +
> +.. [#f3] http://git.ideasonboard.org/?p=media-ctl.git;a=summary
> +
> +.. [#f4] ImgU limitation requires an additional 16x16 for all input
> resolutions

-- 
Regards,

Laurent Pinchart
