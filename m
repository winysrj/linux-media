Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E926C4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294DF2133F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 18:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbfCESvd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 13:51:33 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:48343 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfCESvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2019 13:51:33 -0500
Received: from uno.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 9D3A920000C;
        Tue,  5 Mar 2019 18:51:28 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 00/31] v4l: add support for multiplexed streams
Date:   Tue,  5 Mar 2019 19:51:19 +0100
Message-Id: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hello,
   third version of multiplexed stream support patch series.

V2 sent by Niklas is available at:
https://patchwork.kernel.org/cover/10573817/

As per v2, most of the core patches are work from Sakari and Laurent, with
Niklas' support on top for adv748x and rcar-csi2.

The use case of the series remains the same: support for virtual channel
selection implemented on R-Car Gen3 and adv748x. Quoting the v2 cover letter:

-------------------------------------------------------------------------------
I have added driver support for the devices used on the Renesas Gen3
platforms, a ADV7482 connected to the R-Car CSI-2 receiver. With these
changes I can control which of the analog inputs of the ADV7482 the
video source is captured from and on which CSI-2 virtual channel the
video is transmitted on to the R-Car CSI-2 receiver.

The series adds two new subdev IOCTLs [GS]_ROUTING which allows
user-space to get and set routes inside a subdevice. I have added RFC
support for these to v4l-utils [2] which can be used to test this
series, example:

    Check the internal routing of the adv748x csi-2 transmitter:
    v4l2-ctl -d /dev/v4l-subdev24 --get-routing
    0/0 -> 1/0 [ENABLED]
    0/0 -> 1/1 []
    0/0 -> 1/2 []
    0/0 -> 1/3 []


    Select that video should be outputed on VC 2 and check the result:
    $ v4l2-ctl -d /dev/v4l-subdev24 --set-routing '0/0 -> 1/2 [1]'

    $ v4l2-ctl -d /dev/v4l-subdev24 --get-routing
    0/0 -> 1/0 []
    0/0 -> 1/1 []
    0/0 -> 1/2 [ENABLED]
    0/0 -> 1/3 []
-------------------------------------------------------------------------------

Below is reported the media graph of the system used for testing [1].

v4l2-ctl patches to handle the newly introduced IOCTLs are available from
Niklas' repository at:
git://git.ragnatech.se/v4l-utils routing

The series is now based on latest media-master branch (v5.0-rc6) and I've
addressed most of the comments received on v2. More precisely, the most notable
changes from v2 are:

1) Added IOCTLs documentation, and a section to describe multiplexed media links
to the v4l2-subdevice interface chapter and expanded functions documentation
2) Re-worked the IOCTLs so that they don't need a compat version
3) Sort pads to be passed to has_route() by their index values
4) Drop indirect routes support from this initial version. Might be considered
later to simplify subdevice drivers implementations
5) Add has_route() operations to adv748x and rcar-csi2 subdevice drivers

Based on this series, I plan to implement support for CSI-2 data lane
negotiation for ADV748x and R-Car CSI-2 receiver.

Tested on R-Car Gen3 Salvator-M3W capturing images transmitted on different
virtual channels.

Series available at:
git://jmondi.org/linux v4l2-mux/media-master-v5.0/v3

Thanks
   j

Jacopo Mondi (4):
  media: entity: Add iterator helper for entity pads
  media: Documentation: Add GS_ROUTING documentation
  adv748x: afe: Implement has_route()
  media: rcar-csi2: Implement has_route()

Laurent Pinchart (4):
  media: entity: Add has_route entity operation
  media: entity: Add media_has_route() function
  media: entity: Use routing information during graph traversal
  v4l: subdev: Add [GS]_ROUTING subdev ioctls and operations

Niklas Söderlund (7):
  adv748x: csi2: add translation from pixelcode to CSI-2 datatype
  adv748x: csi2: only allow formats on sink pads
  adv748x: csi2: describe the multiplexed stream
  adv748x: csi2: add internal routing configuration
  adv748x: afe: add routing support
  rcar-csi2: use frame description information to configure CSI-2 bus
  rcar-csi2: expose the subdevice internal routing

