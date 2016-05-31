Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:37658 "EHLO
	ussmtp01.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751316AbcEaHHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 03:07:36 -0400
From: Songjun Wu <songjun.wu@atmel.com>
To: <g.liakhovetski@gmx.de>, <laurent.pinchart@ideasonboard.com>,
	<nicolas.ferre@atmel.com>, <robh@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
	Songjun Wu <songjun.wu@atmel.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	<devicetree@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard@puffinpack.se>,
	Benoit Parrot <bparrot@ti.com>,
	Kumar Gala <galak@codeaurora.org>,
	<linux-kernel@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mark Rutland <mark.rutland@arm.com>,
	<linux-media@vger.kernel.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v3 0/2] [media] atmel-isc: add driver for Atmel ISC
Date: Tue, 31 May 2016 14:58:21 +0800
Message-ID: <1464677903-28412-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Image Sensor Controller driver includes two parts.
1) Driver code to implement the ISC function.
2) Device tree binding documentation, it describes how
   to add the ISC in device tree.

Changes in v3:
- Add pm runtime feature.
- Modify the isc clock code since the dt is changed.
- Remove the 'atmel,sensor-preferred'.
- Modify the isc clock node according to the Rob's remarks.

Changes in v2:
- Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
  in Kconfig file.
- Correct typos and coding style according to Laurent's remarks.
- Delete the loop while in 'isc_clk_enable' function.
- Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
  with 'pfe_cfg0' in struct isc_subdev_entity.
- Add the code to support VIDIOC_CREATE_BUFS in
  'isc_queue_setup' function.
- Invoke isc_config to configure register in
  'isc_start_streaming' function.
- Add the struct completion 'comp' to synchronize with
  the frame end interrupt in 'isc_stop_streaming' function.
- Check the return value of the clk_prepare_enable
  in 'isc_open' function.
- Set the default format in 'isc_open' function.
- Add an exit condition in the loop while in 'isc_config'.
- Delete the hardware setup operation in 'isc_set_format'.
- Refuse format modification during streaming
  in 'isc_s_fmt_vid_cap' function.
- Invoke v4l2_subdev_alloc_pad_config to allocate and
  initialize the pad config in 'isc_async_complete' function.
- Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
- Replace the module_platform_driver_probe() with
  module_platform_driver().
- Remove the unit address of the endpoint.
- Add the unit address to the clock node.
- Avoid using underscores in node names.
- Drop the "0x" in the unit address of the i2c node.
- Modify the description of 'atmel,sensor-preferred'.
- Add the description for the ISC internal clock.

Songjun Wu (2):
  [media] atmel-isc: add the Image Sensor Controller code
  [media] atmel-isc: DT binding for Image Sensor Controller driver

 .../devicetree/bindings/media/atmel-isc.txt        |   88 ++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/atmel/Kconfig               |    9 +
 drivers/media/platform/atmel/Makefile              |    1 +
 drivers/media/platform/atmel/atmel-isc-regs.h      |  276 ++++
 drivers/media/platform/atmel/atmel-isc.c           | 1610 ++++++++++++++++++++
 7 files changed, 1987 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c

-- 
2.7.4

