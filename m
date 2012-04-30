Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19184 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab2D3PKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 11:10:14 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3A0066PSSUNE@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 16:10:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3A005CISSXLF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 30 Apr 2012 16:10:10 +0100 (BST)
Date: Mon, 30 Apr 2012 17:10:11 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v3 00/14] V4L camera control enhancements
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <4F9EAB53.2020705@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/27/2012 04:23 PM, Sylwester Nawrocki wrote:
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

I've done following changes:

- V4L2_CID_AUTO_FOCUS_DISTANCE renamed to V4L2_CID_AUTO_FOCUS_RANGE,
  added new item V4L2_AUTO_FOCUS_RANGE_AUTO,
- V4L2_AUTO_FOCUS_STATUS_SUCCESS renamed to V4L2_AUTO_FOCUS_STATUS_REACHED,
  added V4L2_AUTO_FOCUS_STATUS_LOST,
- edited V4L2_CID_3A_LOCK description, renamed V4L2_3A_LOCK_* to V4L2_LOCK_*,
- added a "_type" sufffix to enum v4l2_wide_dynamic_range,
  v4l2_auto_focus_distance and v4l2_auto_focus_area,

and pushed it to git repository (gitweb link as above):
 git://git.infradead.org/users/kmpark/linux-samsung v4l-controls-s5c73m3

These are a bunch of minor changes, I didn't want to spam the mailing
list by resending whole change set again. I plan to do it at the end
of week if there are more comments and corrections needed.

--

Regards,
Sylwester

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
