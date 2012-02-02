Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40975 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933656Ab2BBXwh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 18:52:37 -0500
Date: Fri, 3 Feb 2012 01:52:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com
Subject: [PATCH v2 0/31] V4L2 subdev and sensor control changes, SMIA++
 driver and N9 camera board code
Message-ID: <20120202235231.GC841@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This the second version of my patchset that contains:

- Integer menu controls [2],
- Selection IOCTL for subdevs [3],
- Sensor control changes [5,7],
- link_validate() media entity and V4L2 subdev pad ops,
- OMAP 3 ISP driver improvements [4],
- SMIA++ sensor driver,
- rm680/rm696 board code (a.k.a Nokia N9 and N950) and
- Other V4L2 and media improvements (see individual patches)

My proposal on the selection / property API is that the V4L2 subdev
interface will have the selection API. The property API should be targeted
to the media controller interface instead. The selection API will provide
real, required features required by SMIA++ driver as well as many other
driver such as the OMAP 3 ISP driver. The property API is not well
understood nor discussed in the community and it will take likely at least
half a year before it will be usable. Drivers implementing the property API
would use generic wrapper functions to provide the selection API.

Changes to version 1 [8] include:

- OMAP 3 ISP driver
  - Swapped order of csi receiver's lane definitions
  - Rewrote omap 3 isp link validation patches almost completely
    - Information on connected external entity collected to isp_pipeline
    - Information collected during link checking and used at streamon

- Media entity link validation
  - Error handling fixes

- SMIA++ driver
  - Selection API bugfixes
  - Report correct pixel order right from boot
  - Move link rate control to subdev connected to subdev external to the
    sensor (e.g. ISP's CSI-2 receiver)
  - Introduce proper serialisation
  - Deny changing some controls when streaming (flipping and link rate)
  - Control handler setup moved from streamon time to first subdev open
  - There is no source compose target
  - Bugfixes

- Media bus pixel codes
  - Documentation fix for dpcm compressed formats
  - Added patch for 4CC guidelines (raw bayer only for now)

- Selections
  - Improved selections documentation
  - Added more selections examples
  - Compose target is not available on source pads anymore [9]
  - Dropped default targets

- V4L2
  - Add documentation on link_validate()
  - link_validate() and relater functions  depends on CONFIG_MEDIA_CONTROLLER
  - Skip link validation for links on which stream_count was non-zero
  - Do not validate link if entity's stream count is non-zero
  - Use v4l2_subdev_link_validate_default() if no link_validate pad op is set
  - Allow changing control handler mutex: this enables a driver to provide
    multiple subdevs but use only one mutex. Default mutex (part of struct
    v4l2_ctrl_handler) is set in v4l2_ctrl_handler_init().
  - Split image source class into two: image source and image processing

Changes to the RFC v1 [6] include:

- Integer controls:
  - Target Linux 3.4 instead of 3.3
  - Proper control type check in querymenu
  - vivi compile fixes

- Subdev selections
  - Pad try fields combined to single struct
  - Correctly set sel.which based on crop->which in crop fall-back

- Subdev selection documentation
  - Better explanation on image processing in subdevs
  - Added a diagram to visualise subdev configuration
  - Fixed DocBook syntax issues
  - Mark VIDIOC_SUBDEV_S_CROP and VIDIOC_SUBDEV_G_CROP obsolete

- Pixel rate
  - Pixel rate is now a 64-bit control, not part of v4l2_mbus_framefmt
  - Unit for pixel rate is pixels / second
  - Pixel rate is read-only

- Link frequency is now in Hz --- documented as such also

- Link validation instead of pipeline validation
  - Each link is validated by calling link_validate op
    - Added link validation op to media_entity_ops
  - Link validation op in pad ops makes this easy for subdev drivers
  - media_entity_pipeline_start() may return an error code now
    - This might affect other drivers, but will warn in compilation.
      No adverse effects are caused if the driver does not use
      link_validate().

- OMAP 3 ISP
  - Make lanecfg as part of the platform data structure, not pointer
  - Document lane configuration structures
  - Link validation moved to respective subdev drivers from ispvideo.c
    - isp_validate_pipeline() removed

- SMIA++ driver
  - Update pixel order based on vflip and hflip
  - Cleanups in the main driver, register definitions and PLL code
  - Depend on V4L2_V4L2_SUBDEV_API and MEDIA_CONTROLLER
  - Use pr_* macros instead of printk
  - Improved error handling for i2c_transfer()
  - Removed useless definitions
  - Don't access try crop / compose directly but use helper functions
  - Add xshutdown to platform data
  - Move driver under smiapp directory

- rm680 board code
  - Use REGULATOR_SUPPLY() where possible
  - Removed printk()'s
  - Don't include private smiapp headers


References:

[1] http://www.spinics.net/lists/linux-omap/msg61295.html

[2] http://www.spinics.net/lists/linux-media/msg40796.html

[3] http://www.spinics.net/lists/linux-media/msg41503.html

[4] http://www.spinics.net/lists/linux-media/msg41542.html

[5] http://www.spinics.net/lists/linux-media/msg40861.html

[6] http://www.spinics.net/lists/linux-media/msg41765.html

[7] http://www.spinics.net/lists/linux-media/msg42848.html

[8] http://www.spinics.net/lists/linux-media/msg42991.html

[9] http://www.spinics.net/lists/linux-media/msg43810.html

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
