Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:51392 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbcFQOQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 10:16:37 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
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
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
Subject: [PATCH v4 0/9] Output raw touch data via V4L2
Date: Fri, 17 Jun 2016 15:16:19 +0100
Message-Id: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of patches to add output of raw touch diagnostic data via V4L2
to the Atmel maXTouch and Synaptics RMI4 drivers.

It's a rewrite of the previous implementation which output via debugfs: it now
uses a V4L2 device in a similar way to the sur40 driver.

We have a utility which can read the data and display it in a useful format:
    https://github.com/ndyer/heatmap/commits/heatmap-v4l

These patches are also available from
    https://github.com/ndyer/linux/commits/v4l-touch-2016-06-17

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
- Remove "single node" support for now, it may be better to treat it as metadata later
- Explicitly set VFL_DIR_RX
- Fix Kconfig

