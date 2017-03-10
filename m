Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:42496 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755398AbdCJUPF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 15:15:05 -0500
Date: Fri, 10 Mar 2017 20:13:56 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v5 00/39] i.MX Media Driver
Message-ID: <20170310201356.GA21222@n2100.armlinux.org.uk>
References: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1489121599-23206-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Version 5 gives me no v4l2 controls exposed through the video device
interface.

Just like with version 4, version 5 is completely useless with IMX219:

imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
ipu1_csi0: pipeline start failed with -110
imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
ipu1_csi0: pipeline start failed with -110
imx6-mipi-csi2: LP-11 timeout, phy_state = 0x00000200
ipu1_csi0: pipeline start failed with -110

So, like v4, I can't do any further testing.

On Thu, Mar 09, 2017 at 08:52:40PM -0800, Steve Longerbeam wrote:
> In version 5:
> 
> - ov5640: renamed "pwdn-gpios" to "powerdown-gpios"
> 
> - ov5640: add mutex lock around the subdev op entry points.
> 
> - ov5640: don't attempt to program the new mode in ov5640_set_fmt().
>   Instead set a new flag, pending_mode_change, and program the new
>   mode at s_stream() if flag is set.
> 
> - ov5640: implement [gs]_frame_interval. As part of that, create
>   ov5640_try_frame_interval(), which is used by both [gs]_frame_interval
>   and [gs]_parm.
> 
> - ov5640: don't attempt to set controls in ov5640_s_ctrl(), or at
>   mode change, do it instead after first power-up.
> 
> - video-multiplexer: include link_validate in media_entity_operations.
> 
> - video-multiplexer: enforce that output pad frame interval must match
>   input pad frame interval in vidsw_s_frame_interval().
> 
> - video-multiplexer: initialize frame interval to a default 30 fps.
> 
> - mipi csi-2: renamed "cfg" clock name property to "ref". This is the
>   27 MHz mipi csi-2 PLL reference clock.
> 
> - mipi csi-2: create a hsfreq_map[] table based on
>   https://community.nxp.com/docs/DOC-94312. Use it to select
>   a hsfreqrange_sel value when programming the D-PHY, based on
>   a max Mbps per lane. This is computed from the source subdev
>   via V4L2_CID_LINK_FREQ control, and if the subdev doesn't implement
>   that control, use a default hard-coded max Mbps per lane.
> 
> - added required ports property description to imx-media binding doc.
> 
> - removed event V4L2_EVENT_FRAME_TIMEOUT. On a frame timeout, which
>   is always unrecoverable, call vb2_queue_error() instead.
> 
> - export the remaining custom events to V4L2_EVENT_FRAME_INTERVAL_ERROR
>   and V4L2_EVENT_NEW_FRAME_BEFORE_EOF.
> 
> - vdic: use V4L2_CID_DEINTERLACING_MODE for motion compensation control
>   instead of a custom control.
> 
> - add v4l2_subdev_link_validate_frame_interval(). Call this in the
>   link_validate imx-media subdev callbacks and video-multiplexer.
> 
> - fix subdev event registration: implementation of subscribe_event()
>   and unsubscribe_event() subdev ops were missing.
> 
> - all calls from the pipeline to the sensor subdev have been removed.
>   Only the CSI subdev still refers to a sensor, and only to retrieve
>   its media bus config, which is necessary to setup the CSI interface.
> 
> - add mutex locks around the imx-media subdev op entry points.
> 
> - completed the propagation of all pad format parameters from sink
>   pads to source pads within every imx-media subdev.
> 
> - implement [gs]_frame_interval in all the imx-media subdevs.
> 
> - imx-ic-prpencvf: there isn't necessarily a CSI subdev in the pipeline
>   in the future, so make sure this is optional when calling the CSI's
>   FIM.
> 
> - the source pads that attach to capture device nodes now require the
>   IPU internal pixel codes. The capture device translates these to
>   v4l2 fourcc memory formats.
> 
> - fix control inheritance to the capture device. When the pipeline
>   was modified, the inherited controls were not being refreshed.
>   v4l2_pipeline_inherit_controls() is now called only in imx-media
>   link_notify() callback when a pipelink link is disabled or modified.
>   imx_media_find_pipeline_video_device() is created to locate the
>   capture device in the pipeline.
> 
> - fix a possible race when propagating formats to the capture device.
>   The subdevs and capture device use different mutex locks when setting
>   formats. imx_media_capture_device_set_format() is created which acquires
>   the capture device mutex when updating the capture device format.
> 
> - verify all subdevs were bound in the async completion callback.
>  
> 
> Philipp Zabel (7):
>   [media] dt-bindings: Add bindings for video-multiplexer device
>   ARM: dts: imx6qdl: Add mipi_ipu1/2 multiplexers, mipi_csi, and their
>     connections
>   add mux and video interface bridge entity functions
>   platform: add video-multiplexer subdevice driver
>   media: imx: csi: fix crop rectangle changes in set_fmt
>   media: imx: csi: add frame skipping support
>   media: imx: csi: fix crop rectangle reset in sink set_fmt
> 
> Russell King (4):
>   media: imx: add support for bayer formats
>   media: imx: csi: add support for bayer formats
>   media: imx: mipi-csi2: enable setting and getting of frame rates
>   media: imx: csi/fim: add support for frame intervals
> 
> Steve Longerbeam (28):
>   [media] dt-bindings: Add bindings for i.MX media driver
>   [media] dt/bindings: Add bindings for OV5640
>   ARM: dts: imx6qdl: Add compatible, clocks, irqs to MIPI CSI-2 node
>   ARM: dts: imx6qdl: add capture-subsystem device
>   ARM: dts: imx6qdl-sabrelite: remove erratum ERR006687 workaround
>   ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
>   ARM: dts: imx6-sabresd: add OV5642 and OV5640 camera sensors
>   ARM: dts: imx6-sabreauto: create i2cmux for i2c3
>   ARM: dts: imx6-sabreauto: add reset-gpios property for max7310_b
>   ARM: dts: imx6-sabreauto: add pinctrl for gpt input capture
>   ARM: dts: imx6-sabreauto: add the ADV7180 video decoder
>   [media] v4l2: add a frame interval error event
>   [media] v4l2: add a new-frame before end-of-frame event
>   [media] v4l2-mc: add a function to inherit controls from a pipeline
>   [media] v4l: subdev: Add function to validate frame interval
>   [media] add Omnivision OV5640 sensor driver
>   UAPI: Add media UAPI Kbuild file
>   media: Add userspace header file for i.MX
>   media: Add i.MX media core driver
>   media: imx: Add Capture Device Interface
>   media: imx: Add CSI subdev driver
>   media: imx: Add VDIC subdev driver
>   media: imx: Add IC subdev drivers
>   media: imx: Add MIPI CSI-2 Receiver subdev driver
>   ARM: imx_v6_v7_defconfig: Enable staging video4linux drivers
>   media: imx: csi: add __csi_get_fmt
>   media: imx: redo pixel format enumeration and negotiation
>   media: imx: propagate sink pad formats to source pads
> 
>  .../devicetree/bindings/media/i2c/ov5640.txt       |   45 +
>  Documentation/devicetree/bindings/media/imx.txt    |   74 +
>  .../bindings/media/video-multiplexer.txt           |   59 +
>  Documentation/media/uapi/mediactl/media-types.rst  |   22 +
>  Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   12 +
>  Documentation/media/v4l-drivers/imx.rst            |  560 +++++
>  Documentation/media/videodev2.h.rst.exceptions     |    2 +
>  arch/arm/boot/dts/imx6dl-sabrelite.dts             |    5 +
>  arch/arm/boot/dts/imx6dl-sabresd.dts               |    5 +
>  arch/arm/boot/dts/imx6dl.dtsi                      |  185 ++
>  arch/arm/boot/dts/imx6q-sabrelite.dts              |    5 +
>  arch/arm/boot/dts/imx6q-sabresd.dts                |    5 +
>  arch/arm/boot/dts/imx6q.dtsi                       |  121 ++
>  arch/arm/boot/dts/imx6qdl-sabreauto.dtsi           |  144 +-
>  arch/arm/boot/dts/imx6qdl-sabrelite.dtsi           |  152 +-
>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi             |  114 +-
>  arch/arm/boot/dts/imx6qdl.dtsi                     |   17 +-
>  arch/arm/configs/imx_v6_v7_defconfig               |   11 +
>  drivers/media/i2c/Kconfig                          |    7 +
>  drivers/media/i2c/Makefile                         |    1 +
>  drivers/media/i2c/ov5640.c                         | 2231 ++++++++++++++++++++
>  drivers/media/platform/Kconfig                     |    8 +
>  drivers/media/platform/Makefile                    |    2 +
>  drivers/media/platform/video-multiplexer.c         |  498 +++++
>  drivers/media/v4l2-core/v4l2-mc.c                  |   48 +
>  drivers/media/v4l2-core/v4l2-subdev.c              |   50 +
>  drivers/staging/media/Kconfig                      |    2 +
>  drivers/staging/media/Makefile                     |    1 +
>  drivers/staging/media/imx/Kconfig                  |   20 +
>  drivers/staging/media/imx/Makefile                 |   12 +
>  drivers/staging/media/imx/TODO                     |   17 +
>  drivers/staging/media/imx/imx-ic-common.c          |  113 +
>  drivers/staging/media/imx/imx-ic-prp.c             |  497 +++++
>  drivers/staging/media/imx/imx-ic-prpencvf.c        | 1236 +++++++++++
>  drivers/staging/media/imx/imx-ic.h                 |   38 +
>  drivers/staging/media/imx/imx-media-capture.c      |  694 ++++++
>  drivers/staging/media/imx/imx-media-csi.c          | 1595 ++++++++++++++
>  drivers/staging/media/imx/imx-media-dev.c          |  522 +++++
>  drivers/staging/media/imx/imx-media-fim.c          |  463 ++++
>  drivers/staging/media/imx/imx-media-internal-sd.c  |  349 +++
>  drivers/staging/media/imx/imx-media-of.c           |  267 +++
>  drivers/staging/media/imx/imx-media-utils.c        | 1009 +++++++++
>  drivers/staging/media/imx/imx-media-vdic.c         |  949 +++++++++
>  drivers/staging/media/imx/imx-media.h              |  311 +++
>  drivers/staging/media/imx/imx6-mipi-csi2.c         |  725 +++++++
>  include/media/imx.h                                |   15 +
>  include/media/v4l2-mc.h                            |   25 +
>  include/media/v4l2-subdev.h                        |   10 +
>  include/uapi/Kbuild                                |    1 +
>  include/uapi/linux/media.h                         |    6 +
>  include/uapi/linux/v4l2-controls.h                 |    4 +
>  include/uapi/linux/videodev2.h                     |    2 +
>  include/uapi/media/Kbuild                          |    2 +
>  include/uapi/media/imx.h                           |   21 +
>  54 files changed, 13262 insertions(+), 27 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt
>  create mode 100644 Documentation/devicetree/bindings/media/imx.txt
>  create mode 100644 Documentation/devicetree/bindings/media/video-multiplexer.txt
>  create mode 100644 Documentation/media/v4l-drivers/imx.rst
>  create mode 100644 drivers/media/i2c/ov5640.c
>  create mode 100644 drivers/media/platform/video-multiplexer.c
>  create mode 100644 drivers/staging/media/imx/Kconfig
>  create mode 100644 drivers/staging/media/imx/Makefile
>  create mode 100644 drivers/staging/media/imx/TODO
>  create mode 100644 drivers/staging/media/imx/imx-ic-common.c
>  create mode 100644 drivers/staging/media/imx/imx-ic-prp.c
>  create mode 100644 drivers/staging/media/imx/imx-ic-prpencvf.c
>  create mode 100644 drivers/staging/media/imx/imx-ic.h
>  create mode 100644 drivers/staging/media/imx/imx-media-capture.c
>  create mode 100644 drivers/staging/media/imx/imx-media-csi.c
>  create mode 100644 drivers/staging/media/imx/imx-media-dev.c
>  create mode 100644 drivers/staging/media/imx/imx-media-fim.c
>  create mode 100644 drivers/staging/media/imx/imx-media-internal-sd.c
>  create mode 100644 drivers/staging/media/imx/imx-media-of.c
>  create mode 100644 drivers/staging/media/imx/imx-media-utils.c
>  create mode 100644 drivers/staging/media/imx/imx-media-vdic.c
>  create mode 100644 drivers/staging/media/imx/imx-media.h
>  create mode 100644 drivers/staging/media/imx/imx6-mipi-csi2.c
>  create mode 100644 include/media/imx.h
>  create mode 100644 include/uapi/media/Kbuild
>  create mode 100644 include/uapi/media/imx.h
> 
> -- 
> 2.7.4
> 

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