Sakari Ailus (16):
  media: entity: Use pad as a starting point for graph walk
  media: entity: Use pads instead of entities in the media graph walk
    stack
  media: entity: Walk the graph based on pads
  v4l: mc: Start walk from a specific pad in use count calculation
  media: entity: Move the pipeline from entity to pads
  media: entity: Use pad as the starting point for a pipeline
  media: entity: Skip link validation for pads to which there is no
    route to
  media: entity: Add an iterator helper for connected pads
  media: entity: Add only connected pads to the pipeline
  media: entity: Add debug information in graph walk route check
  v4l: Add bus type to frame descriptors
  v4l: Add CSI-2 bus configuration to frame descriptors
  v4l: Add stream to frame descriptor
  v4l: subdev: Take routing information into account in link validation
  v4l: subdev: Improve link format validation debug messages
  v4l: mc: Add an S_ROUTING helper function for power state changes

 Documentation/media/kapi/mc-core.rst          |  15 +-
 Documentation/media/uapi/v4l/dev-subdev.rst   |  90 ++++++
 Documentation/media/uapi/v4l/user-func.rst    |   1 +
 .../uapi/v4l/vidioc-subdev-g-routing.rst      | 142 +++++++++
 drivers/media/i2c/adv748x/adv748x-afe.c       |  91 ++++++
 drivers/media/i2c/adv748x/adv748x-csi2.c      | 136 +++++++-
 drivers/media/i2c/adv748x/adv748x.h           |   1 +
 drivers/media/media-device.c                  |  13 +-
 drivers/media/media-entity.c                  | 232 ++++++++------
 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |   6 +-
 .../media/platform/exynos4-is/fimc-capture.c  |   8 +-
 .../platform/exynos4-is/fimc-isp-video.c      |   8 +-
 drivers/media/platform/exynos4-is/fimc-isp.c  |   2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |  10 +-
 drivers/media/platform/exynos4-is/media-dev.c |  20 +-
 drivers/media/platform/omap3isp/isp.c         |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  25 +-
 drivers/media/platform/omap3isp/ispvideo.h    |   2 +-
 .../media/platform/qcom/camss/camss-video.c   |   6 +-
 drivers/media/platform/rcar-vin/rcar-core.c   |  16 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c   | 222 ++++++++++---
 drivers/media/platform/rcar-vin/rcar-dma.c    |   8 +-
 .../media/platform/s3c-camif/camif-capture.c  |   6 +-
 drivers/media/platform/vimc/vimc-capture.c    |   5 +-
 drivers/media/platform/vsp1/vsp1_video.c      |  18 +-
 drivers/media/platform/xilinx/xilinx-dma.c    |  20 +-
 drivers/media/platform/xilinx/xilinx-dma.h    |   2 +-
 drivers/media/usb/au0828/au0828-core.c        |   4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  25 +-
 drivers/media/v4l2-core/v4l2-mc.c             |  76 +++--
 drivers/media/v4l2-core/v4l2-subdev.c         | 296 ++++++++++++++++--
 .../staging/media/davinci_vpfe/vpfe_video.c   |  47 +--
 drivers/staging/media/imx/imx-media-utils.c   |   8 +-
 drivers/staging/media/omap4iss/iss.c          |   2 +-
 drivers/staging/media/omap4iss/iss_video.c    |  38 +--
 drivers/staging/media/omap4iss/iss_video.h    |   2 +-
 include/media/media-entity.h                  | 143 ++++++---
 include/media/v4l2-mc.h                       |  22 ++
 include/media/v4l2-subdev.h                   |  49 +++
 include/uapi/linux/v4l2-subdev.h              |  40 +++
 40 files changed, 1492 insertions(+), 367 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/vidioc-subdev-g-routing.rst

