Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29568 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3EFJeY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 May 2013 05:34:24 -0400
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: [RFC 0/2] V4L2 API for exposing flash subdevs as LED class device
Date: Mon, 06 May 2013 11:33:46 +0200
Message-id: <1367832828-30771-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC proposes generic API for exposing flash subdevices via LED framework.

Rationale

Currently there are two frameworks which are used for exposing LED flash to
user space:
- V4L2 flash controls,
- LED framework(with custom sysfs attributes).

The list below shows flash drivers in mainline kernel with initial commit date
and typical chip application (according to producer):

LED API:
    lm3642: 2012-09-12, Cameras
    lm355x: 2012-09-05, Cameras
    max8997: 2011-12-14, Cameras (?)
    lp3944: 2009-06-19, Cameras, Lights, Indicators, Toys
    pca955x: 2008-07-16, Cameras, Indicators (?)
V4L2 API:
    as3645a:  2011-05-05, Cameras
    adp1653: 2011-05-05, Cameras

V4L2 provides richest functionality, but there is often demand from application
developers to provide already established LED API.
We would like to have an unified user interface for flash devices. Some of
devices already have the LED API driver exposing limited set of a Flash IC
functionality. In order to support all required features the LED API would
have to be extended or the V4L2 API would need to be used. However when
switching from a LED to a V4L2 Flash driver existing LED API interface would
need to be retained.

Proposed solution

This patch adds V4L2 helper functions to register existing V4L2 flash subdev
as LED class device.
After registration via v4l2_leddev_register appropriate entry in
/sys/class/leds/ is created.
During registration all V4L2 flash controls are enumerated and corresponding
attributes are added.

I have attached also patch with new max77693-led driver using v4l2_leddev.
This patch requires presence of the patch "max77693: added device tree support":
https://patchwork.kernel.org/patch/2414351/ .

Additional features

- simple API to access all V4L2 flash controls via sysfs,
- V4L2 subdevice should not be registered by V4L2 device to use it,
- LED triggers API can be used to control the device,
- LED device is optional - it will be created only if V4L2_LEDDEV configuration
  option is enabled and the subdev driver calls v4l2_leddev_register.

Doubts

This RFC is a result of a uncertainty which API developers should expose by
their flash drivers. It is a try to gluing together both APIs.
I am not sure if it is the best solution, but I hope there will be some
discussion and hopefully some decisions will be taken which way we should follow.

Regards
Andrzej Hajda

Andrzej Hajda (2):
  v4l2-leddev: added LED class support for V4L2 flash subdevices
  media: added max77693-led driver

 drivers/media/i2c/max77693-led.c      |  650 +++++++++++++++++++++++++++++++++
 drivers/media/v4l2-core/Kconfig       |    7 +
 drivers/media/v4l2-core/Makefile      |    1 +
 drivers/media/v4l2-core/v4l2-leddev.c |  269 ++++++++++++++
 include/media/v4l2-leddev.h           |   49 +++
 5 files changed, 976 insertions(+)
 create mode 100644 drivers/media/i2c/max77693-led.c
 create mode 100644 drivers/media/v4l2-core/v4l2-leddev.c
 create mode 100644 include/media/v4l2-leddev.h

-- 
1.7.10.4

