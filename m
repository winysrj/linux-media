Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:16692 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbcHHTbW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2016 15:31:22 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jiri Kosina <trivial@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 00/14] pxa_camera transition to v4l2 standalone device
Date: Mon,  8 Aug 2016 21:30:38 +0200
Message-Id: <1470684652-16295-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

We're leaving the domain of the RFC to a proper submission.

This is very alike to what you reviewed earlier, the code is very close, and :
 - the split between patches is done to better isolate cleanups from real code
 - start_streaming() was implemented
 - your remarks have been taken into account (please double-check if you're
   happy with it)
 - v4l2-compliance -f and v4l2-compliance -s were run without any error, and 6 warnings
	warn: v4l2-test-formats.cpp(713): TRY_FMT cannot handle an invalid pixelformat.
	warn: v4l2-test-formats.cpp(714): This may or may not be a problem. For more information see:
	warn: v4l2-test-formats.cpp(715): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html
 - soc_camera is not touched anymore
 - the driver is still functional from a capture point of view as before
  (ie. taking a real picture)
 
I'm still relying on soc_mediabus, hence the not-so-nice Makefile diff hunk.

The only architecture which will have its deconfigs impacted is pxa, under my
maintainance, and once the review is finished and you have a landing cycle I'll
complete with a simple serie on the pxa side (defconfig + platform data).

I've also put the whole serie here if you want to fetch and review from git directly :
 - git fetch https://github.com/rjarzmik/linux.git work/v4l2

Happy review.

--
Robert

Robert Jarzmik (14):
  media: mt9m111: make a standalone v4l2 subdevice
  media: mt9m111: prevent module removal while in use
  media: mt9m111: use only the SRGB colorspace
  media: mt9m111: move mt9m111 out of soc_camera
  media: platform: pxa_camera: convert to vb2
  media: platform: pxa_camera: trivial move of functions
  media: platform: pxa_camera: introduce sensor_call
  media: platform: pxa_camera: make printk consistent
  media: platform: pxa_camera: add buffer sequencing
  media: platform: pxa_camera: remove set_crop
  media: platform: pxa_camera: make a standalone v4l2 device
  media: platform: pxa_camera: add debug register access
  media: platform: pxa_camera: change stop_streaming semantics
  media: platform: pxa_camera: move pxa_camera out of soc_camera

 drivers/media/i2c/Kconfig                      |    7 +
 drivers/media/i2c/Makefile                     |    1 +
 drivers/media/i2c/mt9m111.c                    | 1043 ++++++++++++
 drivers/media/i2c/soc_camera/Kconfig           |    7 +-
 drivers/media/i2c/soc_camera/Makefile          |    1 -
 drivers/media/i2c/soc_camera/mt9m111.c         | 1054 ------------
 drivers/media/platform/Kconfig                 |    8 +
 drivers/media/platform/Makefile                |    1 +
 drivers/media/platform/pxa_camera.c            | 2131 ++++++++++++++++++++++++
 drivers/media/platform/soc_camera/Kconfig      |    8 +-
 drivers/media/platform/soc_camera/Makefile     |    1 -
 drivers/media/platform/soc_camera/pxa_camera.c | 1866 ---------------------
 include/linux/platform_data/media/camera-pxa.h |    2 +
 13 files changed, 3202 insertions(+), 2928 deletions(-)
 create mode 100644 drivers/media/i2c/mt9m111.c
 delete mode 100644 drivers/media/i2c/soc_camera/mt9m111.c
 create mode 100644 drivers/media/platform/pxa_camera.c
 delete mode 100644 drivers/media/platform/soc_camera/pxa_camera.c

-- 
2.1.4

