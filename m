Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C71C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6033820844
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 14:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfA1Owk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 09:52:40 -0500
Received: from mail.bootlin.com ([62.4.15.54]:53092 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfA1Owk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 09:52:40 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 005A02078C; Mon, 28 Jan 2019 15:52:36 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id C562020714;
        Mon, 28 Jan 2019 15:52:36 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 0/5] media: Allwinner A10 CSI support
Date:   Mon, 28 Jan 2019 15:52:31 +0100
Message-Id: <cover.ba7411f0c7155d0292b38d3dec698e26b5cc813b.1548687041.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Here is a series introducing the support for the A10 (and SoCs of the same
generation) CMOS Sensor Interface (called CSI, not to be confused with
MIPI-CSI, which isn't support by that IP).

That interface is pretty straightforward, but the driver has a few issues
that I wanted to bring up:

  * The only board I've been testing this with has an ov5640 sensor
    attached, which doesn't work with the upstream driver. Copying the
    Allwinner init sequence works though, and this is how it has been
    tested. Testing with a second sensor would allow to see if it's an
    issue on the CSI side or the sensor side.
  * We don't have support for the ISP at the moment, but this can be added
    eventually.

Here is the v4l2-compliance output (commit f61132e81d79 of v4l-utils)
v4l2-compliance SHA: not available, 32 bits

Compliance test for device /dev/video1:

Driver Info:
	Driver name      : sun4i_csi
	Card type        : sun4i-csi
	Bus info         : platform:1c09000.csi
	Driver version   : 5.0.0
	Capabilities     : 0x84201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
		Device Capabilities
	Device Caps      : 0x04201000
		Video Capture Multiplanar
		Streaming
		Extended Pix Format
Media Driver Info:
	Driver name      : sun4i-csi
	Model            : Allwinner Video Capture Device
	Serial           :
	Bus info         :
	Media version    : 5.0.0
	Hardware revision: 0x00000000 (0)
	Driver version   : 5.0.0
Interface Info:
	ID               : 0x03000007
	Type             : V4L Video
Entity Info:
	ID               : 0x00000005 (5)
	Name             : sun4i_csi
	Function         : V4L2 I/O
	Pad 0x01000006   : 0: Sink, Must Connect
	  Link 0x02000009: from remote pad 0x1000002 of entity 'ov5640 1-0021': Data, Enabled, Immutable

Required ioctls:
	test MC information (see 'Media Driver Info' above): OK
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second /dev/video1 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
	test VIDIOC_QUERYCTRL: OK (Not Supported)
	test VIDIOC_G/S_CTRL: OK (Not Supported)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK (Not Supported)
	test Composing: OK (Not Supported)
	test Scaling: OK

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Test input 0:

Streaming ioctls:
	test read/write: OK (Not Supported)
	test blocking wait: OK
	test MMAP: OK
	test USERPTR: OK (Not Supported)
	test DMABUF: OK (Not Supported)

Stream using all formats:
	test MMAP for Format YM12, Frame Size 2x2:
		Stride 2, Field None: OK
	test MMAP for Format YM12, Frame Size 2x2:
		Stride 2, Field None: OK
	test MMAP for Format YM12, Frame Size 640x480:
		Stride 640, Field None: OK
Total: 52, Succeeded: 52, Failed: 0, Warnings: 0

Let me know what you think,
Maxime

Changes from v1:
  - Make sure it's compliant with a much newer v4l2-compliance
  - Conversion of the DT bindings to a JSON schema
  - Drop the vendor properties and use a separate compatible instead
  - Fix an issue on the last frame where we would not have any buffer
    queued and would report an error by using a scratch buffer
  - Fix the warnings reported by v4l2-compliance
  - Rebase on top of 5.0-rc1
  - Added a MAINTAINERS entry
  - Switched to strscpy
  - Fixed SPDX header

Maxime Ripard (5):
  dt-bindings: media: Add Allwinner A10 CSI binding
  media: sunxi: Refactor the Makefile and Kconfig
  media: sunxi: Add A10 CSI driver
  ARM: dts: sun7i: Add CSI0 controller
  DO NOT MERGE: ARM: dts: bananapi: Add Camera support

 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml |  73 ++++++++++++-
 MAINTAINERS                                                          |   8 +-
 arch/arm/boot/dts/sun7i-a20-bananapi.dts                             |  94 ++++++++++++++++-
 arch/arm/boot/dts/sun7i-a20.dtsi                                     |  11 ++-
 drivers/media/platform/Kconfig                                       |   2 +-
 drivers/media/platform/Makefile                                      |   2 +-
 drivers/media/platform/sunxi/Kconfig                                 |   2 +-
 drivers/media/platform/sunxi/Makefile                                |   2 +-
 drivers/media/platform/sunxi/sun4i-csi/Kconfig                       |  12 ++-
 drivers/media/platform/sunxi/sun4i-csi/Makefile                      |   5 +-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c                   | 261 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h                   | 142 ++++++++++++++++++++++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c                   | 435 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c                  | 305 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 14 files changed, 1352 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
 create mode 100644 drivers/media/platform/sunxi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Kconfig
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/Makefile
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.h
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_dma.c
 create mode 100644 drivers/media/platform/sunxi/sun4i-csi/sun4i_v4l2.c

base-commit: 372df08972ca8fb397f82fdc63d9669281c50aee
-- 
git-series 0.9.1
