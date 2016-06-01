Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:47163 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932108AbcFAQkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jun 2016 12:40:04 -0400
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
Subject: [PATCH v3 0/8] Input: atmel_mxt_ts - output raw touch diagnostic data via V4L
Date: Wed,  1 Jun 2016 17:39:44 +0100
Message-Id: <1464799192-28034-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a series of patches to add diagnostic data support to the Atmel
maXTouch driver. It's a rewrite of the previous implementation which output via
debugfs: it now uses a V4L2 device in a similar way to the sur40 driver.

There are significant performance advantages to putting this code into the
driver.  The algorithm for retrieving the data has been fairly consistent
across a range of chips, with the exception of the mXT1386 series (see patch).

We have a utility which can read the data and display it in a useful format:
    https://github.com/ndyer/heatmap/commits/heatmap-v4l

These patches are also available from
    https://github.com/ndyer/linux/commits/diagnostic-v4l

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

