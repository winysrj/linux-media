Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58214 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2EDScV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2012 14:32:21 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3I00AL8GSVRCA0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:31:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3I006JCGTT1P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 May 2012 19:32:17 +0100 (BST)
Date: Fri, 04 May 2012 20:32:04 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v4 00/13] V4L: camera control enhancements
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1336156337-10935-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is one more update of the camera class controls change set.

Changes since v3, these are mainly corrections after comments from
Hans (thank you!):
 - V4L2_CID_IMAGE_STABILIZATION and V4L2_CID_WIDE_DYNAMIC_RANGE controls
   type reverted back to boolean, added a note in the documentation that
   these controls may be converted to menu controls in future;
 - Added description for new integer menu control helpers to
   Documentation/video4linux/v4l2-controls.txt
 - edited V4L2_CID_3A_LOCK control's description;
 - removed the vivi patch from the series;

Comments are welcome. If there is no more major corrections required
I'd like to send a pull request next week for the following:

  V4L: Add helper function for standard integer menu controls
  V4L: Add camera exposure bias control
  V4L: Add an extended camera white balance control
  V4L: Add camera wide dynamic range control
  V4L: Add camera image stabilization control
  V4L: Add camera ISO sensitivity controls
  V4L: Add camera exposure metering control
  V4L: Add camera scene mode control
  V4L: Add camera 3A lock control

and after there is an agreement on how to handle the enums in the V4L2 API,
since some of the above patches depend on the new integer menu control
type addition.


Changes since v2:
 - V4L2_CID_WHITE_BALANCE_PRESET replaced with V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE
   according to suggestions from Hans de Goede;
 - added Flurescent H white balance preset;
 - V4L2_CID_IMAGE_STABILIZATION and V4L2_CID_WIDE_DYNAMIC_RANGE controls type
   changed from boolean to menu, to make any further extensions of these
   controls easier;
   I'm just not 100% sure if V4L2_WIDE_DYNAMIC_RANGE_ENABLED and
   V4L2_IMAGE_STABILIZATION_ENABLED are good names for cases where the camera
   doesn't support wide dynamic range or image stabilization technique
   selection and only allows to enable or disable those algorithms;
 - V4L2_CID_ISO_SENSITIVITY_AUTO control type changed from boolean to menu in
   order to support ISO presets; currently enum v4l2_iso_sensitivity_auto_type
   does not contain any presets though;
 - V4L2_CID_COLORFX patch removed from this series;
 - updated vivi and s5c73m3 driver patches.

Changes since v1 (implicit):
 - the V4L2_CID_AUTO_FOCUS_FACE_PRIORITY control merged with
   V4L2_CID_AUTO_FOCUS_FACE_AREA,
 - many minor documentation corrections,
 - removed "08/23 V4L: camera control class..." patch, which got
   accidentally added at v1,
 - added V4L2_CID_SCENE_MODE and V4L2_CID_3A_LOCK controls,
 - added vivi patch for testing.

The patches will be also available in few hours in git repository at:
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/v4l-camera-controls

Regards,
Sylwester


Sylwester Nawrocki (12):
  V4L: Add helper function for standard integer menu controls
  V4L: Add camera exposure bias control
  V4L: Add an extended camera white balance control
  V4L: Add camera wide dynamic range control
  V4L: Add camera image stabilization control
  V4L: Add camera ISO sensitivity controls
  V4L: Add camera exposure metering control
  V4L: Add camera scene mode control
  V4L: Add camera 3A lock control
  V4L: Add auto focus targets to the selections API
  V4L: Add auto focus targets to the subdev selections API
  V4L: Add camera auto focus controls

 Documentation/DocBook/media/v4l/biblio.xml         |   11 +
 Documentation/DocBook/media/v4l/controls.xml       |  481 +++++++++++++++++++-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   33 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |   14 +-
 Documentation/video4linux/v4l2-controls.txt        |   22 +
 drivers/media/video/v4l2-ctrls.c                   |  121 ++++-
 include/linux/v4l2-subdev.h                        |    4 +
 include/linux/videodev2.h                          |   86 ++++
 include/media/v4l2-ctrls.h                         |   17 +
 11 files changed, 820 insertions(+), 7 deletions(-)

-- 
1.7.10

