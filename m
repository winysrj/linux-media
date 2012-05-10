Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54972 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2EJKbG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 06:31:06 -0400
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M3S00C90YJJC2@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:30:55 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M3S00DE7YJR3I@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 May 2012 11:31:03 +0100 (BST)
Date: Thu, 10 May 2012 12:30:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 00/23] V4L: camera control enhancements
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1336645858-30366-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

It's probably the last update of this patch series, it contains a few
minor changes to the V4L2 API patches and updated patches for m5mols
sensor driver that were previously posted to LMML.

Changes since v4:
  - removed V4L2_AUTO_FOCUS_STATUS_LOST AF status bit definition;
  - added m5mols patches instead of s5c73m3 driver;
  - minor changes in V4L2_CID_AUTO_FOCUS_AREA control description;

Changes since v3:
 - V4L2_CID_IMAGE_STABILIZATION and V4L2_CID_WIDE_DYNAMIC_RANGE controls
   type reverted back to boolean, added a note in the documentation that
   these controls may be converted to menu controls in future;
 - Added description for new integer menu control helpers to
   Documentation/video4linux/v4l2-controls.txt
 - edited V4L2_CID_3A_LOCK control's description;
 - removed the vivi patch from the series;

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

Changes since v1:
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


Sylwester Nawrocki (23):
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
  m5mols: Convert macros to inline functions
  m5mols: Refactored controls handling
  m5mols: Use proper sensor mode for the controls
  m5mols: Add ISO sensitivity controls
  m5mols: Add auto and preset white balance control
  m5mols: Add exposure bias control
  m5mols: Add wide dynamic range control
  m5mols: Add image stabilization control
  m5mols: Add exposure metering control
  m5mols: Add JPEG compression quality control
  m5mols: Add 3A lock control

 Documentation/DocBook/media/v4l/biblio.xml         |   11 +
 Documentation/DocBook/media/v4l/compat.xml         |   20 +
 Documentation/DocBook/media/v4l/controls.xml       |  486 +++++++++++++++++++-
 Documentation/DocBook/media/v4l/dev-subdev.xml     |   27 +-
 Documentation/DocBook/media/v4l/selection-api.xml  |   33 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |    9 +-
 .../DocBook/media/v4l/vidioc-g-selection.xml       |   11 +
 .../media/v4l/vidioc-subdev-g-selection.xml        |   14 +-
 Documentation/video4linux/v4l2-controls.txt        |   21 +
 drivers/media/video/m5mols/m5mols.h                |   81 +++-
 drivers/media/video/m5mols/m5mols_capture.c        |   11 +-
 drivers/media/video/m5mols/m5mols_controls.c       |  479 ++++++++++++++++---
 drivers/media/video/m5mols/m5mols_core.c           |   93 +---
 drivers/media/video/m5mols/m5mols_reg.h            |    1 +
 drivers/media/video/v4l2-ctrls.c                   |  121 ++++-
 include/linux/v4l2-subdev.h                        |    4 +
 include/linux/videodev2.h                          |   85 ++++
 include/media/v4l2-ctrls.h                         |   17 +
 18 files changed, 1326 insertions(+), 198 deletions(-)

-- 
1.7.10

