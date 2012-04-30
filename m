Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:15719 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2D3QLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 12:11:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 00/14] V4L camera control enhancements
Date: Mon, 30 Apr 2012 18:11:39 +0200
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204301811.40034.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester!

I've finished my review. You made excellent documentation for the new controls!

Other than some small stuff the only thing I am unhappy about is the use of menu
controls for what are currently just boolean controls.

I am inclined to make them boolean controls and add a comment that they may be
changed to menu controls in the future. That shouldn't be a problem as long as the
control values 0 and 1 retain their meaning.

Regards,

	Hans

On Friday 27 April 2012 16:23:17 Sylwester Nawrocki wrote:
> Here is one more update of the camera class controls change set.
> 
> The changes since v2 are:
>  - V4L2_CID_WHITE_BALANCE_PRESET replaced with V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE
>    according to suggestions from Hans de Goede;
>  - added Flurescent H white balance preset;
>  - V4L2_CID_IMAGE_STABILIZATION and V4L2_CID_WIDE_DYNAMIC_RANGE controls type 
>    changed from boolean to menu, to make any further extensions of these 
>    controls easier;
>    I'm just not 100% sure if V4L2_WIDE_DYNAMIC_RANGE_ENABLED and
>    V4L2_IMAGE_STABILIZATION_ENABLED are good names for cases where the camera
>    doesn't support wide dynamic range or image stabilization technique
>    selection and only allows to enable or disable those algorithms;	 
>  - V4L2_CID_ISO_SENSITIVITY_AUTO control type changed from boolean to menu in
>    order to support ISO presets; currently enum v4l2_iso_sensitivity_auto_type
>    does not contain any presets though;
>  - V4L2_CID_COLORFX patch removed from this series;
>  - updated vivi and s5c73m3 driver patches.
> 
> Changes since v1 (implicit):
>  - the V4L2_CID_AUTO_FOCUS_FACE_PRIORITY control merged with
>    V4L2_CID_AUTO_FOCUS_FACE_AREA,
>  - many minor documentation corrections,
>  - removed "08/23 V4L: camera control class..." patch, which got
>    accidentally added at v1,
>  - added V4L2_CID_SCENE_MODE and V4L2_CID_3A_LOCK controls,
>  - added vivi patch for testing.
> 
> The patches are also available in a git repository at:
> http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-controls-s5c73m3
> 
> 
> Thanks,
> Sylwester
> 
> 
> Sylwester Nawrocki (14):
>   V4L: Add helper function for standard integer menu controls
>   V4L: Add camera exposure bias control
>   V4L: Add an extended camera white balance control
>   V4L: Add camera wide dynamic range control
>   V4L: Add camera image stabilization control
>   V4L: Add camera ISO sensitivity controls
>   V4L: Add camera exposure metering control
>   V4L: Add camera scene mode control
>   V4L: Add camera 3A lock control
>   V4L: Add auto focus targets to the selections API
>   V4L: Add auto focus targets to the subdev selections API
>   V4L: Add camera auto focus controls
>   V4L: Add S5C73M3 sensor sub-device driver
>   vivi: Add controls
> 
>  Documentation/DocBook/media/v4l/biblio.xml         |   11 +
>  Documentation/DocBook/media/v4l/controls.xml       |  501 +++++++-
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +-
>  Documentation/DocBook/media/v4l/selection-api.xml  |   33 +-
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +
>  .../media/v4l/vidioc-subdev-g-selection.xml        |   14 +-
>  drivers/media/video/Kconfig                        |    8 +
>  drivers/media/video/Makefile                       |    1 +
>  drivers/media/video/s5c73m3/Makefile               |    3 +
>  drivers/media/video/s5c73m3/s5c73m3-ctrls.c        |  705 +++++++++++
>  drivers/media/video/s5c73m3/s5c73m3-spi.c          |  126 ++
>  drivers/media/video/s5c73m3/s5c73m3.c              | 1243 ++++++++++++++++++++
>  drivers/media/video/s5c73m3/s5c73m3.h              |  442 +++++++
>  drivers/media/video/v4l2-ctrls.c                   |  133 ++-
>  drivers/media/video/vivi.c                         |  111 +-
>  include/linux/v4l2-subdev.h                        |    4 +
>  include/linux/videodev2.h                          |   92 ++
>  include/media/s5c73m3.h                            |   62 +
>  include/media/v4l2-ctrls.h                         |   17 +
>  19 files changed, 3536 insertions(+), 8 deletions(-)
>  create mode 100644 drivers/media/video/s5c73m3/Makefile
>  create mode 100644 drivers/media/video/s5c73m3/s5c73m3-ctrls.c
>  create mode 100644 drivers/media/video/s5c73m3/s5c73m3-spi.c
>  create mode 100644 drivers/media/video/s5c73m3/s5c73m3.c
>  create mode 100644 drivers/media/video/s5c73m3/s5c73m3.h
>  create mode 100644 include/media/s5c73m3.h
> 
> 
