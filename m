Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:4661 "EHLO
	ussmtp01.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbcERHyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2016 03:54:51 -0400
From: Songjun Wu <songjun.wu@atmel.com>
To: <g.liakhovetski@gmx.de>, <laurent.pinchart@ideasonboard.com>,
	<nicolas.ferre@atmel.com>
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
Subject: [PATCH v2 0/2] [media] atmel-isc: add driver for Atmel ISC
Date: Wed, 18 May 2016 15:46:27 +0800
Message-ID: <1463557590-29318-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Image Sensor Controller driver includes two parts.
1) Driver code to implement the ISC function.
2) Device tree binding documentation, it describes how
   to add the ISC in device tree.

Changes in v2:
- Add "depends on COMMON_CLK && VIDEO_V4L2_SUBDEV_API"
  in Kconfig file.
- Delete the redundant blank in atmel-isc-regs.h
- Enclose the expression in parentheses in some macros.
- Sort the header file alphabetically.
- Move the 'to_isc_clk(hw)' right after the struct
  isc_clk definition
- Move the global variables into the struct isc_device.
- Change some int variable to unsigned int variable.
- Replace pr_debug() with dev_dbg();
- Delete the loop while in 'isc_clk_enable' function.
- Rename the 'tmp_rate' and 'tmp_diff' to 'rate' and
  'diff' in 'isc_clk_determine_rate' function.
- Delete the inner parentheses in 'isc_clk_register'
  function.
- Delete the variable i in 'isc_parse_dt' function.
- Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
  with 'pfe_cfg0' in struct isc_subdev_entity.
- Move the 'isc_parse_dt'function down right above the
  'atmel_isc_probe' function.
- Add the code to support VIDIOC_CREATE_BUFS in
  'isc_queue_setup' function.
- Replace the variable type 'unsigned long' with 'dma_addr_t'
  in 'isc_start_dma' function.
- Remove the list_del call, turn list_for_each_entry_safe
  into list_for_each entry, and add a INIT_LIST_HEAD after
  the loop in 'isc_start_streaming', 'isc_stop_streaming'
  and 'isc_subdev_cleanup' function.
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
- Remove the check of the '!res' since devm_ioremap_resource()
  will check for it.
- Remove the error message in case of failure
  when call devm_ioremap_resource.
- Remove the cast the isc pointer to (void *).
- Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
- Replace the module_platform_driver_probe() with
  module_platform_driver().
- Remove the unit address of the endpoint.
- Add the unit address to the clock node.
- Avoid using underscores in node names.
- Drop the "0x" in the unit address of the i2c node.
- Modify the description of "atmel,sensor-preferred".
- Add the description for the ISC internal clock.

Songjun Wu (2):
  [media] atmel-isc: add the Image Sensor Controller code
  [media] atmel-isc: DT binding for Image Sensor Controller driver

 .../devicetree/bindings/media/atmel-isc.txt        |  100 ++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/atmel/Kconfig               |    9 +
 drivers/media/platform/atmel/Makefile              |    1 +
 drivers/media/platform/atmel/atmel-isc-regs.h      |  276 ++++
 drivers/media/platform/atmel/atmel-isc.c           | 1583 ++++++++++++++++++++
 7 files changed, 1972 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c

-- 
2.7.4

