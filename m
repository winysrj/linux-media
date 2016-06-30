Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:19221 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752585AbcF3Rqs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 13:46:48 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk
Subject: [PATCH v6 0/11] Output raw touch data via V4L2
Date: Thu, 30 Jun 2016 18:38:43 +0100
Message-Id: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of patches to add output of raw touch diagnostic data via V4L2
to the Atmel maXTouch and Synaptics RMI4 drivers.

It's a rewrite of the previous implementation which output via debugfs: it now
uses a V4L2 device in a similar way to the sur40 driver.

We have a utility which can read the data and display it in a useful format:
    https://github.com/ndyer/heatmap/commits/heatmap-v4l

These patches are also available from
    https://github.com/ndyer/linux/commits/v4l-touch-2016-06-30

I will also send a patch to update v4l2-compliance.

Changes in v6:
- Remove BUF_TYPE_TOUCH_CAPTURE, as discussed with Hans V touch devices will
  use BUF_TYPE_VIDEO_CAPTURE.
- Touch devices should now register CAP_VIDEO_CAPTURE: CAP_TOUCH just says that
  this is a touch device, not a video device, but otherwise it acts the same.
- Add some code to v4l_s_fmt() to set sensible default values for fields not
  used by touch.
- Improve naming/doc of RMI4 F54 report types.
- Various minor DocBook fixes, and split to separate patch.
- Update my email address.
- Rework sur40 changes so that PIX_FMT_GREY is supported for backward
  compatibility. Florian is it possible for you to test?

Changes in v5 (Hans Verkuil review):
- Update v4l2-core:
  - Add VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE and V4L2_CAP_TOUCH
  - Change V4L2_INPUT_TYPE_TOUCH_SENSOR to V4L2_INPUT_TYPE_TOUCH
  - Improve DocBook documentation
  - Add FMT definitions for touch data
  - Note this will need the latest version of the heatmap util
- Synaptics RMI4 driver:
  - Remove some less important non full frame report types
  - Switch report type names to const char * array
  - Move a static array to inside context struct
- Split sur40 changes to a separate commit

Changes in v4:
- Address nits from the input side in atmel_mxt_ts patches (Dmitry Torokhov)
- Add Synaptics RMI4 F54 support patch

Changes in v3:
- Address V4L2 review comments from Hans Verkuil
- Run v4l-compliance and fix all issues - needs minor patch here:
  https://github.com/ndyer/v4l-utils/commit/cf50469773f

Changes in v2:
- Split pixfmt changes into separate commit and add DocBook
- Introduce VFL_TYPE_TOUCH_SENSOR and /dev/v4l-touch
- Remove "single node" support for now, it may be better to treat it as
  metadata later
- Explicitly set VFL_DIR_RX
- Fix Kconfig

