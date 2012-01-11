Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:21391 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab2AKV05 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:26:57 -0500
Message-ID: <4F0DFE92.80102@iki.fi>
Date: Wed, 11 Jan 2012 23:26:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	tuukkat76@gmail.com, Kamil Debski <k.debski@samsung.com>,
	Kim HeungJun <riverful@gmail.com>, teturtia@gmail.com
Subject: [PATCH 0/23] V4L2 subdev and sensor control changes, SMIA++ driver
 and N9 camera board code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

This the second version of my patchset that contains:

- Integer menu controls [2],
- Selection IOCTL for subdevs [3],
- Sensor control changes [5,7],
- link_validate() media entity and V4L2 subdev pad ops,
- OMAP 3 ISP driver improvements [4],
- SMIA++ sensor driver and
- rm680/rm696 board code (a.k.a Nokia N9 and N950)

More detailed information and discussion can be found in the references.
The RFC version of the patchset can be found in [6] for more recent
discussion. I want to thank all the reviewers of the previous patchset
up to now; especially Sylwester Nawrocki and Laurent Pinchart.

Comments and questions are very, very welcome.

I have made changes based on the comments I've gotten so far, the
details can be found below. There are a few minor things to be changed
in the selection API which I haven't done yet, and this is why:

I have one question left. Will we go forward with the subdev selection
API, or shall a more generic properties API cover that functionality, as
well as the functionality of current controls API?

Changes to the RFC v1 include:

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

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
