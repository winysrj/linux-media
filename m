Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36484 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab1HHPuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 11:50:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [ANN] Meeting minutes of the Cambourne meeting
Date: Mon, 8 Aug 2011 17:50:06 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107261647.19235.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108081750.07000.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

The V4L2 brainstorming meeting held in Cambourne from August the 1st to August 
the 5th was a success. I would like to thank Linaro again, and particularly 
Stephen Doel and Arwen Donaghey, for accommodating us during the whole week.

Here is a summary of the discussions, with preliminary conclusions, ideas, and 
action points.

I encourage all attendants to make their notes available (yes, that might 
require cleaning them up :-)).


Pipeline configuration
----------------------

 Preliminary conclusions:

 - SUBDEV_ENUM_FRAME_SIZE should enumerate frame sizes that can be obtained
   through binning/skipping, limited to "common sizes".
 - Binning must always be preferred over skipping.
 - SUBDEV_S_FMT selects the frame size at pads, and thus configures scaling.
 - When sensors support cropping on both the pixel array and on the output,
   SUBDEV_S_SELECTION with a new "pixel array" target could be used. Whether
   this is needed isn't known.
 - SUBDEV_G_SELECTION is used to get the pixel array size.
 - When entities include controls that require cropping for internal reasons,
   the recommended behaviour is for the driver to transparently add cropping
   when the control is disabled, in order to allow userspace to enable/disable
   the control at runtime.
 - Cropping and flipping may change format for Bayer sensors. This is allowed,
   but must fail with -EBUSY when streaming.

 Actions:

 - (Pre-requisite) video device node G/S_SELECTION API. (Tomasz)
 - Specify the SUBDEV_G/S_SELECTION ioctl on subdev pads. (Laurent, Sakari)
 - Add a "keep-pipeline" flag to SUBDEV_S_SELECTION. (Laurent, Sakari)
 - Deprecated the SUBDEV_G/S_CROP ioctl on subdev pads. (Laurent, Sakari)
 - Document the pipeline setup behaviour: (Laurent, Sakari)
   - From sink pad to source pad inside subdevs.
   - From device to memory between subdevs (but controlled by userspace, so
     that's not mandatory).


Pixel clock and blanking
------------------------

 Preliminary conclusions:

 - Pixel clock(s) and blanking will be exported through controls on subdev
   nodes.
 - The pixel array pixel clock is needed by userspace.
 - Hosts/bridges/ISPs need pixel clock and blanking information to validate
   pipelines.

 Actions:

 - CSI2 and CCP2 bus frequencies will be selectable use integer menu controls.
   (Sakari)
 - Add an integer menu control type, replacing the name with a 64-bit integer.
   (Sakari, Hans)
 - Research which pixel clock(s) to expose based on the SMIA sensor.
   (Sakari)
 - Add two new internal subdev pad operations to get and set clocks and
   blanking.
   (Laurent, Sakari)


Per-frame configuration
-----------------------

 Use cases:

 - Controls:
   - Exposure/gain/focus bracketing
   - Flash + exposure
 - Output devices:
   - Switching buffer format on the fly on output devices (TI OMAP3 DSS)
   - Codecs support (forcing I-frames, changing quantization parameters)
   - Smooth digital composing
 - Capture devices:
   - Smooth digital zoom

 Preliminary conclusions:

 - ioctls related to per-frame configuration are limited to S_CTRL, S_FMT and
   S_SELECTION.
 - We should not emulate per-frame configuration in kernel drivers for
   hardware that don't support it.

 Preliminary ideas (no consensus):

 - Configuring sensors for exposure/gain/focus bracketing can be done through
   a sensor-specific ioctl on subdev nodes.
 - Per-buffer configuration is easier than per-frame configuration:
   - No need to keep a configuration queue in the driver.
   - It can be difficult for drivers to determine which frame comes up when.
 - Add *_PER_FRAME ioctls (based on the frame sequence number).
 - Use a configuration plane with the multi-plane API.

 Actions:

 - Think about it.


Per-frame meta-data
-------------------

 Preliminary conclusions:

 - Don't add software-based metadata in the kernel. Only export metadata
   generated by the hardware. Pre-processing hardware-generated metadata in
   the kernel is allowed.
 - If we can't find a better API, add a "flash" buffer flag to indicate that
   the buffer has been exposed to flash.
 - Drivers shouldn't parse meta-data. libv4l should parse it.

 Possible implementations:

 - Use a meta-data video device.
 - Use a meta-data plane with the multi-plane API.
 - Use a per-frame control API.

 Actions:

 - Think about it.


Shared buffers
--------------

 Actions:

 - Add support for the shared buffers proof-of-concept API to fbdev and vivi.
   (Tomasz)


Subdevs hierachy, Linux device model
------------------------------------

 Preliminary conclusions:

 - With the move to device tree on ARM (and other platforms), I2C, SPI and
   platform subdevs should be created from board code, not from bridge/host
   drivers.
 - Bus notifiers should be used by bridge/host drivers to wait for all
   required subdevs. V4L2 core should provide helper functions.
 - struct clk should be used to handle clocks provided by hosts to subdevs.

 Actions:

 - Work on a proof-of-concept implementation of the new subdevs registration
   mechanism and send an RFC (whoever needs it first).
 - Work on a proof-of-concept clock handling using struct clk with the OMAP3
   ISP driver (Laurent).


-- 
Regards,

Laurent Pinchart