[1]
-------------------------------------------------------------------------------
Device topology
- entity 1: rcar_csi2 feaa0000.csi2 (5 pads, 15 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev0
	pad0: Sink
		<- "adv748x 4-0070 txa":1 [ENABLED,IMMUTABLE]
	pad1: Source
		[fmt:RGB888_1X24/1280x720 field:none]
		-> "VIN0 output":0 []
		-> "VIN1 output":0 []
		-> "VIN2 output":0 []
		-> "VIN4 output":0 [ENABLED]
		-> "VIN5 output":0 []
		-> "VIN6 output":0 []
	pad2: Source
		[fmt:unknown/0x0]
		-> "VIN1 output":0 []
		-> "VIN3 output":0 []
		-> "VIN5 output":0 []
		-> "VIN7 output":0 []
	pad3: Source
		[fmt:unknown/0x0]
		-> "VIN2 output":0 []
		-> "VIN6 output":0 []
	pad4: Source
		[fmt:unknown/0x0]
		-> "VIN3 output":0 []
		-> "VIN7 output":0 []

- entity 7: adv748x 4-0070 txa (2 pads, 3 links)
            type V4L2 subdev subtype Unknown flags 0
            device node name /dev/v4l-subdev3
	pad0: Sink
		[fmt:RGB888_1X24/1280x720 field:none]
		<- "adv748x 4-0070 afe":8 []
		<- "adv748x 4-0070 hdmi":1 [ENABLED]
	pad1: Source
		-> "rcar_csi2 feaa0000.csi2":0 [ENABLED,IMMUTABLE]

- entity 10: adv748x 4-0070 afe (9 pads, 2 links)
             type V4L2 subdev subtype Decoder flags 0
             device node name /dev/v4l-subdev1
	pad0: Sink
	pad1: Sink
	pad2: Sink
	pad3: Sink
	pad4: Sink
	pad5: Sink
	pad6: Sink
	pad7: Sink
	pad8: Source
		[fmt:UYVY8_2X8/720x240 field:alternate colorspace:smpte170m]
		-> "adv748x 4-0070 txa":0 []
		-> "adv748x 4-0070 txb":0 []

- entity 22: adv748x 4-0070 hdmi (2 pads, 1 link)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev2
	pad0: Sink
		[dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
	pad1: Source
		[fmt:RGB888_1X24/1280x720 field:none colorspace:srgb]
		[dv.caps:BT.656/1120 min:640x480@13000000 max:1920x1200@162000000 stds:CEA-861,DMT caps:progressive]
		[dv.detect:BT.656/1120 1280x720p50 (1980x750) stds:CEA-861 flags:CE-video,has-cea861-vic]
		[dv.current:BT.656/1120 1280x720p50 (1980x750) stds:CEA-861 flags:CE-video,has-cea861-vic]
		-> "adv748x 4-0070 txa":0 [ENABLED]

- entity 29: rcar_csi2 fea80000.csi2 (5 pads, 15 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev4
	pad0: Sink
		<- "adv748x 4-0070 txb":1 [ENABLED,IMMUTABLE]
	pad1: Source
		[fmt:unknown/0x0]
		-> "VIN0 output":0 []
		-> "VIN1 output":0 []
		-> "VIN2 output":0 []
		-> "VIN4 output":0 []
		-> "VIN5 output":0 []
		-> "VIN6 output":0 []
	pad2: Source
		[fmt:unknown/0x0]
		-> "VIN1 output":0 []
		-> "VIN3 output":0 []
		-> "VIN5 output":0 []
		-> "VIN7 output":0 []
	pad3: Source
		[fmt:unknown/0x0]
		-> "VIN2 output":0 []
		-> "VIN6 output":0 []
	pad4: Source
		[fmt:unknown/0x0]
		-> "VIN3 output":0 []
		-> "VIN7 output":0 []

- entity 35: adv748x 4-0070 txb (2 pads, 2 links)
             type V4L2 subdev subtype Unknown flags 0
             device node name /dev/v4l-subdev5
	pad0: Sink
		[fmt:unknown/0x0]
		<- "adv748x 4-0070 afe":8 []
	pad1: Source
		-> "rcar_csi2 fea80000.csi2":0 [ENABLED,IMMUTABLE]

- entity 54: VIN0 output (1 pad, 2 links)
             type Node subtype V4L flags 0
             device node name /dev/video0
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 []
		<- "rcar_csi2 fea80000.csi2":1 []

- entity 58: VIN1 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video1
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 []
		<- "rcar_csi2 feaa0000.csi2":2 []
		<- "rcar_csi2 fea80000.csi2":1 []
		<- "rcar_csi2 fea80000.csi2":2 []

- entity 62: VIN2 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video2
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 []
		<- "rcar_csi2 feaa0000.csi2":3 []
		<- "rcar_csi2 fea80000.csi2":1 []
		<- "rcar_csi2 fea80000.csi2":3 []

- entity 66: VIN3 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video3
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":2 []
		<- "rcar_csi2 feaa0000.csi2":4 []
		<- "rcar_csi2 fea80000.csi2":2 []
		<- "rcar_csi2 fea80000.csi2":4 []

- entity 70: VIN4 output (1 pad, 2 links)
             type Node subtype V4L flags 0
             device node name /dev/video4
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 [ENABLED]
		<- "rcar_csi2 fea80000.csi2":1 []

- entity 74: VIN5 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video5
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 []
		<- "rcar_csi2 feaa0000.csi2":2 []
		<- "rcar_csi2 fea80000.csi2":1 []
		<- "rcar_csi2 fea80000.csi2":2 []

- entity 78: VIN6 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video6
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":1 []
		<- "rcar_csi2 feaa0000.csi2":3 []
		<- "rcar_csi2 fea80000.csi2":1 []
		<- "rcar_csi2 fea80000.csi2":3 []

- entity 82: VIN7 output (1 pad, 4 links)
             type Node subtype V4L flags 0
             device node name /dev/video7
	pad0: Sink
		<- "rcar_csi2 feaa0000.csi2":2 []
		<- "rcar_csi2 feaa0000.csi2":4 []
		<- "rcar_csi2 fea80000.csi2":2 []
		<- "rcar_csi2 fea80000.csi2":4 []


--
2.20.1

